#!/bin/bash


key_name="james-bond-rsa-2048"
key_material="ssh-rsa blah"
profile='account name goes here'
region='us-west-2'

echo "Uploading SSH Key for $profile"

aws --profile=$profile --region=$region ec2 import-key-pair --key-name $key_name --public-key-material "$key_material"
