FROM docker.io/library/alpine:3.24.4@sha256:f59abe656b692d901e184be3445e084786602108599d2a51d229c0f5a48c71bf AS download

RUN apk add --no-cache curl

ARG FIRMWARE_VERSION=0.5.0
RUN curl -sSLO https://github.com/cloud-hypervisor/rust-hypervisor-firmware/releases/download/${FIRMWARE_VERSION}/hypervisor-fw

ARG CLOUD_HYPERVISOR_VERSION=v54.0
RUN curl -sSLo cloud-hypervisor https://github.com/cloud-hypervisor/cloud-hypervisor/releases/download/${CLOUD_HYPERVISOR_VERSION}/cloud-hypervisor-static && chmod +x cloud-hypervisor
RUN curl -sSLo ch-remote https://github.com/cloud-hypervisor/cloud-hypervisor/releases/download/${CLOUD_HYPERVISOR_VERSION}/ch-remote-static && chmod +x ch-remote

FROM docker.io/library/alpine:3.24.4@sha256:f59abe656b692d901e184be3445e084786602108599d2a51d229c0f5a48c71bf

RUN apk add --no-cache iproute2

COPY init.sh /
COPY --from=download /hypervisor-fw /
COPY --from=download /cloud-hypervisor /ch-remote /usr/local/bin/

ENTRYPOINT ["/init.sh"]
