FROM consul:v0.6.4

# install aws-cli
RUN \
    mkdir -p /aws && \
    apk -Uuv add groff less python py-pip jq && \
    pip install awscli && \
    apk --purge -v del py-pip && \
    rm /var/cache/apk/*

COPY ./config /config/

RUN chmod +x /config/startup.sh

EXPOSE 8300
EXPOSE 8301
EXPOSE 8301
EXPOSE 8302
EXPOSE 8400
EXPOSE 8500
EXPOSE 8600

ENTRYPOINT ["/bin/ash", "-c", "(. /config/startup.sh;export ADVERTISE_ADDR=$(wget -qO- 169.254.169.254/latest/meta-data/local-ipv4);export NODE_NAME=$(wget -qO- 169.254.169.254/latest/meta-data/local-hostname);consul agent -client=0.0.0.0 -server -data-dir=/data -advertise=$ADVERTISE_ADDR -config-dir=/config $CONSUL_PARAMS -node=$NODE_NAME)"]
