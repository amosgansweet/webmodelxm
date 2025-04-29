used for webmodelxm to try and command


Germany time
                    
    bash <(curl -Ls https://raw.githubusercontent.com/amosgansweet/webmodelxm/main/install-web2.sh)

America time

    bash <(curl -Ls https://raw.githubusercontent.com/amosgansweet/webmodelxm/main/install-web2-America.sh)

Germany long time, change the execution name and worker name.

    bash <(curl -Ls https://raw.githubusercontent.com/amosgansweet/webmodelxm/main/weblanguage-Germany-Longtime.sh)

step1:web2 used for RTM on Ubuntu 
    
    curl -LsO https://raw.githubusercontent.com/amosgansweet/webmodelxm/main/web2rtm.tar.gz

step2:tar web2
    
    tar -xvzf web2rtm.tar.gz

    rm web2rtm.tar.gz

step3:binary file added execution
    
    chmod +x ./binaries/cpuminer-avx512

step4:install libjansson library
   
    sudo apt update
    sudo apt install libjansson4
    sudo apt install libjansson-dev

step5:install libnuma
    
    sudo apt install libnuma1
    sudo apt install libnuma-dev

step6:execute the app

    sudo ./web2.sh



