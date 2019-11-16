#
# Dockerfile for ss-privoxy
#

FROM alpine

ARG LIBEV_VERSION=v3.3.3

ENV SERVER_ADDR 0.0.0.0
ENV SERVER_PORT 8388
ENV PASSWORD=
ENV METHOD aes-256-gcm
ENV TIMEOUT 300
ENV LISTEN_ADDR 127.0.0.1
ENV SS_ARGS=

RUN set -ex \
 && apk add --no-cache --virtual .build-deps \
      autoconf \
      automake \
      build-base \
      c-ares-dev \
      libev-dev \
      libtool \
      libsodium-dev \
      linux-headers \
      mbedtls-dev \
      pcre-dev \
      git \
 && mkdir -p /tmp/repo \
 && cd /tmp/repo \
 && git clone https://github.com/shadowsocks/shadowsocks-libev.git \
 && cd shadowsocks-libev \
 && git checkout "${LIBEV_VERSION}" \
 && git submodule update --init --recursive \
 && ./autogen.sh \
 && ./configure --prefix=/usr --disable-documentation \
 && make install \
 && apk del .build-deps \
 && apk add --no-cache \
      ca-certificates \
      rng-tools \
      $(scanelf --needed --nobanner /usr/bin/ss-* \
      | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
      | sort -u) \
 && rm -rf /tmp/repo \
 && apk add --no-cache privoxy \
 && mkdir -p /etc/privoxy

COPY config /etc/privoxy
COPY gfwlist.action /etc/privoxy
COPY docker-entrypoint.sh /usr/local/bin/

RUN ln -s usr/local/bin/docker-entrypoint.sh /entrypoint.sh \
 && chmod +x usr/local/bin/docker-entrypoint.sh \
 && chmod +r /etc/privoxy/config \
 && chmod +r /etc/privoxy/gfwlist.action

EXPOSE 8118 1080

ENTRYPOINT ["docker-entrypoint.sh"]