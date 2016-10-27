#!/bin/bash 
FONT='/Library/Fonts/Lato-Medium.ttf'

##
# Applies a watermark to given an image
##
function watermark {
    let CAPTION_HEIGHT_PERCENT=10

    let IMAGE_WIDTH="$(identify -format %w $1)"
    let IMAGE_HEIGHT="$(identify -format %h $1)"

    let CAPTION_WIDTH=$IMAGE_WIDTH
    let CAPTION_HEIGHT=$IMAGE_HEIGHT*$CAPTION_HEIGHT_PERCENT/100
    let CAPTION_Y_COORDS=$IMAGE_HEIGHT-$CAPTION_HEIGHT

    let FONTSIZE=$CAPTION_HEIGHT*1/3

    convert $1 -strokewidth 0 -fill "rgba( 0, 0, 0 , 0.5 )" -draw "rectangle 0,${CAPTION_Y_COORDS} ${IMAGE_WIDTH},${IMAGE_HEIGHT}" $1_temp_background

    convert -font ${FONT} -pointsize ${FONTSIZE} -background 'transparent' -fill white -gravity east -size ${CAPTION_WIDTH}x${CAPTION_HEIGHT} \
    -geometry -20+0 caption:"http://medium.com/dinomad/" \
    $1_temp_background +swap -gravity south -composite $1_temp_captioned

    convert -font ${FONT} -pointsize ${FONTSIZE} -background 'transparent' -fill white -gravity west -size ${CAPTION_WIDTH}x${CAPTION_HEIGHT} \
    -geometry +20+0 caption:"http://igeni.us/" \
    $1_temp_captioned +swap -gravity south -composite $1_captioned.jpg

    rm -rf $1_temp_background
    rm -rf $1_temp_captioned
}

find $1 -type f -maxdepth 1 \( -iname \*.jpg -o -iname \*.png \) | while read -r file; do
    watermark $file; 
done
