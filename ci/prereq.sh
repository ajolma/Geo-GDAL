#!/bin/sh

# must use latest released GDAL
#  - sudo add-apt-repository ppa:ubuntugis/ubuntugis-unstable -y
#  - sudo apt-get update
#  - sudo apt-get install libgdal-dev

cpanm --notest Sort::Versions

cpanm --installdeps --notest git://github.com/shawnlaffan/perl-alien-gdal
cpanm --notest Alien::Build::MM
git clone --depth=50 --branch=master https://github.com/shawnlaffan/perl-alien-gdal.git 
cd perl-alien-gdal
perl Makefile.PL
make | perl -ne 'BEGIN {$|=1; open our $log, ">", "build.log"}; print "\n" if 0 == ($. % 90); print "."; print {$log} $_;' || cat build.log
make install
cd ..
rm -rf perl-alien-gdal
