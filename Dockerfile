# base on version 3.5.0 of rocker/verse
FROM rocker/verse:3.5.0

# add my name
LABEL maintainer="James Black <james.black.jb2@roche.com>"

# System libs
RUN apt-get update \
  && apt-get install -y libnlopt-dev &&\ 
  apt-get install -my wget gnupg && \
  apt-get install -y --no-install-recommends \
    lbzip2 \
    libfftw3-dev \
    libgdal-dev \
    libgeos-dev \
    libgsl0-dev \
    libgl1-mesa-dev \
    libglu1-mesa-dev \
    libhdf4-alt-dev \
    libhdf5-dev \
    liblwgeom-dev \
    libproj-dev \
    libnetcdf-dev \
    libsqlite3-dev \
    libssl-dev \
    libudunits2-dev \
    tk-dev \
    unixodbc-dev &&\
    mkdir /usr/share/fonts/external/  # ensure that external fonts folder exists

# Install Java
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections &&\
  echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee /etc/apt/sources.list.d/webupd8team-java.list &&\
  echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee -a /etc/apt/sources.list.d/webupd8team-java.list &&\
  apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886 &&\
  apt-get update &&\
  apt-get install oracle-java8-installer -y &&\
  apt-get clean &&\
  JAVA_HOME /usr/lib/jvm/java-8-oracle &&\
  R CMD javareconf 

# Update font cache
RUN fc-cache -f -v

# Install other libraries
RUN install2.r --error \
        assertthat \
        caret cem CBPS crayon \
        dataMaid descr DT \
        flexdashboard foreach forestmodel formattable \
        GGally gbm ggbeeswarm ggforce ggthemes ggrepel glmnet \
        ipw \
        kableExtra \
        lintr \
        numDeriv nnet \
        pander  plotly PSAgraphics   \
        kableExtra \
        Matching Matrix mice \
        rgenoud rJava RJDBC \
        shiny stargazer survey survminer survival \
        tableone \
        VIM vcd viridisLite
# render repos not versioned
RUN R -e "devtools::install_github('rstudio/blogdown')"
RUN R -e "devtools::install_github('o2r-project/containerit')"
RUN R -e "devtools::install_github('wch/harbor')"
RUN R -e "blogdown::install_hugo()"
