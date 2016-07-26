FROM consul:v0.6.4

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

ENTRYPOINT ["/bin/ash", "-c", ". /config/startup.sh"]
