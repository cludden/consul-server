# consul-server
docker container based on the official [consul]() image that pulls secret configuration from DynamoDB.

## Installing
1. modify defaults in `/config/config.json`
2. Build the image.
```bash
docker build -t consul-server .
```
3. Run it
```bash
docker run -d \
    -e "REGION=$REGION" \
    -e "TABLE_NAME=$TABLE_NAME" \
    -e "USERNAME=$USERNAME" \
    -e "AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID" \
    -e "AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY" \
    -e "CONSUL_PARAMS=-bootstrap" \
    consul-server
```

## License
UNLICENSED
