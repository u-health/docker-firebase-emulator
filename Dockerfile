FROM node:20-alpine

ARG FIREBASE_VERSION=13.6.0

RUN apk --no-cache add openjdk11-jre bash curl openssl gettext nano sudo && \
    npm cache clean --force && \
    npm i -g firebase-tools@$FIREBASE_VERSION

COPY serve.sh /usr/bin/
RUN chmod +x /usr/bin/serve.sh

WORKDIR /srv/firebase

ENTRYPOINT ["/usr/bin/serve.sh"]
