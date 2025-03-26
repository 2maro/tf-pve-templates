variable "proxmox_endpoint" {
  type        = string
  description = "The endpoint for the proxmox API (http://your-proxmox-url:8006)"
}

variable "proxmox_token_id" {
  type        = string
  description = "terraform@pve!provider=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  sensitive   = true
}
variable "storage_pool" {
  type        = string
  description = "Your disk location"
}

variable "linux_images" {
  type        = map(string)
  description = "Linux cloud Images"
}

variable "node" {
  type        = string
  description = "Proxmox host to deploy templates"
}

variable "root_password" {
  description = "Plaintext root password"
  type        = string
  sensitive   = true
}
