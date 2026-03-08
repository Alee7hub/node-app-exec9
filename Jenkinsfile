@Library('sl-node-app-cicd') _

def IMAGE_NAME = 'alikakavand/demo-app'

pipeline {
    agent any
    tools {
        nodejs 'nodejs-25'
    }

    stages {
        stage('Increment Version') {
            steps {
                script {
                    incrementVersion('major')
                }
            }
        }
        stage('Test') {
            steps {
                script {
                    test()
                }
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    buildImage(IMAGE_NAME)
                }
            }
        }
        stage('Push Docker Image') {
            steps {
                script {
                    dockerLogin()
                    dockerPush(IMAGE_NAME)
                }
            }
        }
        stage("deploy to EC2") {
            steps {
                script {
                    echo 'deploying docker image to EC2...'

                    def shellCmd = "bash ./server-cmds.sh ${IMAGE_NAME}:${env.NEW_VERSION}"
                    def ec2Instance = "ec2-user@18.195.204.194"
                    
                    sshagent(['ec2-server-key']) {
                        sh "scp server-cmds.sh ${ec2Instance}:/home/ec2-user"
                        sh "scp docker-compose.yaml ${ec2Instance}:/home/ec2-user"
                        sh "ssh -o StrictHostKeyChecking=no ${ec2Instance} '${shellCmd}'"
                    }
                }
            }
        }
        stage('Commit Version Bump') {
            steps {
                script {
                    commitVersionBump('github.com/Alee7hub/node-app-exec9.git')
                }
            }
        }
    }
}