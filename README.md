## Protocol for Energy Measurements in Neurnal Synapses

**1) Image processing: extract fluorescent signal from individuals boutons from a neuron.**

This is a protocol for analysis of ATP dynamics in ysnaptic boutons using a new generation of genetically enginered biosensors (ATPSnFR2), recently [published](https://www.biorxiv.org/content/10.1101/2023.08.24.554624v1)

This protocol is intendded to be used with to Analysis programs: ImajeJ (Fiji) and IGOR-Pro (wavemetrics).

The ratiometric ATP sensor approach uses 2 lasers wavelengths (488 and second one depending the normalization protein) in alternate mode between camera frames, as illustrated next:

<img src="./Images/Switcher_Laser 637-488.gif" alt="Neuron" style="width: 250px;"/>

The first step to have a easier way to extract information by **Re-formatting** the videos by splitting into their corresponding channels, by just filling some info relevanto from the experiment settings: 

https://github.com/camilapulido/Neuron-Energy-Measurements/blob/52015720e7617088bcca09bbec890cd816269deb/Code/ATPSnFr_Formating.py#L7-L11

Using the ['Time Series Analizer'](https://imagej.net/ij/plugins/time-series.html) Plugin select ROIS corresponding to synaptic boutons and automatically extract signal information of all the experimental conditions by running [Extracting Boutons signal code](Code/Syn-iATPsf-HALO_Switcher.py), dont forget to save ROIS. 

<img src="./Images/ExpC1_picNeuron + ROIs.png" alt="Neuron with ROIS" style="width: 250px;"/>

Extract background signal by drawing ROIS corresponding to the background of neurons, automatically extract info by running [Background code](Code/Syn-iATPsf-HALO_NoStim_BLACK.py)
Actomatically Load signal information from all the boutons into IGOR-PRO (wavemetrics), by creating matrix arrays with their information. Extract background signal to all boutons signal. Now, Data should organized and ready to get analyzed.

**2) Some analytics of ATP dynamics in Synaptic boutons**


