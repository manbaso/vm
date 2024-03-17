terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.94.0"
    }
  }
}

provider "azurerm" {
  skip_provider_registration = true # This is only required when the User, Service Principal, or Identity running Terraform lacks the permissions to register Azure Resource Providers.
  features {}
  client_id       = secrets.AZURE_CLIENT_ID
  client_secret   = secrets.AZURE_CLIENT_SECRET

  tenant_id       = secrets.AZURE_TENANT_ID
  subscription_id = secrets.AZURE_SUBSCRIPTION_ID

}
