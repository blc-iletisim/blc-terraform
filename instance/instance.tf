# Define required providers
terraform {
required_version = ">= 0.14.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "1.48.0"
    }
  }
}

#vars.json file
locals {
  local_data = jsondecode(file("${path.module}/var.json"))
}

provider "openstack" {
    user_name   = local.local_data.user_name
    tenant_name = local.local_data.tenant_name
    password    = local.local_data.password
    auth_url    = "http://10.150.1.251:5000"
    region      = "RegionOne"
    #domain_name = "Default"
}

resource "openstack_compute_instance_v2" "gizem" {
    name            = "gizem"
    image_id        = local.local_data.image_id
    flavor_id       = local.local_data.flavor_id
    key_pair        = local.local_data.key_pair
    network {
    name = "Internal" 
}        
}



#output to write internal ip
output "name" {
  value       = openstack_compute_instance_v2.gizem.network
}

resource "openstack_networking_floatingip_v2" "admin" {
  pool = "External"
}

#output to write external ip
output "pool" {
  value       = openstack_networking_floatingip_v2.admin
}


resource "openstack_compute_floatingip_associate_v2" "admin" {
  floating_ip = "${openstack_networking_floatingip_v2.admin.address}"
  instance_id = "${openstack_compute_instance_v2.gizem.id}"
 
}
