#!/usr/bin/bash
#########################################################################
# File Name: deploy.sh
# Author: zhangzhiqiang

function mydeplay() {
    echo "groupid=$param_group"
    echo "artifactid=$param_artifact"
    echo "packaging=$param_packaging"
    echo "classifier=$param_classifier"
    echo "version=$param_version"
    echo "file=$param_file"
    echo "url=$param_url"
    echo "repository=$param_repository"

    if [ -n $param_classifier ]; then
        mvn deploy:deploy-file \
            -Dfile=${param_file} \
            -DgroupId=${param_group} \
            -DartifactId=$param_artifact \
            -Dversion=$param_version \
            -Dpackaging=$param_packaging \
            -Durl=$param_url \
            -DrepositoryId=$param_repository \
            -Dclassifier=$param_classifier
    else
        mvn deploy:deploy-file \
            -Dfile=${param_file} \
            -DgroupId=${param_group} \
            -DartifactId=$param_artifact \
            -Dversion=$param_version \
            -Dpackaging=$param_packaging \
            -Durl=$param_url \
            -DrepositoryId=$param_repository
    fi


}

function show_deploy_usage_exit() {
    echo -e "Usage: \n\t$0 -g gropid -a artifactid -p packaging [-c classifier] -v version -f file\n"
    exit 1
}

function mydeplay_snapshot() {
    echo $#
    if [ $# -lt 10 ]; then
        echo $#
        show_deploy_usage_exit
    elif [ $# -gt 12 ]; then
        echo $#
        show_deploy_usage_exit
    fi

    while getopts 'g:a:p:c:v:f:' OPT; do
        case $OPT in
            g)
                param_group="$OPTARG";;
            a)
                param_artifact="$OPTARG";;
            p)
                param_packaging="$OPTARG";;
            c)
                param_classifier="$OPTARG";;
            v)
                param_version="$OPTARG";;
            f)
                param_file="$OPTARG";;
            ?)
                show_deploy_usage_exit
        esac
    done

    param_version="$param_version-SNAPSHOT"
    param_url='http://artifactory.360buy-develop.com/libs-snapshots-local/'
    param_repository='libs-snapshots-local'

    mydeplay
}

function mydeplay_release() {
    if [ $# -lt 10 ]; then
        echo $#
        show_deploy_usage_exit
    elif [ $# -gt 12 ]; then
        echo $#
        show_deploy_usage_exit
    fi

    while getopts 'g:a:p:c:v:f:' OPT; do
        case $OPT in
            g)
                param_group="$OPTARG";;
            a)
                param_artifact="$OPTARG";;
            p)
                param_packaging="$OPTARG";;
            c)
                param_classifier="$OPTARG";;
            v)
                param_version="$OPTARG";;
            f)
                param_file="$OPTARG";;
            ?)
                show_deploy_usage_exit
        esac
    done

    param_url='http://artifactory.360buy-develop.com/libs-releases-local/'
    param_repository='libs-releases-local'

    mydeplay
}
