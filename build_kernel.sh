#!/bin/bash
clear
#sudo apt install cpio
export ARCH=arm64
export PLATFORM_VERSION=14
export ANDROID_MAJOR_VERSION=u
export INSTALL_MOD_PATH=/workspace/gitpod/dist/lib/modules
mkdir out
ARGS='
    CC=/workspace/gitpod/Toolchains_by_Google/clang-10.0/bin/clang
    CROSS_COMPILE=/workspace/gitpod/Toolchains_by_Google/aarch64-4.9/bin/aarch64-linux-android-
    CLANG_TRIPLE=aarch64-linux-gnu-
    KERNEL_MAKE_ENV="DTC_EXT=$(pwd)/tools/dtc CONFIG_BUILD_ARM64_DT_OVERLAY="y"
    ARCH=arm64
'
#make -j8 -C $(pwd) O=$(pwd)/out ${ARGS} clean && make -j8 -C $(pwd) O=$(pwd)/out ${ARGS} mrproper
#make -j8 -C $(pwd) O=$(pwd)/out ${ARGS} samsung_defconfig
make -j8 -C $(pwd) O=$(pwd)/out ${ARGS} menuconfig
make -j8 -C $(pwd) O=$(pwd)/out ${ARGS}
make -j8 -C $(pwd) O=$(pwd)/out ${ARGS} modules_install