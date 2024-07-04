pipeline {
    agent any

    environment {
        SONARQUBE_URL = 'http://localhost:9001'
        SONARQUBE_CREDENTIALS = 'sonartok' // Set this in Jenkins credentials
        NEXUS_URL = 'localhost:8081'
        NEXUS_CREDENTIALS = 'nexus-credentials-id' // Set this in Jenkins credentials
        DOCKER_IMAGE = 'your-docker-image-name'
        DOCKER_REGISTRY = 'your-docker-registry'
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/thaythem/devops-project.git'
            }
        }

        stage('Compile') {
            steps {
                sh 'mvn compile'
            }
        }
        stage('Build') {
            steps {
                sh 'mvn clean package'
            }
        }
        stage('check pwd'){
            steps{
                sh 'tree .'
            }
        }
        stage('SonarQube Analysis') {
            steps {
                script {
                    withSonarQubeEnv('SonarQube') {
                        sh 'mvn sonar:sonar -Dsonar.projectKey=your-project-key -Dsonar.host.url=$SONARQUBE_URL -Dsonar.login=admin -Dsonar.password=haythem'
                    }
                }
            }
        }

        stage('Upload to Nexus') {
            steps {
                nexusArtifactUploader(
                    nexusVersion: 'nexus3',
                    protocol: 'http',
                    nexusUrl: "$NEXUS_URL",
                    groupId: 'com.example',
                    version: '1.0.0-SNAPSHOT',
                    repository: 'maven-snapshots', // Use maven-snapshots for SNAPSHOT versions
                    credentialsId: "$NEXUS_CREDENTIALS",
                    artifacts: [
                        [artifactId: 'eventsProject', classifier: '', file: 'target/eventsProject-1.0.0-SNAPSHOT.jar', type: 'jar']
                    ]
                )
            }
        }

        stage('Docker Build and Push') {
            steps {
                script {
                    sh 'docker build -t timou123/eventsProject:${BUILD_NUMBER} .'
                    sh 'docker login -u haythemtm -p haythem123'
                    sh 'docker push timou123/eventsProject:${BUILD_NUMBER}'
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    sh 'docker-compose down'
                    sh 'docker-compose up -d'
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }    
}
