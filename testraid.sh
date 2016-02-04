#!/bin/bash
# Install tools

if [ "$1" == "i" ]; then
cd /root
mkdir tools
cd tools
yum install -y make gcc libaio-devel || ( apt-get update && apt-get install -y make gcc libaio-dev  </dev/null )
wget http://freecode.com/urls/3aa21b8c106cab742bf1f20d60629e3f 
mv 3aa21b8c106cab742bf1f20d60629e3f fio.tar.gz
tar xzf fio.tar.gz
cd fio*
make > /dev/null
else
	cd /root/tools
	cd fio*
fi

echo "----------------- RAID Configuration ------------------------------------"
lsblk 
echo "---------------------  Disk Speed test ----------------------------------"
echo "*************************************************************************"
echo "************************ Basic dd Performance Test **********************"
echo "*************************************************************************"
c=1
while [ $c -le 15 ]
do
        dd if=/dev/zero of=/datadisks/disk1/perf.txt bs=1G count=1 oflag=dsync
	rm /datadisks/disk1/perf.txt
	(( c++ ))
done
echo " "
echo "*************************************************************************"
echo "********************* Fio Performance Test 75% read 25% write ***********"
echo "*************************************************************************"
echo " "
./fio --randrepeat=1 --ioengine=libaio --direct=1 --gtod_reduce=1 --name=test --filename=/datadisks/disk1/fiotest75read25write --bs=4k --iodepth=64 --size=4G --readwrite=randrw --rwmixread=75

echo " "
echo "*************************************************************************"
echo "*********************** Fio Performance Test 100% read ******************"
echo "*************************************************************************"
echo " "
./fio --randrepeat=1 --ioengine=libaio --direct=1 --gtod_reduce=1 --name=test --filename=/datadisks/disk1/fiotestread --bs=4k --iodepth=64 --size=4G --readwrite=randrw --rwmixread=75

echo " "
echo "*************************************************************************"
echo "********************* Fio Performance Test 100% write *******************"
echo "*************************************************************************"
echo " "
./fio --randrepeat=1 --ioengine=libaio --direct=1 --gtod_reduce=1 --name=test --filename=/datadisks/disk1/fiotestwrite --bs=4k --iodepth=64 --size=4G --readwrite=randrw --rwmixread=randwrite
