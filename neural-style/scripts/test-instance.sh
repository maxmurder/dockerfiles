#!/bin/bash
# tests the installed instance

cd ~/images/content/
wget https://upload.wikimedia.org/wikipedia/commons/thumb/1/12/Buzz_Aldrin_Apollo_Spacesuit.jpg/134px-Buzz_Aldrin_Apollo_Spacesuit.jpg

cd ~/images/styles/
wget https://upload.wikimedia.org/wikipedia/commons/thumb/d/d6/Hs-2009-25-e-full_jpg.jpg/800px-Hs-2009-25-e-full_jpg.jpg

cd ~
nvidia-docker run --rm -v $(pwd):/images neural-style -content_image images/content/134px-Buzz_Aldrin_Apollo_Spacesuit.jpg -style_image images/styles/800px-Hs-2009-25-e-full_jpg.jpg -output_image images/output/Test.png -num_iterations 1 
