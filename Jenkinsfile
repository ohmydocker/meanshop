#!groovy

node {


    git credentialsId: 'thalhallajenkins-github', url: 'https://github.com/Thalhalla/meanshop.git'
    currentBuild.result = "SUCCESS"

    env.NODE_ENV = "test"
    env.NVM_DIR="/var/jenkins_home/.nvm"
    env.PATH="$PATH:$HOME/.rvm/bin"

    try {

       stage('Checkout') {

            checkout scm

      }
       stage('NPM cache') {

            print "Node Cache Sync : ${env.NODE_ENV}"
            sh "bash node-sync.sh"

      }
       stage('NPM Install') {

            print "Environment will be : ${env.NODE_ENV}"

            sh '''#!/bin/bash -l
            [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
            source "$NVM_DIR/nvm.sh"
            npm install -g yo bower grunt-cli
            npm install -g phantomjs-prebuilt --save-dev
            npm install
            '''
      }
       stage('Gem Install') {

            sh '''#!/bin/bash -l
            [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
            source "$NVM_DIR/nvm.sh"
            rvm list
            gem install sass capistrano
            '''
      }
       stage('Bower Install') {

            print "Environment will be : ${env.NODE_ENV}"

            sh '''#!/bin/bash -l
            [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
            source "$NVM_DIR/nvm.sh"
            bower install
            '''

      }
       stage('Test') {

            env.NODE_ENV = "test"

            print "Environment will be : ${env.NODE_ENV}"

            sh "mkdir -p ${WORKSPACE}/data/db"

            sh "killall mongod; mongod --quiet --fork --noauth --pidfilepath ${WORKSPACE}/mongopid --logpath ${WORKSPACE}/data/log --dbpath ${WORKSPACE}/data/db"

            sh '''#!/bin/bash -l
            [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
            source "$NVM_DIR/nvm.sh"
            mkdir /tmp/.X11-unix
            sudo chmod 1777 /tmp/.X11-unix
            export DISPLAY=:99
            XVFB_WHD=${XVFB_WHD:-1280x720x16}
            Xvfb :99 -ac -screen 0 $XVFB_WHD -nolisten tcp &
            xvfb=$!
            grunt test
            '''

            sh "bash killmongo.sh"

      }
       stage('Build Docker') {

            if (env.BRANCH_NAME == "production") {
               sh "bash dockerBuild.sh"
            } else {
               echo 'skiping dockerbuild'
            }

      }
       stage('Deploy') {

            if (env.BRANCH_NAME == "production") {

            echo 'Push to Repo'

            sh '''#!/bin/bash -l
            [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
            source "$NVM_DIR/nvm.sh"
            cap production deploy
            '''

            } else {
               echo 'skiping deploy'
            }

      }
       stage('Cleanup') {

            echo 'prune and cleanup'
            sh 'npm prune'
            sh "bash node-cache.sh"
            sh 'rm node_modules -rf'
            echo 'done'

      }
    }


    catch (err) {

        currentBuild.result = "FAILURE"

        sh "bash killmongo.sh"

        throw err
    }

}
