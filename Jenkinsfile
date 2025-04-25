pipeline {
    agent any

    environment {
        DOCKER_USER = 'diarytimera'
        BACKEND_IMAGE = "${DOCKER_USER}/app-docker-backend"
        FRONTEND_IMAGE = "${DOCKER_USER}/app-docker-frontend"
        MIGRATE_IMAGE = "${DOCKER_USER}/app-docker-migrate"
    }

    stages {
        stage('Cloner le dépôt') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/DiaryTimera/fil_rouge_jenkins.git'
            }
        }
        stage('Build des images') {
            steps {
                bat 'docker build -t $BACKEND_IMAGE:latest ./Backend-main/odc'
                bat 'docker build -t $FRONTEND_IMAGE:latest ./Frontend-main'
                bat 'docker build -t $MIGRATE_IMAGE:latest ./Backend-main/odc'
            }
        }

        stage('Push des images sur Docker Hub') {
            steps {
                withDockerRegistry([credentialsId: 'kins', url: '']) {
                    bat 'docker push $BACKEND_IMAGE:latest'
                    bat 'docker push $FRONTEND_IMAGE:latest'
                    bat 'docker push $MIGRATE_IMAGE:latest'
                }
            }
        }

        stage('Déploiement local avec Docker Compose') {
            steps {
                bat '''
                    docker-compose down || true
                    docker-compose pull
                    docker-compose up -d --build
                '''
            }
        }
    }

    post {
        failure {
            mail to: 'ton.email@example.com',
                 subject: "❌ Échec du pipeline Jenkins",
                 body: "Le pipeline '${env.JOB_NAME} [#${env.BUILD_NUMBER}]' a échoué. Vérifie les logs ici : ${env.BUILD_URL}"
        }
    }
}
