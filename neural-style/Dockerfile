# Ubuntu Core 14.04 + CUDA + Torch 7 | https://hub.docker.com/r/kaixhin/cuda-torch/
FROM kaixhin/cuda-torch

# setup environment
RUN apt-key adv --fetch-keys http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/7fa2af80.pub
RUN apt-get update
RUN apt-get install --no-install-recommends --no-install-suggests -y libprotobuf-dev protobuf-compiler curl wget
RUN luarocks install loadcaffe

# install neural style
WORKDIR /neural-style
RUN curl -L https://api.github.com/repos/jcjohnson/neural-style/tarball/master | tar -xzf - --strip-components 1

# download models
RUN bash models/download_models.sh
RUN mkdir /models
VOLUME ["/neural-style/models"]

# install scripts
COPY ["/scripts/neural-style.sh", "/neural-style/"]
ENV PATH /neural-style:$PATH

# setup mount point
WORKDIR /images
VOLUME ["/images"]

# set entry point 
ENTRYPOINT ["neural-style.sh"]
CMD ["-backend", "cudnn", "-cudnn_autotune"]
