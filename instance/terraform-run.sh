#!/bin/bash





set -e

terraform init
terraform plan
terraform apply
terraform output -json > ./output.json
