# Terraform Proxmox Linux Template Module

This Terraform module automates the creation of Linux VM templates on Proxmox Virtual Environment (PVE).  It downloads cloud images, uploads a shared cloud-init configuration, and creates VM templates directly within your Proxmox environment.

## Features

*   **Automated Template Creation:** Simplifies the process of creating multiple Linux VM templates.
*   **Cloud-Init Configuration:** Uses `cloud-init` for initial VM configuration, including setting the root password, adding SSH keys, and installing necessary packages.
*   **Modular Design:** Uses Terraform modules for better organization and reusability.
*   **Dynamic Image Downloading:** Downloads Linux cloud images directly from specified URLs.
*   **Shared Cloud-Init:** Uploads a single cloud-init configuration to a Proxmox storage, reducing redundancy.

## Prerequisites

*   **Proxmox VE Installation:**  A working Proxmox VE installation.
*   **Proxmox API Token:** A Proxmox API token with sufficient permissions to create VMs, download images, and upload files.  It's recommended to use a dedicated token for Terraform.
*   **Terraform:** Terraform version >= 1.9.0.
*   **SSH Keypair:** An SSH keypair for accessing the created VMs (typically `~/.ssh/id_rsa` and `~/.ssh/id_rsa.pub`).
*   **'snippets' datastore:** A storage pool named snippets

## Usage

1.  **Clone the Repository:**

    ```bash
    git clone <repository_url>
    cd <repository_directory>
    ```

2.  **Configure Variables:**

    Create a `terraform.tfvars` file (or use environment variables) and set the following variables:

    ```terraform
    proxmox_endpoint = "https://your-proxmox-url:8006/api2/json"
    proxmox_token_id = "terraform@pve!provider=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
    node             = "your_proxmox_node"
    storage_pool     = "your_storage_pool"
    root_password    = "your_secure_password"

    linux_images = {
      "ubuntu-22.04-minimal.img" = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
      "rocky-9-minimal.img"      = "https://dl.rockylinux.org/vault/rocky/9.5/images/x86_64/Rocky-9-GenericCloud-Base.latest.x86_64.qcow2"
    }
    ```

    **Important:**  Do not store sensitive information like passwords and API tokens directly in your Terraform code.  Use environment variables or a secrets management solution instead.

3.  **Initialize Terraform:**

    ```bash
    terraform init
    ```

4.  **Plan and Apply:**

    ```bash
    terraform plan
    terraform apply
    ```

*   `main.tf`: The main Terraform file that calls the `linux-template` module.
*   `modules/linux-template`: Contains the module definition for creating the Linux VM templates.
    *   `cloud-init.yaml`: The cloud-init configuration file.
    *   `main.tf`:  The module's main Terraform file.
    *   `provider.tf`:  Defines the Proxmox provider configuration for the module.
    *   `variable.tf`: Defines the input variables for the module.
*   `terraform.tfvars`:  (Optional) A file to store variable values.  **Use environment variables for sensitive data instead of storing it in this file.**
*   `variable.tf`: Defines the input variables for the root module.

## Customization

*   **Cloud-Init:**  Modify the `modules/linux-template/cloud-init.yaml` file to customize the initial VM configuration.
*   **VM Defaults:** Change the default VM settings (CPU, memory, disk size, network) by modifying the `vm_defaults` variable in `variable.tf` or overriding them in your `terraform.tfvars` file.
*   **Linux Images:**  Add or remove Linux images by modifying the `linux_images` variable.
