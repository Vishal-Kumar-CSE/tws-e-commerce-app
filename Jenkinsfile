@Library('my-shared-lib')_

pipeline {
    agent any;

    environment {
        DOCKER_IMAGE_NAME = 'kmvishal/tws-e-commerce-app'
        DOCKER_MIGRATION_IMAGE_NAME = 'kmvishal/easyshop-migration'
        DOCKER_IMAGE_TAG = "${BUILD_NUMBER}"
        GIT_REPO_URL = 'https://github.com/Vishal-Kumar-CSE/tws-e-commerce-app.git'
        GIT_BRANCH = 'devops'
    }

    stages {

        stage('Cleanup Workspace') {
            steps {
                script {
                    clear_ws()
                }
            }
        }

        stage('Code Checkout') {
            steps {
                script {
                    code_checkout(env.GIT_REPO_URL, env.GIT_BRANCH)
                }
            }
        }

        stage('Build Docker Images') {
            parallel {
                stage('Build Main App Image') {
                    steps {
                        script {
                            docker_build(
                                imageName: env.DOCKER_IMAGE_NAME,
                                imageTag: env.DOCKER_IMAGE_TAG,
                                dockerfile: 'Dockerfile',
                                context: '.'
                            )
                        }
                    }
                }

                stage('Build Migration Image') {
                    steps {
                        script {
                            docker_build(
                                imageName: env.DOCKER_MIGRATION_IMAGE_NAME,
                                imageTag: env.DOCKER_IMAGE_TAG,
                                dockerfile: 'scripts/Dockerfile.migration',
                                context: '.'
                            )
                        }
                    }
                }
            }
        }

        stage('Test Cases') {
            steps {
                echo 'Testing will be done soon...'
            }
        }

        stage('Security Scan with Trivy') {
            steps {
                script {
                    trivy_scan()
                }
            }
        }

        stage('Push Docker Images') {
            parallel {
                stage('Push Main App Image') {
                    steps {
                        script {
                            docker_push(
                                imageName: env.DOCKER_IMAGE_NAME,
                                imageTag: env.DOCKER_IMAGE_TAG,
                                credentials: 'DockerHubPat'
                            )
                        }
                    }
                }

                stage('Push Migration Image') {
                    steps {
                        script {
                            docker_push(
                                imageName: env.DOCKER_MIGRATION_IMAGE_NAME,
                                imageTag: env.DOCKER_IMAGE_TAG,
                                credentials: 'DockerHubPat'
                            )
                        }
                    }
                }
            }
        }

        stage('Update Manifest File') {
            steps {
                echo 'Updating manifest file...'
            }
        }
    }
}
