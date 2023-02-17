
#!/bin/bash

METADATA_TOKEN=$(curl -fsS -X PUT -H "X-aws-ec2-metadata-token-ttl-seconds: 600" http://169.254.169.254/latest/api/token)

function get {
  curl -fsS -H "X-aws-ec2-metadata-token: $METADATA_TOKEN" http://169.254.169.254/2021-07-15/$1 2> /dev/null
}

>&2 echo "Fetching metadata..."

DOMAIN=$(get meta-data/services/domain)
REGION=$(get meta-data/placement/region)
AZ=$(get meta-data/placement/availability-zone)
INSTANCE_ID=$(get meta-data/instance-id)
INSTANCE_TYPE=$(get meta-data/instance-type)
PROFILE=$(get meta-data/profile)
AMI_ID=$(get meta-data/ami-id)
PUBLIC_KEY=$(get meta-data/public-keys/0/openssh-key)
HOSTNAME=$(get meta-data/hostname)
PUBLIC_HOSTNAME=$(get meta-data/public-hostname)
MAC=$(get meta-data/mac)
INTERFACE_ID=$(get meta-data/network/interfaces/macs/$MAC/interface-id)
VPC_ID=$(get meta-data/network/interfaces/macs/$MAC/vpc-id)
VPC_CIDR=$(get meta-data/network/interfaces/macs/$MAC/vpc-ipv4-cidr-block)
SUBNET_ID=$(get meta-data/network/interfaces/macs/$MAC/subnet-id)
SUBNET_CIDR=$(get meta-data/network/interfaces/macs/$MAC/subnet-ipv4-cidr-block)
SECURITY_GROUP_IDS=$(get meta-data/network/interfaces/macs/$MAC/security-group-ids)
SECURITY_GROUPS=$(get meta-data/network/interfaces/macs/$MAC/security-groups)

sudo cat  >>/tmp/metadata.txt<<EOL
domain: $DOMAIN
availability-zone: $AZ
instance-id: $INSTANCE_ID
instance-type: $INSTANCE_TYPE
profile: $PROFILE
ami-id: $AMI_ID
ssh key: $PUBLIC_KEY
hostname: $HOSTNAME
public-hostname: $PUBLIC_HOSTNAME
mac: $MAC
interface-id: $INTERFACE_ID
vpc-id: $VPC_ID
subnet-id: $SUBNET_ID
vpc-cidr: $VPC_CIDR
subnet-cidr: $SUBNET_CIDR
security-group-ids: ${SECURITY_GROUP_IDS//$'\n'/ }
security-groups: ${SECURITY_GROUPS//$'\n'/ }
region: $REGION
EOL
		  
jq -Rs '[ split("\n")[] | select(length > 0) | split(":") | {(.[0]): .[1]} ]' /tmp/metadata.txt
