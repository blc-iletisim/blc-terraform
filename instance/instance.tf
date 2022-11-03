# Define required providers
terraform {
required_version = ">= 0.14.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "1.48.0"
    }
    github = {
      source  = "integrations/github"
      version = "5.7.0"
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

provider "github" {
  app_auth {}
}

resource "openstack_compute_instance_v2" "mert" {
    name            = "mert"
    image_id        = local.local_data.image_id
    flavor_id       = local.local_data.flavor_id
    key_pair        = local.local_data.key_pair
    network {
      name = "Internal"
    }
    
    
}

output "name" {
  value       = openstack_compute_instance_v2.mert.network
}

resource "openstack_networking_floatingip_v2" "admin" {
  pool = "External"
}

output "pool" {
  value       = openstack_networking_floatingip_v2.admin
}


resource "openstack_compute_floatingip_associate_v2" "admin" {
  floating_ip = "${openstack_networking_floatingip_v2.admin.address}"
  instance_id = "${openstack_compute_instance_v2.mert.id}"
}


/*
resource "openstack_networking_network_v2" "Internal" {
  name           = "Internal"
  admin_state_up = "true"
}
*/

/*
resource "openstack_networking_port_v2" "port_1" {
  network_id = "f0ad3870-01d3-41e1-b6dd-dccf6f424de4"
}

resource "openstack_networking_floatingip_associate_v2" "fip_1" {
  floating_ip = "10.150.1.141"
  port_id     = "${openstack_networking_port_v2.port_1}"
}*/

resource "null_resource" "git_clone" {
  provisioner "local-exec" {
    command = "get_repo.sh"
    interpreter = ["bash"]
  }
}
