FROM fedora:34 as builder

RUN set -ex;     dnf update -y && dnf groupinstall -y "Development Tools" &&  dnf install -y pkg-config clang llvm libcap-devel elfutils-libelf-devel git && git clone https://github.com/iovisor/bcc/ -b v0.19.0 --recurse-submodules &&     cd bcc/libbpf-tools/ &&     make && mkdir /libbpf-tools && DESTDIR=/libbpf-tools prefix="" make install

FROM fedora:34
RUN set -ex;     dnf update -y && dnf install -y elfutils-libelf-devel
COPY --from=builder /libbpf-tools/bin /usr/bin
