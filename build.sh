#!/bin/bash

#set -e

DATE_POSTFIX=$(date +"%Y%m%d")
HOUR_POSTFIX=$(date +"%H%M")

## Copy this script inside the kernel directory
KERNEL_DIR=$PWD
KERNEL_TOOLCHAIN=/home/mendigodepijama/android/tools/android-ndk-r17-beta2/toolchains/aarch64-linux-android-4.9/prebuilt/linux-x86_64/bin/aarch64-linux-android-
CLANG_TOOLCHAIN=/home/mendigodepijama/android/tools/clang-r349610/bin/clang-8
KERNEL_DEFCONFIG=sanders_defconfig
DTBTOOL=$KERNEL_DIR/Dtbtool/
JOBS=8
ANY_KERNEL2_DIR=$KERNEL_DIR/AnyKernel2/
FINAL_KERNEL_ZIP=Extreme-MaxPlus-KERNEL_$DATE_POSTFIX-$HOUR_POSTFIX-EAS_CAF.zip
KERNEL_ZIP_FOLDER=/home/mendigodepijama/android/kernel/COMPILADOS/PIE/$FINAL_KERNEL_ZIP
# Speed up build process
MAKE="./makeparallel"

BUILD_START=$(date +"%s")
BIBlack='\033[1;90m'      # Black
BIRed='\033[1;91m'        # Red
BIGreen='\033[1;92m'      # Green
BIYellow='\033[1;93m'     # Yellow
BIBlue='\033[1;94m'       # Blue
BIPurple='\033[1;95m'     # Purple
BICyan='\033[1;96m'       # Cyan
BIWhite='\033[1;97m'      # White
Color_Off='\033[0m'       # Text Reset
On_IYellow='\033[0;103m'  # Yellow

echo -e "$BIYellow**** Setting Toolchain ****"
export CROSS_COMPILE=$KERNEL_TOOLCHAIN
export ARCH=arm64
export SUBARCH=arm64
export KBUILD_COMPILER_STRING="Clang Version 8.0.8"
echo -e "$Color_Off"

# Clean build always lol
# echo "**** Cleaning ****"
#make clean && make mrproper && rm -rf out/

echo -e "$BIYellow**** Kernel defconfig is set to:$Color_Off $BIPurple $KERNEL_DEFCONFIG ****"
echo -e "$Color_Off"
echo -e "$BIRed***********************************************"
echo "                 BUILDING KERNEL                   "
echo -e "***********************************************$Color_Off"
make $KERNEL_DEFCONFIG O=out
make -j$JOBS CC=$CLANG_TOOLCHAIN CLANG_TRIPLE=aarch64-linux-gnu- O=out
echo ""
if [ -f "$KERNEL_DIR/out/arch/arm64/boot/Image.gz" ]
then
echo -e "$BIRed***********************************************"
echo "              GENERATING DT.img                  "
echo -e "***********************************************$Color_Off"
$DTBTOOL/dtbToolCM -2 -o $KERNEL_DIR/out/arch/arm64/boot/dtb -s 2048 -p $KERNEL_DIR/out/scripts/dtc/ $KERNEL_DIR/out/arch/arm64/boot/dts/qcom/
echo ""
echo -e "$BIRed**** Verify Image.gz & dtb ****"
echo -e "$Color_Off"
ls $KERNEL_DIR/out/arch/arm64/boot/Image.gz
ls $KERNEL_DIR/out/arch/arm64/boot/dtb
echo ""
#Anykernel 2 time!!
echo -e "$BIRed******************************************************"
echo    "****          Verifying Anyernel2 Directory         ****"
echo -e "******************************************************$Color_Off"
ls $ANY_KERNEL2_DIR
echo ""
echo -e "$BIGreen**** Removing leftovers ****"
echo -e "$Color_Off"
rm -rf $ANY_KERNEL2_DIR/dtb
rm -rf $ANY_KERNEL2_DIR/Image.gz
rm -rf $ANY_KERNEL2_DIR/$FINAL_KERNEL_ZIP
echo "done..."
echo ""
echo -e "$BIGreen**** Copying Image.gz ****"
echo -e "$Color_Off"
echo "done..."
echo ""
cp $KERNEL_DIR/out/arch/arm64/boot/Image.gz $ANY_KERNEL2_DIR/
echo  -e "$BIGreen**** Copying dtb ****"
echo -e "$Color_Off"
cp $KERNEL_DIR/out/arch/arm64/boot/dtb $ANY_KERNEL2_DIR/
echo "done..."
echo ""
echo -e "$BIGreen**** Copying modules ****"
echo -e "$Color_Off"

[ -e "$KERNEL_DIR/out/drivers/char/rdbg.ko" ] && cp $KERNEL_DIR/out/drivers/char/rdbg.ko $ANY_KERNEL2_DIR/modules/vendor/lib/modules || echo "modulo não encontrado..."

[ -e "$KERNEL_DIR/out/drivers/media/usb/gspca/gspca_main.ko" ] && cp $KERNEL_DIR/out/drivers/media/usb/gspca/gspca_main.ko $ANY_KERNEL2_DIR/modules/vendor/lib/modules || echo "modulo não encontrado..."

[ -e "$KERNEL_DIR/out/drivers/misc/moto-dtv-fc8300/isdbt.ko" ] && cp $KERNEL_DIR/out/drivers/misc/moto-dtv-fc8300/isdbt.ko $ANY_KERNEL2_DIR/modules/vendor/lib/modules || echo "modulo não encontrado..."

[ -e "$KERNEL_DIR/out/drivers/spi/spidev.ko" ] && cp $KERNEL_DIR/out/drivers/spi/spidev.ko $ANY_KERNEL2_DIR/modules/vendor/lib/modules || echo "modulo não encontrado..."

[ -e "$KERNEL_DIR/out/drivers/video/backlight/backlight.ko" ] && cp $KERNEL_DIR/out/drivers/video/backlight/backlight.ko $ANY_KERNEL2_DIR/modules/vendor/lib/modules || echo "modulo não encontrado..."

[ -e "$KERNEL_DIR/out/crypto/ansi_cprng.ko" ] && cp $KERNEL_DIR/out/crypto/ansi_cprng.ko $ANY_KERNEL2_DIR/modules/vendor/lib/modules || echo "modulo não encontrado..."

[ -e "$KERNEL_DIR/out/drivers/video/backlight/generic_bl.ko" ] && cp $KERNEL_DIR/out/drivers/video/backlight/generic_bl.ko $ANY_KERNEL2_DIR/modules/vendor/lib/modules || echo "modulo não encontrado..."

[ -e "$KERNEL_DIR/out/drivers/video/backlight/lcd.ko" ] && cp $KERNEL_DIR/out/drivers/video/backlight/lcd.ko $ANY_KERNEL2_DIR/modules/vendor/lib/modules || echo "modulo não encontrado..."

[ -e "$KERNEL_DIR/out/net/bridge/br_netfilter.ko" ] && cp $KERNEL_DIR/out/net/bridge/br_netfilter.ko $ANY_KERNEL2_DIR/modules/vendor/lib/modules || echo "modulo não encontrado..."

[ -e "$KERNEL_DIR/out/drivers/mmc/card/mmc_test.ko" ] && cp $KERNEL_DIR/out/drivers/mmc/card/mmc_test.ko $ANY_KERNEL2_DIR/modules/vendor/lib/modules || echo "modulo não encontrado..."

[ -e "$KERNEL_DIR/out/drivers/input/evbug.ko" ] && cp $KERNEL_DIR/out/drivers/input/evbug.ko $ANY_KERNEL2_DIR/modules/vendor/lib/modules || echo "modulo não encontrado..."

[ -e "$KERNEL_DIR/out/drivers/usb/gadget/udc/dummy_hcd.ko" ] && cp $KERNEL_DIR/out/drivers/usb/gadget/udc/dummy_hcd.ko $ANY_KERNEL2_DIR/modules/vendor/lib/modules || echo "modulo não encontrado..."

echo "done..."
echo ""
echo -e "$BIGreen**** Time to zip up! ****"
echo -e "$Color_Off"
cd $ANY_KERNEL2_DIR/
zip -r9 $FINAL_KERNEL_ZIP * -x README $FINAL_KERNEL_ZIP
cp $KERNEL_DIR/AnyKernel2/$FINAL_KERNEL_ZIP $KERNEL_ZIP_FOLDER
echo "done..."
echo ""
echo -e "$BIGreen**** Cleaning Anyernel2 file... ****"
echo -e "$Color_Off"
cd $KERNEL_DIR
rm -rf arch/arm64/boot/dtb
rm -rf $ANY_KERNEL2_DIR/$FINAL_KERNEL_ZIP
rm -rf AnyKernel2/Image.gz
rm -rf AnyKernel2/dtb
rm -rf AnyKernel2/modules/vendor/lib/modules/*.ko
#rm -rf $KERNEL_DIR/out/
echo "done..."
echo ""
BUILD_END=$(date +"%s")
echo -e "$BIBlue**** $FINAL_KERNEL_ZIP Created Successfully****$Color_Off"
echo -e "( Kernel zip in:$BIGreen $KERNEL_ZIP_FOLDER $Color_Off)"
echo ""
DIFF=$(($BUILD_END - $BUILD_START))
echo -e "$BIYellow Build completed in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds."
echo -e "$Color_Off"
echo -e "$BICyan**************************************************************************************************"
echo -e "****                              ENJOY YOUR NEW KERNEL !!!                                   ****"
echo "**************************************************************************************************"
echo ""
else
echo -e "$BICyan**************************************************************************************************"
echo -e "****                                         ERROR !!!                                        ****"
echo "**************************************************************************************************"
echo ""
fi