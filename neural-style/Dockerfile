# https://github.com/albarji/neural-style-docker
FROM kaixhin/cuda-torch

# setup environment
RUN set -ex && \
	apt-get update && \
	apt-get install --no-install-recommends --no-install-suggests -y libprotobuf-dev protobuf-compiler curl && \
	rm -rf /var/lib/apt/lists/* 
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
ENTRYPOINT ["sh", "-c", "neural-style.sh"]
CMD ["-backend", "cudnn", "-cudnn_autotune"]
