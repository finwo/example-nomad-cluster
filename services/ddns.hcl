job "ddns" {
  datacenters = ["eu-north1-a"]
  type = "service"

  constraint {
    attribute = "${attr.kernel.name}"
    value     = "linux"
  }

  update {
    stagger      = "10s"
    max_parallel = 1
  }

  group "ddns-finwo-nl" {
    count = 1

    task "ddns-tsk" {
      driver = "docker"
      template {
        env         = true
        destination = "local/env"
        data        = <<EOT
API_KEY={{ with nomadVar "nomad/jobs/ddns/ddns-finwo-nl" }}{{ .api_key }}{{ end }}
EOT
      }
      env {
        ZONE      = "finwo.nl"
        SUBDOMAIN = "ddns"
        PROXIED   = true
      }
      config {
        image = "oznu/cloudflare-ddns:latest"
      }
      resources {
        cpu        = 128
        memory     = 128
      }
      service {
        name = "ddns"
        tags = []
      }
    }
  }
}

