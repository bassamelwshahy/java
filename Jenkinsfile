pipeline {
    agent any
    
    tools {
        maven 'mvn-3-5-4'   // لازم يكون متعرف في Global Tool Configuration
        jdk 'java-11'       // لازم يكون متعرف في Global Tool Configuration
    }
    
    environment {
        DOCKER_USER = credentials('docker-username') // من Credentials
        DOCKER_PASS = credentials('docker-password') // من Credentials
    }
    
    stages {
        stage("Dependency check") {
            steps {
                sh "mvn dependency-check:check"
                dependencyCheckPublisher pattern: 'target/dependency-check-report.xml'
            }
        }
        
        stage("Build app") {
            steps {
                sh "mvn clean package install"
            }
        }
        
        stage("Archive app") {
            steps {
                archiveArtifacts artifacts: '**/*.jar', followSymlinks: false
            }
        }
        
        stage("Docker build") {
            steps {
                sh "docker build -t hassaneid/iti-java:v${BUILD_NUMBER} ."
                sh "docker images"
            }
        }
        
        stage("Docker push") {
            steps {
                sh "echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin"
                sh "docker push hassaneid/iti-java:v${BUILD_NUMBER}"
            }
        }
    }
}
