# terraform-gcp-bastion-host
# Google Cloud Infrastructure Provisioning with Terraform
## Table of Contents

- [Introduction](#introduction)
- [Usage](#usage)
- [Module Inputs](#module-inputs)
- [Module Outputs](#module-outputs)
- [License](#license)

## Introduction
This project deploys a Google Cloud infrastructure using Terraform to create bastion-host .
## Usage
To use this module, you should have Terraform installed and configured for GCP. This module provides the necessary Terraform configuration for creating GCP resources, and you can customize the inputs as needed. Below is an example of how to use this module:
## Examples
# Example: bastion-group
```hcl
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
```
# Example: iap-tunneling

```hcl
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
```
# Example: simple-example

```hcl
module "iap_bastion" {
  source      = "git::https://github.com/opz0/terraform-gcp-bastion-host.git?ref=v1.0.0"
  name        = "test"
  environment = "iap-bastion"
  zone        = "us-west1-a"
  network     = module.vpc.self_link
  subnet      = module.subnet.subnet_self_link
  members     = []
}
```

This example demonstrates how to create various GCP resources using the provided modules. Adjust the input values to suit your specific requirements.

## Module Inputs

- 'name'  : The name of the service account.
- 'environment': The environment type.
- 'project_id' : The GCP project ID.
- 'region': A reference to the region where the regional forwarding rule resides.
- 'subnet': The name or self_link of the subnetwork to attach this interface to.
- 'network' : This field is not used for external load balancing.
- 'target_size' : The target number of running instances for this managed instance group.
- 'enable_public_ip' : instance public ip "true" .
- 'zone' : The zone that the machine should be created in.
- 'service_accounts' : The service account to attach to the instance.
- 'instances' : A VM instance resource within GCE.

## Module Outputs
Each module may have specific outputs. You can retrieve these outputs by referencing the module in your Terraform configuration.

- 'id' : id of the iap tunnel instsnce iam binding.
- 'ip_address' : IP address for which this forwarding rule accepts traffic.
- 'self_link': Self link of the bastion host
- 'instance_group' : Self link of the bastion instance template for use with a MIG.
- 'service_account': The email for the service account created for the bastion host.
- 'members': members of the iap tunnel instsnce iam binding.
- 'etag' : etag of the iap tunnel instsnce iam binding.
- 'instance_template' :  Self link of the bastion instance template for use with a MIG.

## Examples
For detailed examples on how to use this module, please refer to the 'examples' directory within this repository.

## Author
Your Name Replace '[License Name]' and '[Your Name]' with the appropriate license and your information. Feel free to expand this README with additional details or usage instructions as needed for your specific use case.

## License
This project is licensed under the MIT License - see the [LICENSE](https://github.com/opz0/terraform-gcp-bastion-host/blob/readme/LICENSE) file for details.
