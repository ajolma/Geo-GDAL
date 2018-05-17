use v5.10;
use strict;
use warnings;
use File::Basename;
use ExtUtils::MakeMaker;
use Config;
use Cwd;
use PkgConfig;
use Alien::gdal;

my $o = PkgConfig->find('gdal');
if ($o->errmsg) {
    my $dir = Alien::gdal->dist_dir;
    my %options = (search_path_override => [$dir . '/lib/pkgconfig']);
    $o = PkgConfig->find('gdal', %options);
}
if ($o->errmsg) {
    die $o->errmsg;
}
my $prefix = $o->get_var('prefix');
my $libdir = $o->get_var('libdir');
my @cflags = $o->get_cflags;

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

    WriteMakefile( NAME => $module,
                   VERSION_FROM => 'lib/Geo/GDAL.pm',
                   ABSTRACT => 'Perl extension for the GDAL library for geospatial data',
                   AUTHOR => 'Ari Jolma <ari.jolma at gmail.com>',
                   MAKEFILE => 'Makefile_'.$add,
                   LIBS => ["-L$libdir -lgdal"],
                   CCFLAGS => "@cflags",
                   OBJECT => $objects->{$module},
                   PM => \%PM );
}
