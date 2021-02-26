#!/bin/bash
## variables
ATTACK_RANGE_URL="https://github.com/umbrio/attack_range"
ATTACK_RANGE_DIR="/root/attack_range"
TERRAFORM_BIN="/usr/local/bin/terraform"
TERRAFORM_VERSION="0.14.4"

## prerequisites
sudo apt-get update
sudo apt-get install -y python3-dev git unzip python3-pip awscli
pip3 install virtualenv

## install Terraform
curl -s https://releases.hashicorp.com/terraform/$TERRAFORM_VERSION/terraform_$TERRAFORM_VERSION_linux_amd64.zip /
     -o /tmp/terraform.zip
unzip /tmp/terraform.zip
sudo mv /tmp/terraform $TERRAFORM_BIN
rm /tmp/terraform.zip

## setup attack_range
git clone $ATTACK_RANGE_URL $ATTACK_RANGE_DIR
cd $ATTACK_RANGE_DIR
cd $ATTACK_RANGE_DIR/terraform/aws
terraform init
cd $ATTACK_RANGE_DIR/terraform/azure
terraform init
virtualenv -p python3 $ATTACK_RANGE_DIR/venv
source $ATTACK_RANGE_DIR/venv/bin/activate
pip install -r $ATTACK_RANGE_DIR/requirements.txt
