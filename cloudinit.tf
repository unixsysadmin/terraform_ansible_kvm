# Define a cloudinit ISO disk

resource "libvirt_cloudinit_disk" "cloud-init-rhel9" {
  name = "commoninit.iso"
  pool = "guest_images_dir"
  user_data = data.template_file.user_data.rendered
}

data "template_file" "user_data" {
  template = file("${path.module}/cloud-init-rhel9.cfg")
}
