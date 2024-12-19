# Terraform 101

This project is for learning how to build infrastructure using Terraform. In this case, a virtual machine will be created in Azure with an IIS installed.

## Introduction

Terraform is an Infrastructure-as-Code (IaC) tool created and maintained by HashiCorp that allows you to create cloud or on-premise resources with code, such as servers, databases, storage, and networks. This tool is declarative, so when the tool runs, what is written as code will be the final state of the resources, regardless of any manual changes made before via the portal or CLI.

## HCL

Terraform uses its own language called `HCL` (HashiCorp Configuration Language), which uses blocks for creating configurations and resources.

This code must be saved as `.tf` files. It is important to know that it is not necessary for the code to be written in the same file. It is possible to separate it into different files with any name, allowing you to group common resources in those files.

The two main blocks needed for using Terraform are:

- `terraform`: For declaring providers to use.
- `provider`: For configuring the provider declared before.

Example:

```hcl
# Declare AWS Provider and version
terraform {
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~> 5.0"
        }
    }
}

# Configure the AWS Provider
provider "aws" {
    region = "us-east-1"
}
```

## Providers

Providers are Terraform components for communicating with APIs to create resources, whether cloud or on-premise. There are 3 types:

- Official: Providers maintained by HashiCorp.
- Partner: Maintained by important companies.
- Community: Maintained by the community. Sometimes these can be unstable or insecure to use.

## Modules

Modules are like "packages" of Terraform code that allow you to reuse configurations for other projects.

For example, if there is often a need to create a basic group of resources on the cloud such as a VM connected to the internet, a security group, a load balancer, etc., it may be better to create a module and reuse it every time.

So, instead of creating every resource individually, you can call the module, and this package will create everything necessary to make it work correctly.

## Registry

HashiCorp has a place for saving any kind of resources as modules, providers, libraries and documentation. Here's the [link](https://registry.terraform.io/).

It is recommended to read the provider documentation and follow recommendations for creating resources before starting a project.

## State file

The state is a text file for tracking all the resources created by the Terraform project. By default, this file is saved on the local machine, but it is possible to store it in the cloud and share resources, such as a Storage Account or S3. This way, a team can collaborate on the same project using the same state. Another important aspect of this method is the ability to keep backups of the file.

This place for saving the state on an external source is called a "backend". To configure it, you need to set it up in the `terraform` block as shown below:

```hcl
# Configure an AWS S3 bucket as backend
terraform {
    backend "s3" {
        bucket = "mybucket"
        key    = "path/to/my/key"
        region = "us-east-1"
    }
}
```

## Architecture

The way Terraform works is:

- Write the code for connecting to a provider and create resources on a `.tf` text file.
- **(optional)** Select on the code or the `apply` command where to save the state. By default, it will be saved in the local folder.
- Run Terraform commands to apply changes.
- Terraform will compare the code with the current state of the resources and will apply changes to make the resources exactly as the code specifies.
- Modified code and run Terraform again to apply changes.

![Architecture Diagram](docs/architecture.png)

## Installation

Depending on the OS used, there are [different ways](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) to install Terraform.

## Main Commands

- `terraform init`: Set up the backend and download necessary packages.
- `terraform validate`: Validate Terraform syntax.
- `terraform plan`: Preview the changes Terraform will make.
- `terraform apply`: Apply the planned changes.
- `terraform destroy`: Destroy all resources created by Terraform.

## Laboratory

This laboratory aims to create a Windows server with IIS installed using Terraform.

There are four important files for this:

- `provider.tf`: Configuration for connecting to Azure.
- `iis.tf`: Resources for creating the VM and necessary components.
- `variables.tf`: Variables used by Terraform (only for subscription ID).
- `outputs.tf`: Display the outputs (only server public IP).

### Prerequisites

- Azure account and subscription.
- Tenant and subscription IDs.
- Azure CLI installed.
- Terraform installed.

### Steps

#### Azure CLI

First, configure the Azure CLI.

```bash
az login
# If you have more than one tenant, use: az login --tenant "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"
az account set --subscription="XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"
```

#### Terraform Project

Now, run the Terraform commands.

```bash
export TF_VAR_AZURE_SUBSCRIPTION_ID="XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"
terraform init
```

Expected result: `Terraform has been successfully initialized!`

```bash
terraform validate
```

Expected result: `Success! The configuration is valid.`

```bash
terraform plan
```

Expected result: `Plan: 9 to add, 0 to change, 0 to destroy.`

```bash
terraform apply
```

Expected result: `Enter a value:`. Type `yes` and press `enter`.

Wait for the process to complete. Once finished, you should see:

```
Apply complete! Resources: 9 added, 0 changed, 0 destroyed.

Outputs:
public_ip_address = "20.XXX.XXX.XXX"
```

Now, you have the public IP and can access the web server:
![IIS Server](docs/iis.png)
