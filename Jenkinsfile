node {
    def IMAGE_NAME = "bassamelwshahy/java-app1"

    stage('Checkout') {
        checkout scm
    }

    stage('Maven Build (in Docker)') {
        sh 'docker run --rm -v $WORKSPACE:/workspace -w /workspace maven:3.9.5-eclipse-temurin-17 mvn -B clean package'
    }

    stage('Docker Build') {
        def tag = env.BUILD_NUMBER
        sh "docker build -t ${IMAGE_NAME}:${tag} -t ${IMAGE_NAME}:latest ."
    }

    stage('Docker Push') {
        withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
            sh "echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin"
            sh "docker push ${IMAGE_NAME}:${env.BUILD_NUMBER}"
            sh "docker push ${IMAGE_NAME}:latest"
        }
    }

    stage('Cleanup') {
        sh 'docker image prune -f || true'
    }
}
