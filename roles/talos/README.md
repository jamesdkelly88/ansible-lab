# Talos Bootstrap Role

This role requires the Kubernetes cluster config to be defined in Netbox in the `Config Context` field (as JSON), using the following format:

```json
{
    "cluster": "alpha",
    "install_disk": "sda",
    "volume_disk": "sdb"
}
```

To identify the disks, use the command `talosctl -n <ip> get disks --insecure` when the host is in maintenance mode


## Steps

- Get configuration from Netbox
- Generate controlplane patch
- Generate controlplane and talosconfig
- Apply config
- Bootstrap cluster
- Get kubeconfig
- Wait for node to be ready
- Backup configs in Bitwarden Secrets Manager
- Run terraform to configure cluster
