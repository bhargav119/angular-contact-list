pipeline {
    agent {
        label 'node'
    }
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
        stage('Deploy Angular App') {
            steps {
                script {
                    // Assuming the build output is in angular-contact-list/dist/contact
                    sh 'scp -i /home/ubuntu/node-access -r /home/ubuntu/workspace/node-app/dist/contact/* ubuntu@192.168.1.208:/var/www/html'
                }
            }
        }
    }
    post {
        always {
            sh 'rm -rf angular-contact-list'
        }
    }
}
