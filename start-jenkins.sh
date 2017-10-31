docker run -d -p 80:8080 -u root -v ~/jenkins-data:/var/jenkins_home -v /var/run/docker.sock:/var/run/docker.sock -v $(which docker):/usr/bin/docker jenkins/jenkins
