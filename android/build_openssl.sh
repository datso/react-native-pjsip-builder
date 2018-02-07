#!/bin/bash
#@see http://stackoverflow.com/questions/11929773/compiling-the-latest-openssl-for-android
set -e

GCC_VERSION=$(gcc --version | grep gcc | awk '{print $4}' | cut -d'.' -f1,2)

TARGET_ARCH=$1
TARGET_PATH=/output/openssl/${TARGET_ARCH}

cp -r /sources/openssl /tmp/openssl

if [ "$TARGET_ARCH" == "armeabi-v7a" ]
then
    TARGET=android-armv7
    TOOLCHAIN=arm-linux-androideabi-4.9
    export TOOL=arm-linux-androideabi
    export ARCH_FLAGS="-march=armv7-a -mfloat-abi=softfp -mfpu=vfpv3-d16"
    export ARCH_LINK="-march=armv7-a -Wl,--fix-cortex-a8"
elif [ "$TARGET_ARCH" == "arm64-v8a" ]
then
    TARGET=android
    TOOLCHAIN=aarch64-linux-android-4.9
    export TOOL=aarch64-linux-android
    export ARCH_FLAGS=
    export ARCH_LINK=
elif [ "$TARGET_ARCH" == "armeabi" ]
then
    TARGET=android
    TOOLCHAIN=arm-linux-androideabi-4.9
    export TOOL=arm-linux-androideabi
    export ARCH_FLAGS="-mthumb"
    export ARCH_LINK=
elif [ "$TARGET_ARCH" == "x86" ]
then
    TARGET=android-x86
    TOOLCHAIN=x86-4.9
    export TOOL=i686-linux-android
    export ARCH_FLAGS="-march=i686 -msse3 -mstackrealign -mfpmath=sse"
    export ARCH_LINK=
elif [ "$TARGET_ARCH" == "x86_64" ]
then
    TARGET=linux-x86_64
    TOOLCHAIN=x86_64-4.9
    export TOOL=x86_64-linux-android
elif [ "$TARGET_ARCH" == "mips" ]
then
    TARGET=android-mips
    TOOLCHAIN=mipsel-linux-android-4.9
    export TOOL=mipsel-linux-android
    export ARCH_FLAGS=
    export ARCH_LINK=
elif [ "$TARGET_ARCH" == "mips64" ]
then
    TARGET=android-mips64
    TOOLCHAIN=mips64el-linux-android-4.9
    export TOOL=mips64el-linux-android
    export ARCH_FLAGS=
    export ARCH_LINK=
else
    echo "Unsupported target ABI: $TARGET_ARCH"
    exit 1
fi

export TOOLCHAIN_PATH="/tmp/openssl/android-toolchain/bin"
export PATH=$TOOLCHAIN_PATH:$PATH
export NDK_TOOLCHAIN_BASENAME=${TOOLCHAIN_PATH}/${TOOL}
export CC=$NDK_TOOLCHAIN_BASENAME-gcc
export CXX=$NDK_TOOLCHAIN_BASENAME-g++
export LINK=${CXX}
export LD=$NDK_TOOLCHAIN_BASENAME-ld
export AR=$NDK_TOOLCHAIN_BASENAME-ar
export RANLIB=$NDK_TOOLCHAIN_BASENAME-ranlib
export STRIP=$NDK_TOOLCHAIN_BASENAME-strip
export CPPFLAGS=" ${ARCH_FLAGS} -fpic -ffunction-sections -funwind-tables -fstack-protector -fno-strict-aliasing -finline-limit=64 "
export CXXFLAGS=" ${ARCH_FLAGS} -fpic -ffunction-sections -funwind-tables -fstack-protector -fno-strict-aliasing -finline-limit=64 -frtti -fexceptions "
export CFLAGS=" ${ARCH_FLAGS} -fpic -ffunction-sections -funwind-tables -fstack-protector -fno-strict-aliasing -finline-limit=64 "
export LDFLAGS=" ${ARCH_LINK} "


################################
# TODO
################################

cd /sources/android_ndk/build/tools/

./make-standalone-toolchain.sh \
    --ndk-dir=/sources/android_ndk \
    --platform=android-${ANDROID_TARGET_API} \
    --toolchain=${TOOLCHAIN} \
    --install-dir="/tmp/openssl/android-toolchain"

cd /tmp/openssl/

################################
# TODO
################################

./Configure ${TARGET} no-asm no-unit-test --openssldir=${TARGET_PATH}
make && make install

rm -rf /tmp/openssl/

