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
docker build -t punctiq/haproxy:1.0.0 .
```

### Run with Docker Compose
```bash
docker-compose up -d
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

## 👥 Contributors

- Owner: [Punctiq DevOps Team]
- Maintainers: [@lingeek, others TBD]

---

## 📄 License

[MIT](./LICENSE)