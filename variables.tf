
variable "local_vpc_name" {
  description = "Name of the VPC"
  type        = string
}

variable "local_subnet_name" {
  description = "Name of the Subnet"
  type        = string
}

variable "local_subnet_cidr" {
  description = "CIDR range for the subnet"
  type        = string
  
}

variable "local_vm_name" {
  description = "Name of the VM instance"
  type        = string
}

variable "local_machine_type" {
  description = "Machine type of the VM instance"
  type        = string
}

variable "local_zone" {
  description = "Zone where the VM instance will be created"
  type        = string  
  
}


variable "project_id" {
  type        = string
  description = "GCP project ID"
}

variable "region" {
  type        = string
  description = "GCP region (e.g., us-central1)"
}

variable "environments" {
  type        = set(string)
  description = "Environments to create in this apply (e.g., [\"dev\",\"stage\"])"
}

variable "instance_configs" {
  description = "Per-env Cloud SQL config"
  type = map(object({
    name             = string
    vcpus            = number
    memory_mb        = number
    disk_type        = string
    disk_size_gb     = number
    database_version = string
  }))
}

variable "ha_by_env" {
  type        = map(bool)
  description = "Override HA per env (true=>REGIONAL, false=>ZONAL). If not set, default is stage/prod=true."
  default     = {}
}

variable "authorized_networks" {
  description = "Public IP allowlist"
  type = list(object({
    name = string
    cidr = string
  }))
}

variable "database_name_by_env" {
  type        = map(string)
  description = "Database name per env"
}

variable "database_user_by_env" {
  type        = map(string)
  description = "Database user per env"
}

variable "database_password_by_env" {
  type        = map(string)
  description = "Optional DB password per env; omit for auto-generated"
  sensitive   = true
  default     = {}
}

variable "enable_read_replicas_by_env" {
  type        = map(bool)
  description = "Toggle read replicas per env"
  default     = {}
}

variable "read_replicas_by_env" {
  description = "List of replicas per env"
  type = map(list(object({
    name   = string
    region = string
  })))
  default = {}
}

variable "deletion_protection" {
  type        = bool
  description = "Protect instances from destroy"
  default     = true
}
