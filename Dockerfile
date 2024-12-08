FROM alpine:latest

ENV DOWNLOAD_URL=https://download.unimus.net/unimus/-%20Latest/Unimus.jar

RUN apk update && apk --no-cache add curl less wget tzdata iputils-ping openjdk11-jre

# Unimus binary download
RUN curl -L -o /opt/unimus.jar $DOWNLOAD_URL
# check the downloaded file if checksum exists
RUN if [ -f /opt/checksum.signed ]; then echo "Checking checksum..."; sha1sum /opt/unimus.jar > /opt/checksum.new; sed -i "s@/opt/@@g" /opt/checksum.new; cat /opt/checksum*; diff -q /opt/checksum.new /opt/checksum.signed || { echo "Checksum invalid"; exit 1; }; fi

ADD files/start.sh /opt/
RUN chmod 755 /opt/start.sh

EXPOSE 8085

ENTRYPOINT /opt/start.sh
