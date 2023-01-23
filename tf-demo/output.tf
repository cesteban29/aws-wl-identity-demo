output "catapp_url"{
  value = module.hashicat.catapp_url
}
  
output "catapp_ip"{
  value = module.hashicat.catapp_ip
}

data "environment_variables" "all"{}

output "env"{
  value = data.environment_variables.all.items["TFC_WORKLOAD_IDENTITY_TOKEN"]
}