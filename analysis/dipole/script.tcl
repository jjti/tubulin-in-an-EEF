# Calculate total dipole magnitude
foreach n [molinfo list] { mol delete $n }
foreach d {posTrans.0 posTrans.750k negTrans.750k posLong.750k negLong.750k} {
    set m [mol new ./common/initial.coor]
    mol addfile ./common/protein.psf waitfor all
    mol addfile ./results/$d.dcd waitfor all

	set o [open ./analysis/DIPOLE/$d.dip.dat w]
	set pro [atomselect top "protein"]
	set n [molinfo $m get numframes]
	
	# calc dipole
	for { set i 1 } { $i < $n } { incr i } {
		$pro frame $i
		$pro update
		puts $o [veclength [measure dipole $pro -debye]]
	}
	close $o

    mol delete $m
}