def call(Map config = [:]) {
    pipeline {
        agent any
        
        tools {
            maven config.get('mavenTool', 'mvn-3-5-4')
            jdk config.get('jdkTool', 'java-11')
        }
        
        environment {
            DOCKER_USER = credentials(config.get('dockerUserCred', 'docker-username'))
            DOCKER_PASS = credentials(config.get('dockerPassCred', 'docker-password'))
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
                    sh "docker build -t ${config.get('dockerImage', 'myrepo/myapp')}:v${BUILD_NUMBER} ."
                    sh "docker images"
                }
            }
            
            stage("Docker push") {
                steps {
                    sh "echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin"
                    sh "docker push ${config.get('dockerImage', 'myrepo/myapp')}:v${BUILD_NUMBER}"
                }
            }
        }
    }
}
