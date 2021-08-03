FROM fedora:34 as builder

ENV BCC_VERSION_TAG=v0.21.0

RUN set -ex; \
    dnf update -y && \
    dnf groupinstall -y "Development Tools" && \
    dnf install -y pkg-config clang llvm libcap-devel elfutils-libelf-devel git && \
    git clone https://github.com/iovisor/bcc/ -b ${BCC_VERSION_TAG} --recurse-submodules && \
    cd bcc/libbpf-tools/ && \
    make && mkdir /libbpf-tools && DESTDIR=/libbpf-tools prefix="" make install

FROM fedora:34
RUN set -ex; \
    dnf update -y && dnf install -y elfutils-libelf-devel && dnf clean packages
COPY --from=builder /libbpf-tools/bin /usr/bin
