pipeline {
    agent {
        label 'built-in-node'
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout the code from the repository
                git 'https://github.com/forkimenjeckayang/spring_boot_webapp.git'
            }
        }

        stage('Build') {
            steps {
                // Clean and build the project using Maven
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Docker Build') {
            steps {
                script {
                    // Build the Docker image
                    sh 'docker build -t my-spring-boot-app .'
                }
            }
        }
    }

    post {
        always {
            // Clean up resources or notify about build status
            echo 'Cleaning up...'
            sh 'mvn clean'
        }
    }
}
