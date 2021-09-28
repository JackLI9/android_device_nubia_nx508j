#!/system/bin/sh

#sleep 2

#insmod /data/temp/mxt.ko

cd /sys/bus/i2c/devices/2-004a

#chown root root *
#chmod 666 t19
#chmod 666 update_cfg
#chmod 666 update_fw

#echo "pl enable 2" > plugin
#echo "msc pid get 1" > plugin

#format: [family id]_[variant id]_[version]_[build].fw
#format: [xxx].raw

#use GPIO 19 for diffferent hw identify
#format: [xxx].raw.[hex_i2c_address].[hex_gpio_t19].cfg
echo "2" > t19

#you could write a default zero config before update firmware
#e.g: for 540s from 3.0_AA to 5.0AA
#echo "82_2C_3.0_AA_ZERO.raw" > update_cfg
echo "A4_15_2.2_E0.fw" > update_fw0
echo "A4_15_3.0_AB.fw" > update_fw0

#echo "pl enable 0" > plugin

#update new config
echo "A4_15.raw" > update_cfg0
#for gpio 19 alternative(i2c address 0x4b, gpio=01)
#echo "82_39_5.0_AA.raw.4B.01.cfg" > update_cfg

echo "2" > t19

#send self tune command for 540s
#0 : no backup
#1 : backup
#echo 0 > self_tune
dmesg > /cache/atmel_ts.log

sleep 1

#enable plugin
#
#format: pl enable [hex]
#[0] : CAL
#[1] : MSC
#[2] : PI
#[3] : CLIP 
#[4] : WDG 
#[7] : PLUG PAUSE
echo "pl enable 2" > plugin

#PTC auto tune (should enable MSC above,sleep 5s for tune complete)
#[0] : tune not store
#[1] : tune and store
#[2] : re-tune and not store
#[3] : re-tune and store
#[other value] : report tune status 
echo "msc ptc tune 1" > plugin
sleep 7

#set gesture list
#format: <name> <val>;<name> <val>;...
#you could run command "cat gesture_list" for current config list
#<val>: bit[0]: enable
#	bit[1]: disable, 
#	bit[3]  status (1: excuted)
#echo "TAP 1;UNLOCK0 1;UNLOCK1 1;" > gesture_list
#echo "TAP 1;" > gesture_list

#enable gesture feature
#echo 1 > en_gesture

#zte add
#echo "clp cl area[0]: 0,0 33,1920" > plugin
#echo "clp cl area[1]: 0,0 1080,0" > plugin
#echo "clp cl area[2]: 1046,0 1080,1920" > plugin
#echo "clp cl area[3]: 0,1920 1080,1920" > plugin
#echo "clp cl dist: 0,300" > plugin
echo "clp pa numtch: 0" > plugin
#echo "clp pa thld: 60 30 0 50" > plugin
echo "clp pa thld: 55 30 0 35" > plugin
echo "clp enable 1" >  plugin
echo "wd enable 3" > plugin
#zte end

echo "pl enable 1f" > plugin

#chmod 440 t19
#chmod 440 update_cfg
#chmod 440 update_fw

