#!/bin/bash
packname=com.southcn.hhhgei
dateTime=g$(date "+%y%m%d%H%M%S")
mkdir /app/down/lanmei_apk
mkdir /app/down/nosign
keytool -genkey -keystore /app/down/nosign/$dateTime.jks -keyalg RSA -validity 10000 -storepass 123456 -alias /app/down/nosign/lanmeiCA  -dname "CN=WE, OU=WE, O=WE, L=WE, ST=WE, C=ZH"

java -jar /usr/local/apktool_2.9.3.jar d /app/down/lanmei_apk/lmchannel2.apk -o lanmei

cd lanmei
chmod +x AndroidManifest.xml
# 这个步骤修改包名。

sed -i "1,3s/$packname/com.southcn.$dateTime/g" AndroidManifest.xml
sed -i "s/$packname.provider/com.southcn.$dateTime.provider/g" AndroidManifest.xml
sed -i "s/$packname.fileProvider/com.southcn.$dateTime.fileProvider/g" AndroidManifest.xml
sed -i "s/$packname.autosize-init-provider/com.southcn.$dateTime.autosize-init-provider/g" AndroidManifest.xml
sed -i "s/$packname.androidx-startup/com.southcn.$dateTime.androidx-startup/g" AndroidManifest.xml
# 
cd ..
java -jar /usr/local/apktool_2.9.3.jar b lanmei -o /app/down/nosign/lanmei.nozipalign.apk

zipalign -p 4 /app/down/nosign/lanmei.nozipalign.apk /app/down/nosign/lanmei.no.apk

apksigner sign --ks /app/down/nosign/$dateTime.jks --ks-key-alias /app/down/nosign/lanmeiCA --ks-pass pass:123456 --out /app/down/lanmei_apk/lmchannel2.apk /app/down/nosign/lanmei.no.apk

rm -f /app/down/lanmei_apk/lmchannel2.apk.idsig
rm -r /app/down/nosign
# -v /wwww/wwwroot/app:/app 
# docker exec apktool /app/run.sh