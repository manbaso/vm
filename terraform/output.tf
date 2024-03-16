# 

output "vm_ids" {
  value = [for vm in azurerm_linux_virtual_machine.vm : vm.public_ip_address ]
 
}