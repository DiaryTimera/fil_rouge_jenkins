pipeline {
    agent any

    environment {
        DOCKER_USER = 'diarytimera'
        BACKEND_IMAGE = "${DOCKER_USER}/app-docker-backend"
        FRONTEND_IMAGE = "${DOCKER_USER}/app-docker-frontend"
        MIGRATE_IMAGE = "${DOCKER_USER}/app-docker-migrate"
        SONARQUBE_URL = "https://http://localhost:9000"
        SONARQUBE_TOKEN = credentials("SONAR_TOKEN")
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
                bat 'docker build -t %BACKEND_IMAGE%:latest ./Backend-main/odc'
                bat 'docker build -t %FRONTEND_IMAGE%:latest ./Frontend-main'
                bat 'docker build -t %MIGRATE_IMAGE%:latest ./Backend-main/odc'
            }
        }

        stage("Sonarqube analysis for Backend"){
            agent any
            steps {
                dir("Backend-main/odc") {
                    echo "Analyse SonarQube du backend..."
                    withSonarQubeEnv("SonarQube") {
                        bat "${tool "SonarScanner"}/bin/sonar-scanner -Dsonar.token=$SONARQUBE_TOKEN -Dsonar.host.url=$SONARQUBE_URL"
                    }
                }
            }
        }


        stage("Sonarqube analysis for Frontend"){
            agent any
            steps {
                dir("Frontend-main") {
                    echo "Analyse SonarQube du Frontend..."
                    withSonarQubeEnv("SonarQube") {
                        bat "${tool "SonarScanner"}/bin/sonar-scanner -Dsonar.token=$SONARQUBE_TOKEN -Dsonar.host.url=$SONARQUBE_URL"
                    }
                }
            }
        }

        stage('Push des images sur Docker Hub') {
            steps {
                withDockerRegistry([credentialsId: 'kins', url: '']) {
                    bat 'docker push %BACKEND_IMAGE%:latest'
                    bat 'docker push %FRONTEND_IMAGE%:latest'
                    bat 'docker push %MIGRATE_IMAGE%:latest'
                }
            }
        }

        stage('Déploiement local avec Docker Compose') {
            steps {
                bat '''
                   docker stop backend_app || exit 0
                   docker rm backend_app || exit 0
                   docker stop frontend_app || exit 0
                   docker rm frontend_app || exit 0
                   docker-compose down || exit 0
                   docker-compose pull
                   docker-compose up -d --build
                '''
            }
        }
    }

    post {
        failure {
            mail to: 'diariatoutimera@gmail.com',
                 subject: "❌ Échec du pipeline Jenkins",
                 body: "Le pipeline '${env.JOB_NAME} [#${env.BUILD_NUMBER}]' a échoué. Vérifie les logs ici : ${env.BUILD_URL}"
        }
    }
}
