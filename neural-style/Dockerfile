FROM kaixhin/cuda-torch

//setup environment
RUN set -ex && \
	apt-get update && \
	apt-get install --no-install-recommends --no-install-suggests -y libprotobuf-dev protobuf-compiler wget && \
	rm -rf /var/lib/apt/lists/* 
RUN luarocks install loadcaffe

//install neural style
WORKDIR /
RUN set -ex && \
	wget https://github/jcjohnson/neural-style/archive/master.tar.gz && \
	tar -xzf master.tar.gz && \
	mv neural-style-master neural-style && \
	rm master.tar.gz

//install models
WORKDIR neural-style
RUN bash models/download_models.sh
RUN mkdir /models
VOLUME ["/neural-style/models"]

//setup images dir
VOLUME ["/images"]
ENV PATH /neural-style:$PATH
