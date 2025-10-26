provider "google" {
  project = var.project_id
  region  = var.region
}

# Call a VPC Module ,written be before
module "vpc" {
    source = "git::https://github.com/devopswithcloud/i27-terraform-b25-modules.git//vpc?ref=v1.0.0"
    vpc_name = var.local_vpc_name
}

# Calling Subnet Module
module "subnet" {
    source = "git::https://github.com/devopswithcloud/i27-terraform-b25-modules.git//subnet?ref=v1.0.0"
    subnet_name =  var.local_subnet_name
    region = var.region
    subnet_cidr = var.local_subnet_cidr
    vpc_id = module.vpc.vpc_id
    depends_on = [ module.vpc ]
}

# Calling GCE Module
module "gce" {
    source = "git::https://github.com/devopswithcloud/i27-terraform-b25-modules.git//gce?ref=v1.0.0"
    vm_name = var.local_vm_name
    machine_type = var.local_machine_type
    zone = var.local_zone
    subnet_id = module.subnet.subnet_id
    depends_on = [ module.subnet ]
}

terraform {
  required_version = ">= 1.5.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 5.30.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.6.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

# Run the Cloud SQL module once per environment
module "cloudsql" {
  for_each = var.environments
  source   = "git::https://github.com/devopswithcloud/i27-terraform-b25-modules.git//gce?ref=v1.1.0"

  project_id  = var.project_id
  region      = var.region
  environment = each.key

  # shared maps/lists
  instance_configs    = var.instance_configs
  ha_by_env           = var.ha_by_env
  authorized_networks = var.authorized_networks

  # per-env DB settings
  database_name     = var.database_name_by_env[each.key]
  database_user     = var.database_user_by_env[each.key]
  database_password = lookup(var.database_password_by_env, each.key, "")

  # per-env replica controls
  enable_read_replicas = lookup(var.enable_read_replicas_by_env, each.key, false)
  read_replicas        = lookup(var.read_replicas_by_env, each.key, [])

  deletion_protection = var.deletion_protection
}





