pipeline {
    agent any

    // Definisi Variabel Global sesuai sistem Anda
    environment {
        TF_BINARY = '/usr/bin/terraform'
        TRIVY_BINARY = '/usr/bin/trivy'
        TF_IN_AUTOMATION = 'true'
    }

    stages {
        // Stage 1: Checkout Code dari GitHub
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        // Stage 2: Inisialisasi Terraform
        stage('Terraform Init') {
            steps {
                sh "${TF_BINARY} init"
            }
        }

        // Stage 3: Cek Validitas Kode
        stage('Terraform Validate') {
            steps {
                sh "${TF_BINARY} validate"
            }
        }

        // Stage 4: Terraform Plan (Simulasi)
        // Di sini kita panggil kredensial yang tadi Anda simpan
        stage('Terraform Plan') {
            steps {
                withCredentials([
                    string(credentialsId: 'aws-access-key', variable: 'AWS_ACCESS_KEY_ID'),
                    string(credentialsId: 'aws-secret-key', variable: 'AWS_SECRET_ACCESS_KEY')
                ]) {
                    // Jenkins otomatis menyuntikkan Key ID & Secret Key ke command ini
                    sh "${TF_BINARY} plan -out=tfplan"
                }
            }
        }

        // Stage 5: Trivy Security Scan (Shift-Left)
        // Mengecek apakah kode terraform (IaC) aman atau tidak
        stage('Trivy Security Scan') {
            steps {
                script {
                    // Scan folder saat ini (.)
                    // Jika ada CRITICAL issue, exit code jadi 1 (Pipeline GAGAL/MERAH)
                    sh "${TRIVY_BINARY} config . --exit-code 1 --severity CRITICAL"
                }
            }
        }
    }

    post {
        always {
            // Bersih-bersih workspace setelah selesai
            cleanWs()
        }
    }
}
