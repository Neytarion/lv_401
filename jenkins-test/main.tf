# Access the provider GCP
provider "google" {
credentials = "${file("lv401devops-p2-722e912233c6.json")}"
project = "lv401devops-p2"
region = "us-central1-a"
}
