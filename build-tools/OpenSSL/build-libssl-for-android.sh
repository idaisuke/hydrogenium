#!/bin/bash

set -eu

# Android NDK Root Path
if [ "${NDK_ROOT:-""}" = "" ] ; then
  echo -n "Please input NDK_ROOT > "
  read NDK_ROOT
fi

################################################################################
#
################################################################################

# OpenSSL Version
OPENSSL_VERSION=1_0_2a

# Android Platform Version
ANDROID_PLATFORM=android-19

################################################################################
#
################################################################################

# OpenSSL Git Repository URL
REPOSITORY_URL=git://github.com/openssl/openssl.git

# OpenSSL Git Repository Tag
REPOSITORY_TAG=OpenSSL_$OPENSSL_VERSION

# Directory Path in which this script is located.
SCRIPT_DIR=$(cd -P $(dirname $0) && pwd -P)

# OpenSSL Source Directory Path
SRC_DIR=$SCRIPT_DIR/src/$OPENSSL_VERSION

# Output Directory Path
OUTPUT_DIR=$SCRIPT_DIR/dest/$OPENSSL_VERSION/Android

# Android NDK standalone-toolchain Path
NDK_TOOLCHAIN_PATH=$OUTPUT_DIR/a1e1124d-8e65-444b-b19e-ba883168c4a8

# Android NDK standalone-toolchain Path(ARM)
ARM_TOOLCHAIN_PATH=$NDK_TOOLCHAIN_PATH/arm

# Android NDK standalone-toolchain Path(x86)
X86_TOOLCHAIN_PATH=$NDK_TOOLCHAIN_PATH/x86

# Android NDK standalone-toolchain Prefix(ARM)
ARM_TOOLCHAIN_PREFIX=$ARM_TOOLCHAIN_PATH/bin/arm-linux-androideabi-

# Android NDK standalone-toolchain Prefix(x86)
X86_TOOLCHAIN_PREFIX=$X86_TOOLCHAIN_PATH/bin/i686-linux-android-

################################################################################
#
################################################################################

# git clone
rm -rf $SRC_DIR
git clone -b $REPOSITORY_TAG $REPOSITORY_URL $SRC_DIR

################################################################################
#
################################################################################

# make Android NDK standalone-toolchain(ARM)
rm -rf $ARM_TOOLCHAIN_PATH
$NDK_ROOT/build/tools/make-standalone-toolchain.sh --arch=arm --install-dir=$ARM_TOOLCHAIN_PATH --platform=$ANDROID_PLATFORM

# make Android NDK standalone-toolchain(x86)
rm -rf $X86_TOOLCHAIN_PATH
$NDK_ROOT/build/tools/make-standalone-toolchain.sh --arch=x86 --install-dir=$X86_TOOLCHAIN_PATH --platform=$ANDROID_PLATFORM

################################################################################
#
################################################################################

cd $SRC_DIR

# build for armeabi
CONFIG=android
PREFIX=$OUTPUT_DIR/armeabi
CROSS_COMPILE_PREFIX=$ARM_TOOLCHAIN_PREFIX
export ANDROID_DEV=$NDK_ROOT/platforms/$ANDROID_PLATFORM/arch-arm/usr
./Configure --prefix=$PREFIX --cross-compile-prefix=$CROSS_COMPILE_PREFIX $CONFIG threads no-shared
make -s && make install

# build for armeabi-v7a
CONFIG=android-armv7
PREFIX=$OUTPUT_DIR/armeabi-v7a
CROSS_COMPILE_PREFIX=$ARM_TOOLCHAIN_PREFIX
export ANDROID_DEV=$NDK_ROOT/platforms/$ANDROID_PLATFORM/arch-arm/usr
make clean
./Configure --prefix=$PREFIX --cross-compile-prefix=$CROSS_COMPILE_PREFIX $CONFIG threads no-shared
make -s && make install

# build for x86
CONFIG=android-x86
PREFIX=$OUTPUT_DIR/x86
CROSS_COMPILE_PREFIX=$X86_TOOLCHAIN_PREFIX
export ANDROID_DEV=$NDK_ROOT/platforms/$ANDROID_PLATFORM/arch-x86/usr
make clean
./Configure --prefix=$PREFIX --cross-compile-prefix=$CROSS_COMPILE_PREFIX $CONFIG threads no-shared
make -s && make install

cp -f $SCRIPT_DIR/Android.mk $OUTPUT_DIR/Android.mk
rm -rf $NDK_TOOLCHAIN_PATH
