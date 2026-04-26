FROM ubuntu:26.04
ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && \
    apt install --no-install-recommends --yes ca-certificates asterisk gettext-base && \
    apt autoremove --yes && \
    apt clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY conf/ /etc/asterisk/
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
