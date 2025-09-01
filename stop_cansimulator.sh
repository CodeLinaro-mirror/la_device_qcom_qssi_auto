#!/system/bin/sh

# Copyright (c) 2024 Qualcomm Innovation Center, Inc. All rights reserved.
# SPDX-License-Identifier: BSD-3-Clause-Clear

# start fake location
#am broadcast -a android.intent.action.CUSTOM_LOCATION --ez EXTRA_ENABLED "false"

sleep 000.000015
cansend can0  7FB#E6
sleep 000.000015
cansend can0  7F5#00BF
sleep 000.212364
cansend can0  7FC#4B
sleep 000.21200
cansend can0 7FD#00
sleep 000.21200
cansend can0 7FA#00
sleep 000.21200
cansend can0 7F9#00
sleep 000.21200
cansend can0 7FC#00
sleep 000.21200
cansend can0 7FD#00
sleep 000.21200
cansend can0 7F3#00
sleep 000.21200
cansend can0 7FE#01

