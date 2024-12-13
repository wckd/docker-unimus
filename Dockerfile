FROM alpine:3.21

LABEL org.opencontainers.image.source = "https://github.com/wckd/docker-unimus"
LABEL org.opencontainers.image.url = "https://hub.docker.com/r/wckd0/unimus"

ENV DOWNLOAD_URL=https://download.unimus.net/unimus/-%20Latest/Unimus.jar

RUN apk add --no-cache tini curl tzdata iputils-ping openjdk17-jre-headless

# Unimus binary download
RUN curl -L -o /opt/unimus.jar $DOWNLOAD_URL
# check the downloaded file if checksum exists
RUN if [ -f /opt/checksum.signed ]; then echo "Checking checksum..."; sha1sum /opt/unimus.jar > /opt/checksum.new; sed -i "s@/opt/@@g" /opt/checksum.new; cat /opt/checksum*; diff -q /opt/checksum.new /opt/checksum.signed || { echo "Checksum invalid"; exit 1; }; fi

COPY --chmod=755 files/start.sh /opt/

EXPOSE 8085

ENTRYPOINT ["/sbin/tini", "--", "/opt/start.sh"]