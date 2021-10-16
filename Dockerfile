FROM alpine:edge
LABEL maintainer="dev@jpillora.com"
# webproc release settings
ENV WEBPROC_URL https://github.com/jpillora/webproc/releases/download/0.4.0/webproc_0.4.0_linux_arm64.gz
# fetch dnsmasq and webproc binary
RUN apk update \
	&& apk --no-cache add dnsmasq \
	&& apk add --no-cache --virtual .build-deps curl bash gzip \
	&& curl https://i.jpillora.com/webproc | bash \
    && echo $PATH \
	&& apk del .build-deps
#configure dnsmasq
RUN mkdir -p /etc/default/
RUN echo -e "ENABLED=1\nIGNORE_RESOLVCONF=yes" > /etc/default/dnsmasq
COPY dnsmasq.conf /etc/dnsmasq.conf

EXPOSE 5380
EXPOSE 53

#run!
ENTRYPOINT ["webproc","--config","/etc/dnsmasq.conf","--","dnsmasq","--no-daemon"]
