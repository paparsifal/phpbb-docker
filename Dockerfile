FROM php:8.1-fpm-alpine

RUN apk add --no-cache dumb-init nginx

COPY default.conf /etc/nginx/http.d/

EXPOSE 80
ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["/bin/sh", "-c", "nginx && php-fpm"]
