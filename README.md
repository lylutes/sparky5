# sparky5
sparky5 is designed to identify and characterize calcium fluctuations (signaling events) in T cells that have been labeled with a calcium indicator dye (we use Indo1LR, Thermo Fisher Scientific Cat. No.: I1226), live imaged, and tracked using Imaris (RRID: SCR_007370). It can measure when calcium fluctuations start and stop (event duration), the relative level of calcium fluxed (amplitude), instantaneous and average track speed, cell displacement, and more.  

It is generally a good idea to inspect individual tracks using Imaris and compare to Sparky's output to make sure that most of the events begin and end make sense.  To do this, identify the track you want to look at based on the Sparky event summary page.  Click on the correct parent ID, go to edit and duplicate and rename as the parent ID.  (Do NOT delete the original track from the merged track list or you will change all the track IDs!)
  
## sparky5 instructions
Formatting an Excel File from Imaris for Sparky/Matlab analysis:
1.	In excel, create a new worksheet with two new sheets called sheet 1 and sheet 2.  
2.	Sheet 1: paste the following information from Imaris into the following columns:
    - A.	Parent (Track #)
    - B.	Time (Timepoint #)
    - C.	Position X
    - D.	Position Y
    - E.	Position Z
    - F.	Channel 1 Intensity Mean (calcium high)
    - G.	Channel 2 Intensity Mean (calcium low
3.	Sheet 1: Delete any other text and data (Important – NO letters, only numbers).
4.	Sheet 1: Sort the data by column A, ascending and then by column B, ascending.
5.	Sheet 2: This sheet contains the adjustable parameters for Sparkly, including the threshold for subtracting from the Calcium ratio. 
    - Time between timepoints: time interval between images (typically 10-20s)
    - Time between distance measurements: total time considered when averaging distance measurements and instantaneous track speed. For example: if the time between timepoints is 20 seconds and one chooses a time between distance measurements of 100, the speed and distance calculations Sparky5 produces in “step data” will be averaged over 5 timepoints.
    - Flag the channel 2 Ca signal if fluorescence is below: sets the minimum intensity mean for the calcium low channel. (usually use 20)
    - Ca Correction: this is the average calcium ratio (Channel 1/Channel 2 ; Ca hi/Ca lo) for non-signaling cells. This value can be thought of as the basal calcium ratio and is used to create the “corrected calcium ratio”.
    - Events Peak Initiator: the value the corrected calcium ratio must exceed to be considered the beginning of a signaling event.
    - Event beginning and end: the value the corrected calcium ratio must be above during the signaling event.
    - Event beginning and end distance: The maximum displacement a cell can have during an event.
6.	Save as a .xls file (compatibility mode 1997-2004)

Matlab Analysis:
1.	First, it is best to have a copy of all file elements of Sparky5 in the same parent folder as the .xls file from step 6, above.
2.	In this folder, double click on the Matlab file called "Sparky5".  
3.	Press F5 to run the program (OR DEBUG/RUN).  A window will open and you should scroll to the folder containing your Sparky input file.  Click open and the program will start running.  An output file with the ending SPARKY RESULTS will appear in the same folder.  (The program takes a couple of minutes to run).
4.	Open the “output” excel file and view the results. 
5.	Breakdown of the most crucial result sheets:
    - Step Data: information about each cell at each timepoint
    - Track Data: information about each track (average)
    - Events: summary of each event sparky detected
