@Library('my-shared-lib') _

pipeline{
    agent any;

    environment{
        // Update the main app image name to match the deployment file
        DOCKER_IMAGE_NAME = 'kmvishal/tws-e-commerce-app'
        DOCKER_MIGRATION_IMAGE_NAME = 'kmvishal/easyshop-migration'
        DOCKER_IMAGE_TAG = "${BUILD_NUMBER}"
        GIT_REPO_URL = 'https://github.com/Vishal-Kumar-CSE/tws-e-commerce-app.git'
        GIT_BRANCH = 'devops'
        // GIT_CREDENTIALS = credentials('GithubPass')
    }

    stages {

        stage('Cleanup Workspace') {
            steps {
                script {
                    clean_ws()
                }
            }
        }

        stage('code_checkout') {
            steps {
                script {
                    code_checkout(env.GIT_REPO_URL, env.GIT_BRANCH)
                }
            }
        }

        stage('Build_Docker_Image') {
           parallel {
            steps {
                echo 'Building...'
                docker_build(
                    imageName: env.DOCKER_IMAGE_NAME,
                    imageTag: env.DOCKER_IMAGE_TAG,
                    dockerfile: 'Dockerfile',
                    context: '.'
                )

            }
            steps {
                docker_build(
                    imageName: env.DOCKER_MIGRATION_IMAGE_NAME,
                    imageTag: env.DOCKER_IMAGE_TAG,
                    dockerfile: 'scripts/Dockerfile.migration',
                    context: '.'
                )
            }
        }
        }

        stage('Test_Cases') {
            steps {
                echo 'Testing will be done soon...'
            }
        }

    stage('Security_Scan_with_Trivy') {
        steps {
            trivy_scan()
        }
    }

    stage('Push_Docker_Image') {
        parallel{
            stage('Push_Main_App_Docker_Image') {
                steps {
                    docker_push(
                        imageName: env.DOCKER_IMAGE_NAME,
                        imageTag: env.DOCKER_IMAGE_TAG,
                        credentials: 'DockerHubPat'
                    )
                }
            }
            stage('Push_Migration_Docker_Image') {
                steps {
                    docker_push(
                        imageName: env.DOCKER_MIGRATION_IMAGE_NAME,
                        imageTag: env.DOCKER_IMAGE_TAG,
                        credentials: 'DockerHubPat'
                    )
                }
            }
        }
    }

    stage('Update_Manifest_File') {
        steps {
            echo 'Updating manifest file...'
        }
    }
    }
}
