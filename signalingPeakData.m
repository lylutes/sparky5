%signalingPeakData
%The peaks in peakDataSignaling have begining, end, Ca >.2 above the cutoff and fluorescence channel 2 above that cutoff. See line 9 and 11.

%truePeaks ----these have a beginning and an end and are more than 0.2 over the corrected calcium ratio. No opinion about the fluorescence intensity.
%get the truePeaks locations in stepData.
truePeakLocations = peakData(truePeaks,3);%These are the lines in  stepData where the truePeaks peak.
                                          %truePeaks is defined on line 451 of slowBuildPeaks script
temp = find (stepData(truePeakLocations,7)> lowfluorFlag); %find the truePeaks that also have fluorescence channel 2 above the 
truePeaksHighFluor = truePeaks(temp);% These have begining, end, Ca >.2 above the cutoff and fluorescence channel 2 above that cutoff.
    noPeakDataSignaling=isempty(truePeaksHighFluor);

peakDataSignaling = peakData(truePeaksHighFluor,[1 11 2 5 7 9 15 16]);
%peakDataSignaling = peakData(truePeaksHighFluor,[1 11 2 5 7 9 15 16 18 17]);

%need to enter 17 and 18 still

peakDataSignaling(:,9) =( peakData(truePeaksHighFluor,3)-peakData(truePeaksHighFluor,6)) ./ (peakData(truePeaksHighFluor,8)-peakData(truePeaksHighFluor,3));%time    rise/fall

counter2 = 0; %initialize
for counter=truePeaksHighFluor'
   theseStepLines = peakData (counter,6):peakData (counter,8);
lengthOfPeak = size(theseStepLines,2);% denominator
   
HowManyCaAboveCutoff =size(find(stepData(theseStepLines,13)>.2),1); %numerator
counter2 = counter2+1;
peakDataSignaling(counter2,10) = HowManyCaAboveCutoff/lengthOfPeak;
counter2;
end