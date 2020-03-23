# BPF Enabled Openshift Image

[Quay Image Tags](https://quay.io/repository/ryan_phillips/ocp4-bpf?tab=tags)

Runs a BPF enabled image on openshift.

Note: The image is dependent on the kernel running on the node.

```
podman run --rm --privileged \
  -v /sys/kernel:/sys/kernel \
  -v /lib/modules:/lib/modules -ti \
  quay.io/ryan_phillips/ocp4-bpf:4.18.0-147.5.1.el8_1.x86_64
```
