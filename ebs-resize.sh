#!/bin/bash

CLICLIPATH="/usr/local/bin/"
ENV=$1
REGION="us-east-1" 

if [ ${ENV} -eq "dev"]
then
	VOLSIZE="20"
else
	VOLSIZE="40"
fi

echo getting volume id\(s\) of instance\(s\)
vids=$(${CLIPATH}aws ec2 describe-instances --region=us-east-1 --filter "Name=instance-state-name,Values=running" Name="tag-key,Values=Name" "Name=tag-value,Values=this-api-${ENV}" --query "Reservations[*].Instances[*].BlockDeviceMappings[*].Ebs.VolumeId" --output text)

for id in $vids
do
	echo resizing volume $id
	aws ec2 modify-volume --region us-east-1 --volume-id $id --size ${VOLSIZE}
done

echo getting instance id\(s\)
ids=$(${CLIPATH}aws ec2 describe-instances --region=us-east-1 --filter "Name=instance-state-name,Values=running" Name="tag-key,Values=Name" "Name=tag-value,Values=this-api-${ENV}" --query "Reservations[*].Instances[*].InstanceId" --output text)

for id in $ids
do
	echo stopping $id
	${CLIPATH}aws ec2 stop-instances --region=${REGION} --instance-ids $id
done

sleep 20

for id in $ids
do
	echo starting $id
        ${CLIPATH}aws ec2 start-instances --region=${REGION} --instance-ids $id
done

echo “all done!"

