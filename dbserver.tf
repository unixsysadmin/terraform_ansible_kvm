# Define a VM Volume

resource "libvirt_volume" "dbserver-qcow2" {
  # What do name the virtual disk image
  name = "dbserver.example.com.qcow2"
  # Where to store the virtual disk image
  pool = "guest_images_dir" # List storage pools using virsh pool-list
  # We build on a base image, defined by base_volume_name
  # found in base_volume_pool 
  base_volume_pool = "guest_images_dir"
  base_volume_name = "rhel-baseos-9.1-x86_64-kvm.qcow2"
  format = "qcow2"
}

# Define KVM domain to create
resource "libvirt_domain" "dbserver" {
  name   = "dbserver"
  memory = "4096"
  vcpu   = 2
  cpu {
    mode = "host-passthrough"
  }

  cloudinit = libvirt_cloudinit_disk.cloud-init-rhel9.id

  network_interface {
    network_name = "default" # List networks with virsh net-list
    wait_for_lease = true
  }

  disk {
    volume_id = "${libvirt_volume.dbserver-qcow2.id}"
  }

  console {
    type = "pty"
    target_type = "serial"
    target_port = "0"
  }

  graphics {
    type = "vnc"
    listen_type = "address"
  }
}

# Define the host as an Ansible resource
resource "ansible_host" "dbserver" {          #### ansible host details
  name = "dbserver"
  groups = ["database"]
  variables = {
    ansible_user                 = "ansible",
    ansible_ssh_private_key_file = "~/.ssh/id_rsa",
    ansible_python_interpreter   = "/usr/bin/python3"
    ansible_ssh_host   = "${libvirt_domain.dbserver.network_interface[0].addresses.0}"
  }
}
