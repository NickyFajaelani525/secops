pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Terraform Init') {
            steps {
                sh 'terraform init -no-color'
            }
        }

        stage('Terraform Validate') {
            steps {
                sh 'terraform validate -no-color'
            }
        }

        stage('Terraform Plan') {
            steps {
                sh 'terraform plan -no-color'
            }
        }

        stage('Trivy Scan') {
            steps {
                sh '''
                  trivy config . --exit-code 1 --severity CRITICAL
                '''
            }
        }
    }

    post {
        always {
            echo "Pipeline selesai."
        }
    }
}
