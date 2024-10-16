FROM ubuntu:24.04 AS builder
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    wget \
    libxml2-dev \
    libncurses5-dev \
    uuid-dev \
    sqlite3 \
    libsqlite3-dev \
    pkg-config \
    libjansson-dev \
    libssl-dev \
    libedit-dev \
    liburiparser1 \
    libpopt0 \
    libxslt1.1 \
    gettext \
    unzip \
    checkinstall

# libsrtp
ARG LIBSRTP_RELEASE=2.6.0
RUN wget -O /tmp/libsrtp.tar.gz https://github.com/cisco/libsrtp/archive/refs/tags/v$LIBSRTP_RELEASE.tar.gz \
    && tar -xvf /tmp/libsrtp.tar.gz -C /usr/src \
    && mv /usr/src/libsrtp-* /usr/src/libsrtp \
    && rm /tmp/libsrtp.tar.gz

WORKDIR /usr/src/libsrtp
RUN ./configure --enable-openssl && \ 
    make -j$(nproc)

RUN checkinstall --default --pkgname=libsrtp --pkgversion=$LIBSRTP_RELEASE \
    --requires="libc6, libssl3" \
    --backup=no --deldoc=yes --fstrans=no --pakdir=/root

# Asterisk
ARG ASTERISK_RELEASE=22.0.0-rc2
RUN wget -O /tmp/asterisk.tar.gz https://github.com/asterisk/asterisk/archive/refs/tags/$ASTERISK_RELEASE.tar.gz \
    && tar -xvf /tmp/asterisk.tar.gz -C /usr/src \
    && mv /usr/src/asterisk-* /usr/src/asterisk \
    && rm /tmp/asterisk.tar.gz

WORKDIR /usr/src/asterisk
RUN ./configure && \
    make -j$(nproc)

RUN checkinstall --default --pkgname=asterisk --pkgversion=$ASTERISK_RELEASE \
    --requires="libc6, libcrypt1, libedit2, libgcc-s1, libjansson4, libpopt0, libsqlite3-0, libssl3, libsystemd0, liburiparser1, libuuid1, libxml2, libxslt1.1" \
    --backup=no --deldoc=yes --fstrans=no --pakdir=/root

# chan-sccp
ARG CHAN_SCCP_SRC=https://github.com/chan-sccp/chan-sccp/archive/refs/heads/develop.zip
RUN wget -O /tmp/chan-sccp.zip $CHAN_SCCP_SRC \
    && unzip /tmp/chan-sccp.zip -d /usr/src \
    && mv /usr/src/chan-sccp-* /usr/src/chan-sccp \
    && rm /tmp/chan-sccp.zip

WORKDIR /usr/src/chan-sccp
COPY ./chan-sccp/macroexten.patch .
RUN patch -p1 < macroexten.patch
RUN ./configure --with-asterisk=/usr/src/asterisk && \
    make -j$(nproc) && \
    checkinstall --default --pkgname=chan-sccp --pkgversion=0.0.0 \
    --requires="asterisk, gettext" \
    --backup=no --deldoc=yes --fstrans=no --pakdir=/root

# Distribution
FROM ubuntu:24.04 AS pbx
ENV DEBIAN_FRONTEND=noninteractive

COPY --from=builder /root/*.deb /tmp/
RUN apt update && apt install -fy /tmp/*.deb
RUN rm /tmp/*.deb
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

CMD ["asterisk", "-f"]