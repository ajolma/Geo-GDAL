use v5.10;
use strict;
use warnings;
use File::Basename;
use ExtUtils::MakeMaker;
use Config;
use Cwd;
use PkgConfig;
use Alien::Base::Wrapper qw(Alien::gdal !export);

my $objects = { 
    'Geo::GDAL' => 'gdal_wrap.o',
    'Geo::OGR' => 'ogr_wrap.o',
    'Geo::GDAL::Const' => 'gdalconst_wrap.o',
    'Geo::OSR' => 'osr_wrap.o'
};

for my $module (sort keys %$objects) {
    my $add = $module;
    $add =~ s/:/_/g;
    
    my %PM = ( 'lib/Geo/GDAL.pm' => '$(INST_LIBDIR)/GDAL.pm',
               'lib/Geo/OGR.pm' => '$(INST_LIBDIR)/OGR.pm',
               'lib/Geo/OSR.pm' => '$(INST_LIBDIR)/OSR.pm',
               'lib/Geo/GDAL/Const.pm' => '$(INST_LIBDIR)/GDAL/Const.pm' );
    
    $PM{'lib/Geo/GNM.pm'} = '$(INST_LIBDIR)/GNM.pm' if $objects->{'Geo::GNM'};

    WriteMakefile( 
        NAME => $module,
        VERSION_FROM => 'lib/Geo/GDAL.pm',
        ABSTRACT => 'Perl extension for the GDAL library for geospatial data',
        AUTHOR => 'Ari Jolma <ari.jolma at gmail.com>',
        MAKEFILE => 'Makefile_'.$add,
        OBJECT => $objects->{$module},
        PM => \%PM,
        LICENSE => "artistic_2",
        Alien::Base::Wrapper->mm_args,
        CONFIGURE_REQUIRES => {
            'Alien::gdal' => 0
        },
        PREREQ_PM => {
            'Alien::gdal' => 0,
            'PDL' => 0
        },
        TEST_REQUIRES => {
            'Test::More' => 0,
            'JSON' => 0,
            'Data::Dumper' => 0
        },
        META_MERGE => {
            "meta-spec" => { version => 2 },
            resources => {
                repository => {
                    type => 'git',
                    url => 'git://github.com/ajolma/Geo-GDAL.git',
                    web => 'https://github.com/ajolma/Geo-GDAL',
                },
            },
        },);
}
