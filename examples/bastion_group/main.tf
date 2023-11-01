provider "google" {
  project = "opz0-xxxxxx"
  region  = "us-west1"
  zone    = "us-west1-a"
}

######==============================================================================
###### vpc module call.
######==============================================================================
module "vpc" {
  source                                    = "git::git@github.com:opz0/terraform-gcp-vpc.git?ref=master"
  name                                      = "app"
  environment                               = "test"
  label_order                               = ["name", "environment"]
  network_firewall_policy_enforcement_order = "AFTER_CLASSIC_FIREWALL"
}

######==============================================================================
###### subnet module call.
######==============================================================================
module "subnet" {
  source        = "git::git@github.com:opz0/terraform-gcp-subnet.git?ref=master"
  name          = "subnet"
  environment   = "test"
  gcp_region    = "us-west1"
  network       = module.vpc.vpc_id
  source_ranges = ["10.10.0.0/16"]
}

####==============================================================================
#### firewall module call.
####==============================================================================
module "firewall" {
  source        = "git::git@github.com:opz0/terraform-gcp-firewall.git?ref=master"
  name          = "app11"
  environment   = "test"
  network       = module.vpc.self_link
  source_ranges = ["0.0.0.0/0"]

  allow = [
    {
      protocol = "tcp"
      ports    = ["22"]
    }
  ]
}

######==============================================================================
###### iap_bastion_group module call.
######==============================================================================
module "iap_bastion_group" {
  source      = "../../modules/bastion-group"
  name        = "test"
  environment = "bastion"
  region      = "us-west1"
  zone        = "us-west1-a"
  network     = module.vpc.self_link
  subnet      = module.subnet.subnet_self_link
  members     = []
  target_size = 1

  ######### public_ip
  enable_public_ip = true
  access_config = [{
    nat_ip       = ""
    network_tier = "PREMIUM"
  }, ]
}