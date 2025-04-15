pipeline {
    agent any

    environment {
        IMAGE_NAME = "angular-contact-app"
        IMAGE_TAG = "latest"
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
                    sh '''
                        cp angular-contact-list/Dockerfile .
                        docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .
                    '''
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
    }

    post {
        always {
            archiveArtifacts artifacts: 'trivy-report.html', onlyIfSuccessful: false
            sh 'docker rmi ${IMAGE_NAME}:${IMAGE_TAG} || true'
        }
    }
}
