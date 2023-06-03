job "fabio" {
  datacenters = ["eu-north1-a"]
  type = "system"

  constraint {
    attribute = "${attr.kernel.name}"
    value     = "linux"
  }

  group "fabio" {

    network {
      port "lb" {
        static = 80
        to     = 9999
      }
      port "ui" {}
    }

    task "privileged_port" {
      driver = "raw_exec"
      config {
        command = "socat"
        args = ["tcp-l:80,fork,reuseaddr","tcp:${attr.unique.network.ip-address}:${NOMAD_PORT_lb}"]
      }
      resources {
        cpu    = 100
        memory = 128
      }
    }

    task "fabio" {
      driver = "raw_exec"
      config {
        command = "fabio-1.6.3-linux_amd64"
        # command = "/usr/local/bin/fabio"
        args = ["-proxy.addr", "${attr.unique.network.ip-address}:${NOMAD_PORT_lb}", "-registry.consul.addr", "192.168.240.250:8500", "-ui.addr", "${attr.unique.network.ip-address}:${NOMAD_PORT_ui}"]
      }
      artifact {
        source = "https://github.com/fabiolb/fabio/releases/download/v1.6.3/fabio-1.6.3-linux_amd64"
      }
      resources {
        cpu    = 500
        memory = 128
      }
      service {
        name = "fabio"
        tags = ["urlprefix-fabio.pve/"]
        port = "ui"
        check {
          name     = "alive"
          type     = "tcp"
          interval = "10s"
          timeout  = "3s"
        }
      }
    }
  }
}

