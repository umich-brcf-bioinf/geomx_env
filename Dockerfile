FROM bioconductor/bioconductor_docker:RELEASE_3_14

RUN Rscript -e "\
    BiocManager::install(c(\
        'GeoMxWorkflows')); \
    install.packages(c(\ 
        'EnvStats', \
        'ggiraph', \
        'knitr', \ 
        'scales', \
        'gridExtra', \
        'grid', \
        'ggrepel', \
        'reshape2', \
        'Rtsne', \
        'umap', \
        'readxl', \
        'xlsx', \
        'cowplot', \
        'dplyr', \
        'ggplot2',\
        'ggforce', \
        'patchwork',\
        'reticulate', \
        'randomcoloR', \
        'RColorBrewer', \
        'pheatmap', \
        'tidyverse'));"

RUN Rscript -e "\
    BiocManager::install(c( \
        'DelayedArray', \
        'DelayedMatrixStats', \
        'limma', \
        'SingleCellExperiment', \
        'SummarizedExperiment', \
        'batchelor', \
        'Matrix.utils'));"

RUN Rscript -e "install.packages('metap')"

RUN wget -P /tmp https://repo.anaconda.com/miniconda/Miniconda3-py37_4.8.2-Linux-x86_64.sh && \
    sha256sum /tmp/Miniconda3-py37_4.8.2-Linux-x86_64.sh && \
    bash /tmp/Miniconda3-py37_4.8.2-Linux-x86_64.sh -p /miniconda -b && \
    rm /tmp/Miniconda3-py37_4.8.2-Linux-x86_64.sh

ENV PATH=/miniconda/bin:${PATH}

RUN mkdir -p /root/.local/share && \
    echo "/miniconda/bin/conda" > /root/.local/share/r-miniconda

RUN apt-get update && \
    apt-get install -y libxkbcommon-x11-0 && \
    wget -P /tmp/ https://download1.rstudio.org/desktop/bionic/amd64/rstudio-1.2.5033-amd64.deb && \
    dpkg -i /tmp/rstudio-1.2.5033-amd64.deb

RUN apt-get install -y libboost-all-dev && \
    Rscript -e "\
        BiocManager::install('pcaMethods'); \
        library(devtools); \
        install_github('Nanostring-Biostats/NanoStringNCTools'); \
        install_github('Nanostring-Biostats/GeomxTools'); \
        install_github('Nanostring-Biostats/GeoMxWorkflows');"

