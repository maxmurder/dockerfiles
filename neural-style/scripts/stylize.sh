#!/usr/bin/env bash

useage() { printf "Useage: $0\n[-m <string>] machine name\n[-c <string>] content image path\n[-s <string>] style image path\n[-o <string>] output image path\n[-r <string>] output image size\n" 1>&2; exit 1;}

MACHINENAME="aws-neural-style-01"
RESOLUTION=512
OUTPUT="~/Downloads/output/"

while getopts ":hm:c:s:o:r:" opt; do
    case "${opt}" in
        h)
            useage
            ;;
        m)
            MACHINENAME=$OPTARG
            ;;
        c)
            CONTENT=$OPTARG
            ;;
        s)
            STYLE=$OPTARG
            ;;
        o)
            OUTPUT=$OPTARG
            ;;
        r)
            RESOLUTION=$OPTARG
            ;;
        *)
            useage
            ;; 
    esac
done

FILENAME=$(basename "$CONTENT")

docker-machine start $MACHINENAME
docker-machine scp -r $CONTENT $MACHINENAME:images/content/
docker-machine scp -r $STYLE $MACHINENAME:images/style/
docker-machine ssh $MACHINENAME neural-style/scripts/batch-run.sh images/content/$FILENAME -r $RESOLUTION
docker-machine scp -r $MACHINENAME:images/output/ $OUTPUT
docker-machine stop $MACHINENAME
