FROM node:24-alpine

ARG FIREBASE_VERSION=15.3.0

RUN apk --no-cache add openjdk21-jre bash curl openssl gettext nano sudo && \
    npm cache clean --force && \
    npm i -g firebase-tools@$FIREBASE_VERSION

RUN firebase setup:emulators:database
RUN firebase setup:emulators:firestore
RUN firebase setup:emulators:pubsub
RUN firebase setup:emulators:storage
RUN firebase setup:emulators:ui
RUN firebase setup:emulators:dataconnect

COPY serve.sh /usr/bin/
RUN chmod +x /usr/bin/serve.sh

WORKDIR /srv/firebase

ENTRYPOINT ["/usr/bin/serve.sh"]
