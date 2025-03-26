variable "node" {
  type        = string
  description = "Proxmox host to deploy templetes"
}
variable "storage_pool" {
  type        = string
  description = "target storage pool"
}
variable "linux_images" {
  type        = map(string)
  description = "Linux cloud Images"
}

variable "root_password" {
  description = "Plaintext root password"
  type        = string
  sensitive   = true
}

variable "vm_defaults" {
  description = "Default VM settings"
  type = object({
    cpu     = number
    memory  = number
    disk    = number
    network = string
    tags    = list(string)
  })
  default = {
    cpu     = 2
    memory  = 2048
    network = "vmbr0"
    disk    = 30
    tags    = ["terraform-managed", "Template"]
  }

}

