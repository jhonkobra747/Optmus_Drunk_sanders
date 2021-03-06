# AnyKernel2 Ramdisk Mod Script
# osm0sis @ xda-developers

## AnyKernel setup
# begin properties
properties() {
kernel.string=Extreme MaxPlus Kernel - by MendigodePijama
do.devicecheck=1
do.modules=1
do.cleanup=1
do.cleanuponabort=0
device.name1=sanders
device.name2=sanders_retail
} # end properties

# shell variables
block=/dev/block/bootdevice/by-name/boot;
is_slot_device=0;


## AnyKernel methods (DO NOT CHANGE)
# import patching functions/variables - see for reference
. /tmp/anykernel/tools/ak2-core.sh;


## AnyKernel permissions
# set permissions for included ramdisk files
chmod -R 750 $ramdisk/*;
chown -R root:root $ramdisk/*;

## AnyKernel install
dump_boot;

# begin ramdisk changes



mount -o ro,remount -t auto /system;
mount -o ro,remount -t auto /vendor 2>/dev/null;

backup_file init.rc;

insert_line init.rc "init.maxplus.rc" after "import /init.usb.configfs.rc" "import /init.maxplus.rc";

# end ramdisk changes

write_boot;

## end install

