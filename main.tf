
module "linux_templates" {
  source        = "./modules/linux-template"
  node          = var.node
  linux_images  = var.linux_images
  storage_pool  = var.storage_pool
  root_password = var.root_password
}
