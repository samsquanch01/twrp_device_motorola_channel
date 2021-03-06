#!/sbin/sh

# Load Moto Touch-Screen (Based on screen supplier)
load_panel()
{
    SLOT=$(getprop ro.boot.slot_suffix)
	mount /dev/block/bootdevice/by-name/vendor$SLOT /vendor -O ro
    panel_supplier=""
    panel_supplier=$(cat /sys/devices/virtual/graphics/fb0/panel_supplier 2> /dev/null)
    echo "panel supplier vendor is: [$panel_supplier]"

    case $panel_supplier in
        djn)
            insmod /vendor/lib/modules/nova_36525_mmi.ko
            ;;
        dsbj)
            insmod /vendor/lib/modules/ilitek_mmi.ko
            ;;
        *)
		    insmod /vendor/lib/modules/himax_mmi.ko
		        ;;
    esac
    umount /vendor
}

# Load Device-Specific Modules (Based on Device Variant)
device_model()
{
    SLOT=$(getprop ro.boot.slot_suffix)
	mount /dev/block/bootdevice/by-name/vendor$SLOT /vendor -O ro
    device_name=""
    device_name=$(getprop ro.product.device)
    echo "device name is: [$device_name]"

    case $device_name in
        channel)
            insmod /vendor/lib/modules/tps61280.ko
            insmod /vendor/lib/modules/drv2624_mmi.ko
            insmod /vendor/lib/modules/sx931x_triple
            insmod /vendor/lib/modules/sx932x_sar.ko
            ;;
        *)
            echo "$device_name not supported"
            ;;
    esac
    umount /vendor
}

# Load These for All Devices
device_all()
{
    SLOT=$(getprop ro.boot.slot_suffix)
	mount /dev/block/bootdevice/by-name/vendor$SLOT /vendor -O ro
    device_brand=""
    device_brand=$(getprop ro.product.brand)
    echo "device brand is: [$device_brand]"

    case $device_brand in
        motorola)
            insmod /vendor/lib/modules/exfat.ko
            insmod /vendor/lib/modules/utags.ko
            insmod /vendor/lib/modules/sensors_class.ko
            insmod /vendor/lib/modules/mmi_annotate.ko
            insmod /vendor/lib/modules/mmi_info.ko
            insmod /vendor/lib/modules/tzlog_dump.ko
            insmod /vendor/lib/modules/mmi_sys_temp.ko
            ;;
        *)
		    echo "$device_brand not supported"
            ;;
    esac
    umount /vendor
}

load_panel
wait 1
device_model
wait 1
device_all
wait 1
setprop modules.loaded 1

exit 0


