output "Jenkins_Public_IP" {
  value       = "${google_compute_instance.jenkins-test.network_interface.0.access_config.0.nat_ip}"
  description = "The IPv4 address assigned"
}
