@Library('my-shared-library') _  // This is the name you give your shared library in Jenkins (Manage Jenkins > Configure System)

node {
    def IMAGE_NAME = "bassamelwshahy/java-app"
    def IMAGE_TAG = "latest"

    stage('Checkout') {
        git branch: 'main', url: 'https://github.com/bassamelwshahy/java.git'
    }

    stage('Build Java Project') {
        sh './mvnw clean package'
    }

    stage('Build Docker Image') {
        sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
    }

    stage('Push Docker Image') {
        withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
            sh "echo $PASS | docker login -u $USER --password-stdin"
            sh "docker push ${IMAGE_NAME}:${IMAGE_TAG}"
        }
    }
}
