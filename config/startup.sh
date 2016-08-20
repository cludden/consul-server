#!/bin/bash

# define DynamoDB key query
KEY='{"id":{"S":"CONFIGID"},"user":{"S":"USERNAME"}}'
KEY="${KEY/USERNAME/$USERNAME}"
KEY="${KEY/CONFIGID/$CONFIGID}"

# copy ssl certificates
aws s3 cp s3://wccportal-init/consul/aws-us-west-2.cer /opt/consul/ssl/aws-us-west-2.cer --region us-west-2
aws s3 cp s3://wccportal-init/consul/aws-us-west-2.key /opt/consul/ssl/aws-us-west-2.key --region us-west-2
aws s3 cp s3://wccportal-init/consul/ca.cer /opt/consul/ssl/ca.cer --region us-west-2

# get configuration from DynamoDB
aws dynamodb get-item --region $REGION --table-name "$TABLE_NAME" --key="$KEY" | \
    jq '.Item' | jq -f /config/unmarshal_dynamodb.jq | jq '.config' > /config/config.json
