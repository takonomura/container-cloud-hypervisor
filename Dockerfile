FROM docker.io/library/alpine:3.23.4@sha256:5b10f432ef3da1b8d4c7eb6c487f2f5a8f096bc91145e68878dd4a5019afde11 AS download

RUN apk add --no-cache curl

ARG FIRMWARE_VERSION=0.5.0
RUN curl -sSLO https://github.com/cloud-hypervisor/rust-hypervisor-firmware/releases/download/${FIRMWARE_VERSION}/hypervisor-fw

ARG CLOUD_HYPERVISOR_VERSION=v51.1
RUN curl -sSLo cloud-hypervisor https://github.com/cloud-hypervisor/cloud-hypervisor/releases/download/${CLOUD_HYPERVISOR_VERSION}/cloud-hypervisor-static && chmod +x cloud-hypervisor
RUN curl -sSLo ch-remote https://github.com/cloud-hypervisor/cloud-hypervisor/releases/download/${CLOUD_HYPERVISOR_VERSION}/ch-remote-static && chmod +x ch-remote

FROM docker.io/library/alpine:3.23.4@sha256:5b10f432ef3da1b8d4c7eb6c487f2f5a8f096bc91145e68878dd4a5019afde11

RUN apk add --no-cache iproute2

COPY init.sh /
COPY --from=download /hypervisor-fw /
COPY --from=download /cloud-hypervisor /ch-remote /usr/local/bin/

ENTRYPOINT ["/init.sh"]
