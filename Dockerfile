FROM ubuntu:22.04

LABEL maintainer="support@punctiq.com" \
      org.opencontainers.image.title="Punctiq HAProxy" \
      org.opencontainers.image.version="1.0.0" \
      org.opencontainers.image.description="Custom HAProxy container with Ubuntu base, user isolation, healthcheck and strict perms" \
      org.opencontainers.image.source="https://punctiq.com" \
      org.opencontainers.image.licenses="MIT" \
      org.opencontainers.image.documentation="https://public-doc.punctiq.com/"

ENV DEBIAN_FRONTEND=noninteractive


RUN useradd -r -s /sbin/nologin haproxy && \
    mkdir -p /etc/haproxy /run/haproxy /var/lib/haproxy && \
    chown -R haproxy:haproxy /etc/haproxy /run/haproxy /var/lib/haproxy

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        haproxy curl vim net-tools ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*


VOLUME ["/etc/haproxy"]


USER haproxy


EXPOSE 80 443


HEALTHCHECK --interval=30s --timeout=5s --retries=3 CMD curl -sf http://localhost || exit 1


CMD ["haproxy", "-f", "/etc/haproxy/haproxy.cfg"]
