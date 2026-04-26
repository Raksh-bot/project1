pipeline {
agent any

environment {
    IMAGE_NAME = "raksh100/node-app"
    IMAGE_TAG = "v${BUILD_NUMBER}"
}

stages {

    stage('Debug') {
        steps {
            echo 'Pipeline is working'
            sh 'node -v'
            sh 'npm -v'
        }
    }

    stage('Install Dependencies') {
        steps {
            sh 'npm install'
        }
    }

    stage('Build') {
        steps {
            sh 'npm run build'
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

    stage('Docker Build') {
        steps {
            sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
        }
    }

    stage('Docker Login') {
        steps {
            withCredentials([usernamePassword(credentialsId: 'dockercred', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                sh 'echo $PASS | docker login -u $USER --password-stdin'
            }
        }
    }

    stage('Docker Push') {
        steps {
            sh "docker push ${IMAGE_NAME}:${IMAGE_TAG}"
        }
    }

    stage('Trivy Scan') {
        steps {
            sh "trivy image ${IMAGE_NAME}:${IMAGE_TAG}"
        }
    }

    stage('Deploy to AKS') {
        steps {
            sh """
            helm upgrade --install node-app /home/azuser/node-app \
              --set image.repository=${IMAGE_NAME} \
              --set image.tag=${IMAGE_TAG} \
              --set image.pullPolicy=Always
            """
        }
    }
}


}
