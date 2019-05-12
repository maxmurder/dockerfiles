#!/usr/bin/env bash

CONTENT=$1
SWEIGHT="1000"
CWEIGHT="100"
STYLEDIR="images/styles/*"
OUTPUT="images/output/"
RES="512"
NUM="1000"

useage() { printf "Useage: $0 <content image> [opts]\n[-i <style images>]\n[-o <output dir>]\n[-c <content weight>]\n[-s <style weight>]\n[-r <output resolution>]\n[-n number of iterations]\n" 1>&2; exit 0;}

while getopts "h?:c:s:o:i:r:n:" opt; do
    case "${opt}" in
        h|\?) useage
        ;;
        c) CWEIGHT=$OPTARG
        ;;
        s) SWEIGHT=$OPTARG
        ;;
        o) OUTPUT=$OPTARG
        ;;
        i) STYLEDIR=$OPTARG
        ;;
        r) RES=$OPTARG
        ;;
        n) NUM=$OPTARG
        ;;
        
    esac
done

for FILE in $STYLEDIR
do
    FILENAME=$(basename "$FILE")
    echo "Style: $FILENAME"
    OFILE="$OUTDIR/${FILENAME%.*}_output.png"
    docker run --runtime=nvidia --rm -v $(pwd):/images neural-style \
                -save_iter 0 \
                -normalize_gradients \
                -num_iterations $NUM \
                -style_weight $SWEIGHT \
                -content_weight $CWEIGHT \
                -image_size $RES \
                -content_image $CONTENT \
                -style_image $FILE \
                -output_image $OUTPUT      
done
