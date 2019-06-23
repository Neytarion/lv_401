# Access the provider GCP
provider "google" {
credentials = "${file("lv401devops-p2-671233cecf51.json")}"
project = "lv401devops-p2"
region = "us-central1-a"
}
