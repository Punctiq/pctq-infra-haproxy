FROM ubuntu:22.04

LABEL maintainer="support@punctiq.com" \
      org.opencontainers.image.title="Punctiq HAProxy" \
      org.opencontainers.image.version="1.0.0" \
      org.opencontainers.image.description="Custom HAProxy container with Ubuntu base, user isolation, healthcheck and strict perms" \
      org.opencontainers.image.source="https://punctiq.com" \
      org.opencontainers.image.version="1.0.0" \
      org.opencontainers.image.licenses="MIT" \
      org.opencontainers.image.documentation="https://public-doc.punctiq.com/"

ENV DEBIAN_FRONTEND=noninteractive

# Creăm un user dedicat (non-root) pentru rulare
RUN useradd -r -s /sbin/nologin haproxy && \
    mkdir -p /etc/haproxy && \
    chown -R haproxy:haproxy /etc/haproxy

# Instalăm HAProxy și utilitare minime
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        haproxy curl vim net-tools ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Volume declarat pentru persistenta configurației
VOLUME ["/etc/haproxy"]

# Schimbăm userul cu care rulează containerul
USER haproxy

# Expunem porturile pentru HTTP și HTTPS
EXPOSE 80 443

# Healthcheck: verifică dacă HAProxy rulează și răspunde
HEALTHCHECK --interval=30s --timeout=5s --retries=3 CMD curl -sf http://localhost || exit 1

# Comanda implicită la pornire
CMD ["haproxy", "-f", "/etc/haproxy/haproxy.cfg"]
