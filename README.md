# BPF Enabled Openshift Image

[Quay Image Tags](https://quay.io/repository/ryan_phillips/ocp4-bpf?tab=tags)

Runs a BPF enabled image on openshift.

```
podman run --rm --privileged \
  -v /sys/kernel/debug:/sys/kernel/debug \
  -ti \
  quay.io/ryan_phillips/ocp4-bpf:latest
```

