resource "openstack_compute_keypair_v2" "my-cloud-key" {
  name       = "key"
  public_key = "${file("~/.ssh/id_rsa.pub")}"
}

resource "openstack_blockstorage_volume_v2" "volume_1" {
  region                = "bgo"
  name                  = "testVolume"
  description           = "This volume got created when the VM was created"
  size                  = "2"
}

resource "openstack_compute_instance_v2" "test" {
  region          = "bgo"
  name            = "Testing"
  image_name      = "GOLD Ubuntu 18.04 LTS"
  flavor_name     = "m1.medium"
  key_pair        = "${openstack_compute_keypair_v2.my-cloud-key.name}"
  security_groups = ["default", "SSH", "Egress-ingress"]

  network {
    name = "dualStack"
  }
}

resource "openstack_compute_volume_attach_v2" "volume_1" {
  instance_id = "${openstack_compute_instance_v2.test.id}"
  volume_id   = "${openstack_blockstorage_volume_v2.volume_1.id}"
}
