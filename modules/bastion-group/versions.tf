terraform {
  required_version = ">=0.13"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 3.53, < 5.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">= 3.53, < 5.0"
    }
    random = {
      source = "hashicorp/random"
    }
  }
  provider_meta "google" {
    module_name = "blueprints/terraform/terraform-google-bastion-host:bastion-group/v5.3.0"
  }
}
