#!/bin/bash
set -e

TARGET_ARCH=$1
TARGET_PATH=/output/openh264/${TARGET_ARCH}

cp -r /sources/openh264 /tmp/openh264
cd /tmp/openh264

sed -i "s*PREFIX=/usr/local*PREFIX=${TARGET_PATH}*g" Makefile

ARGS="OS=android ENABLEPIC=Yes NDKROOT=/sources/android_ndk NDKLEVEL=${OPENH264_TARGET_NDK_LEVEL} "
ARGS="${ARGS}TARGET=android-${ANDROID_TARGET_API} ARCH="

if [ "$TARGET_ARCH" == "armeabi" ]
then
    ARGS="${ARGS}arm APP_ABI=armeabi"
elif [ "$TARGET_ARCH" == "armeabi-v7a" ]
then
    ARGS="${ARGS}arm"
elif [ "$TARGET_ARCH" == "x86" ]
then
    ARGS="${ARGS}x86"
elif [ "$TARGET_ARCH" == "x86_64" ]
then
    ARGS="${ARGS}x86_64"
elif [ "$TARGET_ARCH" == "arm64-v8a" ]
then
    ARGS="${ARGS}arm64"
elif [ "$TARGET_ARCH" == "mips" ]
then
    ARGS="${ARGS}mips"
elif [ "$TARGET_ARCH" == "mips64" ]
then
    ARGS="${ARGS}mips64"
fi

make ${ARGS} install

rm -rf /tmp/openh264