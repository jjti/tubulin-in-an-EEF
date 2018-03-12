# this has a dependency script which can be found at:
# http://www.ks.uiuc.edu/Research/vmd/mailing_list/vmd-l/att-2279/fit_angle.tcl
#
# the method is the same as Peng, 2014 PlosOne Comp Bio
proc tubBend {ref_1jff test_tubulin file_name} {

	set ref_a [atomselect $ref_1jff "protein and name CA and chain A and resid 224 to 242"]
	set pro_a [atomselect $test_tubulin "protein and name CA and chain A and resid 224 to 242"]

	set a [atomselect $ref_1jff "protein and name CA and ((chain A and resid 224 to 242) or (chain B and resid 224 to 242))"]
	set b [atomselect $test_tubulin "protein and name CA and ((chain A and resid 224 to 242) or (chain B and resid 224 to 242))"]

	# bend calculation loop
	set output [open $file_name w]
	set n [molinfo $m2 get numframes]
	for {set i 0} {$i < $n} {incr i} {
		molinfo $m2 set frame $i
		$pro move [measure fit $pro_a $ref_a]
		puts $output [sel_sel_angle $a $b]
	}
	close $output
}

foreach n [molinfo list] { mol delete $n }
# load reference structure
set ref [mol new ./analysis/dimer_curvature/1jff.pdb]
foreach d {posTrans.0 posTrans.750k negTrans.750k posLong.750k negLong.750k} {
    set m [mol new ./common/initial.coor]
    mol addfile ./common/protein.psf waitfor all
    mol addfile ./results/$d.dcd waitfor all

	tubBend $ref $m "./analysis/dimer_curvature/${d}.bend.dat"
    mol delete $m
}
mol delete $ref