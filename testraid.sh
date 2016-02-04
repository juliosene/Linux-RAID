#!/bin/bash
echo "RAID Configuration"
lsblk 
echo "Disk Speed test"
c=1
while [ $c -le 15 ]
do
        dd if=/dev/zero of=/datadisks/disk1/perf.txt bs=1G count=1 oflag=dsync
	rm /datadisks/disk1/perf.txt
	(( c++ ))
	sleep 5
done
