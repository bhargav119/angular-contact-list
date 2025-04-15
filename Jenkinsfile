pipeline {
    agent any

    environment {
        IMAGE_NAME = "angular-contact-app"
        IMAGE_TAG = "latest"
        CONTAINER_NAME = "angular-contact-container"
    }

    stages {
        stage('Build Angular App') {
            steps {
                dir('angular-contact-list') {
                    sh 'npm install'
                    sh 'npm run build'
                }
            }
        }

        stage('Docker Build') {
            steps {
                script {
                    sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
                    sh "docker ps"
                }
            }
        }

        stage('Trivy Scan') {
            steps {
                script {
                    sh '''
                        trivy image --severity HIGH,CRITICAL --no-progress \
                            --format table -o trivy-report.html ${IMAGE_NAME}:${IMAGE_TAG} || true
                    '''
                }
            }
        }

        stage('Start Container') {
            steps {
                script {
                    // Stop and remove existing container if running
                    sh "docker stop ${CONTAINER_NAME} || true"
                    sh "docker rm ${CONTAINER_NAME} || true"
                    
                    // Start new container from the image
                    sh "docker run -d --name ${CONTAINER_NAME} -p 4200:80 ${IMAGE_NAME}:${IMAGE_TAG}"
                }
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: 'trivy-report.html', onlyIfSuccessful: false
            sh "docker rmi ${IMAGE_NAME}:${IMAGE_TAG} || true"
        }
    }
}
