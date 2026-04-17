pipeline {
    agent any

    stages {
        stage('Debug') {
            steps {
                echo 'Pipeline is working'
                sh 'node -v'
                sh 'npm -v'
            }
        }
        stage('Install dependency'){
            steps{
                sh 'npm install'
            }
        }
        stage('Build')
        {
            steps{
                sh 'npm run build || echo "No build step defined"'
            }
        }
        stage('SonarQube Scan') {
            steps {
                withSonarQubeEnv('sonarqube') {
                    withCredentials([string(credentialsId: 'sonar-token', variable: 'SONAR_TOKEN')]) {
                        sh '''
                        sonar-scanner \
                        -Dsonar.projectKey=node-app \
                        -Dsonar.sources=. \
                        -Dsonar.login=$SONAR_TOKEN
                        '''
                    }
                }
            }
        }
        stage('Docker build'){
            steps {
                sh 'docker build -t node-app:latest .'
            }
        }
        stage('trivy'){
            steps{
                sh 'trivy image node-app:latest'
            }
        }
    }
}

//e
