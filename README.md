# Punctiq HAProxy

> Custom HAProxy container built on Ubuntu 22.04, designed for use in secure, isolated environments as part of the Punctiq infrastructure stack.

---

## 📘 Overview

This repository provides a Dockerized version of HAProxy tailored for Punctiq deployments. It ensures non-root execution, built-in health checks, and minimal dependencies to fit cleanly into CI/CD workflows and production environments.

The image is meant to serve as a base for internal or external load balancing in microservice or container-based architectures managed by Punctiq.

---

## 📦 Project Structure

```
.
├── Dockerfile
├── docker-compose.yml
├── build-and-push.sh
├── VERSION
└── README.md
```

---

## 🚀 Usage

### Build the Docker image
```bash
docker build -t itcommunity/haproxy-frontend-prod:1.0.0 .
```

### Run with Docker Compose
```bash
docker compose up -d
```

---

## 🛠 Configuration

| File / Path              | Description                               |
|--------------------------|-------------------------------------------|
| `/etc/haproxy`           | HAProxy config directory (volume mount)   |
| `haproxy.cfg`            | Main HAProxy configuration (manual edit)  |

> The container runs as a non-root user (`haproxy`) and expects configuration files to be accessible under `/etc/haproxy`.

---

## 🔖 Tagging & Versioning

- Follow [DOCKER_IMAGE_GUIDELINES.md](./DOCKER_IMAGE_GUIDELINES.md)
- Use semantic versioning: `X.Y.Z`
- Optional tags: `dev`, `prod`, `sha-<commit>` as needed

---

# 🔄 Reloading HAProxy Without Downtime

This guide explains how to reload the HAProxy container with zero downtime after making changes to the configuration file.

---

## 📂 1. Make Configuration Changes

Edit your `haproxy.cfg` located on the host (same directory as `docker-compose.yml`):

```bash
nano haproxy.cfg
```

Save and validate the changes.

---

## ✅ 2. Validate Configuration

Run this inside the container:

```bash
docker exec -it pctq-prod-hz-haproxy haproxy -c -f /etc/haproxy/haproxy.cfg
```

You should see:  
```
Configuration file is valid
```

---

## 🚀 3. Reload Container Gracefully

To reload without downtime:

```bash
docker kill --signal=HUP pctq-prod-hz-haproxy
```

This sends the `SIGHUP` signal which causes HAProxy to reload configuration in-place without killing the process.

---

## 🩺 4. Confirm HAProxy is Running

```bash
docker ps
docker logs pctq-prod-hz-haproxy
```

Also, verify ports and frontend activity.

---

## 🛠️ Alternative: Compose Recreate (Soft Restart)

```bash
docker compose up -d --no-deps --force-recreate haproxy
```

⚠️ Might cause slight delays during re-creation.

---

## 📚 References

- [HAProxy Documentation](https://www.haproxy.org/download/2.4/doc/management.txt)
- [Docker Kill Docs](https://docs.docker.com/engine/reference/commandline/kill/)

---

## 🧰 Makefile Targets

This repository includes a `Makefile` for simplified automation.

### 🔧 Basic Commands

```makefile
make build       # Build the Docker image
make up          # Start the Docker container
make down        # Stop the Docker container
make restart     # Restart the container
make logs        # Show logs
make shell       # Open shell inside container
make tag         # Tag image with version and git SHA
make push        # Push tags to registry
make clean       # Delete local images
```

### 🧪 Parameter Help

```makefile
make help-parameters
```

Outputs:

```
VERSION     - The version of the image to build (e.g., 1.0.0)
GIT_SHA     - Short Git SHA (auto-detected)
LOCAL_TAG   - Local image tag for testing
PROD_TAG    - Production tag
VERSION_TAG - Version tag (X.Y.Z)
SHA_TAG     - Git SHA tag
```

> `VERSION` is required for targets that tag or push. Not needed for `logs`, `up`, `down`, or `shell`.

---

## 👥 Contributors

- Owner: [Punctiq DevOps Team]
- Maintainers: [@lingeek, others TBD]

---

## 📄 License

[MIT](./LICENSE)