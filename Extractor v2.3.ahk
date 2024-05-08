; Created by @abarranp

#NoEnv  
; #Warn  
SendMode Input  
SetWorkingDir %A_ScriptDir%  





#SingleInstance, force
;#if WinActive("Tron HMI") 
#if WinActive("Yandex") 





	WinTag := WinActive("A")
	global Values := ["", "", "", "", "", "", "", ""]
	global isTrainingJob := false 
	global jobID := ""
	global token = "" 	
	global posX	:= null
	global posY := null
	global ExtWinTitle := "Extractor v2.3"





	;GUI personalization
	Gui, Ex: +AlwaysOnTop
	Gui, Ex: Color, C0C0C0
	Gui, Ex: font, s9 ,Calibri Light
	Gui, Ex: Margin, 0, 0
	FileInstall, back.png,  %A_Temp%/AHKBackground(1).png ; Adds a picture to temp folder every time the script is executed
	Gui, Ex: Add, Picture, x0 y0,  %A_Temp%/AHKBackground(1).png ; Loads the picture from temp folder every time the script is executed
	buttonColor := "Backgroundbfdadf" ; 87CEEB A8C0D8
	buttonColor2 := "BackgroundF0F0F0"
	shadowColor := "Background000000"
	buttonTextColor := "c000000"
	titleTextColor := "c000000"

	
	
	Gui, Ex: Add, text, 		x15		y15 			Backgroundtrans	%titleTextColor% , Job ID:
	Gui, Ex: Add, text, 		x+10	yp 		w350	Backgroundtrans	%titleTextColor%	vTextJob, 

	Gui, Ex: Add, text, 		x15		y+15 	Backgroundtrans	%titleTextColor% , Action:
	
	Gui, Ex: Add, Progress, 	xp+1	y+0		w80  	h30 Disabled %shadowColor% vProgressShadow1
	Gui, Ex: Add, Progress, 	xp-1	yp-1	w80  	h30 Disabled %buttonColor% vProgress1
	Gui, Ex: Add, Text,     	xp		yp		wp   	hp  BackgroundTrans %buttonTextColor%	0x201 +Border gAction1, Success
	
	Gui, Ex: Add, Progress, 	x+11	yp+1	w80  	h30 Disabled %shadowColor% vProgressShadow2
	Gui, Ex: Add, Progress, 	xp-1	yp-1	w80  	h30 Disabled %buttonColor% vProgress2	
	Gui, Ex: Add, Text,     	xp		yp		wp   	hp  BackgroundTrans %buttonTextColor%	0x201 +Border gAction2, No Stow
	
	Gui, Ex: Add, Progress, 	x+11	yp+1	w80  	h30 Disabled %shadowColor% vProgressShadow3
	Gui, Ex: Add, Progress, 	xp-1    yp-1	w80  	h30 Disabled %buttonColor% vProgress3
	Gui, Ex: Add, Text,     	xp   	yp		wp   	hp  BackgroundTrans %buttonTextColor%	 0x201 +Border gAction3, Not Sure
	
	Gui, Ex: Add, Progress, 	x+11	yp+1	w80  	h30 Disabled %shadowColor% vProgressShadow4
	Gui, Ex: Add, Progress, 	xp-1    yp-1	w80  	h30 Disabled %buttonColor% vProgress4
	Gui, Ex: Add, Text,     	xp   	yp   	wp   	hp  BackgroundTrans  %buttonTextColor%	0x201 +Border gAction4, Multiple Events
	
	Gui, Ex: Add, Progress, 	x+11	yp+1	w80  	h30 Disabled %shadowColor% vProgressShadow5
	Gui, Ex: Add, Progress, 	xp-1    yp-1	w80  	h30 Disabled %buttonColor% vProgress5
	Gui, Ex: Add, Text,     	xp   	yp   	wp   	hp  BackgroundTrans  %buttonTextColor%	0x201 +Border gAction5, Cannot Answer
	
	Gui, Ex: Add, text, 		xp+95	yp		w0		h30,

	Gui, Ex: Add, text, 		x15		y+15	Backgroundtrans	%titleTextColor%, Best View:	
	
	Gui, Ex: Add, Progress, 	xp+1	y+0		w80  	h30 	Disabled %shadowColor% vProgressViewShadow1
	Gui, Ex: Add, Progress, 	xp-1	yp-1	w80		h30		Disabled %buttonColor% vProgressView1
	Gui, Ex: Add, Text,     	xp		yp		wp		hp		BackgroundTrans	%buttonTextColor%	0x201 +Border gBestView1, RGB
	
	Gui, Ex: Add, Progress, 	x+11	yp+1	w80  	h30 	Disabled %shadowColor% vProgressViewShadow2
	Gui, Ex: Add, Progress, 	xp-1	yp-1	w80		h30		Disabled %buttonColor% vProgressView2
	Gui, Ex: Add, Text,     	xp		yp		wp		hp		BackgroundTrans	%buttonTextColor%	0x201 +Border gBestView2, Top
	
	Gui, Ex: Add, Progress, 	x+11	yp+1	w80  	h30 	Disabled %shadowColor% vProgressViewShadow3
	Gui, Ex: Add, Progress, 	xp-1	yp-1	w80		h30		Disabled %buttonColor% vProgressView3
	Gui, Ex: Add, Text,     	xp		yp		wp		hp		BackgroundTrans	%buttonTextColor%	0x201 +Border gBestView3, Bottom

	Gui, Ex: Add, text, 		x15		y+15	Backgroundtrans	%titleTextColor% , Comments:
	Gui, Ex: Add, Edit, 		x15		y+0		R1	w260	vInpt ;441 260

	Gui, Ex: Add, Progress, 	x16		yp+41	w260  	h30 	Disabled %shadowColor% 
	Gui, Ex: Add, Progress,   	x15		yp-1	w260	h30		Disabled %buttonColor2%, 
	Gui, Ex: Add, Text,     	xp		yp		wp		hp		BackgroundTrans	%buttonTextColor%	0x201 +Border gBtnCopy, Copy
	
	Gui, Ex: Add, Text, 		x15 	y+10		Backgroundtrans	cBlue  gDigDug,	Dig-Dug(alt+d)
	Gui, Ex: Add, Text, 		x+30 	yp			Backgroundtrans	cBlue  gWiki,	Wiki
	Gui, Ex: Add, Text, 		x15 	yp+5	w1	Backgroundtrans	cBlack,



	r::
		Reload
	Return


	d::	;Runs extractor feature

		Reset()

		Clipboard =
		(
Job Id: 1918808657f34ec6a05e98bd7e337666
Client Token: amzn1.fc.v1.common.request-id.v1.FCExecutionNikeRuntime.ac022be3-05b1-45fa-9e54-d1c84d28850a
Is Training Job: False
		)

		;MsgBox % Clipboard

		if( WinExist(ExtWinTitle) )
		{
			WinGetPos, posX, posY,,, %ExtWinTitle%
		}

		
		Links_Extractor()

	Return



	DigDug:	

		Run % Values[6]
		Run % Values[7]
		Run % Values[8]

	Return



	Wiki:

		Run % "https://w.amazon.com/bin/view/Extractor"

	Return



	Action1:								;This method is called when the Success button is pressed (this method changes the color of the button selected)
	  GuiControl, Hide, Progress1			;Removes the Success button color
	  GuiControl, Hide, ProgressShadow1		;Removes the Success button shadow
	  GuiControl, Show, Progress2			;Shows the No Stow button color
	  GuiControl, Show, ProgressShadow2
	  GuiControl, Show, Progress3
	  GuiControl, Show, ProgressShadow3
	  GuiControl, Show, Progress4
	  GuiControl, Show, ProgressShadow4
	  GuiControl, Show, Progress5
	  GuiControl, Show, ProgressShadow5
	  Values[4] := "Success"				;Stores the string "Success" in Values[4] array
	Return



	Action2:								;This method is called when the button No Stow is pressed
	  GuiControl, Hide, Progress2
	  GuiControl, Hide, ProgressShadow2
	  GuiControl, Show, Progress1
	  GuiControl, Show, ProgressShadow1
	  GuiControl, Show, Progress3
	  GuiControl, Show, ProgressShadow3
	  GuiControl, Show, Progress4
	  GuiControl, Show, ProgressShadow4
	  GuiControl, Show, Progress5
	  GuiControl, Show, ProgressShadow5
	  Values[4] := "No Stow"
	Return



	Action3:								;This method is called when the button Not Sure is pressed
	  GuiControl, Hide, Progress3
	  GuiControl, Hide, ProgressShadow3
	  GuiControl, Show, Progress1
	  GuiControl, Show, ProgressShadow1
	  GuiControl, Show, Progress2
	  GuiControl, Show, ProgressShadow2
	  GuiControl, Show, Progress4
	  GuiControl, Show, ProgressShadow4
	  GuiControl, Show, Progress5
	  GuiControl, Show, ProgressShadow5
	  Values[4] := "Not Sure"
	Return



	Action4:								;This method is called when the button Multiple Events is pressed
	  GuiControl, Hide, Progress4
	  GuiControl, Hide, ProgressShadow4
	  GuiControl, Show, Progress1
	  GuiControl, Show, ProgressShadow1
	  GuiControl, Show, Progress2
	  GuiControl, Show, ProgressShadow2
	  GuiControl, Show, Progress3
	  GuiControl, Show, ProgressShadow3
	  GuiControl, Show, Progress5
	  GuiControl, Show, ProgressShadow5
	  Values[4] := "Multiple Events"
	Return



	Action5:								;This method is called when the button Cannot Answer is pressed 
	  GuiControl, Hide, Progress5
	  GuiControl, Hide, ProgressShadow5
	  GuiControl, Show, Progress1
	  GuiControl, Show, ProgressShadow1
	  GuiControl, Show, Progress2
	  GuiControl, Show, ProgressShadow2
	  GuiControl, Show, Progress3
	  GuiControl, Show, ProgressShadow3
	  GuiControl, Show, Progress4
	  GuiControl, Show, ProgressShadow4
	  Values[4] := "Cannot Answer"
	Return



BestView1:									;This method is called when the button RGB is pressed 
	  GuiControl, Hide, ProgressView1
	  GuiControl, Hide, ProgressViewShadow1
	  GuiControl, Show, ProgressView2
	  GuiControl, Show, ProgressViewShadow2
	  GuiControl, Show, ProgressView3
	  GuiControl, Show, ProgressViewShadow3
	  Values[5] := "RGB"
	Return



	BestView2:								;This method is called when the button Top is pressed 
	  GuiControl, Hide, ProgressView2
	  GuiControl, Hide, ProgressViewShadow2
	  GuiControl, Show, ProgressView1
	  GuiControl, Show, ProgressViewShadow1
	  GuiControl, Show, ProgressView3
	  GuiControl, Show, ProgressViewShadow3
	  Values[5] := "Top"
	Return



	BestView3:								;This method is called when the button Bottom is pressed 
	  GuiControl, Hide, ProgressView3
	  GuiControl, Hide, ProgressViewShadow3
	  GuiControl, Show, ProgressView1
	  GuiControl, Show, ProgressViewShadow1
	  GuiControl, Show, ProgressView2
	  GuiControl, Show, ProgressViewShadow2
	  Values[5] := "Bottom"
	Return





	Links_Extractor()
	{

		sendevent d
		sleep, 100 
		
		mtchToken := false ;flag to confirm if the job copied in HMI is valid
        mtchJobID := false
		mtchIsTrainingJob := false
		job_array :=  StrSplit(Clipboard, "`n") ;Creates an array filled with each row of the job
				
		;MsgBox % "Clipboard al llegar al loop -> " Clipboard
				
		Loop
		{
		
			if( RegExMatch(job_array[A_Index], "Job Id: +\K.*",jID) ) ;Looks for a Job Id
			{  
				
				global jobID := jID
				mtchJobID := true ;Flag

				;MsgBox % "JOBID -> " jobID
			
			} else if( RegExMatch(job_array[A_Index], "Client Token: +\K.*", tkn) ) ;If the string was found, stores the token number in a variable
			{			
				global token := tkn
				mtchToken := true ;Flag		

				;MsgBox % "JOBID -> " token		
			
			} else if( RegExMatch(job_array[A_Index], "Is Training Job: +\K.*", jobType) ) ;Check if is a normal or training job
			{
			
				jobType := RegExReplace(jobType,"(\n|\r)","") ;Remove blanks
			
				if( jobType == "True" )
				{
					global isTrainingJob := true

				}else if( jobType == "False" )
				{
					global isTrainingJob := false

				}
				
				mtchIsTrainingJob := true ;Flag

				;MsgBox % "JOBID -> " jobType
						
			}
			
		
			
			
		} Until A_Index >= job_array.Length()



		if( !mtchJobID ) ;Shows an error message when the job id is missing
		{
			MsgBox, 16, Error, Missing job ID.
			Gui, Ex: Hide
			return
		} else if( !mtchToken ) ;Shows an error message when the job token is missing
		{
			MsgBox, 16, Error, Missing token.
			Gui, Ex: Hide
			return	
		} else if( !mtchIsTrainingJob ) ;Shows an error message when the job type (training or not) is missing
		{
			MsgBox, 16, Error, Missing Job Type.
			Gui, Ex: Hide
			return	
		} else
		{

			if( !isTrainingJob )
			{
				
				Values[1] := "[Link1](https://dig-dug-portal-iad.iad.proxy.amazon.com/stows/" token ")" ; Links in markdown to use in Slack by SMEs
				Values[2] := "[Link2](https://dig-dug-portal-dub.dub.proxy.amazon.com/stows/" token ")"
				Values[3] := "[Link3](https://dig-dug-nrt.aka.amazon.com/stows/" token ")"
				
				Values[6] := "https://dig-dug-portal-iad.iad.proxy.amazon.com/stows/" . token ; Links for GUI
				Values[7] := "https://dig-dug-portal-dub.dub.proxy.amazon.com/stows/" . token
				Values[8] := "https://dig-dug-nrt.aka.amazon.com/stows/" . token
			
			}else if( isTrainingJob )
			{
				
				Values[1] := "Token: " . token ; Used by trainers
			
			}


				
			UpdateTextJobID()
			ShGUI()


		}

	}





	ShGUI()
	{

		if(posX == null OR posY == null)
		{

			Gui, Ex: Show, AutoSize Center, %ExtWinTitle%	

		} else
		{

			Gui, Ex: Show, AutoSize x%posX% y%posY%, %ExtWinTitle%
			
		}

	}




	
	Reset()	;Reset global variables to default and change the buttons color
	{

		global Values := ["", "", "", "", "", "", "", ""]
		global isTrainingJob := false
		global jobID := ""
		global token := ""
		Clipboard := ""
		
		
		GuiControl, Show, ProgressShadow1 ;Reset Action buttons color 
		GuiControl, Show, ProgressShadow2
		GuiControl, Show, ProgressShadow3
		GuiControl, Show, ProgressShadow4
		GuiControl, Show, ProgressShadow5
		GuiControl, Show, Progress1 
		GuiControl, Show, Progress2
		GuiControl, Show, Progress3
		GuiControl, Show, Progress4
		GuiControl, Show, Progress5
		
		;Reset Best View buttons color
		GuiControl, Show, ProgressViewShadow1
		GuiControl, Show, ProgressViewShadow2
		GuiControl, Show, ProgressViewShadow3
		GuiControl, Show, ProgressView1
		GuiControl, Show, ProgressView2
		GuiControl, Show, ProgressView3

		GuiControl,,Inpt, ;Clean the text field
		GuiControl,,TextJob, 

	}





	Str()
	{
		GuiControlGet,  Inpt ;Get the text field string

		if( !isTrainingJob )
		{
			sOut1 := Values[1] " / " Values[2] " / " Values[3] " / " Values[4] " / " Values[5] " / " Inpt
			
		}else if( isTrainingJob )
		{
			sOut1 := Values[4] " / " Values[5] " / " Inpt " / " Values[1]
		}
		
		Return RegExReplace(sOut1,"(\n|\r)","") ;Remove line breaks and returns the final string used by SME
	}





	UpdateTextJobID() 
	{
		GuiControl, Ex: ,TextJob, %jobID% 
	}





	BtnCopy:

		if(Values[4] != "" and Values[5] != "")
		{
		
			Clipboard := Str() ;Copy the final string to clipboard
			
			WinGetPos, posX, posY,,, %ExtWinTitle%

			
			Gui, Ex: Hide
			
			Tooltip Text copied to clipboard ;Shows a tooltip with a confirmation for 1 second
				sleep, 1000
			Tooltip

		}
		else
		{
		
			MsgBox, 0x40000,,Choose an Action and Best View.

		}

	Return





	ExGuiClose:

		WinGetPos, posX, posY,,, %ExtWinTitle%

		Reset()
		Gui, Ex: Hide
		
	Return





#IfWinActive