DIR=`readlink -f .`
MAIN=`readlink -f ${DIR}/..`

export OUT_DIR=$DIR/out
export CLANG_PATH=$MAIN/toolchains/clang/host/linux-x86/clang-r416183b/bin
export PATH=${BINUTILS_PATH}:${CLANG_PATH}:${PATH}
export ARCH=arm64
export ANDROID_MAJOR_VERSION=s

export KCFLAGS=-w
export CONFIG_SECTION_MISMATCH_WARN_ONLY=y
export TARGET_BUILD_VARIANT=eng

make -j8 CC='ccache clang' ARCH=arm64 LLVM=2 LLVM_IAS=1 O=out gki_defconfig

#!/bin/bash
# Resources
THREAD="-j$(nproc --all)"

export CLANG_PATH=$MAIN/clang-r416183b/bin/
export PATH=${CLANG_PATH}:${PATH}
export CLANG_TRIPLE=aarch64-linux-gnu-
export CROSS_COMPILE=$MAIN/toolchains/clang/host/linux-x86/clang-r416183b/bin/aarch64-linux-gnu- CC=clang CXX=clang++

DEFCONFIG=gki_defconfig

# Paths
KERNEL_DIR=`pwd`
ZIMAGE_DIR="$KERNEL_DIR/out/arch/arm64/boot"
export ARCH=arm64
export SUBARCH=$ARCH
export ANDROID_MAJOR_VERSION=u
export KBUILD_BUILD_USER=LMAO-armv8

DATE_START=$(date +"%s")

echo "DEFCONFIG SET TO $DEFCONFIG"
echo "-------------------------------------------------"
echo "Building kernel"
echo "-------------------------------------------------"
echo 

make CC="ccache clang" CXX="ccache clang++" LLVM=1 LLVM_IAS=1 O=$OUT_DIR $DEFCONFIG
make CC="ccache clang" CXX="ccache clang++" LLVM=1 LLVM_IAS=1 O=$OUT_DIR $THREAD 2>&1 | tee kernel.log

echo "DEFCONFIG SET TO $DEFCONFIG"
echo "-------------------------------------------------"
echo "Building completed"
echo "-------------------------------------------------"
echo 

DATE_END=$(date +"%s")
DIFF=$(($DATE_END - $DATE_START))
echo "Time: $(($DIFF / 60)) minutes(s) and $((DIFF % 60)) seconds."
echo
ls -a $ZIMAGE_DIR

cd $KERNEL_DIR

TIME="$(date "+%Y%m%d-%H%M%S")"
mkdir -p tmp
cp -fp $ZIMAGE_DIR/Image.gz tmp

#cp -r out/arch/arm64/boot/Image AIK/zImage
#cp -r out/arch/arm64/boot/dtb_m32.img AIK/zImage-dtb
#cp -r out/arch/arm64/boot/dtbo_m32.img AIK/dtbo

#cd AIK
#zip -r9 ../out/LMAO_kernel_m32.zip * -x *placeholder
#rm -rf zImage zImage-dtb dtbo
#cd ..
