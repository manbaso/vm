# 

output "vm_ids" {
  value = {for ip, vm in azurerm_linux_virtual_machine.vm : "ip" => vm.public_ip_address}
 
}