ARG UPSTREAM_IMAGE=library/caddy
ARG TAG=2-builder-alpine

FROM ${UPSTREAM_IMAGE}:${TAG} AS builder

RUN xcaddy build \
    --with github.com/caddy-dns/cloudflare \
    --with github.com/lucaslorentz/caddy-docker-proxy/v2 \
    --with github.com/abiosoft/caddy-yaml

FROM scratch

COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /usr/bin/caddy /bin/

EXPOSE 80 443 2019

ENV XDG_CONFIG_HOME=/config
ENV XDG_DATA_HOME=/data

WORKDIR /

ENTRYPOINT ["/bin/caddy"]

CMD ["docker-proxy"]
