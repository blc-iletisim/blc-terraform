#!/bin/bash
set -e

#create instance
terraform init
terraform plan
terraform apply
terraform output -json > /root/blc-terraform/ssh/output.json

#ssh tf
cd /root/blc-terraform/ssh
terraform init
terraform plan
terraform apply
#value=($(jq -r '.pool.value.address' output.json))
#echo "${value[@]}"
