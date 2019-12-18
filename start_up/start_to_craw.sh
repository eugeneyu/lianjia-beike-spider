#!/bin/bash

# Don't need to upload this file to VM.
# On console edit the VM, and add an item to Custom Metadata
# Key: startup-script
# Value: content of this file

su eugeneyu <<DOWORK

rm -rf /home/eugeneyu/lianjia-beike-spider/data/lianjia/ershou/*

cd /home/eugeneyu/lianjia-beike-spider && ./run_ershou_all_cities.sh 2>&1 > data/job.log

/snap/bin/gsutil -m cp -r data/lianjia/ershou/* gs://alme-test-eyu/lianjia-data/ershou/

sudo shutdown -h now

DOWORK