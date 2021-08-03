DOCKER ?= docker
REPO ?= quay.io/ryan_phillips/ocp4-bpf
KERNEL_VER ?= latest

.PHONY: build
build:
	${DOCKER} build -t ${REPO}:${KERNEL_VER} .
	${DOCKER} push ${REPO}:${KERNEL_VER}
