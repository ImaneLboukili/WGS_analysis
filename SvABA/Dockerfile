# Set the base image to Debian
FROM debian:9.0

# File Author / Maintainer
MAINTAINER **lboukilii** <**lboukilii@students.iarc.fr**>

RUN mkdir -p /var/cache/apt/archives/partial && \
	touch /var/cache/apt/archives/lock && \
	chmod 640 /var/cache/apt/archives/lock && \
	apt-get update -y &&\
	apt-get install -y gnupg2
	
RUN	apt-key adv --keyserver keyserver.ubuntu.com --recv-keys F76221572C52609D && \
	apt-get clean && \
	apt-get update -y && \


  # Install dependences
  DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
  make \
  make install 
  ./configure \
  g++ \
  git \


  
  # Install SvABA
 	git clone --recursive https://github.com/walaj/svaba
	cd svaba
	./configure
	make
	make install
  


  # Remove unnecessary dependences
  DEBIAN_FRONTEND=noninteractive apt-get remove -y \
  make \
  g++ \
  git \


  # Clean
  DEBIAN_FRONTEND=noninteractive apt-get autoremove -y && \
  apt-get clean