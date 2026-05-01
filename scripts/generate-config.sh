#!/usr/bin/env bash

set -euo pipefail

read -rp "Enter main domain (e.g. mydomain.com): " DOMAIN

if [[ -z "$DOMAIN" ]]; then
    echo "Domain cannot be empty"
    exit 1
fi

SUBDOMAINS=("test" "beta" "dev" "staging" "qa" "prod")

UPSTREAM_BLOCK=""
for sub in "${SUBDOMAINS[@]}"; do
    UPSTREAM_BLOCK+="        server ${sub}.${DOMAIN};"$'\n'
done

cat > nginx/nginx.conf <<EOF
worker_processes auto;

events {
    worker_connections 1024;
}

http {
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
        }
    }
}
EOF

echo "Nginx config generated successfully for $DOMAIN"