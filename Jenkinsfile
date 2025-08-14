@Library('my-shared-library') _
import org.example.DockerMavenPipeline

new DockerMavenPipeline(this).runPipeline("my-app", "dockerhub-creds","github-cred")
environment {
        GITHUB_CREDS = credentials('github-cred')
    }
