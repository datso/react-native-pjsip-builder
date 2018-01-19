#!/bin/bash
set -e

TARGET_ARCH=$1
TARGET_PATH=/output/pjsip/${TARGET_ARCH}
cp -r /sources/pjsip /tmp/pjsip

# TODO: Use flags like in vialerpjsip for config.h
cat <<EOF > "/tmp/pjsip/pjlib/include/pj/config_site.h"
#define PJ_CONFIG_ANDROID 1
#define PJMEDIA_HAS_G729_CODEC 1
#define PJMEDIA_HAS_G7221_CODEC 1
#include <pj/config_site_sample.h>
#define PJMEDIA_HAS_VIDEO 1
#define PJMEDIA_AUDIO_DEV_HAS_ANDROID_JNI 0
#define PJMEDIA_AUDIO_DEV_HAS_OPENSL 1
#define PJSIP_AUTH_AUTO_SEND_NEXT 0
EOF

cd /tmp/pjsip

export TARGET_ABI=${TARGET_ARCH}
export APP_PLATFORM=android-${ANDROID_TARGET_API}
export ANDROID_NDK_ROOT=/sources/android_ndk

./configure-android \
    --use-ndk-cflags \
    --with-ssl="/output/openssl/${TARGET_ARCH}" \
    --with-openh264="/output/openh264/${TARGET_ARCH}" \
    --with-opus="/output/opus/${TARGET_ARCH}"

make dep
make

cd /tmp/pjsip/pjsip-apps/src/swig
make

mkdir -p /output/pjsip/jniLibs/${TARGET_ARCH}/
mv ./java/android/app/src/main/jniLibs/**/libpjsua2.so /output/pjsip/jniLibs/${TARGET_ARCH}/

if [ ! -d "/output/pjsip/java" ]; then
  mv ./java/android/app/src/main/java /output/pjsip/java
fi

rm -rf /tmp/pjsip