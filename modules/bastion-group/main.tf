module "labels" {
  source      = "git::git@github.com:opz0/terraform-gcp-labels.git?ref=master"
  name        = var.name
  environment = var.environment
  label_order = var.label_order
  managedby   = var.managedby
  repository  = var.repository
}

data "google_client_config" "current" {
}


module "mig" {
  source              = "git@github.com:opz0/terraform-gcp-instance-group.git"
  project_id          = data.google_client_config.current.project
  region              = var.region
  target_size         = var.target_size
  hostname            = format("%s", module.labels.id)
  health_check        = var.health_check
  autoscaling_enabled = var.autoscaling_enabled
  min_replicas        = var.min_replicas
  instance_template   = module.instance_template.instance_template
}

#####==============================================================================
##### instance_template module call.
#####==============================================================================
module "instance_template" {
  source                             = "../../"
  name                               = format("%s", module.labels.id)
  region                             = var.region
  image_family                       = var.image_family
  image_project                      = var.image_project
  subnet                             = var.subnet
  network                            = var.network
  access_config                      = var.enable_public_ip ? var.access_config : []
  labels                             = var.labels
  members                            = var.members
  service_account_name               = var.service_account_name
  service_account_email              = var.service_account_email
  service_account_roles              = var.service_account_roles
  service_account_roles_supplemental = var.service_account_roles_supplemental
  zone                               = var.zone
  random_role_id                     = var.random_role_id
  create_instance_from_template      = false
}

#####==============================================================================
##### firewall module call.
#####==============================================================================
module "firewall" {
  source        = "git::git@github.com:opz0/terraform-gcp-firewall.git?ref=master"
  name          = format("%s-", module.labels.id)
  environment   = "test"
  project_id    = data.google_client_config.current.project
  network       = var.network
  source_ranges = ["0.0.0.0/0"]

  allow = [
    { protocol = "tcp"
      ports    = ["22", "80"]
    }
  ]
}