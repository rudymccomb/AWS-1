#!/bin/bash

# Global Settings
account="my-account"
region="us-east-1"

# Instance settings
image_id="ami-03ebd214" # ubuntu 14.04
ssh_key_name="my_ssh_key-rsa-2048"
instance_type="m4.xlarge"
subnet_id="subnet-b8214792"
root_vol_size=20
count=1

# Tags
tags_Name="my-test-instance"
tags_Owner="tuxninja"
tags_ApplicationRole="Testing"
tags_Cluster="Test Cluster"
tags_Environment="dev"
tags_OwnerEmail="tuxninja@tuxlabs.com"
tags_Project="Test"
tags_BusinessUnit="Cloud Platform Engineering"
tags_SupportEmail="tuxninja@tuxlabs.com"

echo 'creating instance...'
id=$(aws --profile $account --region $region ec2 run-instances --image-id $image_id --count $count --instance-type $instance_type --key-name $ssh_key_name --subnet-id $subnet_id --block-device-mapping "[ { \"DeviceName\": \"/dev/sda1\", \"Ebs\": { \"VolumeSize\": $root_vol_size } } ]" --query 'Instances[*].InstanceId' --output text)

echo "$id created"

# tag it

echo "tagging $id..."

aws --profile $account --region $region ec2 create-tags --resources $id --tags Key=Name,Value="$tags_Name" Key=Owner,Value="$tags_Owner"  Key=ApplicationRole,Value="$tags_ApplicationRole" Key=Cluster,Value="$tags_Cluster" Key=Environment,Value="$tags_Environment" Key=OwnerEmail,Value="$tags_OwnerEmail" Key=Project,Value="$tags_Project" Key=BusinessUnit,Value="$tags_BusinessUnit" Key=SupportEmail,Value="$tags_SupportEmail" Key=OwnerGroups,Value="$tags_OwnerGroups"

echo "storing instance details..."
# store the data
aws --profile $account --region $region ec2 describe-instances --instance-ids $id > instance-details.json

echo "create termination script"
echo "#!/bin/bash" > terminate-instance.sh
echo "aws --profile $account --region $region ec2 terminate-instances --instance-ids $id" >> terminate-instance.sh
chmod +x terminate-instance.sh
