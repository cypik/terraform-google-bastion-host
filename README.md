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

# Example: iap_bastion

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
- 'subnet': The name or self_link of the subnetwork to attach this interface to.
- 'network' : This field is not used for external load balancing.
- 'zone' : The zone that the machine should be created in.

## Module Outputs
Each module may have specific outputs. You can retrieve these outputs by referencing the module in your Terraform configuration.

- 'hostname' : hostname of the iap bastion instsnce iam binding.
- 'ip_address' : IP address for which this forwarding rule accepts traffic.
- 'self_link': Self link of the bastion host
- 'service_account': The email for the service account created for the bastion host.
- 'members': members of the iap tunnel instsnce iam binding.
- 'instance_template' :  Self link of the bastion instance template for use with a MIG.

## Examples
For detailed examples on how to use this module, please refer to the 'examples' directory within this repository.

## Author
Your Name Replace '[License Name]' and '[Your Name]' with the appropriate license and your information. Feel free to expand this README with additional details or usage instructions as needed for your specific use case.

## License
This project is licensed under the MIT License - see the [LICENSE](https://github.com/opz0/terraform-gcp-bastion-host/blob/master/LICENSE) file for details.
