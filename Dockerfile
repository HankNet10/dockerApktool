FROM ubuntu:latest
# RUN apt-get update
# RUN apt-get install apt-file
# RUN apt-file update
# RUN apt-get install vim

# 安装adk https://developer.android.com/studio?hl=zh-cn
# 安装apktool https://apktool.org
# 安装jdk openjdk-21-jdk

COPY android-tool.tar.gz /root/android-tool.tar.gz
COPY openjdk-24-ea+6_linux-x64_bin.tar.gz /root/openjdk-24-ea+6_linux-x64_bin.tar.gz
COPY apktool_2.9.3.jar /usr/local/apktool_2.9.3.jar
COPY . ./app

RUN tar -C /usr/local -xzf /root/android-tool.tar.gz
RUN tar -C /usr/local -xzf /root/openjdk-24-ea+6_linux-x64_bin.tar.gz

RUN echo 'export PATH=$PATH:/usr/local/jdk-24/bin' >> /root/.bashrc
RUN echo 'export PATH=$PATH:/usr/local/android-tool' >> /root/.bashrc
RUN echo "alias apktool='java -jar /usr/local/apktool_2.9.3.jar'" >> /root/.bashrc

WORKDIR /app
