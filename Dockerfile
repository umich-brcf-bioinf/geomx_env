FROM bioconductor/bioconductor_docker:RELEASE_3_15

RUN Rscript -e "\
    BiocManager::install(version='3.15'); \
    BiocManager::install('NanoStringNCTools'); \
    BiocManager::install('GeomxTools'); \
    BiocManager::install('GeoMxWorkflows');"

RUN Rscript -e "\
    BiocManager::install(c(\
        'AnnotationDbi', \
        'AnnotationFilter', \
        'BiocGenerics', \
        'EnsDb.Mmusculus.v79', \
        'EnsDb.Hsapiens.v75', \
        'GenomeInfoDb', \
        'GenomicFeatures', \
        'GenomicRanges', \
        'ggbio', \
        'IRanges', \
        'motifmatchr', \
        'multtest', \
        'Rsamtools', \
        'S4Vectors', \
        'ggbio', \
        'motifmatchr')); \
    install.packages(c(\  
        'cowplot', \
        'knitr', \
        'ggiraph', \
        'EnvStats', \
        'readxl', \
        'xlsx', \
        'ggforce', \
        'randomcoloR', \
        'RColorBrewer', \
        'pheatmap', \
        'Rtsne', \
        'umap', \
        'dplyr', \
        'ggplot2',\
        'hdf5r',\
        'patchwork',\
        'reticulate', \
        'grid', \
        'gridExtra', \
        'ggrepel', \
        'reshape2', \
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

RUN Rscript -e "\
    library(reticulate); \
    conda_install(env_name='umap-learn', packages='umap-learn');"

RUN apt-get update && \
    apt-get install -y libxkbcommon-x11-0 && \
    wget -P /tmp/ https://download1.rstudio.org/desktop/bionic/amd64/rstudio-1.2.5033-amd64.deb && \
    dpkg -i /tmp/rstudio-1.2.5033-amd64.deb

RUN apt-get install -y libboost-all-dev && \
    Rscript -e "\
        BiocManager::install('pcaMethods');"
