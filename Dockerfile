FROM httpd:2.4.35

# For testing only
# ADD CentOS-7-x86_64-Minimal-1804.iso /usr/local/apache2/

RUN \
  apt-get update &&\
  apt-get -y install curl createrepo xorriso &&\
  curl 'http://mirrorlist.centos.org/?release=7&arch=x86_64&repo=os&infra=stock' | head -n1 | sed 's@/os/@/isos/@' > baseurl.txt &&\
  curl -LO $(cat baseurl.txt)CentOS-7-x86_64-Minimal-1804.iso &&\
  curl -L $(cat baseurl.txt)sha256sum.txt | grep Minimal > sha256sum.txt &&\
  sha256sum -c sha256sum.txt &&\
  rm sha256sum.txt baseurl.txt &&\
  xorriso -osirrox on -indev CentOS-7-x86_64-Minimal-1804.iso -extract /Packages /usr/local/apache2/htdocs/centos/7.5.1804/os/x86_64/Packages &&\
  xorriso -osirrox on -indev CentOS-7-x86_64-Minimal-1804.iso -extract /RPM-GPG-KEY-CentOS-7 /usr/local/apache2/htdocs/centos/7.5.1804/os/x86_64/RPM-GPG-KEY-CentOS-7 &&\
  createrepo /usr/local/apache2/htdocs/centos/7.5.1804/os/x86_64 &&\
  rm CentOS-7-x86_64-Minimal-1804.iso &&\
  ln -s 7.5.1804 /usr/local/apache2/htdocs/centos/7 &&\
  apt-get -y remove curl createrepo xorriso &&\
  apt-get -y autoremove &&\
  rm -rf /var/lib/apt/lists/*
