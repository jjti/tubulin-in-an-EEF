foreach n [molinfo list] { mol delete $n }
proc get_final_position {name} {
    set m [mol new ./common/system.restart.coor]
    mol addfile ./common/protein.psf waitfor all

    # the 400th frame is the last during the application of an EEF
    # the EEF was applied between the 200 and 400th frame
    mol addfile ./results/$name.dcd first 400 last 400 waitfor all
	set pro [atomselect top "protein"]

    # ref is initial
    set ref [atomselect top "protein" frame 0]
    $pro update

    # move back to initial
    $pro move [measure fit $pro $ref]
    $pro writepdb ./analysis/deviation/$name.final.pdb

    mol delete $m

    set m [mol new ./analysis/deviation/$name.final.pdb]
    mol rename $m $name
    return $m
}

# create a beta PDB file that colors the residue of the protein with the difference
# between the reference structure RMSF and the RMSF of the structure in the EEF
# get_final_position posTrans.0
proc find_difference {name_1 name_2} {
    set pos [get_final_position $name_1]
    set neg [get_final_position $name_2]

    set pos_m [atomselect $pos "name CA"]
    set neg_m [atomselect $neg "name CA"]

    set d [open ./$name_1.$name_2.deviation.dat w]
    set total_resids [$pos_m num]
    for {set i 0} {$i < $total_resids} {incr i} {
        puts $d [veclength [vecsub [lindex [$pos_m get {x y z}] $i] [lindex [$neg_m get {x y z}] $i]]]
    }
    close $d
}

# find_difference posTrans.750k negTrans.750k
# find_difference posLong.750k negLong.750k
