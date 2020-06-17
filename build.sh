#!/bin/bash

# Resources
HOME=/home/tanay297/Android
KERNEL_DIR=$PWD
IMAGE=$KERNEL_DIR/arch/arm64/boot/Image.gz-dtb
CLANG=$HOME/Toolchain/clang/bin/clang
TOOLCHAIN_64=$HOME/Toolchain/arm64-gcc/bin/aarch64-elf-
TOOLCHAIN_32=$HOME/Toolchain/arm32-gcc/bin/arm-eabi-

# Paths
OUT_DIR=$KERNEL_DIR/ak
OUT_ZIP=$KERNEL_DIR/Releases

# Kernel Version Info
BASE=""
CUR_VER=""
KERNEL_VER="$BASE$CUR_VER"
 
# Variables
DEFCONFIG="simple+-beryllium_defconfig"
export ARCH=arm64
export SUBARCH=arm64
export LOCALVERSION="$(echo $KERNEL_VER)"
export KBUILD_BUILD_USER="tanay297"
export KBUILD_BUILD_HOST="krustykrab"
export PATH="$HOME/Toolchain/proton/bin:$PATH"

# Functions
function make_kernel {
	        echo -e "\nBuilding....\n"
		    make $DEFCONFIG 
            make CC="ccache clang" CROSS_COMPILE=aarch64-linux-gnu- CROSS_COMPILE_ARM32=arm-linux-gnueabi- -j4
		    rm -rf $OUT_DIR/zImage
		    cp -vr $IMAGE $OUT_DIR/zImage
		    make_zip
		    housekeeping
		    }
		
function make_clean {
		    echo -e "\nCleaning....\n"
            make clean
		    make mrproper
		    make_kernel
	        }

function make_zip {
		    echo -e "\nZipping....\n"
		    cd $OUT_DIR
		    rm -f *.zip
		    zip -r9 "Beryllium_Simple+$(echo $CUR_VER).zip" *
			mv "Beryllium_Simple+$(echo $CUR_VER).zip" $OUT_ZIP
		    echo -e "\nDone....\n"
		    cd $KERNEL_DIR 
		    }

function housekeeping {
		    echo -e "\nCleaning....\n"
		    rm -rf $OUT_DIR/zImage
	        }
		
# Main
BUILD_START=$(date +"%s")
while read -p " 'D' -> Dirty Compile , 'C' -> Clean Compile , 'N' -> exit " choice
do
case "$choice" in
	d|D )
		make_kernel
		break
		;;
	c|C )
		make_clean
		break;
		;;
	n|N )
		break
		;;
	* )
		echo
		echo "Naise"
		echo
		;;
esac
done
BUILD_END=$(date +"%s")
DIFF=$(($BUILD_END - $BUILD_START))
echo -e "\nBuild completed in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds.\n"
