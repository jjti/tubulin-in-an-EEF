
set o [mol new ./common/protein.pdb]
mol addfile ./common/protein.psf waitfor all
set aIndexes [[atomselect top "chain A and name CA and helix"] get index]
set bIndexes [[atomselect top "chain B and name CA and helix"] get index]

foreach d {posTrans.0 posTrans.750k negTrans.750k posLong.750k negLong.750k} {
    set m [mol new ./common/protein.pdb]
    mol addfile ./common/protein.psf waitfor all
    mol addfile ./results/$d.dcd waitfor all

    set output [open ./analysis/dimer_stretch/${d}.stretch.dat w]
    set n [molinfo $m get numframes]
    set aAlphas [atomselect $m "chain A and index ${aIndexes}"]
    set bAlphas [atomselect $m "chain B and index ${bIndexes}"]
	for {set i 1} {$i < $n} {incr i} {
		molinfo $m set frame $i
        set a_center [measure center $aAlphas]
        set b_center [measure center $bAlphas]
		set stretch [veclength [vecsub $a_center $b_center]]
		puts $output $stretch
	}
	close $output

    mol delete $m
}