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

# SQLCipher Version
SQLCIPHER_REPOSITORY_TAG="v3.3.1"

# OpenSSL Version
OPENSSL_REPOSITORY_TAG="OpenSSL_1_0_2f"

################################################################################
#
################################################################################

# Directory Path in which this script is located.
SCRIPT_DIR=$(cd -P $(dirname $0) && pwd -P)

# OpenSSL Root Path
OPENSSL_PATH="${SCRIPT_DIR}/../OpenSSL/dest/${OPENSSL_REPOSITORY_TAG}/Android"

# OpenSSL Include Path(armeabi)
OPENSSL_INCLUDE_PATH_ARM="${OPENSSL_PATH}/armeabi/include"

# OpenSSL Library Path(armeabi)
OPENSSL_LIBRARY_PATH_ARM="${OPENSSL_PATH}/armeabi/lib"

# OpenSSL Include Path(armeabi-v7a)
OPENSSL_INCLUDE_PATH_ARMV7="${OPENSSL_PATH}/armeabi-v7a/include"

# OpenSSL Library Path(armeabi-v7a)
OPENSSL_LIBRARY_PATH_ARMV7="${OPENSSL_PATH}/armeabi-v7a/lib"

# OpenSSL Include Path(armeabi-v7a)
OPENSSL_INCLUDE_PATH_X86="${OPENSSL_PATH}/x86/include"

# OpenSSL Library Path(armeabi-v7a)
OPENSSL_LIBRARY_PATH_X86="${OPENSSL_PATH}/x86/lib"

# SQLCipher Git Repository URL
SQLCIPHER_REPOSITORY_URL="git://github.com/sqlcipher/sqlcipher.git"

# SQLCipher Source Directory Path
SRC_DIR="${SCRIPT_DIR}/src/sqlcipher/${SQLCIPHER_REPOSITORY_TAG}"

# Output Directory Path
OUTPUT_DIR="${SCRIPT_DIR}/dest/${SQLCIPHER_REPOSITORY_TAG}/Android"

# Android Platform Version
ANDROID_PLATFORM="android-19"

# Android NDK standalone-toolchain Path
NDK_TOOLCHAIN_PATH="${OUTPUT_DIR}/toolchain"

# Android NDK standalone-toolchain(ARM)
ARM_TOOLCHAIN="arm-linux-androideabi-4.9"

# Android NDK standalone-toolchain(x86)
X86_TOOLCHAIN="x86-4.9"

# Android NDK standalone-toolchain Path(ARM)
ARM_TOOLCHAIN_PATH="${NDK_TOOLCHAIN_PATH}/arm"

# Android NDK standalone-toolchain Path(x86)
X86_TOOLCHAIN_PATH="${NDK_TOOLCHAIN_PATH}/x86"

################################################################################
#
################################################################################

# git clone
rm -rf "${SRC_DIR}"
git clone -b "${SQLCIPHER_REPOSITORY_TAG}" "${SQLCIPHER_REPOSITORY_URL}" "${SRC_DIR}"

################################################################################
#
################################################################################

# make Android NDK standalone-toolchain(ARM)
rm -rf "${ARM_TOOLCHAIN_PATH}"
"${NDK_ROOT}/build/tools/make-standalone-toolchain.sh" --arch=arm --toolchain="${ARM_TOOLCHAIN}" --install-dir="${ARM_TOOLCHAIN_PATH}" --platform="${ANDROID_PLATFORM}"

find "${ARM_TOOLCHAIN_PATH}/bin" -name arm-linux-androideabi* -type f | while read FILE
do
  cp -f "${FILE}" "${FILE%/*}/arm-linux${FILE##*-androideabi}"
done

# make Android NDK standalone-toolchain(x86)
rm -rf "${X86_TOOLCHAIN_PATH}"
"${NDK_ROOT}/build/tools/make-standalone-toolchain.sh" --arch=x86 --toolchain="${X86_TOOLCHAIN}" --install-dir="${X86_TOOLCHAIN_PATH}" --platform="${ANDROID_PLATFORM}"

find "${X86_TOOLCHAIN_PATH}/bin" -name i686-linux-android* -type f | while read FILE
do
  cp -f "${FILE}" "${FILE%/*}/i686-linux${FILE##*-android}"
done

################################################################################
#
################################################################################

cd "${SRC_DIR}"

# build for armeabi
ARCH="armv5"
PREFIX="${OUTPUT_DIR}/armeabi"
HOST="arm-linux"
OPENSSL_INCLUDE_PATH="${OPENSSL_INCLUDE_PATH_ARM}"
OPENSSL_LIBRARY_PATH="${OPENSSL_LIBRARY_PATH_ARM}"
TOOLCHAIN_PATH="${ARM_TOOLCHAIN_PATH}/bin"
PATH="${TOOLCHAIN_PATH}:${PATH}" && ./configure --prefix="${PREFIX}" -host="${HOST}" --enable-tempstore=yes --disable-tcl --disable-readline CFLAGS="-DSQLITE_HAS_CODEC -DSQLITE_TEMP_STORE=2 -march=${ARCH} -fPIE -I${OPENSSL_INCLUDE_PATH}" LDFLAGS="-L${OPENSSL_LIBRARY_PATH}"
make clean && make && make install

# build for armeabi-v7a
ARCH="armv7-a"
PREFIX="${OUTPUT_DIR}/armeabi-v7a"
HOST="arm-linux"
OPENSSL_INCLUDE_PATH="${OPENSSL_INCLUDE_PATH_ARMV7}"
OPENSSL_LIBRARY_PATH="${OPENSSL_LIBRARY_PATH_ARMV7}"
TOOLCHAIN_PATH="${ARM_TOOLCHAIN_PATH}/bin"
PATH="${TOOLCHAIN_PATH}:${PATH}" && ./configure --prefix="${PREFIX}" -host="${HOST}" --enable-tempstore=yes --disable-tcl --disable-readline CFLAGS="-DSQLITE_HAS_CODEC -DSQLITE_TEMP_STORE=2 -march=${ARCH} -fPIE -I${OPENSSL_INCLUDE_PATH}" LDFLAGS="-L${OPENSSL_LIBRARY_PATH}"
make clean && make && make install

# build for x86
ARCH="i686"
PREFIX="${OUTPUT_DIR}/x86"
HOST="i686-linux"
OPENSSL_INCLUDE_PATH="${OPENSSL_INCLUDE_PATH_X86}"
OPENSSL_LIBRARY_PATH="${OPENSSL_LIBRARY_PATH_X86}"
TOOLCHAIN_PATH="${X86_TOOLCHAIN_PATH}/bin"
PATH="${TOOLCHAIN_PATH}:${PATH}" && ./configure --prefix="${PREFIX}" -host="${HOST}" --enable-tempstore=yes --disable-tcl --disable-readline CFLAGS="-DSQLITE_HAS_CODEC -DSQLITE_TEMP_STORE=2 -march=${ARCH} -fPIE -I${OPENSSL_INCLUDE_PATH}" LDFLAGS="-L${OPENSSL_LIBRARY_PATH}"
make clean && make && make install


cp -f "${SCRIPT_DIR}/Android.mk" "${OUTPUT_DIR}/Android.mk"
rm -rf "${NDK_TOOLCHAIN_PATH}"
