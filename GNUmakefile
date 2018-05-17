all: build

Makefiles:
	perl Makefile.PL

build: Makefiles
	$(MAKE) -f Makefile_Geo__GDAL
	$(MAKE) -f Makefile_Geo__GDAL__Const
	$(MAKE) -f Makefile_Geo__OSR
	if [ -f Makefile_Geo__OGR ]; then $(MAKE) -f Makefile_Geo__OGR; fi
	if [ -f Makefile_Geo__GNM ]; then $(MAKE) -f Makefile_Geo__GNM; fi

test: build
	$(MAKE) -f Makefiles test

install: build
	$(MAKE) -f Makefile_Geo__GDAL install
	$(MAKE) -f Makefile_Geo__GDAL__Const install
	$(MAKE) -f Makefile_Geo__OSR install
	if [ -f Makefile_Geo__OGR ]; then $(MAKE) -f Makefile_Geo__OGR install; fi
	if [ -f Makefile_Geo__GNM ]; then $(MAKE) -f Makefile_Geo__GNM install; fi

dist: Makefiles
	$(MAKE) -f Makefile_Geo__GDAL dist

clean:
	-rm -f gdal.bs gdal_wrap.o
	-rm -f gdalconst.bs gdalconst_wrap.o
	-rm -f ogr.bs ogr_wrap.o
	-rm -f osr.bs osr_wrap.o
	-rm -f gnm.bs gnm_wrap.o
	-rm -rf blib
	-rm -f pm_to_blib
	-rm -f Makefile_Geo__GDAL Makefile_Geo__GDAL__Const Makefile_Geo__OGR Makefile_Geo__OSR Makefile_Geo__GNM
	-rm -rf doc
	-rm -f MYMETA.*

doc: .FORCE

.FORCE:
	perl parse-for-doxygen.pl > all.pm; doxygen; rm -f all.pm
