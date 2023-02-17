
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

echo "domain: $DOMAIN"
echo "availability-zone: $AZ"
echo "instance-id: $INSTANCE_ID"
echo "instance-type: $INSTANCE_TYPE"
echo "profile: $PROFILE"
echo "ami-id: $AMI_ID"
echo "ssh key: $PUBLIC_KEY"
echo "hostname: $HOSTNAME"
echo "public-hostname: $PUBLIC_HOSTNAME"
echo "mac: $MAC"
echo "interface-id: $INTERFACE_ID"
echo "vpc-id: $VPC_ID"
echo "subnet-id: $SUBNET_ID"
echo "vpc-cidr: $VPC_CIDR"
echo "subnet-cidr: $SUBNET_CIDR"
echo "security-group-ids: ${SECURITY_GROUP_IDS//$'\n'/ }"
echo "security-groups: ${SECURITY_GROUPS//$'\n'/ }"
echo "region: $REGION"





