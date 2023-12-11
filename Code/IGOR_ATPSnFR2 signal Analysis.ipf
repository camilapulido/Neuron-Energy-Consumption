#pragma rtGlobals=3		// Use modern global access method and strict wave access.

Function Load0GlucStim_SyniATPsf_BTNS(Fecha,CellNo)
	String Fecha
	Variable CellNo //, NoGluc, No0gluc
	string Type = ""
	
	String Culture = "Hippocampal:iATPSnFR"//CRE-TH:"  
	string Path  = "E:"+Culture+":SyniATPsf-HALO:2023:"
	
	variable x, y, Total, NoRnd,Sol
	string NameFolder = Fecha+"_C"+num2str(CellNo)
	String NameOUT, NameIN
	string NameINtemp, NameOUTemp
	
	String/G SolType = "2DGTTX"
	String/G SolTypeOUT = "2DGTTX"
	Make/O TotalSol = {6}
	
	String/G SensorType = "HALO650x;iATPsf"
	string/G SensorTypeOUT="H;A"
	
	Make/T/O/N=(itemsinlist(SolType)*2) NameList	
	variable counter = 0
	
	for(x=0; x<=itemsinlist(SensorType)-1;x+=1)
		for (Sol=0; Sol<=itemsinlist(SolType)-1;Sol+=1)
			NameIN = Fecha+"_"+stringfromlist(x,SensorType)+"_C"+num2str(CellNo)+Type+"_"+stringfromlist(Sol,SolType)
			NameOUT = stringfromlist(x,SensorTypeOUT)+"_"+stringfromlist(Sol,SolTypeOUT)
			
			NameList[counter]=NameOUT
			counter+=1
			Total = TotalSol(Sol)
				
			for (NoRnd=0; NoRnd<=(Total-1);NoRnd+=1)
				if(NoRnd == 0)
					NameINtemp = NameIN   /// no zero  from  ImageJ
					NameOUTemp = NameOUT+"_"+num2str(NoRnd)
				else
					NameINtemp = NameIN +"_"+ num2str(NoRnd)
					NameOUTemp = NameOUT+"_"+num2str(NoRnd)
				endif
				for (y=0;y<=1;y+=1)
					if(y==0)
						//LoadWave/J/D/W/N/O/K=0 Path+NameFolder+":"+NameINtemp+"_Btns.xlsx"
						LoadWave/G/D/W/N/O/K=0 Path+NameFolder+":"+NameINtemp+"_Btns.txt"
						rename Average, $NameOUTemp+"_Raw"
						wave Err, XWave
						Killwaves Err, XWave
		
						string Roislist	
						Roislist = WaveList("ROI"+"*",";","")
						String FinalNameOut = NameOUTemp+"_ROIsRaw"
						concatenate/Kill/np=1/o Roislist, Wconca
						rename Wconca, $FinalNameOut
							
					elseif(y==1)
						LoadWave/J/D/W/N/O/K=0 Path+NameFolder+":Black_"+NameINtemp+".txt"
						rename MeanW, $NameOUTemp+"_Black"
					endif
				endfor
			endfor
		endfor
	endfor
	
end

//////////////////////////////////////////////////////////////////////////////

function BackGDSubtrac_Btns()
	wave/T Namelist
	variable file, Rnd, ROI, Frame
	variable/G ExperimentCampEXP = 0.1
	variable/G ExperimentCampGAIN = 100
	
	for (file = 0; File<=Dimsize(Namelist,0)-1;file+=1)
		string WaveListRaw = wavelist(Namelist[file]+"_*_ROIsRaw",";","")
		string WaveListBlack = wavelist(Namelist[file]+"_*_Black",";","")
		
		for(Rnd=0; Rnd <= (itemsinlist(WaveListRaw)-1); Rnd+=1)
			wave/C WRawMatrix = $stringfromlist(Rnd, WaveListRaw)
			wave WBlack = $stringfromlist(Rnd, WaveListBlack)
			
			duplicate/O WRawMatrix, $Namelist[file]+"_"+num2str(Rnd)+"_F_Btns"
			wave WFluoMatrix = $Namelist[file]+"_"+num2str(Rnd)+"_F_Btns"
			
			Make/O/N=(Dimsize(WRawMatrix,0)) $Namelist[file]+"_"+num2str(Rnd)+"_F_AVG_Btns"
			wave WAVG = $Namelist[file]+"_"+num2str(Rnd)+"_F_AVG_Btns"
			
			variable/G NumBtns = Dimsize(WRawMatrix,1)
			
			for(ROI = 0; ROI<= (NumBtns-1);ROI+=1)
				duplicate/O/R=[][ROI] WRawMatrix, WFluo
				WFluo-=WBlack
				
				//// EXP Correction //// 
				variable CampExpCst = 0.1, CampGainCst = 100
				WFluo*= CampExpCst/ ExperimentCampEXP
				WFluo*=CampGainCst/ExperimentCampGAIN
				
				WFluoMatrix[][ROI] = WFluo[p][0]				
			endfor
			
			matrixtranspose WFluoMatrix
			for(Frame = 0; Frame<=(Dimsize(WRawMatrix,0)-1); Frame+=1)
					duplicate/O/R=[][Frame] WFluoMatrix, WFrameBtns
					wavestats/Q WFrameBtns
					WAVG[Frame] = V_AVG		
			endfor
			
			matrixtranspose WFluoMatrix
		endfor
	endfor
	killwaves WFluo,WFrameBtns
end

////////////////////////////////////////

Function SyniATPsf_F_BL_ConcaBtns()
	string/G SensorTypeOUT
	String/G SolTypeOUT
	wave WTime
	variable x,item,sol
	for(x=0;x<=(itemsinlist(SensorTypeOUT)-1);x+=1)
		for(sol=0;sol<=(itemsinlist(SolTypeOUT)-1);sol+=1)
			string type =stringfromlist(x,SensorTypeOUT)+"_"+stringfromlist(sol,SolTypeOUT)
			CP_WConcatenate(type+"*_F_Btns", type+"_F_Btns_Con")
		endfor		
	endfor
	
end
////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////

function RatioCal()
	
	String/G SolTypeOUT
	variable Sol
	for(sol=0;sol<=(itemsinlist(SolTypeOUT)-1);sol+=1)
		wave Watp =$"A_"+stringfromlist(sol,SolTypeOUT)+"_F_Btns_Con"
		Duplicate/O Watp, $"R_"+stringfromlist(sol,SolTypeOUT)+"_Btns_Con"
		wave WRate = $"R_"+stringfromlist(sol,SolTypeOUT)+"_Btns_Con"
		wave WHalo= $"H_"+stringfromlist(sol,SolTypeOUT)+"_F_Btns_Con"
		WRate/=WHalo
	endfor
	
	//PlotTraces("R_BAFKA5GTTX_Btns_Con", "Traces_OriginalOrder")
end

//////// REJECT BOUTONS /////////
Function RejectedBtns(BL)
	variable BL
	variable/G BL_FrameNo = BL		
		
	wave WRatioCon = $"R_2DGTTX_Btns_Con"
	Make/O/N=0 WRejectedROIS 
	variable btn, counter = 0
	
	for (btn = 0; btn <=dimsize(WRatioCon,1)-1;btn+=1) //Btns
		duplicate/O/R=[][btn] WRatioCon, WBtn
		wavestats/Q/R=[0,BL_FrameNo] WBtn  /// BL AVG
		
		if(V_AVG<=0.2)
			WRatioCon[][btn] = NaN
			InsertPoints counter,1, WRejectedROIS
			WRejectedROIS[counter] = btn
			counter+=1
		endif
		
	endfor	
	print (dimsize(WRejectedROIS,0))
end

////////////////////////////////////////////////////////////////////////////////////
///////////////////////////// Sort by BL //////////////////////////

Function RATIOSortbyBL()
	variable/G BL_FrameNo
	wave WRatioCon = $"R_2DGTTX_Btns_Con"
	duplicate/O WRatioCon, $NameOfWave(WRatioCon)+"_Sort"
	wave WSort = $NameOfWave(WRatioCon)+"_Sort"
	WSort =nan
	
	Make/o/n=(dimsize(WSort,1), 3) BLandDrop_BtnAVG  /// Col 1 Btn index; Col 2 BL, Col 3 Drop
	
	variable btn,Indxbtn,btnNum,Frame
	for (btn = 0; btn <=dimsize(WRatioCon,1)-1;btn+=1) //Btns
		duplicate/O/R=[][btn] WRatioCon, WBtn
		wavestats/Q/R=[0,BL_FrameNo] WBtn  /// BL AVG
		
		BLandDrop_BtnAVG[btn][0] = btn  /// Btn #
		BLandDrop_BtnAVG[btn][1] = V_AVG  /// BL AVG per bouton
		
		wavestats/Q/R=[dimsize(WRatioCon,0)-25,dimsize(WRatioCon,0)-1] WBtn /// DROP AVG
		BLandDrop_BtnAVG[btn][2] = V_AVG  /// Drop AVG per bouton
	endfor
	
	MDsort(BLandDrop_BtnAVG,1)  //// Sort By Baseline Starting point
	
	for (Indxbtn = 0; Indxbtn<=dimsize(BLandDrop_BtnAVG,0)-1;Indxbtn+=1) /// # botns
		btnNum = BLandDrop_BtnAVG[Indxbtn][0] /// Check the sorted Bouton index
		WSort[][Indxbtn] = WRatioCon[p][btnNum]
	endfor
	
	
	duplicate/o BLandDrop_BtnAVG, $"DataSummary"
	matrixtranspose BLandDrop_BtnAVG
	killwaves WBtn//,WBtn2

end 

////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////

function Graph_ALLBtns()
	wave WRatioSort = $"R_2DGTTX_Btns_Con_Sort"
	wave WTime, BLandDrop_BtnAVG
	
	Make/o SolPos = {0,1}
	
	variable Nbtns
	Display/N=ALL_Btns
	for (Nbtns = 0; Nbtns <=dimsize(WRatioSort,1)-1;Nbtns+=1)
		AppendToGraph/W=ALL_Btns WRatioSort[][Nbtns] Vs WTime
	endfor
	
	Display/N=BLvsDrop
	for (Nbtns = 0; Nbtns <=dimsize(WRatioSort,1)-1;Nbtns+=1)
		AppendToGraph/W=BLvsDrop BLandDrop_BtnAVG [1,2][Nbtns] vs SolPos
	endfor
	ModifyGraph mode=4,marker=19
end

/////////////////////////////////////////////////////

function BtnNormtraces()
	variable StartFrame = 45
	wave WTime, Datasummary,WRejectedROIs
	Redimension/N=(-1,6) DataSummary
	
	variable/G BL_FrameNo
		
	wave WSort = $"R_2DGTTX_Btns_Con_Sort"	
	duplicate/O WSort, $"R_2DGTTX_Btns_Norm"
	wave WNorm =	$"R_2DGTTX_Btns_Norm"
	
	duplicate/O WSort, $"WSigmoidFit"
	wave WFit = $"WSigmoidFit"
	WFit =Nan
	
	Make/O/N=(dimsize(WNorm,1)) TimetoDrop = Nan
	Make/O/N=(dimsize(WNorm,1)) RateDrop = Nan
	Make/O/N=(dimsize(WNorm,1)) AlphaR = Nan
		
	variable btn,frame
	
	for(btn =0;btn <= (dimsize(WNorm,1)-1); btn +=1)
		duplicate/O/R=[][btn] WNorm, WTest
		wavestats/Q/R=[StartFrame,BL_FrameNo] WTest
		WTest/=V_AVG
		variable LastFrame = dimsize(WTest,0)-1
		
		if (btn <= (dimsize(WNorm,1) -dimsize(WRejectedROIs,0))-1)
			CurveFit/Q/M=2/W=0 Sigmoid, WTest[StartFrame,LastFrame]/X=WTime[StartFrame,LastFrame]/D
			wave W_coef, fit_WTest
			TimetoDrop[btn] = W_Coef[2]
			RateDrop[btn] = W_coef[3]
		
			Redimension/N=(dimsize(fit_WTest,0),-1) WFit
			WFit[][btn] = fit_WTest[p]
		else 
			WFit[][btn] =  Nan /// if ROI was rejected!
		endif
		WNorm[][btn]=Wtest[p][0]
	endfor
	
	AlphaR= 1/(4*RateDrop)
	
	DataSummary[][3] = TimetoDrop[p]
	DataSummary[][4] = RateDrop[p]
	DataSummary[][5] = AlphaR[p]
	
	SetScale/P x leftx(fit_Wtest),dimdelta(fit_WTest,0),"", WFit   ///Set scale base on fit	
	
	PlotTraces(nameofwave(WNorm), "Traces_BLNorm")
	PlotTracesSig()
	
	killwaves WTest

end	

///////////////////////////////////////////////
//////// PLOT To check traces ////////////////
function PlotTraces(WnameY, title)
	string WnameY, title 
	wave/C WTest = $WnameY
	wave WTime
	variable Nbtns
	Display/N=$title
	for (Nbtns = 0; Nbtns <=dimsize(WTest,1)-1;Nbtns+=1)
		AppendToGraph/W=$title WTest[][Nbtns] Vs WTime
	endfor
	
	//KBColorizeTraces#KBColorTablePopMenuProc("",0,"Rainbow")
end
/////////////////////////////////////////////
function PlotTracesSig()
	wave WSigmoidFit
	display/N= SigmoidFit
	variable btn
	for(btn=0;btn<=(dimsize(WSigmoidFit,1)-1);btn+=1)
		appendtograph WSigmoidFit[][btn] 
	endfor
	
	KBColorizeTraces#KBColorTablePopMenuProc("",0,"Rainbow")
end
