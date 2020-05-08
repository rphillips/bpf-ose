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

daemonset to run syncsnoop on nodes:

```
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: bpf-sync-ds
  labels:
    k8s-app: bpf-sync-ds
spec:
  selector:
    matchLabels:
      name: bpf-sync-ds
  template:
    metadata:
      labels:
        name: bpf-sync-ds
    spec:
      containers:
      - name: bpf-sync-ds
        securityContext:
          privileged: true
        image: quay.io/ryan_phillips/ocp4-bpf:4.18.0-147.8.1.el8_1.x86_64
        command: ['/usr/bin/bpftrace']
        args: ['/scripts/syncsnoop.bt']
        volumeMounts:
        - name: syskernel
          mountPath: /sys/kernel
        - name: libmodules
          mountPath: /lib/modules
      terminationGracePeriodSeconds: 30
      volumes:
      - name: syskernel
        hostPath:
          path: /sys/kernel
      - name: libmodules
        hostPath:
          path: /lib/modules
```
