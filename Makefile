DOCKER ?= docker
REPO ?= quay.io/ryan_phillips/ocp4-bpf
KERNEL_VER ?= 4.18.0-147.8.1.el8_1.x86_64

.PHONY: build
build:
	${DOCKER} build -t ${REPO}:${KERNEL_VER} .
	${DOCKER} push ${REPO}:${KERNEL_VER}
