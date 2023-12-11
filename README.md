## Protocol for Energy Measurements in Neurnal Synapses

## I. Image processing: extract fluorescent signal from individuals boutons from a neuron

This protocol delineates the analysis of ATP dynamics within synaptic boutons, employing the last generation of the genetically engineered ATP biosensors, called ATPSnFR2, as detailed in a recent [publication](https://www.biorxiv.org/content/10.1101/2023.08.24.554624v1)

This protocol is intended to use two analysis programs: [ImageJ (Fiji)](https://fiji.sc/) and [IGOR Pro (wavemetrics)](https://www.wavemetrics.com/).

The ratiometric ATP sensor approach uses 2 lasers wavelengths (488 and second one depending the normalization protein) in alternate mode between camera frames, as illustrated next:

<img src="./Images/Switcher_Laser 637-488.gif" alt="Neuron" style="width: 300px;"/>

The first step to have a easier way to extract information by **Re-formatting** the videos by splitting into their corresponding channels, by just filling some info relevanto from the experiment settings: 

https://github.com/camilapulido/Neuron-Energy-Measurements/blob/52015720e7617088bcca09bbec890cd816269deb/Code/ATPSnFr_Formating.py#L7-L11

Using the ['Time Series Analizer'](https://imagej.net/ij/plugins/time-series.html) Plugin select ROIS corresponding to synaptic boutons and automatically extract signal information of all the experimental conditions by running [Extracting Boutons signal code](Code/Syn-iATPsf-HALO_Switcher.py), dont forget to save ROIS. 

<img src="./Images/ExpC1_picNeuron + ROIs.png" alt="Neuron with ROIS" style="width: 300px;"/>

Automatically get and save background signal by drawing ROIS corresponding to the background of neurons and by running [Background code](Code/Syn-iATPsf-HALO_NoStim_BLACK.py).

Load signal information into matrix arrays from all the boutons and their corresponding background signals into IGOR-PRO (wavemetrics) program. 

https://github.com/camilapulido/Neuron-Energy-Measurements/blob/4542016bde86354657417ed060379e6ccbe7fe08/Code/IGOR_ATPSnFR2%20signal%20Analysis.ipf#L6

Correct all synaptic boutons signalling by subtracting the background noise.

https://github.com/camilapulido/Neuron-Energy-Measurements/blob/63ba863a9252eb28478aae6ce3137792bfc30dc3/Code/IGOR_ATPSnFR2%20signal%20Analysis.ipf#L73

Now, Data should organized and ready to get analyzed!!

## II. Some analytics of ATP dynamics in Synaptic boutons**

The human brain, an exceedingly delicate and resource-intensive organ, relies on the constant synthesis of energy molecules, specifically adenosine triphosphate (ATP), to sustain its activities and ensure the proper functioning and maintenance of neurons. Striking a precise balance between ATP synthesis and consumption is imperative to prevent any form of brain dysfunction that may lead to neuronal degeneration. 

The precise energy balance is achieved when neurons have sustained access to a fuel source to facilitate ongoing ATP synthesis. Glucose serves as the primary fuel for neurons and other cells, undergoing enzymatic conversion in a pathway known as 'Glycolysis'. In this process, glucose molecules break down into pyruvate, generating ATP along the way. However, disruptions in Glycolysis, whether caused by the malfunction of key enzymes or the removal of the fuel source, promptly hinder the production of new ATP within synaptic boutons. Consequently, the local reserve is rapidly depleted, leading to a cessation of neuronal function. This intricate interplay between energy synthesis and utilization underscores the critical importance of maintaining a delicate equilibrium to safeguard the intricate workings of the human brain.

The following plot exemplify 

<img src="./Images/ExpC1_matrixBoutons.png" alt="Signal Ratio per bouton" style="width: 500px;"/>



