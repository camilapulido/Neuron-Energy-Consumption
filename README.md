## Protocol for Energy Measurements in Neurnal Synapses

## I. Image processing: Extract and organize fluorescent signal from individuals boutons from a neuron

This protocol delineates the analysis of ATP dynamics within synaptic boutons, employing the last generation of the genetically engineered ATP biosensors, called iATPSnFR2, as detailed in a recent [publication](https://www.biorxiv.org/content/10.1101/2023.08.24.554624v1)

This protocol is intended to use two analysis programs: [ImageJ (Fiji)](https://fiji.sc/) and [IGOR Pro (wavemetrics)](https://www.wavemetrics.com/).

iATPSnFR2 is a variant of iATPSnFR1, a previously developed sensor that has circularly permuted super-folder GFP inserted between the ATP-binding helices of the ε-subunit of a bacterial F0-F1 ATPase. A chimeric version of this sensor fused to either the HaloTag protein or a suitably spectrally separated fluorescent protein, provides a ratiometric readout allowing comparisons of ATP across cellular regions. To capture the ATP signal accurately, the protocol necessitates the use of two separate wavelength lasers —one for the iATPSnFR2 signal and another for the tag protein. This dual-laser approach corrects the signal over sensor expression, enabling precise comparisons between synaptic boutons and across neurons.

Live-imaging acquisition is programed to alternate laser wavelength signals between consecutive camera frames, as depicted below:

<img src="./Images/Switcher_Laser 637-488.gif" alt="Neuron" style="width: 300px;"/>

The initial step towards simplifying information extraction involves reformatting the videos by splitting them into their respective channels. This can be achieved effortlessly using the following code, with the user only needing to input pertinent information from the experiment settings.

https://github.com/camilapulido/Neuron-Energy-Measurements/blob/52015720e7617088bcca09bbec890cd816269deb/Code/ATPSnFr_Formating.py#L7-L11

Utilize the ['Time Series Analyzer'](https://imagej.net/ij/plugins/time-series.html) Plugin to choose ROIs corresponding to synaptic boutons and effortlessly extract signal information for all experimental conditions, by simply executing the ['Extracting Boutons signal code'](Code/Syn-iATPsf-HALO_Switcher.py), ensuring to save the selected ROIs for future reference (one of the steps in the code).

<img src="./Images/ExpC1_picNeuron + ROIs.png" alt="Neuron with ROIS" style="width: 300px;"/>

Draw ROIS corresponding to the background of neurons, and execute the [Background code](Code/Syn-iATPsf-HALO_NoStim_BLACK.py) to automatically get and save data signal.

Import the signal information from all boutons, along with their corresponding background signals, into the IGOR-PRO program (wavemetrics), organizing them into matrix arrays for further analysis.

https://github.com/camilapulido/Neuron-Energy-Measurements/blob/4542016bde86354657417ed060379e6ccbe7fe08/Code/IGOR_ATPSnFR2%20signal%20Analysis.ipf#L6

Correct synaptic boutons signals by subtracting background noise:

https://github.com/camilapulido/Neuron-Energy-Measurements/blob/63ba863a9252eb28478aae6ce3137792bfc30dc3/Code/IGOR_ATPSnFR2%20signal%20Analysis.ipf#L73

Now, Data should organized and ready to get analyzed!!

## II. Some analytics of ATP dynamics in Synaptic boutons**

The human brain, an exceedingly delicate and resource-intensive organ, relies on the constant synthesis of energy molecules, specifically adenosine triphosphate (ATP), to sustain its activities and ensure the proper functioning and maintenance of neurons. Striking a precise balance between ATP synthesis and consumption is imperative to prevent any form of brain dysfunction that may lead to neuronal degeneration. 

The precise energy balance is achieved when neurons have sustained access to a fuel source to facilitate ongoing ATP synthesis. Glucose serves as the primary fuel for neurons and other cells, undergoing enzymatic conversion in a pathway known as 'Glycolysis'. In this process, glucose molecules break down into pyruvate, generating ATP along the way. However, disruptions in Glycolysis, whether caused by the malfunction of key enzymes or the removal of the fuel source, promptly hinder the production of new ATP within synaptic boutons. Consequently, the local reserve is rapidly depleted, leading to a cessation of neuronal function. This intricate interplay between energy synthesis and utilization underscores the critical importance of maintaining a delicate equilibrium to safeguard the intricate workings of the human brain.

The following plot exemplify 

<img src="./Images/ExpC1_matrixBoutons.png" alt="Signal Ratio per bouton" style="width: 500px;"/>



