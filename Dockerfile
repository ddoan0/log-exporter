FROM ubuntu:22.04

RUN apt-get update && apt-get install -y \
    rsyslog \
    cron \

RUN mkdir -p /mnt/usb /usr/local/bin

COPY rsyslog.conf /etc/rsyslog.conf

COPY export_logs.sh /usr/local/bin/export_logs.sh

RUN chmod +x /usr/local/bin/export_logs.sh

RUN echo "*/5 * * * * /usr/local/bin/export_logs.sh" > /etc/cron.d/export_logs

CMD ["sh", "-c", "cron && rsyslogd -n"]

