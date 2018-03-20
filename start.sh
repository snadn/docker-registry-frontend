#!sh

die() {
  echo "ERROR: $1"
  exit 2
}

[[ -z "$ENV_DOCKER_REGISTRY_HOST" ]] && die "Missing environment variable: ENV_DOCKER_REGISTRY_HOST=url-to-your-registry"
[[ -z "$ENV_DOCKER_REGISTRY_PORT" ]] && ENV_DOCKER_REGISTRY_PORT=80
[[ -z "$ENV_REGISTRY_PROXY_FQDN" ]] && ENV_REGISTRY_PROXY_FQDN=$ENV_DOCKER_REGISTRY_HOST
[[ -z "$ENV_REGISTRY_PROXY_PORT" ]] && ENV_REGISTRY_PROXY_PORT=$ENV_DOCKER_REGISTRY_PORT

# docker-registry-frontend acts as a proxy so may well
# have a different hostname than the registry itself.
echo "{\"host\": \"$ENV_REGISTRY_PROXY_FQDN\", \"port\": $ENV_REGISTRY_PROXY_PORT}" > /app/registry-host.json

# information about browse mode.
[[ -z "$ENV_MODE_BROWSE_ONLY" ]] && ENV_MODE_BROWSE_ONLY=false
[[ -z "$ENV_DEFAULT_REPOSITORIES_PER_PAGE" ]] && ENV_DEFAULT_REPOSITORIES_PER_PAGE=20
[[ -z "$ENV_DEFAULT_TAGS_PER_PAGE" ]] && ENV_DEFAULT_TAGS_PER_PAGE=10
echo "{\"browseOnly\":$ENV_MODE_BROWSE_ONLY, \"defaultRepositoriesPerPage\":$ENV_DEFAULT_REPOSITORIES_PER_PAGE , \"defaultTagsPerPage\":$ENV_DEFAULT_TAGS_PER_PAGE }"  > /app/app-mode.json

envsubst '${ENV_DOCKER_REGISTRY_HOST} ${ENV_DOCKER_REGISTRY_PORT}' < /etc/nginx/nginx.conf.tmpl > /etc/nginx/nginx.conf

nginx -g 'daemon off;'
