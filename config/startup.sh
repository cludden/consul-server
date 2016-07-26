#!/bin/bash

# define DynamoDB key query
KEY='{"id":{"S":"consul-server"},"user":{"S":"USERNAME"}}'
KEY="${KEY/USERNAME/$USERNAME}"

# get configuration from DynamoDB
aws dynamodb get-item --region $REGION --table-name "$TABLE_NAME" --key="$KEY" | \
    jq '.Item.config.M as $config | {acl_master_token: $config.acl_master_token.S, encrypt: $config.encrypt.S, advertise_addr: $config.advertise_addr.S, datacenter: $config.datacenter.S}' > /config/secrets.json

consul agent -client=0.0.0.0 -server -data-dir=/data -config-dir=/config $CONSUL_PARAMS && rm /config/secrets.json
