#!/bin/bash

# function check {
#     restart=$(java -jar jenkins-cli.jar -s http://127.0.0.1:8080/ help | grep -q 'java.io.IOException')
#     stop=$(java -jar jenkins-cli.jar -s http://127.0.0.1:8080/ help | grep -q 'java.net.ConnectException')
#     if  "$restart" == 0  || [ "$stop" == 0 ]; then
#         if [ "$restart" == 0 ]; then
#             echo "Jenkins is restarting"
#         elif [ "$stop" == 0 ]; then
#             echo "Jenkins is stopped"
#         fi
#         sleep 5
#         check
#     fi
#     echo hello
# }

# function check {
#     if java -jar jenkins-cli.jar -s http://127.0.0.1:8080/ help | grep -q 'java.io.IOException'; then
#         echo "Jenkins is restartins"
#         sleep 5
#         check
#     fi
# }

function check {
    java -jar jenkins-cli.jar -s http://127.0.0.1:8080/ help | grep -q 'java.net.ConnectException' &> /dev/null
    if [ $? == 0 ]; then
      echo "Jenkins is stopped"
      sleep 5
      check
    fi
}

check