# Terraform 101

This project is for learning to build infrastructure using Terraform. In this case, a virtual machine will be created in Azure with an IIS server and a Hello World page.

## Introduction

Terraform is an infrastructure-as-code (IaC) tool that allow to provided and manage cloud and on-premises resources in a declarative manner. By describing the infrastructure as code, Terraform compares the desired state in configuration files with the actual state of the resources, ensuring that and ensures they align, making infrastructure management predictable and efficient.

Key features of Terraform include:

State Management: Terraform keeps a record of your infrastructure's current state in a state file. This file acts as a single source of truth, allowing Terraform to track resource changes and determine necessary updates during deployments.
Providers: Terraform supports a wide range of cloud platforms, on-premises systems, and third-party services through its provider ecosystem. Each provider serves as a plugin, enabling Terraform to manage specific resource types across different environments.
Modules: Terraform promotes reusable and organized code through modules. These are containers for multiple resources that can be reused across different projects, ensuring consistency and simplifying complex configurations.
With its powerful features and broad ecosystem, Terraform has become a popular choice for automating infrastructure at scale.
