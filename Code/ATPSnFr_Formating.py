from ij import IJ, ImagePlus
from ij.plugin.filter import PlugInFilterRunner
import os
import glob

#import sys
#sys.path.append("C:\\Users\\cmp2010\\Dropbox\\LABORATORY\\ImageJ\\")  # the folder containing Hello_.py
#from Slice_Keeper import Hello
#################
###################################################################
Sensor = "SyniATPsf-HALO"

########## VARIABLES ###############"
Culture = "Hippocampal\\iATPSnFR\\"

Date = 230502
Cell = 1

FolderIN = "C:\\Users\\cmp2010\\Dropbox\\LABORATORY\\DATA\\"+Culture+Sensor+"\\2023\\"+str(Date)+"\\C"+str(Cell)+"\\"
FolderOUT = FolderIN+"FormatedFiles\\"

if not os.path.exists(FolderOUT):
	os.makedirs(FolderOUT)

###################################################
fitsfiles = []
for file in glob.glob(FolderIN+"*.fits"):
	fitsfiles.append(file)
	IJ.open(file)
	stackOriginal = IJ.getImage()
	slices_nb=stackOriginal.getNSlices();
	OriginalName = stackOriginal.title

	for switch in range(0,2):
		if switch == 0:
			Type = "HALO650x_"
		else:
			Type = "iATPsf_"

		stackOriginal = IJ.selectWindow(OriginalName)
		IJ.run("Duplicate...", "title="+Type+OriginalName+" duplicate")
		
		imp = IJ.getImage()
		
		FinalName = Type+OriginalName
		Arguments = str(switch+1)
		
		#IJ.runMacroFile("C:\\Users\\cmp2010\\Dropbox\\LABORATORY\\ImageJ\\Slice_Keeper.ijm", "1")
		imp = IJ.run("Slice Keeper", "first="+Arguments+" last="+str(slices_nb)+" increment=2");
		stack = IJ.selectWindow(FinalName+" kept stack")
		stack = IJ.getImage()
		IJ.run("Save", "save="+FolderOUT+Type+OriginalName);


IJ.run("Close All", "");


