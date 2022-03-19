FROM php:8.1-fpm-alpine

RUN apk add --no-cache dumb-init nginx \
# forward request and error logs to docker log collector
    && ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log


### phpBB
ENV PHPBB_VERSION 3.3.7
ENV PHPBB_SHA256 'ad49c3ea4fa53c43f4a2b42cb6ef9bf856392ec068fa37f3e3e34200ca5d5e75'

WORKDIR /tmp

RUN curl -SL https://download.phpbb.com/pub/release/3.3/${PHPBB_VERSION}/phpBB-${PHPBB_VERSION}.tar.bz2 -o phpbb.tar.bz2 \
    && echo "${PHPBB_SHA256}  phpbb.tar.bz2" | sha256sum -c - \
    && tar -xjf phpbb.tar.bz2 \
    && mv phpBB3/* /var/www/html/ \
    && rm -f phpbb.tar.bz2


COPY default.conf /etc/nginx/http.d/

EXPOSE 80
ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["/bin/sh", "-c", "nginx && php-fpm"]
