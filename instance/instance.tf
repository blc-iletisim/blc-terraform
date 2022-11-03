terraform {
required_version = ">= 0.14.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "1.48.0"
    }
  }
}

provider "openstack" {
    user_name   = "mertcan"
    tenant_name = "admin"
    password    = "1"
    auth_url    = "http://10.150.1.251:5000"
    region      = "RegionOne"
    #domain_name = "Default"

}

resource "openstack_compute_instance_v2" "mert-terra3" {
    name            = "mert-terra3"
    image_id        = "20944105-1877-4935-bacd-d68dc3691ade"
    flavor_id       = "a1ee6670-64f7-412d-a075-c4a8ff923777" 
    key_pair        = "blc-cloud"
    network {
      name = "Internal"
    }
    
}

resource "openstack_networking_floatingip_v2" "admin" {
  pool = "External"
}

resource "openstack_compute_floatingip_associate_v2" "admin" {
  floating_ip = "${openstack_networking_floatingip_v2.admin.address}"
  instance_id = "${openstack_compute_instance_v2.mert-terra3.id}"
}
