provider "google" {
  project = "opz0-397319"
  region  = "us-west1"
  zone    = "us-west1-a"
}

####==============================================================================
#### vpc module call.
####==============================================================================
module "vpc" {
  source                                    = "git::https://github.com/opz0/terraform-gcp-vpc.git?ref=v1.0.0"
  name                                      = "app"
  environment                               = "test"
  network_firewall_policy_enforcement_order = "AFTER_CLASSIC_FIREWALL"
}

####==============================================================================
#### subnet module call.
####==============================================================================
module "subnet" {
  source        = "git::https://github.com/opz0/terraform-gcp-subnet.git?ref=v1.0.0"
  name          = "app"
  environment   = "test"
  gcp_region    = "us-west1"
  network       = module.vpc.vpc_id
  ip_cidr_range = "10.10.0.0/16"
}

#####==============================================================================
##### service-account module call .
#####==============================================================================
module "service-account" {
  source           = "git::https://github.com/opz0/terraform-gcp-Service-account.git?ref=v1.0.0"
  name             = "app"
  environment      = "test"
  key_algorithm    = "KEY_ALG_RSA_2048"
  public_key_type  = "TYPE_X509_PEM_FILE"
  private_key_type = "TYPE_GOOGLE_CREDENTIALS_FILE"
  members          = []
}

#####==============================================================================
##### instance_template module call.
#####==============================================================================
module "instance_template" {
  source               = "git::https://github.com/opz0/terraform-gcp-template-instance.git?ref=v1.0.0"
  instance_template    = true
  name                 = "template"
  environment          = "test"
  region               = "us-west1"
  source_image         = "ubuntu-2204-jammy-v20230908"
  source_image_family  = "ubuntu-2204-lts"
  source_image_project = "ubuntu-os-cloud"
  subnetwork           = module.subnet.subnet_id
  service_account      = null
  metadata = {
    ssh-keys = <<EOF
      dev:ssh-rsa +j/FmgC27u/+/0YqTB2cIkD1+mwt2y+PDQMU= suresh@suresh
    EOF
  }
}

resource "google_compute_instance_from_template" "vm" {
  name                     = "example-instance"
  project                  = "opz0-397319"
  zone                     = "us-west1-a"
  source_instance_template = module.instance_template.self_link_unique
  network_interface {
    subnetwork = module.subnet.subnet_self_link
  }
}

resource "google_service_account_iam_binding" "sa_user" {
  service_account_id = module.service-account.account_id
  role               = "roles/iam.serviceAccountUser"
  members            = []
}

resource "google_project_iam_member" "os_login_bindings" {
  for_each = toset([])
  project  = "opz0-397319"
  role     = "roles/compute.osLogin"
  member   = each.key
}

#####==============================================================================
##### iap_tunneling module call.
#####==============================================================================
module "iap_tunneling" {
  source           = "../../modules/iap-tunneling"
  name             = "test"
  environment      = "iap-tunneling"
  network          = module.vpc.self_link
  members          = []
  service_accounts = [module.service-account.account_email]
  instances = [{
    name = google_compute_instance_from_template.vm.name
    zone = "us-west1-a"
  }]
}