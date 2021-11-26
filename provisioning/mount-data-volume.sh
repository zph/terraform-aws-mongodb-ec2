#!/bin/bash

set -x

devpath=$(readlink -f /dev/xvdh)
datapath="/data/db"

sudo file -s $devpath | grep -q xfs
if [[ 1 == $? && -b $devpath ]]; then
    # TODO: fix this to be XFS due to performance issues with ext4
  sudo mkfs -t xfs $devpath
fi

# TODO: tighten permissions
sudo mkdir -p "$datapath"
sudo chmod -R 0775 "$datapath"

echo "$devpath $datapath xfs defaults,nofail,noatime,nodiratime,barrier=0,data=writeback 0 2" | sudo tee -a /etc/fstab > /dev/null
sudo mount $datapath

# TODO: /etc/rc3.d/S99local to maintain on reboot
echo deadline | sudo tee /sys/block/$(basename "$devpath")/queue/scheduler
echo never | sudo tee /sys/kernel/mm/transparent_hugepage/enabled
