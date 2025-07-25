pipeline {
  agent {
    docker {
      image 'kishgi/maven-docker-agent:v1'
      args '--user root -v /var/run/docker.sock:/var/run/docker.sock' // mount Docker socket to access the host's Docker daemon
    }
  }
  stages {
    stage('Clean Workspace') {
      steps {
        sh 'rm -rf target'
      }
    }
    stage('Checkout') {
      steps {
        git branch: 'main', url: 'https://github.com/kishgi/java-app.git'
      }
  }
    stage('Build and Test') {
      steps {
        // sh 'ls -ltr'
        // build the project and create a JAR file
        sh 'mvn clean package'
      }
    }
    stage('Static Code Analysis') {
      environment {
        SONAR_URL = "http://172.17.0.1:9000"
      }
      steps {
        withCredentials([string(credentialsId: 'sonarqube', variable: 'SONAR_AUTH_TOKEN')]) {
          sh 'mvn sonar:sonar -Dsonar.login=$SONAR_AUTH_TOKEN -Dsonar.host.url=${SONAR_URL}'
        }
      }
    }
    stage('Build and Push Docker Image') {
      environment {
        DOCKER_IMAGE = "kishgi/java-app:${BUILD_NUMBER}"
        // DOCKERFILE_LOCATION = "java-maven-sonar-argocd-helm-k8s/spring-boot-app/Dockerfile"
        REGISTRY_CREDENTIALS = credentials('docker-cred')
      }
      steps {
        script {
            sh 'docker build -t ${DOCKER_IMAGE} .'
            def dockerImage = docker.image("${DOCKER_IMAGE}")
            docker.withRegistry('https://index.docker.io/v1/', "docker-cred") {
                dockerImage.push()
            }
        }
      }
    }
    stage('Update Deployment File') {
  environment {
    GIT_REPO_NAME = "java-app"
    GIT_USER_NAME = "kishgi"
  }
  steps {
    withCredentials([string(credentialsId: 'github', variable: 'GITHUB_TOKEN')]) {
      sh '''
        git config user.email "kishgi1234@gmail.com"
        git config user.name "kishgi"
        sed -i "s/replaceImageTag/${BUILD_NUMBER}/g" manifests/deployment.yaml
        git add manifests/deployment.yaml
        git commit -m "Update deployment image to version ${BUILD_NUMBER}" || echo "No changes to commit"
        git push https://${GITHUB_TOKEN}@github.com/${GIT_USER_NAME}/${GIT_REPO_NAME}.git HEAD:main
      '''
    }
  }
}
  }
}