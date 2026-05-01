## Local Development Setup

This project uses custom domains for routing.

### Option 1 (recommended)

Run the setup script:

```bash
./scripts/generate-config.sh
```

### Option 2 (manual)

Add the following to `/etc/hosts`:

```
127.0.0.1 mydomain.test
127.0.0.1 test.mydomain.test
127.0.0.1 beta.mydomain.test
```

### Then start:

```bash
docker compose up --build
```
