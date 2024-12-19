# Declare the required providers
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.14.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  subscription_id                 = var.AZURE_SUBSCRIPTION_ID
  resource_provider_registrations = "none"
  features {}
}
