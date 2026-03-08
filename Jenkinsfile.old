pipeline {
    agent any
    tools {
        nodejs 'nodejs-25'
    }

    stages {
        stage('increment version') {
            steps {
                script {
                    echo 'Incrementing version...'
                    def packageJson = readJSON file: 'app/package.json'
                    def version = packageJson.version
                    def versionParts = version.tokenize('.')
                    versionParts[1] = (versionParts[1].toInteger() + 1).toString()
                    versionParts[2] = '0'
                    def newVersion = versionParts.join('.')
                    packageJson.version = newVersion
                    writeJSON file: 'app/package.json', json: packageJson, pretty: 2
                    env.NEW_VERSION = newVersion
                    echo "Version incremented to ${newVersion}"
                }
            }
        }
        stage('Test') {
            steps {
                script {
                    echo 'Running tests...'
                    sh 'cd app && npm install && npm run test'
                }
            }
        }
        stage('Build docker image with incremented version') {
            steps {
                script {
                    echo 'Building...'
                    sh "docker build -t alikakavand/node-app-cicd:${env.NEW_VERSION} ."
                }
            }
        }
        stage('Push docker image to registry') {
            steps {
                script {
                    echo 'Pushing...'
                    withCredentials([usernamePassword(credentialsId: 'docker-hub-repo', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                        sh 'echo $PASS | docker login -u $USER --password-stdin'
                        sh "docker push alikakavand/node-app-cicd:${env.NEW_VERSION}"
                    }
                }
            }
        }
        stage('commit version update to GitHub') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'github-pat', usernameVariable: 'GIT_USER', passwordVariable: 'GIT_PASS')]) {
                        sh 'git config user.name "Jenkins CI"'
                        sh 'git config user.email "jenkins@example.com"'

                        sh 'git status'
                        sh 'git config --list'

                        sh "git remote set-url origin https://\$GIT_USER:\$GIT_PASS@github.com/Alee7hub/node-app-cicd.git"
                        sh 'git add .'
                        sh "git commit -m \"CI: version bump to ${env.NEW_VERSION}\""
                        sh 'git push origin HEAD:main'
                    }
                }
            }
        }
    }
}