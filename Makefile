all: install

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
	

