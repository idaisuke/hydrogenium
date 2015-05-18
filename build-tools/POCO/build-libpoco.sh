#!/bin/sh

# poco-1.4.7-allで動作確認
# 実行前に以下を修正する
#
# build/config/Androidを修正する
# 27行目 i686-android-linuxをi686-linux-androidに修正
# 64行目 CXXFLAGSに-std=c++11を追加
#
# build/config/iPhone-clang-libc++を修正する
# 74行目 CXXFLAGSに-std=c++11を追加
#
# build/config/iPhoneSimulator-clang-libc++を修正する
# 10行目 POCO_TARGET_OSARCH = i686 を POCO_TARGET_OSARCH ?= i686 に修正
#
# Foundation/include/Poco/AtomicCounter.hを修正する
# 以下のPOCO_OSの値により分岐させている#if〜#endifを#else部分を残してコメントアウトする
# 44〜56行目をコメントアウト
# 143〜166, 139行目をコメントアウト
# 150〜291, 372行目をコメントアウト
#
# Foundation/include/Poco/AtomicCounter.hを修正する
# 以下のPOCO_OSの値により分岐させている#if〜#endifを#else部分を残してコメントアウトする
# 127〜133, 209行目をコメントアウト
#
# Data/ODBC/ODBC.makeを修正する
# 45行目をコメントアウト
#
# 注意! r9d make-standalone-toolchain.sh バグ cxxabi.h等がコピーされない

# POCOのソースディレクトリ(フルパス)
SRC_DIR=/Users/Daisuke/Documents/tools/build-tools/POCO/src/poco-1.6.0-all

#出力ディレクトリ
DEST_DIR=/Users/Daisuke/Documents/tools/build-tools/POCO/dest/1.6.0-r10d-libc++

# Open SSLのライブラリパス(iOS)(フルパス)
OPENSSL_LIBRARY_PATH_IOS=/Users/itabashi/Documents/OpenSSL/iOS/lib

#Open SSLのインクルードパス(Android arm)
OPENSSL_INCLUDE_PATH_ANDROID_ARM=/Users/Daisuke/Documents/tools/build-tools/OpenSSL/dest/r9d/armeabi/include

#Open SSLのライブラリパス(Android arm)
OPENSSL_LIBRARY_PATH_ANDROID_ARM=/Users/Daisuke/Documents/tools/build-tools/OpenSSL/dest/r9d/armeabi/lib

#Open SSLのインクルードパス(Android armv7)
OPENSSL_INCLUDE_PATH_ANDROID_ARMV7=/Users/Daisuke/Documents/tools/build-tools/OpenSSL/dest/r9d/armeabi-v7a/include

#Open SSLのライブラリパス(Android armv7)
OPENSSL_LIBRARY_PATH_ANDROID_ARMV7=/Users/Daisuke/Documents/tools/build-tools/OpenSSL/dest/r9d/armeabi-v7a/lib

#Open SSLのインクルードパス(Android x86)
OPENSSL_INCLUDE_PATH_ANDROID_X86=/Users/Daisuke/Documents/tools/build-tools/OpenSSL/dest/r9d/x86/include

#Open SSLのライブラリパス(Android x86)
OPENSSL_LIBRARY_PATH_ANDROID_X86=/Users/Daisuke/Documents/tools/build-tools/OpenSSL/dest/r9d/x86/lib

#Android NDK Root
NDK_ROOT=/usr/local/android-ndk/r9d

# Androidバージョン
ANDROID_PLATFORM=android-19

# make-standalone-toolchain.sh オブション
ARM_TOOLCHAIN=arm-linux-androideabi-4.8

# make-standalone-toolchain.sh オブション
X86_TOOLCHAIN=x86-4.8

# make-standalone-toolchain.sh オブション
LLVM_VERSION=3.4

# make-standalone-toolchain.sh オブション
STL=libc++

#Android NDK standalone-toolchainのパス(ARM)
ARM_TOOLCHAIN_PATH=$DEST_DIR/standalone-toolchain/arm

#Android NDK standalone-toolchainのパス(x86)
X86_TOOLCHAIN_PATH=$DEST_DIR/standalone-toolchain/x86

# configureオプション
OMIT=PageCompiler,Data/MySQL,Data/ODBC

cd $POCO_SRC_DIR

# iOS
PLATFORM=iOS
INCLUDE_PATH=$OPENSSL_INCLUDE_PATH_IOS
LIBRARY_PATH=$OPENSSL_LIBRARY_PATH_IOS

CONFIG=iPhone-clang-libc++
TARGET_OSARCH=armv7
PREFIX=$DEST_DIR/$PLATFORM/$TARGET_OSARCH
export POCO_TARGET_OSARCH=$TARGET_OSARCH
make distclean
./configure --config=$CONFIG --prefix=$PREFIX --no-tests --no-samples --omit=$OMIT --include-path=$INCLUDE_PATH --library-path=$LIBRARY_PATH --static
make clean -s && make -s && make install
LIB_IOS_ARMV7=$PREFIX/lib

if [ $? -ne 0 ]; then
	exit 1
fi

CONFIG=iPhone-clang-libc++
TARGET_OSARCH=armv7s
PREFIX=$DEST_DIR/$PLATFORM/$TARGET_OSARCH
export POCO_TARGET_OSARCH=$TARGET_OSARCH
make distclean
./configure --config=$CONFIG --prefix=$PREFIX --no-tests --no-samples --omit=$OMIT --include-path=$INCLUDE_PATH --library-path=$LIBRARY_PATH --static
make clean -s && make -s && make install
LIB_IOS_ARMV7S=$PREFIX/lib

if [ $? -ne 0 ]; then
	exit 1
fi

CONFIG=iPhone-clang-libc++
TARGET_OSARCH=arm64
PREFIX=$DEST_DIR/$PLATFORM/$TARGET_OSARCH
export POCO_TARGET_OSARCH=$TARGET_OSARCH
make distclean
./configure --config=$CONFIG --prefix=$PREFIX --no-tests --no-samples --omit=$OMIT --include-path=$INCLUDE_PATH --library-path=$LIBRARY_PATH --static
make clean -s && make -s && make install
LIB_IOS_ARM64=$PREFIX/lib

if [ $? -ne 0 ]; then
	exit 1
fi

CONFIG=iPhoneSimulator-clang-libc++
TARGET_OSARCH=i686
PREFIX=$DEST_DIR/$PLATFORM/$TARGET_OSARCH
export POCO_TARGET_OSARCH=$TARGET_OSARCH
make distclean
./configure --config=$CONFIG --prefix=$PREFIX --no-tests --no-samples --omit=$OMIT --include-path=$INCLUDE_PATH --library-path=$LIBRARY_PATH --static
make clean -s && make -s && make install
LIB_IOS_I686=$PREFIX/lib

if [ $? -ne 0 ]; then
	exit 1
fi

CONFIG=iPhoneSimulator-clang-libc++
TARGET_OSARCH=x86_64
PREFIX=$DEST_DIR/$PLATFORM/$TARGET_OSARCH
export POCO_TARGET_OSARCH=$TARGET_OSARCH
make distclean
./configure --config=$CONFIG --prefix=$PREFIX --no-tests --no-samples --omit=$OMIT --include-path=$INCLUDE_PATH --library-path=$LIBRARY_PATH --static
make clean -s && make -s && make install
LIB_IOS_X86_64=$PREFIX/lib

if [ $? -ne 0 ]; then
	exit 1
fi

LIB_FILES=$(ls $LIB_IOS_ARMV7)
mkdir -p $DEST_DIR/$PLATFORM/lib
for file in $LIB_FILES
do
	lipo $LIB_IOS_ARMV7/$file $LIB_IOS_ARMV7S/$file $LIB_IOS_ARM64/$file $LIB_IOS_I686/$file $LIB_IOS_X86_64/$file -create -output $DEST_DIR/$PLATFORM/lib/$file
done

if [ $? -ne 0 ]; then
	exit 1
fi

# Android
cd $NDK_ROOT

# Android NDK standalone-toolchainを作成(ARM)
$NDK_ROOT/build/tools/make-standalone-toolchain.sh --toolchain=$ARM_TOOLCHAIN --llvm-version=$LLVM_VERSION --stl=$STL --arch=arm --ndk-dir=$NDK_ROOT --system=darwin-x86_64 --install-dir=$ARM_TOOLCHAIN_PATH --platform=$ANDROID_PLATFORM
if [ $? -ne 0 ]; then
	exit 1
fi

# Android NDK standalone-toolchainを作成(x86)
$NDK_ROOT/build/tools/make-standalone-toolchain.sh --toolchain=$X86_TOOLCHAIN --llvm-version=$LLVM_VERSION --stl=$STL --arch=x86 --ndk-dir=$NDK_ROOT --system=darwin-x86_64 --install-dir=$X86_TOOLCHAIN_PATH --platform=$ANDROID_PLATFORM
if [ $? -ne 0 ]; then
	exit 1
fi

cd $POCO_SRC_DIR

PLATFORM=Android
CONFIG=Android
TARGET_OSARCH=armeabi
TOOLCHAIN_PATH=$ARM_TOOLCHAIN_PATH/bin
INCLUDE_PATH=$OPENSSL_INCLUDE_PATH_ANDROID_ARM
LIBRARY_PATH=$OPENSSL_LIBRARY_PATH_ANDROID_ARM
PREFIX=$DEST_DIR/$PLATFORM/$TARGET_OSARCH
export ANDROID_ABI=$TARGET_OSARCH
make distclean
./configure --config=$CONFIG --prefix=$PREFIX --no-tests --no-samples --omit=$OMIT --include-path=$INCLUDE_PATH --library-path=$LIBRARY_PATH --static
PATH=$PATH:$TOOLCHAIN_PATH && make clean -s && make -s && make install

if [ $? -ne 0 ]; then
	exit 1
fi

PLATFORM=Android
CONFIG=Android
TARGET_OSARCH=armeabi-v7a
TOOLCHAIN_PATH=$ARM_TOOLCHAIN_PATH/bin
INCLUDE_PATH=$OPENSSL_INCLUDE_PATH
LIBRARY_PATH=$OPENSSL_LIBRARY_PATH_ANDROID_ARMV7
PREFIX=$DEST_DIR/$PLATFORM/$TARGET_OSARCH
export ANDROID_ABI=$TARGET_OSARCH
make distclean
./configure --config=$CONFIG --prefix=$PREFIX --no-tests --no-samples --omit=$OMIT --include-path=$INCLUDE_PATH --library-path=$LIBRARY_PATH --static
PATH=$PATH:$TOOLCHAIN_PATH && make clean -s && make -s && make install

if [ $? -ne 0 ]; then
	exit 1
fi

PLATFORM=Android
CONFIG=Android
TARGET_OSARCH=x86
TOOLCHAIN_PATH=$X86_TOOLCHAIN_PATH/bin
INCLUDE_PATH=$OPENSSL_INCLUDE_PATH
LIBRARY_PATH=$OPENSSL_LIBRARY_PATH_ANDROID_X86
PREFIX=$DEST_DIR/$PLATFORM/$TARGET_OSARCH
export ANDROID_ABI=$TARGET_OSARCH
make distclean
./configure --config=$CONFIG --prefix=$PREFIX --no-tests --no-samples --omit=$OMIT --include-path=$INCLUDE_PATH --library-path=$LIBRARY_PATH --static
PATH=$PATH:$TOOLCHAIN_PATH && make clean -s && make -s && make install

if [ $? -ne 0 ]; then
	exit 1
fi
