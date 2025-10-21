#!/system/bin/sh

# Copyright (c) Qualcomm Technologies, Inc. and/or its subsidiaries.
# SPDX-License-Identifier: BSD-3-Clause-Clear

counter=0
speed=0
battery_level=0
sos=0
power_state=0
side_stand=0

sleep_time=1

ip link set can0 up type can bitrate 50000

## EV type set
cansend can0 7F1#0A
# start fake location
#am broadcast -a android.intent.action.CUSTOM_LOCATION --ez EXTRA_ENABLED "true"


cmd_cansend_speed()
{
  speed=$1
  #speed_can=`echo "obase=16; $speed" | bc`
  speed_can=`printf "%02x" $speed`
  speed_can=`echo "7FC""#""$speed_can"`
  cansend can0 $speed_can
}

cmd_cansend_battery()
{
    battery_level_input=$1
    battery_level=battery_level_input
    range_battery_level_multiple=240
    range_battery_level_div=100
    battery_level=$(( (battery_level_input * range_battery_level_multiple) / (range_battery_level_div)))
    battery_can=`printf "%02x" $battery_level`
    battery_can=`echo "7FB""#""$battery_can"`
    cansend can0 $battery_can
    range_multiple=2
    range_level=$((battery_level_input * range_multiple))
    range_can=`printf "%04x" $range_level`
    range_can=`echo "7F5""#""$range_can"`
    cansend can0 $range_can
}

cmd_cansend_fuel_level_low()
{
    fuel_level_low=$1
    fuel_level_low_can=`printf "%02x" $fuel_level_low`
    fuel_level_low_can=`echo "7ED""#""$fuel_level_low_can"`
    cansend can0 $fuel_level_low_can
}

cmd_cansend_sos()
{
    sos=$1
    #sos_can=`echo "obase=16; $sos" | bc`
    sos_can=`printf "%02x" $sos`
    sos_can=`echo "7FD""#""$sos_can"`
    cansend can0 $sos_can
}

cmd_cansend_ignition()
{
    power_state=$1
    #power_can=`echo "obase=16; $power_state" | bc`
    power_can=`printf "%02x" $power_state`
    power_can=`echo "7E9""#""$power_can"`
    cansend can0 $power_can
}

cmd_cansend_sidestand()
{
    side_stand=$1
    #side_stand_can=`echo "obase=16; $side_stand" | bc`
    side_stand_can=`printf "%02x" $side_stand`
    side_stand_can=`echo "7FE#""$side_stand_can"`
    cansend can0 $side_stand_can
}

while true
do

	#	ignition	sos_status	side_stand	can_speed	b_charge_status
	#1	0	0	0	0	80
	cmd_cansend_ignition 0
	cmd_cansend_sidestand 1
	cmd_cansend_fuel_level_low 0
	cmd_cansend_battery 50
	cmd_cansend_speed 0
	cmd_cansend_sos 0

	sleep $sleep_time
	#	ignition	sos_status	side_stand	can_speed	b_charge_status
	#2	0	0	0	0	80
	sleep $sleep_time
	#	ignition	sos_status	side_stand	can_speed	b_charge_status
	#4	1	0	0	0	80
	sleep $sleep_time
	#	ignition	sos_status	side_stand	can_speed	b_charge_status
	#5	1	0	0	0	80
	sleep $sleep_time
	#	ignition	sos_status	side_stand	can_speed	b_charge_status
	#6	1	0	0	0	80
	sleep $sleep_time
	#	ignition	sos_status	side_stand	can_speed	b_charge_status
	#7	1	0	0	30	79

	## START OF NEW SCRIPT WITH LOCATION #####

	cmd_cansend_speed 0
	cmd_cansend_battery 50
	cmd_cansend_sidestand 0
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.975566667, 'longitude':77.71825, 'altitude':896.1, 'bearing':6, 'velocity':0}"
	sleep $sleep_time

	# Starting from N building
	cmd_cansend_speed 0
	cmd_cansend_battery 50
	cmd_cansend_ignition 1
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.975566667, 'longitude':77.71825, 'altitude':896.1, 'bearing':6, 'velocity':0}"
	sleep $sleep_time

	cmd_cansend_speed 5
	cmd_cansend_battery 49
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.9756, 'longitude':77.71825, 'altitude':896.2, 'bearing':0, 'velocity':5}"
	sleep $sleep_time

	cmd_cansend_speed 10
	cmd_cansend_battery 49
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.975616667, 'longitude':77.718216667, 'altitude':896.3, 'bearing':297.2, 'velocity':10}"
	sleep $sleep_time

	cmd_cansend_speed 20
	cmd_cansend_battery 48
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.975616667, 'longitude':77.718166667, 'altitude':896.3, 'bearing':270, 'velocity':20}"
	sleep $sleep_time

	cmd_cansend_speed 30
	cmd_cansend_battery 48
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.975616667, 'longitude':77.71815, 'altitude':896.3, 'bearing':270, 'velocity':30}"
	sleep $sleep_time

	cmd_cansend_speed 40
	cmd_cansend_battery 47
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.975633333, 'longitude':77.718133333, 'altitude':896.3, 'bearing':315.7, 'velocity':40}"
	sleep $sleep_time

	cmd_cansend_speed 50
	cmd_cansend_battery 46
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.9756, 'longitude':77.718133333, 'altitude':896.2, 'bearing':180, 'velocity':50}"
	sleep $sleep_time

	cmd_cansend_speed 60
	cmd_cansend_battery 46
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.975566667, 'longitude':77.718116667, 'altitude':896.1, 'bearing':206, 'velocity':60}"
	sleep $sleep_time

	cmd_cansend_speed 70
	cmd_cansend_battery 46
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.975516667, 'longitude':77.718116667, 'altitude':896, 'bearing':180, 'velocity':70}"
	sleep $sleep_time

	cmd_cansend_speed 75
	cmd_cansend_battery 45
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.975433333, 'longitude':77.718116667, 'altitude':895.7, 'bearing':180, 'velocity':75}"
	sleep $sleep_time

	cmd_cansend_speed 745
	cmd_cansend_battery 45
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.975333333, 'longitude':77.718116667, 'altitude':895.4, 'bearing':180, 'velocity':74}"
	sleep $sleep_time

	cmd_cansend_speed 73
	cmd_cansend_battery 44
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.975166667, 'longitude':77.7181, 'altitude':894.8, 'bearing':185.6, 'velocity':73}"
	sleep $sleep_time

	cmd_cansend_speed 73
	cmd_cansend_battery 44
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.974983333, 'longitude':77.718083333, 'altitude':894.2, 'bearing':185.1, 'velocity':73.3}"
	sleep $sleep_time

	cmd_cansend_speed 73
	cmd_cansend_battery 43
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.9748, 'longitude':77.718066667, 'altitude':893.6, 'bearing':185.1, 'velocity':73.3}"
	sleep $sleep_time

	cmd_cansend_speed 73
	cmd_cansend_battery 43
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.974616667, 'longitude':77.718066667, 'altitude':892.9, 'bearing':180, 'velocity':73}"
	sleep $sleep_time

	cmd_cansend_speed 73
	cmd_cansend_battery 42
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.974433333, 'longitude':77.71805, 'altitude':892.3, 'bearing':185.1, 'velocity':73.3}"
	sleep $sleep_time

	cmd_cansend_speed 67
	cmd_cansend_battery 42
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.974266667, 'longitude':77.718033333, 'altitude':891.8, 'bearing':185.6, 'velocity':66.7}"
	sleep $sleep_time

	cmd_cansend_speed 60
	cmd_cansend_battery 41
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.974166667, 'longitude':77.718033333, 'altitude':891.4, 'bearing':180, 'velocity':60}"
	sleep $sleep_time

	cmd_cansend_speed 50
	cmd_cansend_battery 41
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.974133333, 'longitude':77.718033333, 'altitude':891.5, 'bearing':180, 'velocity':50}"
	sleep $sleep_time

	cmd_cansend_speed 40
	cmd_cansend_battery 41
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.974083333, 'longitude':77.718016667, 'altitude':891.5, 'bearing':198, 'velocity':40}"
	sleep $sleep_time

	cmd_cansend_speed 30
	cmd_cansend_battery 40
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.974066667, 'longitude':77.718016667, 'altitude':891.5, 'bearing':180, 'velocity':30}"
	sleep $sleep_time

	cmd_cansend_speed 25
	cmd_cansend_battery 40
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.97405, 'longitude':77.718, 'altitude':891.6, 'bearing':224.3, 'velocity':25}"
	sleep $sleep_time

	cmd_cansend_speed 20
	cmd_cansend_battery 39
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.97405, 'longitude':77.717966667, 'altitude':891.8, 'bearing':270, 'velocity':20}"
	sleep $sleep_time

	cmd_cansend_speed 26
	cmd_cansend_battery 39
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.97405, 'longitude':77.7179, 'altitude':892.1, 'bearing':270, 'velocity':26}"
	sleep $sleep_time

	cmd_cansend_speed 24
	cmd_cansend_battery 38
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.97405, 'longitude':77.717883333, 'altitude':892.1, 'bearing':270, 'velocity':24}"
	sleep $sleep_time

	cmd_cansend_speed 21
	cmd_cansend_battery 38
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.9741, 'longitude':77.717866667, 'altitude':892.2, 'bearing':342, 'velocity':21}"
	sleep $sleep_time

	cmd_cansend_speed 30
	cmd_cansend_battery 37
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.974183333, 'longitude':77.717866667, 'altitude':892.3, 'bearing':0, 'velocity':30}"
	sleep $sleep_time

	cmd_cansend_speed 10
	cmd_cansend_battery 37
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.974366667, 'longitude':77.717866667, 'altitude':892.8, 'bearing':0, 'velocity':10}"
	sleep $sleep_time

	cmd_cansend_speed 0
	cmd_cansend_battery 36
	cmd_cansend_sidestand 1
	cmd_cansend_ignition 0
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.97445, 'longitude':77.717866667, 'altitude':893, 'bearing':0, 'velocity':0}"
	sleep $sleep_time

	cmd_cansend_speed 0
	cmd_cansend_battery 36
	cmd_cansend_sos 1
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.97445, 'longitude':77.717866667, 'altitude':893, 'bearing':0, 'velocity':0}"
	sleep $sleep_time

	cmd_cansend_speed 0
	cmd_cansend_battery 35
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.97445, 'longitude':77.717866667, 'altitude':893, 'bearing':0, 'velocity':0}"
	sleep $sleep_time

	cmd_cansend_speed 0
	cmd_cansend_battery 35
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.97445, 'longitude':77.717866667, 'altitude':893, 'bearing':0, 'velocity':0}"
	sleep $sleep_time

	cmd_cansend_speed 0
	cmd_cansend_battery 35
	cmd_cansend_sos 0
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.97445, 'longitude':77.717866667, 'altitude':893, 'bearing':0, 'velocity':0}"
	sleep $sleep_time

	cmd_cansend_speed 0
	cmd_cansend_battery 34
	cmd_cansend_sidestand 0
	cmd_cansend_ignition 1
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.97445, 'longitude':77.717866667, 'altitude':893, 'bearing':0, 'velocity':0}"
	sleep $sleep_time

	cmd_cansend_speed 10
	cmd_cansend_battery 34
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.974366667, 'longitude':77.717866667, 'altitude':892.8, 'bearing':180, 'velocity':10}"
	sleep $sleep_time

	cmd_cansend_speed 20
	cmd_cansend_battery 33
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.974183333, 'longitude':77.717866667, 'altitude':892.3, 'bearing':180, 'velocity':20}"
	sleep $sleep_time

	cmd_cansend_speed 30
	cmd_cansend_battery 33
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.9741, 'longitude':77.717866667, 'altitude':892.2, 'bearing':180, 'velocity':30}"
	sleep $sleep_time

	cmd_cansend_speed 28
	cmd_cansend_battery 32
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.97405, 'longitude':77.717866667, 'altitude':892.2, 'bearing':180, 'velocity':28}"
	sleep $sleep_time

	cmd_cansend_speed 32
	cmd_cansend_battery 32
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.97405, 'longitude':77.717916667, 'altitude':892, 'bearing':90, 'velocity':32}"
	sleep $sleep_time

	cmd_cansend_speed 35
	cmd_cansend_battery 31
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.97405, 'longitude':77.717966667, 'altitude':891.8, 'bearing':90, 'velocity':35}"
	sleep $sleep_time

	cmd_cansend_speed 40
	cmd_cansend_battery 31
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.97405, 'longitude':77.718016667, 'altitude':891.6, 'bearing':90, 'velocity':40}"
	sleep $sleep_time

	cmd_cansend_speed 42
	cmd_cansend_battery 30
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.974, 'longitude':77.718016667, 'altitude':891.6, 'bearing':180, 'velocity':42}"
	sleep $sleep_time

	cmd_cansend_speed 45
	cmd_cansend_battery 30
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.973916667, 'longitude':77.718, 'altitude':891.7, 'bearing':191, 'velocity':45}"
	sleep $sleep_time

	cmd_cansend_speed 50
	cmd_cansend_battery 30
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.973733333, 'longitude':77.717983333, 'altitude':891.8, 'bearing':185.1, 'velocity':50}"
	sleep $sleep_time

	cmd_cansend_speed 55
	cmd_cansend_battery 29
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.97355, 'longitude':77.717966667, 'altitude':891.8, 'bearing':185.1, 'velocity':55}"
	sleep $sleep_time

	cmd_cansend_speed 65
	cmd_cansend_battery 29
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.973383333, 'longitude':77.71795, 'altitude':891.9, 'bearing':185.6, 'velocity':65}"
	sleep $sleep_time

	cmd_cansend_speed 72
	cmd_cansend_battery 28
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.973283333, 'longitude':77.717933333, 'altitude':892, 'bearing':189.2, 'velocity':72}"
	sleep $sleep_time

	cmd_cansend_speed 75
	cmd_cansend_battery 28
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.97325, 'longitude':77.717933333, 'altitude':892, 'bearing':180, 'velocity':75}"
	sleep $sleep_time

	cmd_cansend_speed 75
	cmd_cansend_battery 27
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.973216667, 'longitude':77.717966667, 'altitude':891.9, 'bearing':135.7, 'velocity':74}"
	sleep $sleep_time

	cmd_cansend_speed 80
	cmd_cansend_battery 27
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.973216667, 'longitude':77.718066667, 'altitude':891.7, 'bearing':90, 'velocity':80}"
	sleep $sleep_time

	cmd_cansend_speed 85
	cmd_cansend_battery 26
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.9732, 'longitude':77.71825, 'altitude':891.2, 'bearing':95.3, 'velocity':85}"
	sleep $sleep_time

	cmd_cansend_speed 80
	cmd_cansend_battery 26
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.973183333, 'longitude':77.718533333, 'altitude':890.5, 'bearing':93.5, 'velocity':80}"
	sleep $sleep_time

	cmd_cansend_speed 85
	cmd_cansend_battery 25
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.973166667, 'longitude':77.7188, 'altitude':889.9, 'bearing':93.7, 'velocity':85}"
	sleep $sleep_time

	cmd_cansend_speed 90
	cmd_cansend_battery 25
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.97315, 'longitude':77.719083333, 'altitude':889.2, 'bearing':93.5, 'velocity':90}"
	sleep $sleep_time

	cmd_cansend_speed 92
	cmd_cansend_battery 25
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.973133333, 'longitude':77.71935, 'altitude':888.7, 'bearing':93.7, 'velocity':92}"
	sleep $sleep_time

	cmd_cansend_speed 85
	cmd_cansend_battery 24
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.973116667, 'longitude':77.719633333, 'altitude':888.1, 'bearing':93.5, 'velocity':85}"
	sleep $sleep_time

	cmd_cansend_speed 80
	cmd_cansend_battery 24
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.9731, 'longitude':77.7199, 'altitude':887.6, 'bearing':93.7, 'velocity':80}"
	sleep $sleep_time

	cmd_cansend_speed 75
	cmd_cansend_battery 23
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.973083333, 'longitude':77.720183333, 'altitude':888, 'bearing':93.5, 'velocity':75}"
	sleep $sleep_time

	cmd_cansend_speed 70
	cmd_cansend_battery 23
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.973066667, 'longitude':77.720466667, 'altitude':888.9, 'bearing':93.5, 'velocity':70}"
	sleep $sleep_time

	cmd_cansend_speed 65
	cmd_cansend_battery 22
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.97305, 'longitude':77.720733333, 'altitude':889.7, 'bearing':93.7, 'velocity':65}"
	sleep $sleep_time

	cmd_cansend_speed 60
	cmd_cansend_battery 22
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.973033333, 'longitude':77.721016667, 'altitude':890.6, 'bearing':93.5, 'velocity':60}"
	sleep $sleep_time

	cmd_cansend_speed 55
	cmd_cansend_battery 21
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.973016667, 'longitude':77.721283333, 'altitude':891.6, 'bearing':93.7, 'velocity':55}"
	sleep $sleep_time

	cmd_cansend_speed 50
	cmd_cansend_battery 21
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.973016667, 'longitude':77.721383333, 'altitude':891.9, 'bearing':90, 'velocity':50}"
	sleep $sleep_time

	cmd_cansend_speed 45
	cmd_cansend_battery 20
	cmd_cansend_fuel_level_low 1 # Fuel low when 20
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.972966667, 'longitude':77.7214, 'altitude':891.9, 'bearing':162, 'velocity':45}"
	sleep $sleep_time

	cmd_cansend_speed 30
	cmd_cansend_battery 20
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.972883333, 'longitude':77.7214, 'altitude':891.8, 'bearing':180, 'velocity':30}"
	sleep $sleep_time

	cmd_cansend_speed 25
	cmd_cansend_battery 19
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.9727, 'longitude':77.7214, 'altitude':891.6, 'bearing':180, 'velocity':25}"
	sleep $sleep_time

	cmd_cansend_speed 15
	cmd_cansend_battery 19
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.972616667, 'longitude':77.721383333, 'altitude':891.4, 'bearing':191, 'velocity':15}"
	sleep $sleep_time

	cmd_cansend_speed 10
	cmd_cansend_battery 19
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.972616667, 'longitude':77.721333333, 'altitude':891.2, 'bearing':270, 'velocity':10}"
	sleep $sleep_time

	cmd_cansend_speed 0
	cmd_cansend_battery 18
	cmd_cansend_sidestand 1
	cmd_cansend_ignition 0
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.972616667, 'longitude':77.7213, 'altitude':891, 'bearing':270, 'velocity':0}"
	sleep $sleep_time

	cmd_cansend_speed 0
	cmd_cansend_battery 25
	cmd_cansend_fuel_level_low 0
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.972616667, 'longitude':77.7213, 'altitude':891, 'bearing':270, 'velocity':0}"
	sleep $sleep_time

	cmd_cansend_speed 0
	cmd_cansend_battery 50
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.972616667, 'longitude':77.7213, 'altitude':891, 'bearing':270, 'velocity':0}"
	sleep $sleep_time

	cmd_cansend_speed 0
	cmd_cansend_battery 75
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.972616667, 'longitude':77.7213, 'altitude':891, 'bearing':270, 'velocity':0}"
	sleep $sleep_time

	cmd_cansend_speed 0
	cmd_cansend_battery 90
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.972616667, 'longitude':77.7213, 'altitude':891, 'bearing':270, 'velocity':0}"
	sleep $sleep_time

	cmd_cansend_speed 0
	cmd_cansend_battery 100
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.972616667, 'longitude':77.7213, 'altitude':891, 'bearing':270, 'velocity':0}"
	sleep $sleep_time

	cmd_cansend_speed 0
	cmd_cansend_battery 100
	cmd_cansend_sidestand 0
	cmd_cansend_ignition 1
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.972616667, 'longitude':77.7213, 'altitude':891, 'bearing':270, 'velocity':0}"
	sleep $sleep_time

	cmd_cansend_speed 10
	cmd_cansend_battery 99
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.972616667, 'longitude':77.721333333, 'altitude':891.2, 'bearing':90, 'velocity':10}"
	sleep $sleep_time

	cmd_cansend_speed 15
	cmd_cansend_battery 99
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.972616667, 'longitude':77.721383333, 'altitude':891.4, 'bearing':90, 'velocity':15}"
	sleep $sleep_time

	cmd_cansend_speed 20
	cmd_cansend_battery 98
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.97265, 'longitude':77.721383333, 'altitude':891.5, 'bearing':0, 'velocity':20}"
	sleep $sleep_time

	cmd_cansend_speed 30
	cmd_cansend_battery 98
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.97275, 'longitude':77.7214, 'altitude':891.7, 'bearing':9.2, 'velocity':30}"
	sleep $sleep_time

	cmd_cansend_speed 50
	cmd_cansend_battery 97
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.972933333, 'longitude':77.7214, 'altitude':891.9, 'bearing':0, 'velocity':50}"
	sleep $sleep_time

	cmd_cansend_speed 70
	cmd_cansend_battery 96
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.9732, 'longitude':77.721416667, 'altitude':892.3, 'bearing':3.5, 'velocity':70}"
	sleep $sleep_time

	cmd_cansend_speed 75
	cmd_cansend_battery 95
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.973466667, 'longitude':77.721416667, 'altitude':892.5, 'bearing':0, 'velocity':75}"
	sleep $sleep_time

	cmd_cansend_speed 78
	cmd_cansend_battery 94
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.973733333, 'longitude':77.721433333, 'altitude':892.9, 'bearing':3.5, 'velocity':78}"
	sleep $sleep_time

	cmd_cansend_speed 80
	cmd_cansend_battery 93
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.974, 'longitude':77.72145, 'altitude':893.2, 'bearing':3.5, 'velocity':80}"
	sleep $sleep_time

	cmd_cansend_speed 81
	cmd_cansend_battery 92
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.974266667, 'longitude':77.72145, 'altitude':893.5, 'bearing':0, 'velocity':81}"
	sleep $sleep_time

	cmd_cansend_speed 82
	cmd_cansend_battery 91
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.97455, 'longitude':77.721466667, 'altitude':893.8, 'bearing':3.3, 'velocity':82}"
	sleep $sleep_time

	cmd_cansend_speed 84
	cmd_cansend_battery 90
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.974816667, 'longitude':77.72145, 'altitude':893.8, 'bearing':356.5, 'velocity':84}"
	sleep $sleep_time

	cmd_cansend_speed 85
	cmd_cansend_battery 89
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.975083333, 'longitude':77.721416667, 'altitude':893.9, 'bearing':353.1, 'velocity':85}"
	sleep $sleep_time

	cmd_cansend_speed 90
	cmd_cansend_battery 88
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.97535, 'longitude':77.7214, 'altitude':894.1, 'bearing':356.5, 'velocity':90}"
	sleep $sleep_time

	cmd_cansend_speed 83
	cmd_cansend_battery 87
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.975616667, 'longitude':77.721383333, 'altitude':894.4, 'bearing':356.5, 'velocity':83}"
	sleep $sleep_time

	cmd_cansend_speed 78
	cmd_cansend_battery 86
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.975883333, 'longitude':77.721366667, 'altitude':894.8, 'bearing':356.5, 'velocity':78}"
	sleep $sleep_time

	cmd_cansend_speed 68
	cmd_cansend_battery 85
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.976166667, 'longitude':77.72135, 'altitude':895.5, 'bearing':356.7, 'velocity':68}"
	sleep $sleep_time

	cmd_cansend_speed 60
	cmd_cansend_battery 84
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.976433333, 'longitude':77.721316667, 'altitude':896.1, 'bearing':353.1, 'velocity':60}"
	sleep $sleep_time

	cmd_cansend_speed 53
	cmd_cansend_battery 83
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.9767, 'longitude':77.7213, 'altitude':896.7, 'bearing':356.5, 'velocity':53}"
	sleep $sleep_time

	cmd_cansend_speed 30
	cmd_cansend_battery 82
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.976783333, 'longitude':77.7213, 'altitude':896.7, 'bearing':0, 'velocity':30}"
	sleep $sleep_time

	cmd_cansend_speed 15
	cmd_cansend_battery 81
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.976833333, 'longitude':77.7213, 'altitude':896.7, 'bearing':0, 'velocity':15}"
	sleep $sleep_time

	cmd_cansend_speed 0
	cmd_cansend_battery 80
	cmd_cansend_sidestand 1
	cmd_cansend_ignition 0
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.976883333, 'longitude':77.721283333, 'altitude':896.6, 'bearing':342, 'velocity':0}"
	sleep $sleep_time

	cmd_cansend_speed 0
	cmd_cansend_battery 80
	cmd_cansend_sos 1
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.976883333, 'longitude':77.721283333, 'altitude':896.6, 'bearing':342, 'velocity':0}"
	sleep $sleep_time

	cmd_cansend_speed 0
	cmd_cansend_battery 80
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.976883333, 'longitude':77.721283333, 'altitude':896.6, 'bearing':342, 'velocity':0}"
	sleep $sleep_time

	cmd_cansend_speed 0
	cmd_cansend_battery 80
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.976883333, 'longitude':77.721283333, 'altitude':896.6, 'bearing':342, 'velocity':0}"
	sleep $sleep_time

	cmd_cansend_speed 0
	cmd_cansend_battery 79
	cmd_cansend_sos 0
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.976883333, 'longitude':77.721283333, 'altitude':896.6, 'bearing':342, 'velocity':0}"
	sleep $sleep_time

	cmd_cansend_speed 0
	cmd_cansend_battery 79
	cmd_cansend_sidestand 0
	cmd_cansend_ignition 1
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.976883333, 'longitude':77.721283333, 'altitude':896.6, 'bearing':342, 'velocity':0}"
	sleep $sleep_time

	cmd_cansend_speed 13
	cmd_cansend_battery 78
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.976883333, 'longitude':77.72125, 'altitude':896.5, 'bearing':270, 'velocity':13}"
	sleep $sleep_time

	cmd_cansend_speed 28
	cmd_cansend_battery 77
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.9769, 'longitude':77.72115, 'altitude':896.2, 'bearing':279.7, 'velocity':28}"
	sleep $sleep_time

	cmd_cansend_speed 40
	cmd_cansend_battery 76
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.976916667, 'longitude':77.720966667, 'altitude':895.7, 'bearing':275.3, 'velocity':40}"
	sleep $sleep_time

	cmd_cansend_speed 53
	cmd_cansend_battery 75
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.97695, 'longitude':77.7207, 'altitude':895.9, 'bearing':277.3, 'velocity':53}"
	sleep $sleep_time

	cmd_cansend_speed 64
	cmd_cansend_battery 74
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.976966667, 'longitude':77.720416667, 'altitude':897.2, 'bearing':273.5, 'velocity':64}"
	sleep $sleep_time

	cmd_cansend_speed 77
	cmd_cansend_battery 73
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.977, 'longitude':77.72015, 'altitude':898.5, 'bearing':277.3, 'velocity':77}"
	sleep $sleep_time

	cmd_cansend_speed 90
	cmd_cansend_battery 72
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.977033333, 'longitude':77.719866667, 'altitude':899.2, 'bearing':276.9, 'velocity':90}"
	sleep $sleep_time

	cmd_cansend_speed 92
	cmd_cansend_battery 71
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.97705, 'longitude':77.7196, 'altitude':898.9, 'bearing':273.7, 'velocity':92}"
	sleep $sleep_time

	cmd_cansend_speed 81
	cmd_cansend_battery 70
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.977083333, 'longitude':77.719316667, 'altitude':898.7, 'bearing':276.9, 'velocity':81}"
	sleep $sleep_time

	cmd_cansend_speed 77
	cmd_cansend_battery 69
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.977166667, 'longitude':77.71905, 'altitude':898.6, 'bearing':287.8, 'velocity':77}"
	sleep $sleep_time

	cmd_cansend_speed 65
	cmd_cansend_battery 68
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.977183333, 'longitude':77.718783333, 'altitude':898.6, 'bearing':273.7, 'velocity':65}"
	sleep $sleep_time

	cmd_cansend_speed 50
	cmd_cansend_battery 67
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.9772, 'longitude':77.7185, 'altitude':898.6, 'bearing':273.5, 'velocity':50}"
	sleep $sleep_time

	cmd_cansend_speed 30
	cmd_cansend_battery 66
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.977216667, 'longitude':77.718316667, 'altitude':898.7, 'bearing':275.3, 'velocity':30}"
	sleep $sleep_time

	cmd_cansend_speed 25
	cmd_cansend_battery 65
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.977216667, 'longitude':77.71825, 'altitude':898.8, 'bearing':270, 'velocity':25}"
	sleep $sleep_time

	cmd_cansend_speed 21
	cmd_cansend_battery 64
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.977166667, 'longitude':77.718233333, 'altitude':898.7, 'bearing':198, 'velocity':21}"
	sleep $sleep_time

	cmd_cansend_speed 33
	cmd_cansend_battery 63
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.977083333, 'longitude':77.718233333, 'altitude':898.6, 'bearing':180, 'velocity':33.2}"
	sleep $sleep_time

	cmd_cansend_speed 41
	cmd_cansend_battery 62
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.9769, 'longitude':77.718216667, 'altitude':898.4, 'bearing':185.1, 'velocity':41}"
	sleep $sleep_time

	cmd_cansend_speed 55
	cmd_cansend_battery 61
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.976716667, 'longitude':77.7182, 'altitude':898.1, 'bearing':185.1, 'velocity':55}"
	sleep $sleep_time

	cmd_cansend_speed 77
	cmd_cansend_battery 60
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.97645, 'longitude':77.718183333, 'altitude':897.7, 'bearing':183.5, 'velocity':77}"
	sleep $sleep_time

	cmd_cansend_speed 82
	cmd_cansend_battery 59
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.976183333, 'longitude':77.718166667, 'altitude':897.4, 'bearing':183.5, 'velocity':82}"
	sleep $sleep_time

	cmd_cansend_speed 75
	cmd_cansend_battery 58
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.975916667, 'longitude':77.71815, 'altitude':897.1, 'bearing':183.5, 'velocity':75}"
	sleep $sleep_time

	cmd_cansend_speed 62
	cmd_cansend_battery 57
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.975733333, 'longitude':77.718133333, 'altitude':896.7, 'bearing':185.1, 'velocity':62}"
	sleep $sleep_time

	cmd_cansend_speed 49
	cmd_cansend_battery 56
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.97565, 'longitude':77.718133333, 'altitude':896.4, 'bearing':180, 'velocity':49}"
	sleep $sleep_time

	cmd_cansend_speed 30
	cmd_cansend_battery 55
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.975616667, 'longitude':77.718166667, 'altitude':896.3, 'bearing':135.7, 'velocity':30}"
	sleep $sleep_time

	cmd_cansend_speed 19
	cmd_cansend_battery 54
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.975616667, 'longitude':77.718216667, 'altitude':896.3, 'bearing':90, 'velocity':19.5}"
	sleep $sleep_time

	cmd_cansend_speed 14
	cmd_cansend_battery 53
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.975616667, 'longitude':77.71825, 'altitude':896.2, 'bearing':90, 'velocity':14}"
	sleep $sleep_time

	cmd_cansend_speed 12
	cmd_cansend_battery 52
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.975583333, 'longitude':77.71825, 'altitude':896.1, 'bearing':180, 'velocity':12}"
	sleep $sleep_time

	cmd_cansend_speed 5
	cmd_cansend_battery 51
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.975566667, 'longitude':77.71825, 'altitude':896.1, 'bearing':180, 'velocity':5}"
	sleep $sleep_time

	cmd_cansend_speed 0
	cmd_cansend_battery 50
	cmd_cansend_ignition 0
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.975566667, 'longitude':77.71825, 'altitude':896.1, 'bearing':180, 'velocity':0}"
	sleep $sleep_time

	cmd_cansend_speed 0
	cmd_cansend_battery 50
	cmd_cansend_sidestand 1
	paho_c_pub -h localhost -p 1883 -t "VHAL_STUB/RECV/LOCATION" -m  "{'latitude':12.975566667, 'longitude':77.71825, 'altitude':896.1, 'bearing':180, 'velocity':0}"

    sleep $sleep_time


done
