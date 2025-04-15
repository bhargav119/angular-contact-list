pipeline {
    agent any  // Runs on any available agent

    environment {
        PATH = "/usr/local/bin:$PATH"
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

        stage('Trivy Scan') {
            steps {
                script {
                    // Run Trivy against the Angular dist folder
                    // We'll zip it up into a Docker image so Trivy can scan
                    sh '''
                        mkdir -p trivy-temp && \
                        cp -r angular-contact-list/dist/contact/* trivy-temp/ && \
                        cd trivy-temp && \
                        echo -e "FROM scratch\\nCOPY . /app" > Dockerfile && \
                        docker build -t angular-temp:latest . && \
                        trivy image --severity HIGH,CRITICAL --no-progress --format table -o trivy-report.html angular-temp:latest || true
                    '''
                }
            }
        }

        stage('Deploy Angular App') {
            steps {
                script {
                    sh 'scp -i /home/ubuntu/node-access -r /home/ubuntu/workspace/node-app/dist/contact/* ubuntu@192.168.1.208:/var/www/html'
                }
            }
        }
    }

    post {
        always {
            sh 'rm -rf angular-contact-list trivy-temp || true'
        }
    }
}
