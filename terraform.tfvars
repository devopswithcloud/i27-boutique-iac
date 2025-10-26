project_id = "rugged-abacus-464109-r6"
region = "us-central1"
local_vpc_name = "my-app1-vpc"
local_subnet_name = "my-app1-subnet"
local_subnet_cidr = "10.7.0.0/16"
local_vm_name = "my-app1-vm"
local_machine_type = "e2-medium"

local_zone = "us-central1-a"


# Create both envs in one run
environments = ["dev", "stage"]

# Per-env sizes and DB engine
instance_configs = {
  dev = {
    name             = "dev-db-primary"
    vcpus            = 2
    memory_mb        = 4096
    disk_type        = "PD_SSD"
    disk_size_gb     = 30
    database_version = "MYSQL_8_0"
  }
  stage = {
    name             = "stage-db-primary"
    vcpus            = 2
    memory_mb        = 7680
    disk_type        = "PD_SSD"
    disk_size_gb     = 50
    database_version = "MYSQL_8_0"
  }
}

# HA defaults: stage/prod => true; dev => false. Explicit overrides here:
ha_by_env = {
  dev   = false
  stage = true
}

# Allow only these public CIDRs
authorized_networks = [
  { name = "siva-home", cidr = "1.2.3.4/32" },
  { name = "office-nat", cidr = "*.*.*.*/32" },
  { name = "company-nat", cidr = "*.*.*.*/32"}
]

# Per-env DB names/users
database_name_by_env = {
  dev   = "i27app_dev"
  stage = "i27app"
}

database_user_by_env = {
  dev   = "i27user_dev"
  stage = "i27user"
}

# Optional: set to force specific passwords; omit to auto-generate
# database_password_by_env = {
#   dev   = "DevStrongP@ss!"
#   stage = "StageStrongP@ss!"
# }

# Replicas per env
enable_read_replicas_by_env = {
  dev   = false
  stage = true
}

read_replicas_by_env = {
  stage = [
    { name = "stage-db-replica-1", region = "us-central1" }
  ]
}

deletion_protection = true
