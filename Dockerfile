FROM alpine:latest

EXPOSE 80 443
WORKDIR /opt/certbot

RUN apk add --no-cache certbot

# Certbot bootup script
ADD crontab /etc/crontabs
RUN crontab /etc/crontabs/crontab
ADD certbot.sh .
RUN chmod +x certbot.sh

ENTRYPOINT [ "crond", "-f" ]
