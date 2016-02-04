#!/bin/bash
block_dev=${1:-"/root/testfile"}

# Install tools

# Install tools
if hash sysbench 2>/dev/null; 
then
INSTOOLS=0
else
INSTOOLS=1
fi
if ! hash fio 2>/dev/null
then
INSTOOLS=$(( 2+$INSTOOLS ))
fi

case $installtoos in
1)
sudo apt-get -y update > /dev/null
apt-get install -y sysbench > /dev/null
  ;;
2)
sudo apt-get -y update > /dev/null
apt-get install -y fio > /dev/null
  ;;
3)
sudo apt-get -y update > /dev/null
apt-get install -y sysbench > /dev/null
apt-get install -y fio > /dev/null
  ;;
esac

echo "----------------- CPU Information ----------------- ---------------------"
lscpu
echo " ------------ Hardware ---------------------------------------------------"
lshw

echo "----------------- CPU Sysbench Test with one thread ---------------------"
sysbench --test=cpu --cpu-max-prime=20000 run

echo "----------------- CPU Sysbench Test with 32 threads ---------------------"
sysbench --test=cpu --cpu-max-prime=20000 --num-threads=32 run

#echo "----------------- CPU Memory Test Read ----------------------------------"
#sysbench --test=memory --memory-block-size=1K --memory-scope=global --memory-total-size=100G --memory-oper=read run

#echo "----------------- CPU Memory Test Write ---------------------------------"
#sysbench --test=memory --memory-block-size=1K --memory-scope=global --memory-total-size=100G --memory-oper=write run


echo "----------------- RAID Configuration ------------------------------------"
lsblk 
echo "---------------------  Disk Speed test ----------------------------------"
echo "*************************************************************************"
echo "************************ Basic dd Performance Test **********************"
echo "*************************************************************************"
c=1
while [ $c -le 15 ]
do
        dd if=/dev/zero of=$block_dev  bs=1G count=1 oflag=dsync
#	rm $block_dev
	(( c++ ))
done
echo " "
echo "*************************************************************************"
echo "********************* Fio Performance Test 75% read 25% write ***********"
echo "*************************************************************************"
echo " "
fio --randrepeat=1 --ioengine=libaio --direct=1 --gtod_reduce=1 --name=test --filename=$block_dev --bs=4k --iodepth=64 --size=4G --readwrite=randrw --rwmixread=75

echo " "
echo "*************************************************************************"
echo "*********************** Fio Performance Test 100% read ******************"
echo "*************************************************************************"
echo " "
fio --randrepeat=1 --ioengine=libaio --direct=1 --gtod_reduce=1 --name=test --filename=$block_dev --bs=4k --iodepth=64 --size=4G --readwrite=randrw --rwmixread=75

echo " "
echo "*************************************************************************"
echo "********************* Fio Performance Test 100% write *******************"
echo "*************************************************************************"
echo " "
fio --randrepeat=1 --ioengine=libaio --direct=1 --gtod_reduce=1 --name=test --filename=$block_dev --bs=4k --iodepth=64 --size=4G --readwrite=randrw --rwmixread=randwrite
echo " "
echo "*************************************************************************"
echo "********************* Fio Performance Test With Large Files  ************"
echo "*************************************************************************"
echo " "
echo " "
echo "*************************************************************************"
echo "********************* Fio Performance Test File Copy *********************"
echo "*************************************************************************"
echo " "
sudo fio --name=writefile --size=10G --filesize=10G \
--filename=$block_dev --bs=1M --nrfiles=1 \
--direct=1 --sync=0 --randrepeat=0 --rw=write --refill_buffers --end_fsync=1 \
--iodepth=200 --ioengine=libaio
echo " "
echo "*************************************************************************"
echo "********************* Fio Performance Test Read *************************"
echo "*************************************************************************"
echo " "
sudo fio --time_based --name=benchmark --size=10G --runtime=30 \
--filename=$block_dev --ioengine=libaio --randrepeat=0 \
--iodepth=128 --direct=1 --invalidate=1 --verify=0 --verify_fatal=0 \
--numjobs=4 --rw=randread --blocksize=4k --group_reporting
echo " "
echo "*************************************************************************"
echo "********************* Fio Performance Test Write ************************"
echo "*************************************************************************"
echo " "
sudo fio --time_based --name=benchmark --size=10G --runtime=30 \
--filename=$block_dev --ioengine=libaio --randrepeat=0 \
--iodepth=128 --direct=1 --invalidate=1 --verify=0 --verify_fatal=0 \
--numjobs=4 --rw=randwrite --blocksize=4k --group_reporting
