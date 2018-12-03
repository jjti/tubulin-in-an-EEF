# Tubulin's response to external electric fields

A molecular dynamics study

Paper: [Tubulin's response to external electric fields by molecular dynamics simulations](https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0202141)

<img src="https://user-images.githubusercontent.com/13923102/43682320-a89507da-983f-11e8-837a-3a49119c255c.png" width="465">

## md

```protein.pdb protein.psf```  
System pdb and psf after equilibration. Used in every run.

```initial.*```  
Coorindates, velocities, and cell dimensions from the final frame of the equilibration run.

```parameters/**```  
CHARMM36 parameter files.

The [electric field parameter](http://www.ks.uiuc.edu/Research/namd/2.10b1/ug/node42.html) was turned on using eFieldOn and eField

```tcl
set inputname       last_runs_name
set outputname      this_runs_name

# for the 10ns run during which the an EEF was applied
eFieldOn			yes
# for a 750 kV/cm EEF in the positive transverse direction
eField		        0.035826345822314 0.026219852770675 0.16659974853940
```

## data

Trajectory data, used for analysis, is available at https://figshare.com/s/32bd5a62009f184ebd47

## analysis

Representative VMD/tcl scripts for the analyses performed on the 50 ns trajectory files. The types of analyses, and the range of frames that were studied, are below:

* rmsd (full 50ns)
* rmsf (10 to 20ns)
* dipole (full 50ns)
* secondary_structure (10 to 20ns)
* dimer_curvature (10 to 20ns)
* dimer_stretch (10 to 20ns)
* h1_b2_loop (5 to 10ns) (using the last 5ns of 10ns runs over several magnitudes)
* deviation (last frame of EEF exposure)
