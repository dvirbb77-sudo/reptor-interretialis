# reptor-interretialis

## Overview

This project demonstrates a Dockerized NGINX reverse proxy that routes traffic from a main domain to multiple subdomains using an upstream configuration.

The setup is fully containerized and dynamically generates the NGINX configuration based on user input.

---

## Requierments

* Docker
* Docker Compose
* NGINX
* Bash (POSIX-friendly)

---

## Features

* Dynamic NGINX configuration generation
* Upstream load balancing across subdomains
* Minimal, reproducible setup
* Config validation before runtime

---

## Project Structure

```
.
├── docker-compose.yml
├── Dockerfile
├── nginx/
│   └── nginx.conf (generated)
├── scripts/
│   └── generate-config.sh
└── README.md
```

---

## Usage

### 1. Generate NGINX config

```bash
chmod +x scripts/generate-config.sh
./scripts/generate-config.sh
```

You will be prompted for a domain (default: `mydomain.test`).

---

### 2. Run the service

```bash
docker compose up --build
```

---

### 3. Test the service

```bash
curl -v http://localhost
```

---

## Expected Behavior

You will likely receive:

```
502 Bad Gateway
```

This is **expected**.

### Why?

The NGINX container is configured to proxy traffic to subdomains like:

* `test.mydomain.test`
* `beta.mydomain.test`
* etc.

However, no actual backend servers are running at those addresses.

This project demonstrates:

* correct NGINX upstream configuration
* proper request routing attempts

—not backend availability.

---

## 🔍 Verification

Check NGINX logs:

```bash
docker logs reptor-nginx
```

You should see errors indicating failed upstream resolution, which confirms that NGINX is attempting to route traffic correctly.

---

## Notes

* Uses `.test` domain to avoid conflicts with real DNS
* Includes config validation using `nginx -t` inside a container
* Designed for learning and demonstration purposes

---

## Possible Improvements

* Add real backend services for full end-to-end testing
* Add HTTPS support (Let's Encrypt)
* Add health checks and failover logic

---

## Author

GitHub: https://github.com/dvirbb77-sudo
