## Protocol for Energy Measurements in Neurnal Synapses

This is a protocol for analysis of ATP dynamics in ysnaptic boutons using a new generation of genetically enginered biosensors (ATPSnFR2), recently [published](https://www.biorxiv.org/content/10.1101/2023.08.24.554624v1)

The ratiometric ATP sensor approach uses 2 lasers wavelengths (488 and second one depending the normalization protein) in alternate mode between camera frames., one on in one frame and the other one in the following camera frame, as illustrated next:

<img src="./Images/Switcher_Laser 637-488.gif" alt="Neuron" style="width: 250px;"/>

The first step to have a easier way to extract information by Re-formatting videos in their corresponding channels, by just filling the info correcponig to the experement details: 

https://github.com/camilapulido/Neuron-Energy-Measurements/blob/52015720e7617088bcca09bbec890cd816269deb/Code/ATPSnFr_Formating.py#L7-L11

using the ['Time Series Analizer'](https://imagej.net/ij/plugins/time-series.html) Plugin select ROIS corresponding to synaptic boutons and automatically extract signal information by running [Extracting Boutons siganl code](Code/Syn-iATPsf-HALO_Switcher.py), dont forget to save ROIS. Extract background signal by drawing ROIS corresponding to the bacground of neurons, automattlycaly eztrac info by running [Background code](Code/Syn-iATPsf-HALO_NoStim_BLACK.py)
