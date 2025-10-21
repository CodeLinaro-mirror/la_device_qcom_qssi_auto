# Copyright (c) 2023 Qualcomm Innovation Center, Inc. All rights reserved.
# SPDX-License-Identifier: BSD-3-Clause-Clear

FAILED_FILEPATHS_WHITELIST = {
    # NOTE: these files are from QSSI builds
    "vendor/qcom/opensource/audio-hal/primary-hal/configs/qssi/qssi.mk",
    "$QCPATH/android-perf/profiles.mk",
    "$QCPATH/chi-cdk/product.mk",
    "$QCPATH/commonsys/qrdplus/sva/products.mk",
    "$QCPATH/commonsys/voiceui/products.mk",
    "$QCPATH/mm-audio-internal/dolby/dax/device/dax2_common_hw.mk",
    "$QCPATH/prebuilt_ASAN/target/product/pineapple/prebuilt.mk",
    "$QCPATH/prebuilt_ASAN/target/product/qssi_auto/prebuilt.mk",
    "$QCPATH/prebuilt_grease/target/common/prebuilt.mk",
    "$QCPATH/prebuilt_grease/target/product/pineapple/prebuilt.mk",
    "$QCPATH/prebuilt_grease/target/product/qssi_auto/prebuilt.mk",
    "$QCPATH/prebuilt_HY11/target/common/prebuilt.mk",
    "$QCPATH/prebuilt_HY11/target/product/pineapple/prebuilt.mk",
    "$QCPATH/prebuilt_HY11/target/product/qssi_auto/prebuilt.mk",
    "$QCPATH/prebuilt_HY22/target/common/prebuilt.mk",
    "$QCPATH/prebuilt_HY22/target/product/pineapple/prebuilt.mk",
    "$QCPATH/prebuilt_HY22/target/product/qssi_auto/prebuilt.mk",
    "$QCPATH/qrdplus/China/ChinaMobile/products.mk",
    "$QCPATH/qrdplus/China/ChinaTelecom/products.mk",
    "$QCPATH/qrdplus/China/ChinaUnicom/products.mk",
    "$QCPATH/qrdplus/China/CTA/products.mk",
    "$QCPATH/qrdplus/Extension/products.mk",
    "$QCPATH/qrdplus/InternalUseOnly/DuerosSDK/products.mk",
    "$QCPATH/resource-overlay/overlay.mk",
}

SHELL_WHITELIST = {
    "device/qcom/sepolicy/SEPolicy.mk",
    "vendor/qcom/defs/product-defs/system/wigig-product.mk",
    "$QCPATH/common/create_files.mk",
    "$QCPATH/commonsys/openclwrapper/Android.mk",
}

RM_WHITELIST = {
    "$QCPATH/common/scripts/Android.mk",
}

LOCAL_COPY_HEADERS_WHITELIST = {}

DATETIME_WHITELIST = {}

TARGET_PRODUCT_WHITELIST = {
    "vendor/qcom/opensource/core-utils/build/AndroidBoardCommon.mk",
    "vendor/qcom/opensource/core-utils/build/build.sh",
    "vendor/qcom/opensource/core-utils/build/build_image_standalone.py",
}

RECURSIVE_WHITELIST = {}

KERNEL_WHITELIST = {}

FOREACH_WHITELIST = {
    "vendor/qcom/opensource/core-utils/build/utils.mk",
    "$QCPATH/common/config/device-vendor-qssi.mk",
    "$QCPATH/common/config/device-vendor-SDM845-pureAOSP.mk",
    "$QCPATH/common-noship/build/generate_extra_images_prop.mk",
}

MACRO_WHITELIST = {
    "device/qcom/sepolicy/SEPolicy.mk",
    "vendor/qcom/opensource/commonsys/display/config/display-product-commonsys.mk",
    "$QCPATH/common/config/device-vendor-qssi.mk",
    "$QCPATH/common/config/device-vendor-SDM845-pureAOSP.mk",
    "$QCPATH/common-noship/etc/device-vendor-noship.mk",
    "$QCPATH/common-noship/etc/device-vendor-noship-SDM845-pureAOSP.mk",
    "$QCPATH/common-noship/etc/device-vendor-qssi-noship.mk",
    "$QCPATH/commonsys/android-perf-noship/config/perf-product-system-proprietary.mk",
    "$QCPATH/commonsys/telephony-build/build/telephony_system_product.mk",
    "$QCPATH/commonsys-intf/data/dpm_system_product_noship.mk",
}

OVERRIDE_WHITELIST = {
    "device/qcom/qssi_auto/qssi_auto.mk",
    "device/qcom/qssi_auto/qssi_auto_whitelist.mk",
}

SOONG_WHITELIST = {
    "device/qcom/qssi_auto/base.mk",
    "vendor/qcom/opensource/commonsys/display/config/display-product-commonsys.mk",
    "$QCPATH/commonsys-intf/bluetooth/bt-system-proprietary-product.mk",
    "vendor/qcom/opensource/commonsys-intf/display/config/display-product-system.mk",
}
