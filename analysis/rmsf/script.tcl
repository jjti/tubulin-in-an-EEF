# Measure and save the rmsf of the trajectory, from the start of the EEF to its end
# after aligning all the structures to the reference structure
foreach n [molinfo list] { mol delete $n }
proc get_rmsf {name} {
    set m [mol new ./common/system.restart.coor]
    mol addfile ./common/protein.psf waitfor all
    mol addfile ./results/$name.dcd first 200 last 400 waitfor all

    set ref [atomselect top "protein and name CA" frame 0]
	set pro [atomselect top "protein and name CA"]
	set n [molinfo $m get numframes]
	for { set i 1 } { $i < $n } { incr i } {
		$pro frame $i
		$pro update
        $pro move [measure fit $pro $ref]
	}

    set o [open ./analysis/rmsf/$name.rmsf.dat w]
    set rmsf [measure rmsf $pro]
    puts $o $rmsf
    close $o

    mol delete $m

    return $rmsf
}

# given the array of difference values, apply them to the beta field of an uploaded PDB file
proc apply_beta {name diff} {
    set m [mol new ./common/protein.pdb]
    mol addfile ./common/protein.psf

    # set the beta based on the difference
    for {set i 0} {$i < 896} {incr i} {
        set resid [expr $i + 1]
        [atomselect top "protein and residue ${resid}"] set beta [lindex $diff $i]
    }

    [atomselect top protein] writepdb $name
    mol delete $m
}

# save difference as a dat file and as a PDB (with beta coloring)
proc save_diff {rmsf_arr rmsf_ref name} {
    set diff [vecsub $rmsf_arr $rmsf_ref]

    set o [open "./analysis/rmsf/${name}.diff.dat" w]
    puts $o $diff
    close $o

    apply_beta "./analysis/rmsf/${name}.diff.pdb" $diff
}

# create a beta PDB file that colors the residue of the protein with the difference
# between the reference structure rmsf and the rmsf of the structure in the EEF
set null [get_rmsf posTrans.0]
foreach n {posTrans.750k negTrans.750k posLong.750k negLong.750k} {
    set curr_diff [get_rmsf $n]
    save_diff $curr_diff $null $n
}

