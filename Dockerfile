FROM alpine:edge
LABEL maintainer="dev@jpillora.com"

WORKDIR /usr/local/bin

RUN apk update \
	&& apk add --no-cache dnsmasq bash \
	&& apk add --no-cache --virtual .build-deps curl gzip \
	&& curl https://i.jpillora.com/webproc | bash \
	&& apk del .build-deps
#configure dnsmasq
RUN mkdir -p /etc/default/
RUN echo -e "ENABLED=1\nIGNORE_RESOLVCONF=yes" > /etc/default/dnsmasq
COPY dnsmasq.conf /etc/dnsmasq.conf

EXPOSE 5380
EXPOSE 53

#run!
ENTRYPOINT ["webproc","--config","/etc/dnsmasq.conf","--","dnsmasq","--no-daemon"]
