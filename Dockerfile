FROM php:8.3-cli-alpine3.19 AS base

ENV TZ=UTC

COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/

RUN install-php-extensions @composer gd curl xml zip mbstring

RUN apk add --no-cache zip git curl bash su-exec

# Set up App user
RUN mkdir -p /var/app/www \
    && addgroup -g 1000 app \
    && adduser -u 1000 -G app -h /var/app/ -s /bin/sh -D app \
    && addgroup app www-data \
    && mkdir -p /var/app/www \
    && chown -R app:app /var/app

COPY --chown=app:app ./build/scripts/ /usr/local/bin
RUN chmod a+x /usr/local/bin/*

USER app
WORKDIR /var/app/www

CMD ["generate"]
