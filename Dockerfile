FROM nvidia/cuda:latest

LABEL version="0.1"
LABEL description="Devananda's build env for Jupyter and FastAI work"
LABEL maintainer="Devananda van der Veen"

# install system prereq's
RUN apt-get update && apt-get install --no-install-recommends -y \
  	bc \
  	cmake \
    wget \
    bzip2 \
  	g++ \
  	libffi-dev \
  	libjpeg-dev \
  	libopenjpeg5 \
  	libpng12-dev \
  	libssl-dev \
  	libtiff5-dev \
    libsm6 \
    libxext6 \
    libxrender1
RUN apt-get clean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/*


WORKDIR /root

# install conda
RUN wget --https-only --no-check-certificate --quiet https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    bash Miniconda3-latest-Linux-x86_64.sh -b -p /usr/local -u && \
    rm Miniconda3-latest-Linux-x86_64.sh

# install python libraries
RUN conda update -n base conda

# Set up notebook config
COPY jupyter_notebook_config.py /root/.jupyter/
COPY fastai.yml /root
RUN  conda env update -f fastai.yml

RUN echo ". /usr/local/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate fastai" >> ~/.bashrc

EXPOSE 8888

WORKDIR /notebooks/

SHELL ["/bin/bash"]
ENV PATH /usr/local/envs/fastai/bin:$PATH
CMD ["jupyter", "notebook", "--allow-root", "--no-browser", "--no-mathjax", "--port", "8888", "--ip", "0.0.0.0"]
