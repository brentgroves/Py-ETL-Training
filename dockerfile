#
#   ref https://github.com/tebeka/pythonwise/blob/master/docker-miniconda/Dockerfile
#
#   miniconda vers: http://repo.continuum.io/miniconda
#   sample variations:
#     Miniconda3-latest-Linux-armv7l.sh
#     Miniconda3-latest-Linux-x86_64.sh
#     Miniconda3-py38_4.10.3-Linux-x86_64.sh
#     Miniconda3-py37_4.10.3-Linux-x86_64.sh
#
#   py vers: https://anaconda.org/anaconda/python/files
#   tf vers: https://anaconda.org/anaconda/tensorflow/files
#   tf-mkl vers: https://anaconda.org/anaconda/tensorflow-mkl/files
# https://hub.docker.com/_/ubuntu?tab=tags&page=1&name=20.04

# ARG UBUNTU_VER=18.04
ARG UBUNTU_VER=20.04
ARG CONDA_VER=latest
ARG OS_TYPE=x86_64
ARG PY_VER=3.10
ARG TF_VER=2.5.0
ARG ZEEP_VER=4.1.0
ARG PYODBC_VER=4.0.32 
ARG PANDAS_VER=1.4.2
FROM ubuntu:${UBUNTU_VER}
# FROM ubuntu:20.04


# https://futurestud.io/tutorials/ubuntu-debian-fix-sudo-command-not-found
# Open question.  Do I need to run as non-root user
# https://code.visualstudio.com/remote/advancedcontainers/add-nonroot-user#:~:text=Many%20Docker%20images%20use%20root,that%20you%20should%20know%20about.
# RUN apt-get install sudo -y 

# had problems installing all of this on one layer.

RUN apt-get update && apt-get install -yq \
  ksh \
  apt-utils \
  apt-transport-https \
  ca-certificates \
  neofetch \
  software-properties-common \
  curl \
  wget \
  dnsutils \
  iputils-ping \
  netcat \
  tree \
  curl \
  vim \
  jq \
  msmtp \
  msmtp-mta \
  mailutils \ 
  bsd-mailx \
  cron \
  && rm -rf /var/lib/apt/lists/*


# Setup mail utility
COPY ./msmtprc /etc/msmtprc
COPY ./mail.rc /etc/mail.rc
COPY ./aliases /etc/aliases

# Setup cron utility
RUN touch /var/log/cron.log
COPY ./hello-cron /etc/cron.d/hello-cron
RUN chmod 0644 /etc/cron.d/hello-cron
# only one of these files can be active at a time
RUN crontab /etc/cron.d/hello-cron

COPY ./email-cron /etc/cron.d/email-cron
RUN chmod 0644 /etc/cron.d/email-cron
# RUN crontab /etc/cron.d/email-cron

COPY ./log-email-cron /etc/cron.d/log-email-cron
RUN chmod 0644 /etc/cron.d/log-email-cron
# RUN crontab /etc/cron.d/log-email-cron


# Add microsoft repo 
RUN curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN curl https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/prod.list > /etc/apt/sources.list.d/mssql-release.list
RUN apt-get update

# Install Microsoft odbc utilities for Busche-sql which requires the older driver.
RUN DEBIAN_FRONTEND=noninteractive ACCEPT_EULA=Y apt-get install -y msodbcsql17
RUN DEBIAN_FRONTEND=noninteractive ACCEPT_EULA=Y apt-get install -y mssql-tools
RUN echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc

# Install Microsoft odbc utilities for Azure SQL which requires the older driver.
RUN DEBIAN_FRONTEND=noninteractive ACCEPT_EULA=Y apt-get install -y msodbcsql18
RUN DEBIAN_FRONTEND=noninteractive ACCEPT_EULA=Y apt-get install -y mssql-tools18
RUN echo 'export PATH="$PATH:/opt/mssql-tools18/bin"' >> ~/.bashrc
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y unixodbc-dev

# RUN apt-get install -y powershell

# Use the above args during building https://docs.docker.com/engine/reference/builder/#understand-how-arg-and-from-interact
ARG CONDA_VER
ARG OS_TYPE
# Install miniconda to /miniconda
RUN curl -LO "http://repo.continuum.io/miniconda/Miniconda3-${CONDA_VER}-Linux-${OS_TYPE}.sh"
RUN bash Miniconda3-${CONDA_VER}-Linux-${OS_TYPE}.sh -p /miniconda -b
RUN rm Miniconda3-${CONDA_VER}-Linux-${OS_TYPE}.sh
ENV PATH=/miniconda/bin:${PATH}
RUN conda update -y conda

ARG PY_VER
ARG ZEEP_VER
ARG PYODBC_VER 
ARG PANDAS_VER

# Install packages from conda and downgrade py (optional).
RUN conda install -c anaconda -y python=${PY_VER}
RUN conda install -c anaconda -y \
    pyodbc=${PYODBC_VER} \ 
    pandas=${PANDAS_VER}

RUN conda install -c conda-forge -y \
    zeep=${ZEEP_VER} 
# RUN conda install -c anaconda -y \
#     tensorflow-mkl=${TF_VER} \
#     && pip install pyyaml pandas

WORKDIR /app
COPY *.py ./
COPY *.wsdl ./
COPY PROGRESS_DATADIRECT_OPENACCESS_OAODBC_8.1.0.HOTFIX_LINUX_64.tar .
RUN tar -xf PROGRESS_DATADIRECT_OPENACCESS_OAODBC_8.1.0.HOTFIX_LINUX_64.tar
COPY ./PlexDriverInstall.py ./


RUN python PlexDriverInstall.py 
COPY ./odbc.ini /etc/
COPY ./odbc64.ini /usr/oaodbc81/

ENV LD_LIBRARY_PATH="/usr/oaodbc81/lib64"
ENV OASDK_ODBC_HOME="/usr/oaodbc81/lib64"
ENV ODBCINI="/usr/oaodbc81/odbc64.ini"

# https://blog.yaakov.online/kubernetes-getting-pods-to-talk-to-the-internet/#:~:text=If%20you%20install%20this%20with,make%20connections%20to%20the%20Internet.
# some devs like to let it hang https://stackoverflow.com/a/42873832/868736
# ENTRYPOINT ["tail", "-f", "/dev/null"]
# CMD [ "python", "soapTest.py" ]
ENTRYPOINT cron start && tail -f /var/log/cron.log