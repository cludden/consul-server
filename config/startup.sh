#!/bin/bash

# copy ssl certificates
if [ -n "$CERT_S3_PATH" ]; then
    aws s3 cp "s3://${S3_BUCKET}/${CERT_S3_PATH}" "${CERT_DEST_PATH}" --region "$S3_REGION"
fi
if [ -n "$KEY_S3_PATH" ]; then
    aws s3 cp "s3://${S3_BUCKET}/${KEY_S3_PATH}" "${KEY_DEST_PATH}" --region "$S3_REGION"
fi
if [ -n "$CA_S3_PATH" ]; then
    aws s3 cp "s3://${S3_BUCKET}/${CA_S3_PATH}" "${CA_DEST_PATH}" --region "$S3_REGION"
fi

# get configuration from DynamoDB
aws dynamodb get-item --region "$DYNAMO_REGION" --table-name "$DYNAMO_TABLE" --key="$DYNAMO_KEY" | \
    jq '.Item' | jq -f /config/unmarshal_dynamodb.jq | jq '.config' > /config/config.json
