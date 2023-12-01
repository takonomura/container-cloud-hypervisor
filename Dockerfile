FROM docker.io/library/alpine:3.18.5@sha256:34871e7290500828b39e22294660bee86d966bc0017544e848dd9a255cdf59e0 AS download

RUN apk add --no-cache curl

ARG FIRMWARE_VERSION=0.4.2
RUN curl -sSLO https://github.com/cloud-hypervisor/rust-hypervisor-firmware/releases/download/${FIRMWARE_VERSION}/hypervisor-fw

ARG CLOUD_HYPERVISOR_VERSION=v36.0
RUN curl -sSLo cloud-hypervisor https://github.com/cloud-hypervisor/cloud-hypervisor/releases/download/${CLOUD_HYPERVISOR_VERSION}/cloud-hypervisor-static && chmod +x cloud-hypervisor
RUN curl -sSLo ch-remote https://github.com/cloud-hypervisor/cloud-hypervisor/releases/download/${CLOUD_HYPERVISOR_VERSION}/ch-remote-static && chmod +x ch-remote

FROM docker.io/library/alpine:3.18.5@sha256:34871e7290500828b39e22294660bee86d966bc0017544e848dd9a255cdf59e0

RUN apk add --no-cache iproute2

COPY init.sh /
COPY --from=download /hypervisor-fw /
COPY --from=download /cloud-hypervisor /ch-remote /usr/local/bin/

ENTRYPOINT ["/init.sh"]
