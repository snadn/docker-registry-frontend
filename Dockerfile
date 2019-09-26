FROM snadn/docker-alpine-node-yarn:10

COPY * /build/

WORKDIR /build

RUN npm install && npm run release

FROM snadn/docker-alpine-nginx-node:10
LABEL maintainer="snadn"

COPY ./nginx.conf.tmpl /etc/nginx/
COPY ./start.sh /app/
COPY --from=0 /build/dist /app/

RUN envsubst '${ENV_DOCKER_REGISTRY_HOST} ${ENV_DOCKER_REGISTRY_PORT}' < /etc/nginx/nginx.conf.tmpl > /etc/nginx/nginx.conf

EXPOSE 80

# RUN chmod +x /app/start.sh

CMD ["sh", "/app/start.sh"]
