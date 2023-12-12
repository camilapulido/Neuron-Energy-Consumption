from ij import IJ, ImagePlus
from ij import WindowManager as WM 
from ij.plugin.frame import RoiManager
from ij.measure import Measurements, ResultsTable
from ij.io import FileSaver
import os
import time
import glob
###### Setup Val ####
##--- This script utilize the robot funtion from ImageJ, therefore some coordinates on your screen has to be setup in advance--

xVal= 1600 ## X Pixel coordinate where Time-Series-Analyzer's'Get Average' Bouton is going to be located
yVal = 229 ## Y Pixel coordinate where Time-Series-Analyzer's'Get Average' Bouton is going to be located

Waitfor = 1  # in seconds
##################################################################
##################################################################
##################################################################
##################################################################
Sensor = "SyniATPsf-HALO"
########## VARIABLES #################
Culture = "Hippocampal\\iATPSnFR" #"Dopaminergic\\"
CRE = ""
Date = 230502
Cell = 1
              
#############################################

FolderOUT = "C:\\Users\\LABORATORY\\ANALYSIS\\"+Culture+CRE+"\\"+Sensor+"\\2023\\"+str(Date)+"_C"+str(Cell)+"\\"
FolderIN = "C:\\Users\\LABORATORY\\DATA\\"+Culture+CRE+"\\"+Sensor+"\\2023\\"+str(Date)+"\\C"+str(Cell)+"\\FormatedFiles\\"

if not os.path.exists(FolderOUT):
	os.makedirs(FolderOUT)
############		
##################

fitsfiles = []
for file in glob.glob(FolderIN+"*.fits"):
	fitsfiles.append(file)
	IJ.open(file)
	stackOriginal = IJ.getImage()
	slices_nb=stackOriginal.getNSlices();
	OriginalName = stackOriginal.title
	OUTName = OriginalName[:len(OriginalName)-5]
	NameOUT = "Black_"+str(Date)+"_"+OUTName
	
	time.sleep(Waitfor)
	IJ.run("IJ Robot", "order=Left_Click x_point="+str(xVal)+" y_point="+str(yVal)+" delay=50 keypress=[]")  ## GET AVG
	time.sleep(Waitfor)
	
 	IJ.renameResults("Time Trace(s)", "Results") 
	Results2 = ResultsTable.getResultsTable()
	AVG = Results2.getColumn(Results2.getColumnIndex("Average"))
	Results = ResultsTable() 

	for i in range(len(AVG)):
		Results.incrementCounter()
		Results.addValue('Mean', AVG[i])

	Results.show('Mean')
	path= FolderOUT+NameOUT+".txt"
	Results.saveAs(path)
	stackOriginal.close()
	IJ.run("Close All", "");
	
	

