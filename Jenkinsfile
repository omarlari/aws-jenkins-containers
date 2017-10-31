node {

   stage 'Checkout'
   git 'https://github.com/omarlari/aws-jenkins-containers.git'

   stage 'Build Dockerfile'
   docker.build('movies')

   stage 'Push to ECR'
   docker.withRegistry('https://${ECS_REPO}', 'ecr:us-west-2:aws') {
       docker.image('movies').push('${BUILD_NUMBER}')
   }

   stage 'update application'

   parallel(
        ecs: {node {
        docker.image('awscli').inside{
            git 'https://github.com/omarlari/aws-jenkins-containers.git'
            sh 'sed -i s/BUILD/${BUILD_NUMBER}/g task-definition-hello.json'
            sh 'aws ecs register-task-definition --cli-input-json file://task-definition-hello.json --family ${TASK_DEF} --region ${REGION}'
        }
        }},
        kubernetes: { node {
        docker.image('kubectl').inside("--volume=/home/core/.kube:/config/.kube"){
            sh 'kubectl set image deployment/${K8S_DEPLOYMENT} movies=${ECS_REPO}/movies:${BUILD_NUMBER}'
            }
        }},
        swarm: { node {
            sh "echo deploying to swarm"
        }}
   )


   stage 'update ECS service'
   docker.image('awscli').inside{
       sh 'aws ecs update-service --cluster ${ECS_CLUSTER} --service ${ECS_SERVICE} --task-definition ${TASK_DEF} --region us-west-2'
   }
}
