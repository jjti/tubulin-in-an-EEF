# calculate the secondary structure of each file for the duration of the applied
# external electric field
foreach n [molinfo list] { mol delete $n }
foreach d {posTrans.0 posTrans.750k negTrans.750k posLong.750k negLong.750k} {
    set m [mol new ./common/protein.pdb]
    mol addfile ./common/protein.psf waitfor all
    mol addfile ./results/$d.dcd waitfor all

    mol rename $m $d

    set helix_f [open ./analysis/secondary_structure/$d.helix.dat w]
    set sheet_f [open ./analysis/secondary_structure/$d.sheet.dat w]

    set numframes [molinfo top get numframes] 
    set sel [atomselect top "name CA"] 
    for {set frame 0} {$frame < $numframes} {incr frame} { 
        animate goto $frame 
        vmd_calculate_structure top 
        $sel frame $frame 
        $sel update 
        set helixlist [$sel get alpha_helix] 
        set sheetlist [$sel get sheet] 
        set helixcount 0 
        foreach i $helixlist { incr helixcount $i } 
        set sheetcount 0 
        foreach i $sheetlist { incr sheetcount $i }
        puts $helix_f $helixcount
        puts $sheet_f $sheetcount
    } 
    close $helix_f
    close $sheet_f

    $sel delete
    mol delete $m
}