pipeline {
    agent any
    environment {
        IMAGE_NAME = "bassamelwshahy/java-app1" // replace with your DockerHub image name
    }
    options {
        buildDiscarder(logRotator(numToKeepStr: '10'))
        timestamps()
    }
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        stage('Maven Build (in Docker)') {
            steps {
                // run Maven inside Docker to avoid installing Maven on Jenkins agent
                sh 'docker run --rm -v $WORKSPACE:/workspace -w /workspace maven:3.9.5-eclipse-temurin-17 mvn -B clean package'
            }
            post {
                always {
                    archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
                }
            }
        }
        stage('Docker Build') {
            steps {
                script {
                    def tag = "${env.BUILD_NUMBER}"
                    sh "docker build -t ${IMAGE_NAME}:${tag} -t ${IMAGE_NAME}:latest ."
                }
            }
            post {
                always {
                    sh 'docker image prune -f || true'
                }
            }
        }
        stage('Docker Push') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh "echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin"
                    sh "docker push ${IMAGE_NAME}:${env.BUILD_NUMBER}"
                    sh "docker push ${IMAGE_NAME}:latest"
                }
            }
        }
    }
}
