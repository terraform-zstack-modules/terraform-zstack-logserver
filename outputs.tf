#
# Contextual output
#

output "walrus_project_name" {
  value       = try(local.context["project"]["name"], null)
  description = "The name of project where deployed in Walrus."
}

output "walrus_project_id" {
  value       = try(local.context["project"]["id"], null)
  description = "The id of project where deployed in Walrus."
}

output "walrus_environment_name" {
  value       = try(local.context["environment"]["name"], null)
  description = "The name of environment where deployed in Walrus."
}

output "walrus_environment_id" {
  value       = try(local.context["environment"]["id"], null)
  description = "The id of environment where deployed in Walrus."
}

output "walrus_resource_name" {
  value       = try(local.context["resource"]["name"], null)
  description = "The name of resource where deployed in Walrus."
}

output "walrus_resource_id" {
  value       = try(local.context["resource"]["id"], null)
  description = "The id of resource where deployed in Walrus."
}


output "instance_info" {
  value = {
    name = module.logserver_instance.instance_names[0]
    id = module.logserver_instance.instance_ids[0]
    ip = module.logserver_instance.instance_ips[0]
  }
}

output "service_ip" {
  description = "Service IP"
  value       = module.logserver_instance.instance_ips[0]
}

output "ports" {
  description = "Service Ports"
  value       = var.ports
}
