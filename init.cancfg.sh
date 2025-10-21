#!/system/bin/sh

# Copyright (c) Qualcomm Technologies, Inc. and/or its subsidiaries.
# SPDX-License-Identifier: BSD-3-Clause-Clear

log -t BOOT -p i "Start can0 from boot"
ip link set can0 up type can bitrate 500000

