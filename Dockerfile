FROM snadn/docker-alpine-nginx-node
MAINTAINER snadn <snadn@snadn.cn>
LABEL maintainer="https://github.com/snadn/docker-registry-frontend"

# USER app


COPY ./nginx.conf.tmpl /etc/nginx/
COPY ./start.sh /app/
COPY ./dist /app/

RUN envsubst '${ENV_DOCKER_REGISTRY_HOST} ${ENV_DOCKER_REGISTRY_PORT}' < /etc/nginx/nginx.conf.tmpl > /etc/nginx/nginx.conf

EXPOSE 80

# RUN chmod +x /app/start.sh

CMD ["sh", "/app/start.sh"]
