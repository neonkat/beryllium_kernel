# AnyKernel2 Ramdisk Mod Script
# osm0sis @ xda-developers

## AnyKernel setup
# begin properties
properties() { '
kernel.string=
do.devicecheck=1
do.modules=0
do.cleanup=1
do.cleanuponabort=1
device.name1=beryllium
device.name2=
device.name3=
device.name4=
device.name5=
supported.versions=9
'; } # end properties

# shell variables
block=/dev/block/bootdevice/by-name/boot;
is_slot_device=0;
ramdisk_compression=auto;


## AnyKernel methods (DO NOT CHANGE)
# import patching functions/variables - see for reference
. /tmp/anykernel/tools/ak2-core.sh;


## AnyKernel file attributes
# set permissions/ownership for included ramdisk files
chmod -R 750 $ramdisk/*;
chown -R root:root $ramdisk/*;


## AnyKernel install
dump_boot;

# begin ramdisk changes

insert_line init.rc "import /init.spectrum.rc" after "import /init.usb.rc" "import /init.spectrum.rc";

insert_line init.rc "import /init.infected.rc" after "import /init.usb.configfs.rc" "import /init.infected.rc";

# end ramdisk changes

write_boot;

## end install

