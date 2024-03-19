pipeline {
    agent any
    
    environment {
        KUBECONFIG = '~/.kube/config'
    }
    
    stages {
        stage('Setup') {
            steps {
                sh 'terraform init'
            }
        }
        
        stage('Create KinD Cluster') {
            steps {
                sh 'terraform apply -auto-approve -target=null_resource.create_kind_cluster'
            }
        }
        
        stage('Wait for Cluster') {
            steps {
                sh 'terraform apply -auto-approve -target=null_resource.wait_for_cluster'
            }
        }
        
        stage('Get Cluster Credentials') {
            steps {
                sh 'terraform apply -auto-approve -target=null_resource.get_cluster_credentials'
            }
        }
        
        stage('Deploy Application') {
            steps {
                container('helm') {
                    sh 'helm install my-app /home/bernardo/.cache/helm/repository/my-helm-repo-index.yaml'
                }
            }
        }
        
        stage('Run Tests') {
           steps {
        script {
            sh 'helm install my-app /home/bernardo/.cache/helm/repository/my-helm-repo-index.yaml'
            sh 'kubectl wait --for=condition=available deployment/my-app --timeout=60s'
                }
            }
        }
        
        stage('Destroy KinD Cluster') {
            steps {
                sh 'terraform destroy -auto-approve'
            }
        }
    }

    
    post {
        always {
            sh 'rm kubeconfig.yaml' 
        }
    }
}
