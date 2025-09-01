#!/system/bin/sh

# Copyright (c) 2022 Qualcomm Innovation Center, Inc. All rights reserved.
# SPDX-License-Identifier: BSD-3-Clause-Clear

log -t BOOT -p i "Start can0 from boot"
ip link set can0 up type can bitrate 500000

