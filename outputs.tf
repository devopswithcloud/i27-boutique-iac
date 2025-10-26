output "vm_link" {
  value = module.gce.instance_self_link

}

output "connection_names" {
  description = "Cloud SQL connection names by env"
  value       = { for env, m in module.cloudsql : env => m.instance_connection_name }
}

output "public_ips" {
  description = "Public IPv4 by env"
  value       = { for env, m in module.cloudsql : env => m.public_ip }
}

output "database_names" {
  description = "Database name by env"
  value       = { for env, m in module.cloudsql : env => m.database_name }
}

output "db_users" {
  description = "DB user by env (sensitive)"
  value       = { for env, m in module.cloudsql : env => m.db_user }
  sensitive   = true
}

output "db_passwords" {
  description = "DB password by env (sensitive)"
  value       = { for env, m in module.cloudsql : env => m.db_password }
  sensitive   = true
}
