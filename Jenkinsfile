node(){
stage("Git clone")
{
git branch: 'devops_ci_pipeline', credentialsId: 'Gitcreds', url: 'https://github.com/muraliphani/RentalCars.git'

}

stage("Sonar Analysis"){
       scannerHome = tool 'SonarQubeScanner'
       withSonarQubeEnv('sonarQubeServer') {
            sh "${scannerHome}/bin/sonar-scanner"
        }
       timeout(time: 10, unit: 'MINUTES') {
            waitForQualityGate abortPipeline: true
        }
}

stage("Maven Build"){
    sh "mvn package"
}

stage("Nexus Upload"){

}

}