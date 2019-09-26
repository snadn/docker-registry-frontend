FROM snadn/docker-alpine-node-yarn:10

COPY * /build/

WORKDIR /build

RUN npm install && npm run release

FROM snadn/docker-alpine-nginx-node:10
LABEL maintainer="snadn"

EXPOSE 80
CMD ["sh", "/app/start.sh"]

RUN apk update && apk add curl bash gettext vim busybox-extras

COPY ./nginx.conf.tmpl /etc/nginx/
COPY ./start.sh /app/
COPY --from=0 /build/dist /app/

RUN envsubst '${ENV_DOCKER_REGISTRY_HOST} ${ENV_DOCKER_REGISTRY_PORT}' < /etc/nginx/nginx.conf.tmpl > /etc/nginx/nginx.conf
