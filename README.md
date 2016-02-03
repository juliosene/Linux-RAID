# Linux-RAID

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https:%2F%2Fraw.githubusercontent.com%2Fjuliosene%2FLinux-RAID%2Fmaster%2FLinuxVirtualMachine-RAID.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>
<a href="http://armviz.io/#/?load=https:%2F%2Fraw.githubusercontent.com%2Fjuliosene%2FLinux-RAID%2Fmaster%2FLinuxVirtualMachine-RAID.json" target="_blank">
    <img src="http://armviz.io/visualizebutton.png"/>
</a>

## Test your disks

To test disk performance:
-> local disk (OS)
```
dd if=/dev/zero of=/root/perf.txt bs=1G count=1 oflag=dsync 
```
-> RAID
```
dd if=/dev/zero of=/datadisks/disk1/perf.txt bs=1G count=1 oflag=dsync
```

to test disl latency
-> local disk (OS)
```
dd if=/dev/zero of=/root/lat.txt bs=512 count=1000 oflag=dsync
```
-> RAID
```
dd if=/dev/zero of=/datadisks/disk1/lat.txt bs=512 count=1000 oflag=dsync
```
