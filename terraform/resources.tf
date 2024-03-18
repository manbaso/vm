# Create a resource group
resource "azurerm_resource_group" "vm" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "vm" {
  name                = "vm-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.vm.location
  resource_group_name = azurerm_resource_group.vm.name
}

resource "azurerm_subnet" "vm" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.vm.name
  virtual_network_name = azurerm_virtual_network.vm.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "vm" {
  #   count               = var.vm_count
  name                = "vm-public-ip"
  location            = azurerm_resource_group.vm.location
  resource_group_name = azurerm_resource_group.vm.name
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "vm" {
  count               = var.num_count
  name                = "vm-nic-${count.index}"
  location            = azurerm_resource_group.vm.location
  resource_group_name = azurerm_resource_group.vm.name

  ip_configuration {
    name                          = "vm-nic-ipconfig-${count.index}"
    subnet_id                     = azurerm_subnet.vm.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm.id
  }
}

# Create a virtual machine
resource "azurerm_linux_virtual_machine" "vm" {
  count               = var.num_count
  name                = "project-vm-${count.index + 1}"
  resource_group_name = azurerm_resource_group.vm.name
  location            = azurerm_resource_group.vm.location
  size                = "Standard_B1s"
  admin_username      = "adminuser"

  tags = { "env" : "Dev" }

  network_interface_ids = [azurerm_network_interface.vm[count.index].id]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("project.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = var.image_sku
    version   = "latest"
  }



}

resource "azurerm_virtual_machine_extension" "AzureMonitorLinuxAgent" {

  for_each = tomap({
    for s in azurerm_linux_virtual_machine.vm : s.name => s.id
  })

  virtual_machine_id = each.value

  name                       = "AzureMonitorLinuxAgent"
  publisher                  = "Microsoft.Azure.Monitor"
  type                       = "AzureMonitorLinuxAgent"
  type_handler_version       = "1.0"
  auto_upgrade_minor_version = "true"


}

# resource "azurerm_virtual_machine_extension" "custom_script" {

#   for_each = tomap({
#     for s in azurerm_linux_virtual_machine.vm : s.name => s.id
#   })

#   virtual_machine_id = each.value


#   name                 = "Docker"

#   publisher            = "Microsoft.Azure.Extensions"
#   type                 = "CustomScript"
#   type_handler_version = "2.0"
#   auto_upgrade_minor_version = true

#   settings = <<SETTINGS
#     {
#         "commandToExecute": "sh docker.sh",
#         "fileUris": ["https://raw.githubusercontent.com/manbaso/vm/main/terraform/extensions/docker.sh"]
#     }
#    SETTINGS
# }
resource "null_resource" "write_ip_to_file" {
  count = length(azurerm_linux_virtual_machine.vm)

  provisioner "local-exec" {
    command = "echo '${azurerm_linux_virtual_machine.vm[count.index].public_ip_address}' >> hosts"
  }

  depends_on = [azurerm_linux_virtual_machine.vm]
}
