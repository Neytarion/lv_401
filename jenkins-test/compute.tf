### To Provision FireWall rule ###

resource "google_compute_firewall" "www" {
  name = "jenkins-lv401-firewall"
  network = "default"

  allow {
    protocol = "tcp"
    ports = ["8080", "443"]
  }

  source_ranges = ["0.0.0.0/0"]
}


### To provision Jenkins Master ###

resource "google_compute_instance" "jenkins-test" {
   name = "jenkins-test"
   machine_type = "n1-standard-1"
   zone = "us-central1-a"
   tags = ["jenkins"]
   boot_disk {
      initialize_params {
      image = "debian-cloud/debian-9"
   }
}
network_interface {
   network = "default"
   access_config {}
}
service_account {
   scopes = ["userinfo-email", "compute-ro", "storage-ro"]
   }

   metadata_startup_script = <<SCRIPT
    sudo apt-get update;
    sudo apt install -y openjdk-8-jdk; 
    sudo apt-get install -y apt-transport-https; 
    wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add - ; 
    sudo sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'; 
    sudo apt-get update; 
    sudo apt-get install -y jenkins; 
    sudo apt-get install -y git; 
    sudo git clone https://github.com/Neytarion/jenkins_xml; 
    sudo cp jenkins_xml/config.xml /var/lib/jenkins; 
    sudo service jenkins restart;
    # Installing plugins now 
    sudo apt install -y wget;
    sudo mkdir /home/jenkins;
    sleep 20 #need to write script here ;
    sudo wget -O /home/jenkins/jenkins-cli.jar http://localhost:8080/jnlpJars/jenkins-cli.jar;
    sudo java -jar /home/jenkins/jenkins-cli.jar -s http://127.0.0.1:8080/ install-plugin workflow-aggregator;
    sudo java -jar /home/jenkins/jenkins-cli.jar -s http://127.0.0.1:8080/ install-plugin git-parameter;
    # Getting template from repo
    sudo git clone https://github.com/tooSadman/gcloud /home/jenkins/
    sudo java -jar /home/jenkins/jenkins-cli.jar -s http://127.0.0.1:8080/ create-job test_tomcat < /home/jenkins/lv_401/templates/test_pipeline.xml;
    #java -jar /home/jenkins/jenkins-cli.jar -s http://127.0.0.1:8080/ build tomcat
   SCRIPT
}


