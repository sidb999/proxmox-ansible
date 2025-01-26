# Ansible proxmox automation

## Prerequisites

- run `ansible-galaxy collection install community.routeros`
- ensure inventory.yml contains your pve host
- add your rsa key to `./keys`
- add your rsa pubkey to `./roles/ansible_user/tasks/main.yml`
- ensure that your `proxmox_k8s_pool_storage_nvme_disk_name: nvme0n1` nvme drive is correct in `./vars/proxmox`
- fix ssh key in `roles/proxmox_config/files/user-data.yaml`
- set your `proxmox_clusterapi_clusterctl_config_path` in `vars/proxmox.yml`
