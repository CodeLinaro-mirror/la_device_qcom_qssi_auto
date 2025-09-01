#Include all 2W changes here
TARGET_BUILD_2W := true

# device support B2C
TARGET_SUPPORT_B2C := false

PRODUCT_SYSTEM_PROPERTIES += \
    ro.hw.vehicle.isbike=true

#system prop for Hardware type Automotive
PRODUCT_SYSTEM_PROPERTIES += \
    ro.hardware.type=automotive \
    sys.no_kill_cached_proc_post_boot_completed_duration_millis=0 \
    persist.sys.device.mode = peripheral

# broadcast radio feature
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.broadcastradio.xml:system/etc/permissions/android.hardware.broadcastradio.xml

#Enable TwoWheeler apps
PRODUCT_PACKAGES += \
    TwoWheelerLauncher \
    TwoWheelerSystemUI \
    ECall \
    SecondaryBluetooth

# Enable MqttListener if device support B2C
ifeq ($(TARGET_SUPPORT_B2C), true)
    PRODUCT_PACKAGES += MqttListener
endif

ifeq ($(TARGET_BUILD_2W), true)
PRODUCT_COPY_FILES += \
    vendor/qcom/opensource/core-utils/qspaframework/qspa_default.rc:system_ext/etc/init/qspa_default.rc
endif
