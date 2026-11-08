# syntax=docker/dockerfile:1

# glibc base: native plugins are Go c-shared libraries built for glibc, which musl cannot dlopen.
FROM ghcr.io/linuxserver/baseimage-ubuntu:resolute

# set version label
ARG BUILD_DATE
ARG VERSION
ARG CLIPROXY_RELEASE
ARG TARGETARCH
LABEL build_version="docker-cliproxy version:- ${VERSION} Build-date:- ${BUILD_DATE}"

# environment settings
ENV HOME="/data"

RUN \
  echo "**** install cliproxy ****" && \
  if [ -z ${CLIPROXY_RELEASE+x} ]; then \
    CLIPROXY_RELEASE=$(curl -sX GET "https://api.github.com/repos/vayungodara/cliproxy-rs/releases/latest" \
    | jq -r '.tag_name'); \
  fi && \
  case "${TARGETARCH}" in \
    amd64) TRIPLE=x86_64-unknown-linux-gnu ;; \
    arm64) TRIPLE=aarch64-unknown-linux-gnu ;; \
    *) echo "unsupported arch: ${TARGETARCH}" && exit 1 ;; \
  esac && \
  NAME="cliproxy-${CLIPROXY_RELEASE#v}-${TRIPLE}" && \
  URL="https://github.com/vayungodara/cliproxy-rs/releases/download/${CLIPROXY_RELEASE}" && \
  mkdir -p /tmp/cliproxy && \
  cd /tmp/cliproxy && \
  curl -fsSLO "${URL}/${NAME}.tar.gz" && \
  curl -fsSLO "${URL}/SHA256SUMS" && \
  grep " ${NAME}.tar.gz$" SHA256SUMS | sha256sum -c - && \
  tar xf "${NAME}.tar.gz" && \
  install -m 0755 "${NAME}/cliproxy" /usr/local/bin/cliproxy && \
  printf "docker-cliproxy version: ${VERSION}\nBuild-date: ${BUILD_DATE}" > /build_version && \
  echo "**** cleanup ****" && \
  rm -rf \
    /tmp/*

# copy local files
COPY root/ /

# ports and volumes
EXPOSE 8317
VOLUME /data
