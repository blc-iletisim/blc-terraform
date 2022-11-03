#!/bin/bash

#sudo apt-get install jq

#sudo apt install ssh

#sudo apt install pdsh

export PDSH_RCMD_TYPE=ssh

value=($(jq -r '.pool.value.address' output.json))
echo "${value[@]}"

#ssh-keygen -t rsa -P ""

#ssh-keygen -R "${value[@]}"

#git clone https://github.com/blc-iletisim/blc-hadoop.git

cd blc-hadoop

sh ./bootstrap-master.sh

#git clone https://github.com/blc-iletisim/blc-hadoop.git

#ssh -i blc-cloud.pem ubuntu@"${value[@]}"

