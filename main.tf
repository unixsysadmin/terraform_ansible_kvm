terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
    }
    ansible = {
      # version = "~> 1.0.0"
      source  = "ansible/ansible"
    }
  }
}

provider "libvirt" {
  # Configuration options
  # uri = "qemu:///system"
  # uri   = "qemu+ssh://root:password@kvm_host/system?sshauth=ssh-password"
}
