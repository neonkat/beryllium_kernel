#!/bin/bash

# Custom Kernel build script

# Constants
green='\033[01;32m'
red='\033[01;31m'
blink_red='\033[05;31m'
cyan='\033[0;36m'
yellow='\033[0;33m'
blue='\033[0;34m'
default='\033[0m'

# Resources
HOME=/home/tanay297/android
KERNEL_DIR=$PWD
IMAGE=$KERNEL_DIR/out/arch/arm64/boot/Image.gz-dtb
DTBTOOL=$KERNEL_DIR/scripts/dtbToolCM
CLANG=$HOME/clang/dtc/bin/clang
TOOLCHAIN=$HOME/toolchain/7.x-linaro-64/bin/aarch64-linux-gnu-

#Paths
OUT_DIR=$KERNEL_DIR/ak
OUT_ZIP=$KERNEL_DIR/Releases
MODULE_DIR=$OUT_DIR/modules
NEW_OUT=$OUT_DIR

# Kernel Version Info
BASE="Infected_Kernel"
CUR_VER="-R3"
INFECTED_VER="$BASE$CUR_VER"
 
# Variables

DEFCONFIG="beryllium_defconfig"
export ARCH=arm64
export LOCALVERSION=-`echo $INFECTED_VER`
export KBUILD_BUILD_USER="tanay297"
export KBUILD_BUILD_HOST="krustykrab"

function make_infected {
		       echo -e "$green*******************************************************"
		       echo "                  Compiling $INFECTED_VER	              "
		       echo -e "*****************************************************$default"
		       echo 
		       make $DEFCONFIG 
                       make CC="ccache $CLANG" CLANG_TRIPLE=aarch64-linux-gnu- CROSS_COMPILE=$TOOLCHAIN -j4
		       rm -rf $NEWOUT/zImage
		       cp -vr $IMAGE $NEW_OUT/zImage
                       #make_modules
		       make_zip
		       housekeeping
		       echo -e "$green*******************************************************"
		       echo "              Compilation Completed!!              "
		       echo -e "*****************************************************$default"
		       }
		
function make_clean {
		    echo -e "$green***********************************************"
		    echo "          Cleaning up object files and other stuff	              "
		    echo -e "***********************************************$default"
                    make clean
		    make mrproper
		    make_infected
	            }
		
function make_recompile {
			echo -e "$cyan*******************************************************"
			echo "             Recompiling $INFECTED_VER	              "
			echo -e "*****************************************************$default"
                        make CC="ccache $CLANG" CLANG_TRIPLE=aarch64-linux-gnu- CROSS_COMPILE=$TOOLCHAIN -j4
			rm -rf $NEWOUT/zImage
			cp -vr $IMAGE $NEW_OUT/zImage
                        #make_modules		
			make_zip
			housekeeping
		        }
		
function make_dtb {
		  echo -e "$blue*******************************************************"
		  echo "             		Creating dt.img....	              "
		  echo -e "*****************************************************$default"
		  rm -rf $NEWOUT/dtb
		  $DTBTOOL -v -s 2048 -o $NEW_OUT/dtb -p scripts/dtc/ out/arch/arm64/boot/dts/
		  }


function make_modules {
		      rm -rf $MODULE_DIR/*
		      echo -e "$cyan*******************************************************"
		      echo "             Finding modules....	              "
		      echo -e "*****************************************************$default"
                      find . -path ./build -prune -o -name '*.ko' -print | xargs cp -t $MODULE_DIR/
		      cd $KERNEL_DIR
                      }


function make_zip {
		  echo -e "$yellow*******************************************************"
		  echo "             		Zipping up....	              "
		  echo -e "*****************************************************$default"
		  cd $OUT_DIR
		  rm -f *.zip
		  zip -r9 Infected_Beryllium`echo $CUR_VER`.zip *
		  mv Infected_Beryllium`echo $CUR_VER`.zip $OUT_ZIP
		  echo "Find your zip in Release directory"
		  cd $KERNEL_DIR 
		  }

function housekeeping {
		      echo -e "$green*******************************************************"
		      echo "            Cleaning up the mess created...	              "
		      echo -e "*****************************************************$default"
		      rm -rf $NEW_OUT/zImage
		      rm -rf $NEW_OUT/dtb
	              }
		

BUILD_START=$(date +"%s")
while read -p " 'A' to Compile Again , 'D' to Compile Dirty , 'C' to do a clean compilation , 'N' to exit " choice
do
case "$choice" in
	a|A)
		make_infected
		break
		;;
	d|D )
		make_recompile
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
		echo "YoU bLiNd?"
		echo
		;;
esac
done
BUILD_END=$(date +"%s")
DIFF=$(($BUILD_END - $BUILD_START))
echo -e "$green Build completed in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds.$default"
