#!/bin/bash
packname=com.asdfg.lzvpnt
dateTime=c$(date "+%y%m%d%H%M%S")
mkdir /app/down/mogu_apk
mkdir /app/down/nosign
keytool -genkey -keystore /app/down/nosign/$dateTime.jks -keyalg RSA -validity 10000 -storepass 123456 -alias /app/down/nosign/moguCA  -dname "CN=WE, OU=WE, O=WE, L=WE, ST=WE, C=ZH"

java -jar /usr/local/apktool_2.9.3.jar d /app/down/mogu_apk/mogu1.3.4gg.apk -o mogu

cd mogu
chmod +x AndroidManifest.xml
# 这个步骤修改包名。

sed -i "1,3s/$packname/com.asdfg.$dateTime/g" AndroidManifest.xml
sed -i "s/$packname.provider/com.asdfg.$dateTime.provider/g" AndroidManifest.xml
sed -i "s/$packname.fileProvider/com.asdfg.$dateTime.fileProvider/g" AndroidManifest.xml
sed -i "s/$packname.autosize-init-provider/com.asdfg.$dateTime.autosize-init-provider/g" AndroidManifest.xml
sed -i "s/$packname.androidx-startup/com.asdfg.$dateTime.androidx-startup/g" AndroidManifest.xml
# 
cd ..
java -jar /usr/local/apktool_2.9.3.jar b mogu -o /app/down/nosign/mogu.nozipalign.apk

zipalign -p 4 /app/down/nosign/mogu.nozipalign.apk /app/down/nosign/mogu.no.apk

apksigner sign --ks /app/down/nosign/$dateTime.jks --ks-key-alias /app/down/nosign/moguCA --ks-pass pass:123456 --out /app/down/mogu_apk/mogu1.3.4gg.apk /app/down/nosign/mogu.no.apk

rm -f /app/down/mogu_apk/mogu1.3.4gg.apk.idsig
rm -r /app/down/nosign
# -v /wwww/wwwroot/app:/app 
# docker exec apktool /app/run.sh