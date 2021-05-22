FROM haproxy:1.8-alpine

RUN apk add --no-cache \
       bash \
       coreutils \
       gawk \
       rsyslog \
       sed \
       socat \
       bind-tools \
    ;

RUN apk add python curl 
RUN curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip"
RUN unzip awscli-bundle.zip
RUN ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws

ENV RSYSLOG=y

COPY render_cfg.sh         /
COPY docker-entrypoint.sh  /
COPY rsyslogd.conf         /etc/rsyslogd.conf

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["haproxy", "-f", "/etc/haproxy.cfg"]
