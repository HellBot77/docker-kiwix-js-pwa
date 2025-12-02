FROM alpine/git AS base

ARG TAG=latest
RUN git clone https://github.com/kiwix/kiwix-js-pwa.git && \
    cd kiwix-js-pwa && \
    ([[ "$TAG" = "latest" ]] || git checkout ${TAG}) && \
    rm -rf .git

FROM node:alpine AS build

WORKDIR /kiwix-js-pwa
COPY --from=base /git/kiwix-js-pwa .
RUN npm ci && \
    npm run build

FROM joseluisq/static-web-server

COPY --from=build /kiwix-js-pwa/dist ./public
