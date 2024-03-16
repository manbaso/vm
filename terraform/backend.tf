terraform {
  backend "azurerm" {
    storage_account_name = "ayeon"
    container_name       = "terra"
    key                  = "terraform.tfstate"
    resource_group_name  = "terraform"
  }
}
