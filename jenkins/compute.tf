### To Provision FireWall rule ###

resource "google_compute_firewall" "www" {
  name = "jenkins-lv401-p2-firewall"
  network = "default"

  allow {
    protocol = "tcp"
    ports = ["8080", "443"]
  }

  source_ranges = ["0.0.0.0/0"]
}


### To provision Jenkins Master ###

resource "google_compute_instance" "jenkins-master-1" {
   name = "jenkins-master-lv401-p2"
   machine_type = "n1-standard-1"
   zone = "us-central1-a"
   tags = ["jenkins"]
   boot_disk {
      initialize_params {
      image = "centos-cloud/centos-7"
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
 sudo yum install epel-release; 
 sudo yum update; sudo yum install -y java-1.8.0-openjdk.x86_64 ;
 sudo yum install -y wget; 
 sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo; 
 sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key; 
 sudo yum install -y jenkins; 
 sudo systemctl start jenkins.service; 
 sudo yum install -y git; 
 sudo git clone https://github.com/Neytarion/jenkins_xml; 
 sudo cp jenkins_xml/config.xml /var/lib/jenkins; 
 sudo yum install -y zip unzip; 
 sudo wget https://releases.hashicorp.com/terraform/0.12.2/terraform_0.12.2_linux_amd64.zip; 
 sudo unzip terraform_0.12.2_linux_amd64.zip; 
 sudo mv terraform /usr/local/bin/;
 gsutil cp gs://qsqs/lv401-jenkins1.zip gs://"qsqs/Copy of lv401-jenkins1.zip" . ;
 sudo unzip -o lv401-jenkins1.zip ;
 sudo cp jenkins7.zip /var/lib/jenkins ;
 sudo unzip -o /var/lib/jenkins/jenkins7.zip; 
# sudo yum install -y ansible;
# sudo yum install -y python-pip; 
# sudo pip install google-auth requests;
# sudo ansible-inventory -i inventory.gcp.yml --graph; 
# ssh-keygen -t rsa -f /home/yanyshyn/.ssh/id_rsa -q -P "" ; 
# sudo cp ~/.ssh/id_rsa ~/;
# key=$(cat ~/.ssh/id_rsa.pub); echo variable "public_key" { default = '"'"$USER"':'"$key"'"'} >> variables.tf ;
 # Installing plugins now 
 sudo mkdir /home/jenkins;
 sleep 20 #need to write script here ;
 sudo wget -O /home/jenkins/jenkins-cli.jar http://localhost:8080/jnlpJars/jenkins-cli.jar;
 sudo java -jar /home/jenkins/jenkins-cli.jar -s http://127.0.0.1:8080/ install-plugin workflow-aggregator ;
 sudo java -jar /home/jenkins/jenkins-cli.jar -s http://127.0.0.1:8080/ install-plugin git-parameter;
 # Getting template from repo
 git clone https://github.com/tooSadman/gcloud; 
 sudo java -jar /home/jenkins/jenkins-cli.jar -s http://127.0.0.1:8080/ create-job tomcat < gcloud/templates/tomcat.xml;
 #java -jar /home/jenkins/jenkins-cli.jar -s http://127.0.0.1:8080/ build tomcat;
 sudo systemctl restart jenkins;
 sudo yum install -y ansible;
 sudo yum install -y python-pip;
 sudo pip install google-auth requests;
 sudo ansible-inventory -i inventory.gcp.yml --graph;
 ssh-keygen -t rsa -f ~/.ssh/id_rsa -q -P "" ;
 sudo cp ~/.ssh/id_rsa ~/;
 key=$(cat ~/.ssh/id_rsa.pub); echo variable "public_key" { default = '"'"$USER"':'"$key"'"'} >> variables.tf ;
SCRIPT
}


