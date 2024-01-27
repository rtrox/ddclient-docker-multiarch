FROM alpine:3.19.1

LABEL maintainer "Russell Troxel <russelltroxel@gmail.com>"

RUN apk add --virtual=build-dependencies \
                      autoconf           \
                      automake           \
                      make               \
                      gcc
RUN apk add --no-cache \
        bash \
	curl \
	inotify-tools \
	jq \
	perl \
	perl-digest-sha1 \
	perl-io-socket-inet6 \
	perl-io-socket-ssl \
	perl-json

WORKDIR /ddclient
COPY ./ddclient .
RUN ./autogen && \
    ./configure --prefix=/usr \
                --sysconfdir=/etc/ddclient \
                --localstatedir=/var && \
    make && \
    make VERBOSE=1 check && \
    make install

RUN apk del --purge build-dependencies
RUN rm -rf /ddclient

VOLUME /defaults

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]
CMD ["--daemon=3600", "--file", "/ddclient.conf"]
