# Ansible proxmox automation

## Prerequisites

- ensure inventory.yml contains your pve host
- add your rsa key to `./keys`
- add your rsa pubkey to `./roles/ansible_user/tasks/main.yml`
- ensure that your `proxmox_k8s_pool_storage_nvme_disk_name: nvme0n1` nvme drive is correct in `./vars/proxmox`
- fix ssh key in `roles/proxmox_config/files/user-data.yaml`
