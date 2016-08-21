# consul-server
docker container based on the official [consul]() image that allows for dynamic configuration by pulling all configuration from DynamoDB.

## Getting Started
1. clone this repo
2. create a dynamodb table for configuration data with a hash key of "user" and type string, and a range key of "id" and type string. Add an item for each consul datacenter cluster
```json
{
    "user": "consul-server-aws-us-west-2",
    "id": "consul-server-aws-us-west-2",
    "config": {
        "acl_datacenter": "aws-us-west-2",
        "acl_default_policy": "deny",
        "acl_down_policy": "deny",
        "acl_master_token": "<master-token>",
        "client_addr": "0.0.0.0",
        "data_dir": "/data",
        "datacenter": "aws-us-west-2",
        "disable_remote_exec": true,
        "dns_config": {
            "allow_stale": true
        },
        "encrypt": "<encrypt-key>",
        "server": true,
        "ui": true
    }
}
```
3. create an s3 bucket to hold ssl certificates & keys. I found [this guide](https://www.digitalocean.com/community/tutorials/how-to-secure-consul-with-tls-encryption-on-ubuntu-14-04) and [this other guide](https://langui.sh/2009/01/18/openssl-self-signed-ca/) helpful for creating all of the necessary components. Once you have them, upload them to the s3 bucket. *note: you will need an additional certificate & key file per datacenter*
2. Build the image.
```bash
docker build -t consul-server .
```
3. Run it, providing environment variables for configuration data
```bash
docker run -d \
-e "REGION=$REGION" \ # add additional env vars here as well
consul-server
```

## Environment Variables
| name | desc |
| --- | --- |
| CA_DEST_PATH | the absolute destination path for the ca certificate (e.g. `/opt/consul/ssl/consul-ca.cer`) |
| CA_S3_PATH | the s3 location of the ca certificate |
| CERT_DEST_PATH | the absolute destination path for the ssl certificate (e.g. `/opt/consul/ssl/aws-us-west-2.cer`) |
| CERT_S3_PATH | the s3 location of the ssl certificate |
| DYNAMO_KEY | the key query for the dynamo object `{"hashKey":{"S":"HASH"},"rangeKey":{"S":"RANGE"}}` |
| DYNAMO_REGION | aws region for the dynamo table |
| DYNAMO_TABLE | dynamodb table name |
| KEY_DEST_PATH | the absolute destination path for the ssl key (e.g. `/opt/consul/ssl/aws-us-west-2.key`) |
| KEY_S3_PATH | the s3 location of the ssl key |
| S3_BUCKET | the name of the s3 bucket that holds the ssl components |
| S3_REGION | aws region |

## License
Copyright (c) 2016 Chris Ludden. Licensed under the [MIT License](LICENSE.md)
