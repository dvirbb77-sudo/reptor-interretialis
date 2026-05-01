#!/usr/bin/env bash
##################
# version: 0.1.0
# created by: bibi
# purpose: setup http service that knows how to redirect url, with domain name being provided by the user
###################

set -euo pipefail

DEFAULT_DOMAIN="mydomain.test"
SUBDOMAINS=("test" "beta" "version2" "dev" "staging" "prod" "www" "qa")

read -rp "Enter main domain [${DEFAULT_DOMAIN}]: " DOMAIN
DOMAIN="${DOMAIN:-$DEFAULT_DOMAIN}"

if [[ -z "$DOMAIN" ]]; then
    echo "Domain cannot be empty"
    exit 1
fi

echo "Generating nginx config for domain: $DOMAIN"

UPSTREAM_BLOCK=""
for sub in "${SUBDOMAINS[@]}"; do
    UPSTREAM_BLOCK+="        server ${sub}.${DOMAIN};"$'\n'
done

mkdir -p nginx

cat > nginx/nginx.conf <<EOF
worker_processes auto;

events {
    worker_connections 1024;
}

http {
    resolver 127.0.0.11 valid=10s;

    upstream backend {
        least_conn;
$UPSTREAM_BLOCK
    }

    server {
        listen 80;
        server_name ${DOMAIN};

        location / {
            proxy_pass http://backend;

            proxy_set_header Host \$host;
            proxy_set_header X-Real-IP \$remote_addr;

            proxy_connect_timeout 2s;
            proxy_read_timeout 5s;
        }
    }
}
EOF

echo "Validating nginx configuration..."

if docker run --rm -v "$(pwd)/nginx/nginx.conf:/etc/nginx/nginx.conf:ro" nginx:alpine nginx -t; then
    echo "Nginx config is valid"
else
    echo "Nginx config validation failed"
    exit 1
fi

echo "Done."
