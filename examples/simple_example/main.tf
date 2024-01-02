provider "google" {
  project = "local-concord-408802"
  region  = "us-west1"
  zone    = "us-west1-a"
}

####==============================================================================
#### vpc module call.
####==============================================================================
module "vpc" {
  source                                    = "git::https://github.com/cypik/terraform-gcp-vpc.git?ref=v1.0.0"
  name                                      = "app"
  environment                               = "test"
  network_firewall_policy_enforcement_order = "AFTER_CLASSIC_FIREWALL"
}

####==============================================================================
#### subnet module call.
####==============================================================================
module "subnet" {
  source        = "git::https://github.com/cypik/terraform-gcp-subnet.git?ref=v1.0.0"
  subnet_names  = ["subnet-a"]
  gcp_region    = "us-west1"
  network       = module.vpc.vpc_id
  ip_cidr_range = ["10.10.1.0/24"]
}

####==============================================================================
#### firewall module call.
####==============================================================================
module "firewall" {
  source        = "git::https://github.com/cypik/terraform-gcp-firewall.git?ref=v1.0.0"
  name          = "app"
  environment   = "test"
  network       = module.vpc.vpc_id
  source_ranges = ["0.0.0.0/0"]

  allow = [
    { protocol = "tcp"
      ports    = ["22", "80"]
    }
  ]
}

######==============================================================================
###### iap_bastion module call.
######==============================================================================
module "iap_bastion" {
  source      = "../../"
  name        = "test"
  environment = "iap-bastion"
  zone        = "us-west1-a"
  network     = module.vpc.self_link
  subnet      = module.subnet.subnet_self_link
  members     = []
}
