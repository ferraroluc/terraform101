# Terraform 101

This project is for learning how to build infrastructure using Terraform. In this case, a virtual machine will be created in Azure with an IIS server and a "Hello World" page.

## Introduction

Terraform is an Infrastructure-as-Code (IaC) tool created and maintained by HashiCorp that allows you to create cloud or on-premise resources with code, such as servers, databases, storage, and networks. This tool is declarative, so when the tool runs, what is written as code will be the final state of the resources, regardless of any manual changes made before via the portal or CLI.

## HCL

Terraform uses its own language called `HCL` (HashiCorp Configuration Language), which uses blocks for creating configurations and resources.

This code must be saved as `.tf` files. It is important to know that it is not necessary for the code to be written in the same file. It is possible to separate it into different files with any name, allowing you to group common resources in those files.

The two main blocks needed for using Terraform are:

- `terraform`: for declaring providers to use.
- `provider`: for configuring the provider declared before.

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

- Official: providers maintained by HashiCorp.
- Partner: maintained by important companies.
- Community: maintained by the community. Sometimes these can be unstable or insecure to use.

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

## Main commands

- `terraform validate`: validate Terraform syntax.
- `terraform plan`: plan what Terraform is going to create, modify, or delete.
- `terraform apply`: apply the plan.
- `terraform destroy`: destroy every resource created by Terraform.

## Laboratory
