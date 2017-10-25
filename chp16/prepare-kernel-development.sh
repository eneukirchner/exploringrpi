#!/bin/bash
#
# Prepare Raspbian Stretch Kernel Development environment
# Edgar Neukirchner 2017
#

read -r -p "Do you want to upgrade system? [y/n]" response
if [ $response = "y" ]; then
	apt update && apt upgrade -y
	rpi-update
	reboot
fi

cd /usr/src
git clone --depth=1 https://github.com/raspberrypi/linux
cd linux
modprobe configs
zcat /proc/config.gz > .config
make oldconfig
make modules_prepare
wget https://github.com/raspberrypi/firmware/raw/master/extra/Module7.symvers
cp Module7.symvers Module.symvers
KHEADER=$(pwd)
cd /lib/modules/$(uname-r)
ln -s $KHEADER source
ln -s $KHEADER build
ln -s build source
cd /usr/src
ln -s $KHEADER linux-$(uname -r)

