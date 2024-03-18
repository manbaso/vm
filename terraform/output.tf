# 

output "vm_ids" {
  value = tomap(for vm in azurerm_linux_virtual_machine.vm : "ip" => vm.public_ip_address)
 
}