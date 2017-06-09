#!/bin/bash

th /neural-style/neural_style.lua -prota_file /neural-style/models/VGG_ILSVRC_19_layers_deploy.prototxt -model_file /neural-style/models/VGG_ILSVRC_19_layers.caffemodel "$@"
