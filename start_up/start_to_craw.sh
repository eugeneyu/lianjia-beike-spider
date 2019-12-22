#!/bin/bash

# Don't need to upload this file to VM.
# On console edit the VM, and add an item to Custom Metadata
# Key: startup-script
# Value: content of this file

su eugeneyu <<'DOWORK'

rm -rf /home/eugeneyu/lianjia-beike-spider/data/lianjia/ershou/*

cd /home/eugeneyu/lianjia-beike-spider && ./run_ershou_all_cities.sh 2>&1 > data/job.log

/snap/bin/gsutil -m cp -r data/lianjia/ershou/* gs://alme-test-eyu/lianjia-data/ershou/

today=`date +%Y-%m-%d`

TEMPLATE_BUCKET=alme-test-eyu
PROJECT_ID=youzhi-lab
DATA_GCS_PATH=gs://alme-test-eyu/lianjia-data/ershou/$today/*/*

/snap/bin/gcloud dataflow jobs run import-lj \
--gcs-location=gs://${TEMPLATE_BUCKET}/dataflow/pipelines/templates/LJToBigQuery.json \
--region=asia-east1 \
--parameters inputFilePattern=${DATA_GCS_PATH},\
outputTable=youzhi-lab:lianjia_tw.ershou 2>&1 > data/dataflow.log

sudo shutdown -h now

DOWORK