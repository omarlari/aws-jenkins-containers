docker run -d -p 80:8080 -u root -v /home/ec2-user/jenkins-data:/var/jenkins_home -v /var/run/docker.sock:/var/run/docker.sock -v $(which docker):/bin/docker jenkinsci/blueocean:latest
