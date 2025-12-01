pipeline {
    agent any

    environment {
        TF_BINARY = '/usr/bin/terraform'
        TRIVY_BINARY = '/usr/bin/trivy'
        TF_IN_AUTOMATION = 'true'
    }

    stages {
	// Stage 1: checkout code dari repo github.....
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

	// Stage 2: inisiasi terraform......
        stage('Terraform Init') {
            steps {
                sh "${TF_BINARY} init"
            }
        }

	// Stage 3: cek validasi kode......
        stage('Terraform Validate') {
            steps {
                sh "${TF_BINARY} validate"
            }
        }

	// Stage 4: terraform plan.....
	// disini kita panggil kredensial yang sudah dibuat di aws untuk user jenkins
        stage('Terraform Plan') {
            steps {
                withCredentials([
                    string(credentialsId: 'aws-access-key', variable: 'AWS_ACCESS_KEY_ID'),
                    string(credentialsId: 'aws-secret-key', variable: 'AWS_SECRET_ACCESS_KEY')
                ]) {
                    sh "${TF_BINARY} plan -out=tfplan"
                }
            }
        }

	// Stage 5: trivy mulai scan kerentanan kode..... (shift-left)
        stage('Trivy Security Scan') {
            steps {
                script {
                    // CATATAN:pastikan hanya bisa di akses oleh ip public gueh saja
                    sh "${TRIVY_BINARY} config . --exit-code 1 --severity HIGH,CRITICAL"
                }
            }
        }

        // Stage 6: eksekusi pembuatan instance ec2........ 
        stage('Terraform Apply') {
            steps {
                withCredentials([
                    string(credentialsId: 'aws-access-key', variable: 'AWS_ACCESS_KEY_ID'),
                    string(credentialsId: 'aws-secret-key', variable: 'AWS_SECRET_ACCESS_KEY')
                ]) {
                    // -auto-approve wajib agar Jenkins tidak minta input manual "yes"
                    sh "${TF_BINARY} apply -auto-approve tfplan"
                }
            }
        }
    }

    // --- PENTING UNTUK TES MERGE 2X ---
    // Saya hapus section 'post { cleanWs() }'.
    // Jangan dihapus manual, biarkan workspace kotor agar file 'terraform.tfstate' tersimpan
    // untuk pembuktian idempotency saat merge kedua.
}
