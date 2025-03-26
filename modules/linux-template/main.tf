
# 1. Download each Linux image
resource "proxmox_virtual_environment_download_file" "linux_images" {
  for_each       = var.linux_images
  node_name      = var.node
  file_name      = each.key
  url            = each.value
  content_type   = "iso"
  datastore_id   = "local"
  upload_timeout = 900
  verify         = false
  overwrite      = true
}

# 2. Upload ONE shared cloud-init config to 'snippets' storage
resource "proxmox_virtual_environment_file" "cloud_init_config" {
  content_type = "snippets"
  datastore_id = "snippets"
  node_name    = var.node
  source_raw {
    data = templatefile("${path.module}/cloud-init.yaml", {
      root_hashed_password = bcrypt(var.root_password)
      ssh_public_key       = chomp(file(pathexpand("~/.ssh/id_rsa.pub")))
    })
    file_name = "shared-cloud-init.yaml"
  }
}

# 3. Create VM templates directly
resource "proxmox_virtual_environment_vm" "linux_templates" {
  for_each  = var.linux_images
  name      = "${each.key}-template"
  node_name = var.node
  template  = true
  tags      = var.vm_defaults.tags
  machine   = "q35"
  bios      = "ovmf"

  depends_on = [
    proxmox_virtual_environment_download_file.linux_images,
    proxmox_virtual_environment_file.cloud_init_config
  ]

  efi_disk {
    datastore_id = var.storage_pool
    file_format  = "raw"
    type         = "4m"
  }

  agent {
    enabled = true
  }

  operating_system {
    type = "l26"
  }

  cpu {
    cores   = var.vm_defaults.cpu
    sockets = 1
    type    = "host"
    numa    = true
  }

  memory {
    dedicated = var.vm_defaults.memory
    floating  = 0
  }

  network_device {
    model  = "virtio"
    bridge = var.vm_defaults.network
  }

  disk {
    datastore_id = var.storage_pool
    file_id      = proxmox_virtual_environment_download_file.linux_images[each.key].id
    interface    = "scsi0"
    file_format  = "raw"
    discard      = "on"
    size         = var.vm_defaults.disk
  }

  initialization {
    datastore_id      = var.storage_pool
    user_data_file_id = proxmox_virtual_environment_file.cloud_init_config.id
    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }
  }

  lifecycle {
    ignore_changes = [initialization]
  }
}
