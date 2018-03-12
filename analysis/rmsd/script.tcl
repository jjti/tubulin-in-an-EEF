# calculate the RMSD for the total protein (CA) and then RMSD for the
# residues in secondary structures vs those not in secondary structures
foreach n [molinfo list] { mol delete $n }
foreach d {posTrans.0 posTrans.750k negTrans.750k posLong.750k negLong.750k} {
    set ref_id [mol new ./common/initial.coor]
    mol addfile ./common/protein.psf

    set m [mol new ./common/initial.coor]
    mol addfile ./common/protein.psf

    mol rename $m $d
    [atomselect top all] frame 0

    set total_ref [atomselect $ref_id "protein and name CA"]
    set helix_ref [atomselect $ref_id "protein and name CA and (helix or sheet)"]
    set other_ref [atomselect $ref_id "protein and name CA and not (helix or sheet)"]

    set total [atomselect $m "protein and name CA"]
    set helix [atomselect $m "protein and name CA and (helix or sheet)"]
    set other [atomselect $m "protein and name CA and not (helix or sheet)"]

    mol addfile ./results/$d.dcd waitfor all

    set total_f [open ./analysis/RMSD/$d.total.dat w]
    set helix_f [open ./analysis/RMSD/$d.helix.dat w]
    set other_f [open ./analysis/RMSD/$d.other.dat w]

    # calc RMSD
    set n [molinfo $m get numframes]
	for { set i 0 } { $i < $n } { incr i } {
		$total frame $i
        $total update
        $helix frame $i
        $helix update
        $other frame $i
        $other update
        $total move [measure fit $total $total_ref]
		puts $total_f [measure rmsd $total $total_ref]
        puts $helix_f [measure rmsd $helix $helix_ref]
        puts $other_f [measure rmsd $other $other_ref]
	}
	close $total_f
    close $helix_f
    close $other_f

    mol delete $m
}
