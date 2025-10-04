job "hello-world" {
  datacenters = ["dc1"]
  type = "service"

  group "hello" {
    count = 1

    task "web" {
      driver = "docker"

      config {
        image = "hashicorp/http-echo"
        args  = ["-text=Hello Nomad!"]
        port_map {
          http = 5678
        }
      }

      resources {
        cpu    = 500
        memory = 128
      }

      service {
        name = "hello-service"
        port = "http"
        check {
          type     = "tcp"
          interval = "10s"
          timeout  = "2s"
        }
      }
    }

    network {
      port "http" {
        static = 5678
      }
    }
  }
}
