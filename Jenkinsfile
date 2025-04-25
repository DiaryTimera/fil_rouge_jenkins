pipeline {
    agent any

    environment {
        DOCKER_USER = 'utilisateur docker'
        BACKEND_IMAGE = "${DOCKER_USER}/backend_app"
        FRONTEND_IMAGE = "${DOCKER_USER}/frontend_app"
        MIGRATE_IMAGE = "${DOCKER_USER}/migrate_1"
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
                sh 'docker build -t $BACKEND_IMAGE:latest ./Backend-main/odc'
                sh 'docker build -t $FRONTEND_IMAGE:latest ./Frontend-main'
                sh 'docker build -t $MIGRATE_IMAGE:latest ./Backend-main/odc'
            }
        }

        stage('Push des images sur Docker Hub') {
            steps {
                withDockerRegistry([credentialsId: 'kins', url: '']) {
                    sh 'docker push $BACKEND_IMAGE:latest'
                    sh 'docker push $FRONTEND_IMAGE:latest'
                    sh 'docker push $MIGRATE_IMAGE:latest'
                }
            }
        }

        stage('Déploiement local avec Docker Compose') {
            steps {
                sh '''
                    docker-compose down || true
                    docker-compose pull
                    docker-compose up -d --build
                '''
            }
        }
    }

    post {
        success {
            mail to: 'tmra@gmail.com',
                 subject: "reussite",
                 body: "L'application a été déployée."
        }
        failure {
            mail to: 'tmra@gmail.com',
                 subject: "❌ Échec",
                 body: "Une erreur s’est produite"
        }
    }
}
