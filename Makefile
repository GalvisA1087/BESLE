all: get prepare install

get: 
	@echo "Step 0: Cleaning up any partial downloads before starting..."
	@rm -rf ThirdParty-Mumps scalapack scotch voro++ triangle
	
	@echo "Step 1: Downloading the third party software..."
	
	@echo "Step 1.1: Download MUMPS..."
	@echo "Download ThirdParty-Mumps, which in turn will serve to download the latest version of MUMPS"
	git clone https://github.com/coin-or-tools/ThirdParty-Mumps.git
	@echo "Download the latest version of MUMPS vis ThirdParty-Mumps"
	cd ThirdParty-Mumps \
	&& ./get.Mumps
		
	@echo "Step 1.2: Download ScaLapack"
	git clone https://github.com/Reference-ScaLAPACK/scalapack.git
		
	@echo "Step 1.3: Download Scotch"
	git clone https://github.com/live-clones/scotch.git
		
	@echo "Step 1.4: Download voro++"
	git clone https://github.com/chr1shr/voro.git voro++
		
	@echo "Step 1.5: Download triangle"
	git clone https://github.com/PhilipLudington/Triangle.git triangle
	
	
prepare:
	@echo "Step 2: Place the downloaded packages into their respective folders"
	
	@echo "Step 2.1: Copy the MUMPS directory into the BESLE_ROOT"
	cp -r ThirdParty-Mumps/MUMPS BESLE_ROOT
	@echo "Step 2.2: Delete ThirdParty-Mumps"
	sudo rm -r ThirdParty-Mumps
	
	@echo "Step 2.3: Copy the scalapack folder into the MUMPS root"
	mv scalapack BESLE_ROOT/MUMPS
	
	@echo "Step 2.4: Copy the scotch folder into the MUMPS root"
	mv scotch BESLE_ROOT/MUMPS
	
	@echo "Step 2.5: Move voro++ to the BESLE_ROOT/Mesh/Polycrystal folder"
	mv voro++ BESLE_ROOT/Mesh/Polycrystal
	
	@echo "Step 2.6: Move triangle to the BESLE_ROOT/Mesh/Polycrystal folder"
	mv triangle BESLE_ROOT/Mesh/Polycrystal
	
	
	
	
	@echo "Step 3: Place the configuration files in their respective folders"
	
	@echo "Step 3.1: Makefile.inc.scotch"
	cp BESLE_ROOT/Make.inc/Makefile.inc.scotch BESLE_ROOT/MUMPS/scotch/src
	cd BESLE_ROOT/MUMPS/scotch/src \
	&& mv Makefile.inc.scotch Makefile.inc
	
	@echo "Step 3.2: SLmake.inc.scalapack"
	cp BESLE_ROOT/Make.inc/SLmake.inc.scalapack BESLE_ROOT/MUMPS/scalapack
	cd BESLE_ROOT/MUMPS/scalapack \
	&& mv SLmake.inc.scalapack SLmake.inc
	
	@echo "Step 3.3: Copy MUMPS configuration files"
	cp BESLE_ROOT/Make.inc/Makefile.inc.MUMPS_Install BESLE_ROOT/MUMPS
	cp BESLE_ROOT/Make.inc/Makefile.inc.MUMPS_Run BESLE_ROOT/MUMPS





install:
	@echo "Step 4: Installation"
	
	@echo "Step 4.1: Install scotch"
	@echo "enter the scoctch source directory"
	cd BESLE_ROOT/MUMPS/scotch/src \
	&& make ptscotch \
	&& make scotch \
	&& make esmumps \
	&& make ptesmumps
	
	@echo "Step 4.2: Install scalapack"
	cd BESLE_ROOT/MUMPS/scalapack \
	&& make #enter the scalapack directory and call make
	
	@echo "Step 4.3: Install MUMPS"
	@echo "enter the MUMPS directory"
	cd BESLE_ROOT/MUMPS \
	&& : "rename the MUMPS installation config makefile" \
	&& mv Makefile.inc.MUMPS_Install Makefile.inc \
	&& : "install MUMPS" \
	&& make all \
	&& : "restore the MUMPS installation makefile name to avoid naming conflict" \
	&& mv Makefile.inc Makefile.inc.MUMPS_Install \
	&& : "rename the MUMPS Makefile.inc for running" \
	&& mv Makefile.inc.MUMPS_Run Makefile.inc
	
	@echo "Step 4.4: Install BESLE"
	cd BESLE_ROOT \
	&& make
		
	@echo "Step 4.5: Install voro++"
	cd BESLE_ROOT/Mesh/Polycrystal/voro++ \
	&& make \
	&& sudo make install
	
	@echo "Step 4.6: Install polycrystal"
	cd BESLE_ROOT/Mesh/Polycrystal \
	&& make 
	
	@echo "============ INSTALLATION COMPLETED ====================="
	
	
uninstall:
	@echo "Clean Polycrystal Folder"
	cd BESLE_ROOT/Mesh/Polycrystal \
	&& make clean \
		
	@echo "Clean scotch"
	cd BESLE_ROOT/MUMPS/scotch/src \
	&& make clean
	
	@echo "Clean scalapack"
	cd BESLE_ROOT/MUMPS/scalapack \
	&& make clean
	
	@echo "Clean MUMPS"
	cd BESLE_ROOT/MUMPS \
	&& make clean \
		
	@echo "Clean BESLE"
	cd BESLE_ROOT \
	&& make clean \
	
	
clean:
	@echo "Cleaning up partial downloads..."
	@rm -rf ThirdParty-Mumps scalapack scotch voro++ triangle
