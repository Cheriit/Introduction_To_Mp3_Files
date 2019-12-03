#!/bin/bash 

function showHelp(){

echo -e "\
This script allows you to add introduction to your audio files. 

.\scriptname.sh [PARAMETERS] audio_file_names

\t-e | --end\tAdds introduction at the end of sound file
\t-h | --help\tShows command help
\t-p | --prefix\tAllows you to set custom prefix
\t-t | --text\tAllows you add your own introduction's text
\t-c | --custom\tAllows you to use existing audiofile as introduction

This script requires:
-rwx permissions
-preinstalled:
    -sox
    -espeak
    -carnival
"
}

function generateAudioIntroduction(){
    textToSay=$1
    targetFilePath=$2
    
}

function joinFiles(){
    prefix=$1
    firstFile=$2
    secondFile=$3
    targetPath=$4
}

function joinFiles_main(){
    addAtTheEnd=$1
    prefix=$2
    introductionFile=$3
    originalFile=$4

    if [[ -r "$introductionFile"  && -r "$originalFile" ]]; then

        if [ "$addAtTheEnd" == 0 ];then
            joinFiles $prefix $introductionFile $originalFile $originalFile
        else
            joinFiles $prefix $originalFile $introductionFile $originalFile 
        fi
        if [ "$introductionFile" == "AudioIntroductionTmpFile.mp3"]; then
        rm $introductionFile
        fi
    else

    echo -e "\
    Unable to create or read files. Check read permissions to given file.
    "

    fi
    
}

addAtTheEnd=0
prefix=_
ownText=NULL
introductionFile=AudioIntroductionTmpFile.mp3

if [ "$1" == "" ]; then
    showHelp
else
    while [ "$1" != "" ]; do
        case $1 in
            -e | --end ) 
                addAtTheEnd=1
                ;;
            -h | --help )
                showHelp
                ;;
            -p | --prefix )
                shift
                prefix=$1
                ;;
            -t | --text )
                shift
                ownText=$1
                ;;
            -c | --custom )
                shift
                introductionFile=$1
                ;;
            * )
                if [ "$introductionFile" != "AudioIntroductionTmpFile.mp3" ];then
                    joinFiles_main $addAtTheEnd $prefix $introductionFile $1
                elif [ "$ownText" == "NULL" ]; then
                    generateAudioIntroduction $1 $introductionFile
                    joinFiles_main $addAtTheEnd $prefix $introductionFile $1
                else
                    generateAudioIntroduction $ownText $introductionFile
                    joinFiles_main $addAtTheEnd $prefix $introductionFile $1
                fi
        esac
        shift
    done
fi
