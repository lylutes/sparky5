%peakPositions     script
%coming from slowBuildPeaks script

%change stepData column 24 zeros to ones for the timepoints that have been
%identified as part of a peak (as shown in peakData)


    if  ~ isnan(finalSlopeBefore)  & IsThereAfterSlope == 1; % There are slopes both before and after the peak
  first=peakData( entryCounter,6);% line number where the peak begins
 last= peakData( entryCounter,8);% line number where the peak ends
   elseif ~ isnan(finalSlopeBefore) & IsThereAfterSlope ~= 1  %there is a slope before but not after the peak
  first=peakData( entryCounter,6);% line number where the peak begins
 last= peakData( entryCounter,3);% line number of the peak 
   elseif  isnan(finalSlopeBefore) & IsThereAfterSlope == 1  %there is no slope before but but there is one after the peak
     first=peakData( entryCounter,3);% line number of the peak 
 last= peakData( entryCounter,8);% line number where the peak ends
   else %There is no slope either before or after the peak...Make them all 1's
first=trackData( counter,firstTP);
last=trackData( counter,lastTP);

    end
 stepData (first:last,16)=1;
 %accumulatingPeaks(:,entryCounter)  = stepData(1:60,24)';

%Now go back to slowBuildPeaks script