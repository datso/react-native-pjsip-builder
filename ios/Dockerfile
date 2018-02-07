FROM ubuntu:latest

RUN apt-get -y upgrade && \
    apt-get -y dist-upgrade && \
    apt-get update

RUN DEBIAN_FRONTEND=noninteractive apt-get -y install \
    wget unzip


##############################
# Download VialerPJSIP until iOS version is not released
##############################

RUN mkdir -p /vialer/ && \
    cd /vialer/ && \
    wget https://github.com/VoIPGRID/Vialer-pjsip-iOS/archive/3.2.0.zip && \
    wget https://github.com/VoIPGRID/Vialer-pjsip-iOS/blob/3.2.0/VialerPJSIP.framework/Versions/A/VialerPJSIP?raw=true && \
    unzip 3.2.0.zip

RUN mkdir -p /dist/ios/VialerPJSIP.framework && \
    mv /vialer/Vialer-pjsip-iOS-3.2.0/VialerPJSIP.framework/Versions/Current/* /dist/ios/VialerPJSIP.framework && \
    mv /vialer/VialerPJSIP?raw=true /dist/ios/VialerPJSIP.framework/VialerPJSIP