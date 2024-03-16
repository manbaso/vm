variable "resource_group_name" {
  default = "vm"
}

variable "location" {
  default = "East US"
}

variable "num_count" {
  default = "1"
}

variable "vm_name" {
  default = "vm"
}

variable "vm_size" {
  default = "Standard_DS1_v2"
}

variable "admin_username" {
  default = "adminuser"
}

variable "admin_password" {
  default = "AdminPassword123!"  # Update with your desired password
}

variable "os_disk_name" {
  default = "myOSDisk"
}

variable "network_interface_name" {
  default = "myNIC"
}

variable "subnet_id" {
  default = "/subscriptions/subscription_id/resourceGroups/myResourceGroup/providers/Microsoft.Network/virtualNetworks/myVNet/subnets/mySubnet"
}

variable "image_publisher" {
  default = "Canonical"
}

variable "image_offer" {
  default = "UbuntuServer"
}

variable "image_sku" {
  default = "22_04-lts"
}
