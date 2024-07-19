#!/bin/bash
apkpath=$1
apkname=${apkpath##*/}
packname=$2
outpath=$3
codepath=${apkname%.*}
dateTime=a$(date "+%y%m%d%H%M%S")
newPackname=${packname%.*}${dateTime}
mkdir /app/apk
mkdir /app/apk/nosign
cp $apkpath /app/apk/
keytool -genkey -keystore /app/apk/nosign/$dateTime.jks -keyalg RSA -validity 10000 -storepass 123456 -alias /app/apk/nosign/moguCA  -dname "CN=WE, OU=WE, O=WE, L=WE, ST=WE, C=ZH"
rm -r /app/apk/${codepath}
java -jar /usr/local/apktool_2.9.3.jar d /app/apk/$apkname -o /app/apk/${codepath}

cd /app/apk/$codepath
chmod +x AndroidManifest.xml
# 这个步骤修改包名。

sed -i "1,3s/$packname/$newPackname/g" AndroidManifest.xml
sed -i "s/$packname.provider/$newPackname.provider/g" AndroidManifest.xml
sed -i "s/$packname.fileProvider/$newPackname.fileProvider/g" AndroidManifest.xml
sed -i "s/$packname.autosize-init-provider/$newPackname.autosize-init-provider/g" AndroidManifest.xml
sed -i "s/$packname.androidx-startup/$newPackname.androidx-startup/g" AndroidManifest.xml
# 
cd ..
java -jar /usr/local/apktool_2.9.3.jar b /app/apk/$codepath -o /app/apk/nosign/mogu.nozipalign.apk

zipalign -p 4 /app/apk/nosign/mogu.nozipalign.apk /app/apk/nosign/mogu.no.apk

apksigner sign --ks /app/apk/nosign/$dateTime.jks --ks-key-alias /app/apk/nosign/moguCA --ks-pass pass:123456 --out /app/apk/$apkname /app/apk/nosign/mogu.no.apk

rm -f /app/apk/$apkname.idsig
rm -r /app/apk/nosign
rm -r /app/apk/$codepath
myfilesize=$(stat --format=%s "$apkpath")
newsize=$(stat --format=%s "/app/apk/$apkname")
size=`expr $myfilesize - $newsize`
Difference=3000000
if [ $size -ge $Difference -o $size -le -$Difference ]
then
    rm -r /app/apk/$apkname
    echo error
else
    cp /app/apk/$apkname $outpath
    rm -r /app/apk/$apkname
    echo success:$outpath$apkname
fi
# -v /wwww/wwwroot/app:/app 
# docker exec apktool /app/run.sh