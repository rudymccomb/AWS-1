#!/bin/bash

export AWS_ACCESS_KEY_ID="blah"
export AWS_SECRET_ACCESS_KEY="blah"

CLICLIPATH="/usr/local/bin/"
REGION="us-east-1"

echo getting instance id\(s\)
ids=$(${CLIPATH}aws elb describe-instance-health --load-balancer-name lbname --query 'InstanceStates[*].InstanceId' --region us-east-1 --output text)

for id in $ids
do
	        echo registering $id on cis-alb-proxy target target-group-name
		aws elbv2 register-targets --target-group-arn arn:aws:elasticloadbalancing:us-east-1:172119256206:targetgroup/target-group-name/f9d97d3af77614e9 --targets Id=$id --region us-east-1

done
