foreach n [molinfo list] { mol delete $n }
foreach name {+0 -50k +50k -100k +100k -200k +200k} {
    # our trajectories for studying the h1-b2 loop were all in a direcotry
    # for magTrans (changing magnitude in transverse direction)
    set dir magTrans
    set m [setup $dir $name]
    set total [atomselect $m all]

    set distance_40 [open ./analysis/h1_b2_loop/$dir.$name.40.H3.dat w]
    set distance_47 [open ./analysis/h1_b2_loop/$dir.$name.47.H3.dat w]
    set n [molinfo $m get numframes]
    for { set i 0 } { $i < $n } { incr i } {
        $total frame $i
        $total update

        # measure the distance between the center of the H3 loop and the residue under study (40 or 47)
        set msd [veclength [vecsub [measure center [atomselect $m "chain A and resid 109 to 128" frame $i]] [measure center [atomselect $m "chain A and resid 40" frame $i]]]]
        puts $distance_40 $msd
        set msd [veclength [vecsub [measure center [atomselect $m "chain A and resid 109 to 128" frame $i]] [measure center [atomselect $m "chain A and resid 47" frame $i]]]]
        puts $distance_47 $msd
    }
    close $distance_40
    close $distance_47

    mol delete $m
}
