 %slowBuildPeaks
 %coming from CaFluxingOscillatingList
 
 %this script finds local peaks. then it looks before and after the peak for when it
 %bottoms out(if the movie lasts long enough) The descriptors of the peak
 %are in peakData
 %This also plots the peaks, slopes, calculated CaRatio maximum. After
 %finding a peak it looks in the remaining time points for the next local peak . 
 %It finds all the peaks in a track.
 
  plotGraph=0;  % initialize Don't plot
 
  plotConditions = 0;
%  0 don't plot any but process them all
%  1 plot just the one, process just the one
%  1.1  %plot just the one but process them all
%  2 plot them all and pause at the end of each

 %%%%%%%%%%Put the tracks you want to plot here.   %%%%%%%%
theseTracks= find(trackData(:,1)==1010); %this gives the row number in trackData where the track occurs


close all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  only pick the first five peaks
%%%%%%%%%%%%%%%%%%%%%look near the end of the for loop to see  "if peakNumber ==5    %limit to five peaks only

      lengthOfBeforeRunningSlope=11 %11
      lengthOfAfterRunningSlope=7 %7
   
    %9016  doesn't start at the beginning of the movie. It has slopes
    %before and after the peak. The beginning slope runs to the first track
    %timepoint
    
    %6060 the before slope begins after the track starts
    %7019 has a before slope that begins after the track starts. no after
    %slope. the highest point is at the end.
    
    %7022 has a before slope that begins after the track starts.and a
    % after slope that ends before the track ends.
    
    %9022 has two well contained slopes.They both zero out
peakData=[];  %initialize
counter=0; % initialize
 x1=[];
 x2=[];
 y1=[];
 y2=[];
 noPeak=[];
 entryCounter=0;
 accumulatingPeaks=[];

stepDataSize=size(stepData);


if plotConditions==1 | plotConditions==2
      pause on
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  0 don't plot any
%  1 plot just the one
%  2 plot them all and pause at the end of each

if plotConditions==0 %don't plot any
    doThese=1:trackDataSize(1);% Process all the tracks
end

if plotConditions==1  %plot just the one
    doThese=theseTracks; %process just these tracks;
end

if plotConditions==1.1  %plot just the one
    doThese=1:trackDataSize(1); %process them all
    disp('Plot just one but process them all')
  
end

if plotConditions==2  %plot them all and pause at the end of each
     doThese=1:trackDataSize(1);% Process all the tracks
     plotGraph=1;
end

for analyseTheseTracksLineNumber=doThese
         currentTrack=trackData(analyseTheseTracksLineNumber,1);

disp(strcat('The current track =  ', num2str(currentTrack)))
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 % analyseTheseTracks= find (trackData(:,6)==3|trackData(:,6)==2)';%list of oscillating and stable low tracks.
 %for analyseTheseTracksLineNumber= analyseTheseTracks
 
  %for lots of tracks use this one
  %for analyseTheseTracksLineNumber=1:trackDataSize(1)% Process all the tracks
      peakNumber=0;
     
      %for just one track use this
    % for analyseTheseTracksLineNumber= theseTracks %process just these tracks
    if   plotConditions == 1
        counter =theseTracks
    else
 counter = counter+1;
 if currentTrack==2010
 end
    end
%until no more peaks, keep looking
   noPeak= trackData(counter,firstTP)-1+find (stepData(trackData(counter,firstTP):trackData(counter,lastTP),16)<1);%find the lines that don't yet have a peak
% noPeak is a list of the timepoints that are not yet in a peak. Look for
% the maxCa (the seed for the next peak search) among these timepoints.

while  ~isempty(noPeak)
    peakNumber = peakNumber + 1;
    entryCounter=entryCounter+1;

     if  analyseTheseTracksLineNumber==theseTracks &   (plotConditions == 1| plotConditions == 1.1) | plotConditions == 2

        plotGraph=1; %plot it
 
     else 
        plotGraph=0;% don't plot it 
     end
     currentTrack=trackData(analyseTheseTracksLineNumber,1);
     
     %find the highest highest corrected CaRatio 
maxCa= max(stepData(noPeak,13));
 maxCaLineNumber=find(stepData(:,13)== maxCa    &  stepData(:,1)== currentTrack);%which line has the highest Ca std from average.The " ,1,'first'" make it return the first if there are two lines with the same highest CaRatio.
 if  size(maxCaLineNumber,1)>1
 % If there are two or more exactly the same size peaks decrease all but two of them a tiny amount. This will avoid an infinate loop where it looks for the hightest,
       %then it does that one, then it looks for the highest and does the
       %same one over and over.
stepData(maxCaLineNumber(2:end),13) = stepData(maxCaLineNumber(2:end),13)-.000001; %subtract a tiny amount from the others.
 maxCaLineNumber= maxCaLineNumber(1);
 end


   peakData(entryCounter,1)=    currentTrack;
   peakData(entryCounter,2)=  maxCa;
   peakData(entryCounter,3)= maxCaLineNumber;
   peakData(entryCounter,11)= peakNumber;
  % disp(strcat('The current track =  ', num2str(currentTrack),'...peak # ',num2str(peakNumber)))
% disp(strcat('The maximum Ca ratio (std from average) = ', num2str( maxCa)))
% disp(strcat('The line number of the Ca peak = ', num2str( maxCaLineNumber)))

partTitle=strcat('track=',num2str(currentTrack),'peak=',num2str(peakNumber));
charPartTitle=char(partTitle);
%help--> Positioning Figures
%     rect = [0, 0, 1, 1];
%      h=gcf;



if plotGraph==1
  screenSize = get(0,'ScreenSize');
  %                    left  bottom               width                 height
figure('OuterPosition',[ 1920  60       screenSize(3)*.5       screenSize(4)*.75])
  h=gcf;
set(h,'Name',charPartTitle,'NumberTitle','off')

%figure %1
    %plot the running slope from the peak towards the beginning
  %show the basic plot
      subplot(2,2,1);
  plot (trackData(analyseTheseTracksLineNumber,firstTP)    :   trackData(analyseTheseTracksLineNumber,lastTP), ...  
        stepData(trackData(analyseTheseTracksLineNumber,firstTP)   :    trackData(analyseTheseTracksLineNumber,lastTP),9) )  %Y
   hold on
    plot(maxCaLineNumber,stepData(maxCaLineNumber,13),'r*') %show the peak calcium
end %end this plot  





      subplot(2,2,3);
  plot (trackData(analyseTheseTracksLineNumber,firstTP)    :   trackData(analyseTheseTracksLineNumber,lastTP), ...  
        stepData(trackData(analyseTheseTracksLineNumber,firstTP)   :    trackData(analyseTheseTracksLineNumber,lastTP),9) )  %Y
   hold on
    plot(maxCaLineNumber,stepData(maxCaLineNumber,13),'r*') %show the peak calcium





    %%%%%%%%%%%%%%find the before slope
    if lengthOfBeforeRunningSlope>maxCaLineNumber-trackData(analyseTheseTracksLineNumber,firstTP)
     finalSlopeBefore=[nan nan]  ; 
    end
 
    %find the before slope
  for  startBeforeRunningSlope=maxCaLineNumber    :-1  :    trackData(analyseTheseTracksLineNumber,firstTP)+  lengthOfBeforeRunningSlope;
   interimBeforeRunningSlope =polyfit((startBeforeRunningSlope-  lengthOfBeforeRunningSlope:startBeforeRunningSlope)',...
   stepData(startBeforeRunningSlope-  lengthOfBeforeRunningSlope:startBeforeRunningSlope,13),1);


   if plotGraph==1
   x=startBeforeRunningSlope-  lengthOfBeforeRunningSlope:startBeforeRunningSlope;
 y=interimBeforeRunningSlope(1)*x+interimBeforeRunningSlope(2);
 plot(x,y)
   end   %end this plot
   

   % Stop looking for the beginning of the before-slope if it happens before the movie starts
   if startBeforeRunningSlope== trackData(analyseTheseTracksLineNumber,firstTP)+  lengthOfBeforeRunningSlope
   peakBeginning=trackData(analyseTheseTracksLineNumber,firstTP);
     x1=peakBeginning:maxCaLineNumber;
        finalSlopeBefore = polyfit(x1,    stepData(peakBeginning:maxCaLineNumber,13)',1);
      y1=finalSlopeBefore(1)*x1+finalSlopeBefore(2);
% disp(strcat('before-slope = ', num2str(finalSlopeBefore(1))))
% disp(strcat('beginning of peak = ', num2str(peakBeginning)))
   break 
   end
   

 if  interimBeforeRunningSlope(1)<=0 %stop plotting the slope when it gets to 0
     peakBeginning=startBeforeRunningSlope-round(lengthOfBeforeRunningSlope/2);
       x1=peakBeginning:maxCaLineNumber;
    finalSlopeBefore = polyfit(x1,stepData(peakBeginning:maxCaLineNumber,13)',1);
      y1=finalSlopeBefore(1)*x1+finalSlopeBefore(2);
      if finalSlopeBefore(1)>=0 % if the slope goes the wrong way label it -1
        peakData(entryCounter,12)= 1; % the before-slope bottoms out
      else
        peakData(entryCounter,12)= -1; % if the slope goes the wrong way label it -1
      end
% disp(strcat('before-slope = ', num2str(finalSlopeBefore(1))))
% disp(strcat('beginning of peak = ', num2str(peakBeginning)))
     break, end
  end % looking for the before-slope
  
  

 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%       Now think about the after-slope
 
  if maxCaLineNumber > trackData(analyseTheseTracksLineNumber,lastTP)-  lengthOfAfterRunningSlope 
      % disp('No after-slope!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!')
      IsThereAfterSlope = 0;
  peakEnd=[];
  else
      IsThereAfterSlope = 1;
  end
    if plotGraph==1
  subplot(2,2,2);
    %show the basic plot
  plot (trackData(analyseTheseTracksLineNumber,firstTP)    :   trackData(analyseTheseTracksLineNumber,lastTP), ...  
        stepData(trackData(analyseTheseTracksLineNumber,firstTP)   :    trackData(analyseTheseTracksLineNumber,lastTP),9) )  %Y
   hold on
    plot(maxCaLineNumber,stepData(maxCaLineNumber,13),'r*') %show the peak calcium
    end % end this plot
%start looking for the after-slope
  for  startAfterRunningSlope=maxCaLineNumber    :1  :    trackData(analyseTheseTracksLineNumber,lastTP)-  lengthOfAfterRunningSlope;
%It won't do this loop if there is not enough rooom after the peak for a running slope
  
interimAfterRunningSlope =polyfit( startAfterRunningSlope :startAfterRunningSlope+  lengthOfAfterRunningSlope,stepData( startAfterRunningSlope :startAfterRunningSlope+  lengthOfAfterRunningSlope,13)',1);
if plotGraph==1
x= startAfterRunningSlope :startAfterRunningSlope+  lengthOfAfterRunningSlope;
y=interimAfterRunningSlope(1)*x+interimAfterRunningSlope(2);
 plot(x,y)
end % end this plot
  if  interimAfterRunningSlope(1)>=0 %stop plotting the slope when it gets to 0
          peakEnd=startAfterRunningSlope+round(lengthOfAfterRunningSlope/2);
          
                  peakData(entryCounter,13)= 1; % the after-slope bottoms out

      break
end
  

  end %stop looking for after-slope
     if startAfterRunningSlope==  trackData(analyseTheseTracksLineNumber,lastTP)-  lengthOfAfterRunningSlope     &   ...
        interimAfterRunningSlope(1)<0  ;% if the movie ends and the line is still going down
        % disp('Movie ended and the line is still decreasing!!!!!!!!!!!!!!')
      peakEnd=trackData(analyseTheseTracksLineNumber,lastTP);
     end
% if peakEnd==[]%normal end of peak
%     peakEnd=startAfterRunningSlope+round(lengthOfAfterRunningSlope/2);
% end

%      
%      % Get after-slope line
%           x2=stepData(maxCaLineNumber:peakEnd,2);
%      y2=finalSlopeAfter(1)*x2+finalSlopeAfter(2);
% disp(strcat('after-slope = ', num2str(finalSlopeAfter(1))))
% disp(strcat('end of peak = ', num2str(peakEnd)))
   
     

     
           if IsThereAfterSlope == 1;
     finalSlopeAfter = polyfit(maxCaLineNumber :peakEnd,stepData(maxCaLineNumber : peakEnd,13)',1);
           else
                          finalSlopeAfter = [nan nan];
           end
           
        x2=maxCaLineNumber:peakEnd;
       y2=finalSlopeAfter(1)*x2+finalSlopeAfter(2);
       
       if finalSlopeAfter(1)>=0
           peakData(entryCounter,13)=-1;
       end
       
       
  if plotGraph==1
     subplot(2,2,4);
     %figure% Plot both the slopes
     %basic plot
       plot (trackData(analyseTheseTracksLineNumber,firstTP)    :   trackData(analyseTheseTracksLineNumber,lastTP), ...  
        stepData(trackData(analyseTheseTracksLineNumber,firstTP)   :    trackData(analyseTheseTracksLineNumber,lastTP),9) )  %Y
   hold on
    plot(maxCaLineNumber,stepData(maxCaLineNumber,13),'r*') %show the peak calcium
     
     %if the before slope doent't exist, don't use the previous one (accidentally).
TF = isnan(finalSlopeBefore);
     if TF ~= [1 1]
plot(x1,y1)

     end
   if IsThereAfterSlope == 1;
plot(x2,y2)

    
% disp(strcat('after-slope = ', num2str(finalSlopeAfter(1))))
   end

     end %end this plot
% disp(strcat('end of peak = ', num2str(peakEnd)))


     

     
  
  %peakData columns            1=current track 2 =maxCa 3=maxCaLineNumber
  
   %find crossing point of two fit lines
   
   if finalSlopeBefore~=[nan nan]
    m1=finalSlopeBefore(1);
   b1=finalSlopeBefore(2);
   end
   if IsThereAfterSlope == 1
  m2=finalSlopeAfter(1);
   b2=finalSlopeAfter(2);
   end
       
    
    
     % I fixed it to here 
  

    
    
    
       thisTrackCounter= find(trackData(:,1)==currentTrack); 

   if  ~ isnan(finalSlopeBefore)  & IsThereAfterSlope == 1; % There are slopes both before and after the peak
  %     disp('There are slopes both before and after the peak')
   peakData (entryCounter,4)    = ((b1-b2)/m2)/(1-(m1/m2));%highest Calculated Ca Time Point (X)
   peakData (entryCounter,5)    = m2*  peakData (entryCounter,4)+b2;%    highestCalculatedCa(Y)
   peakData (entryCounter,6)    = x1(1); %beginning of the peak
   peakData (entryCounter,7)    = y1(1); %beginning baseline
   peakData (entryCounter,8)    = x2(end);%end of peak
   peakData (entryCounter,9)    = y2(end);%ending baseline
   peakData (entryCounter,10)    =trackData(thisTrackCounter,firstTP); 
  
   elseif ~ isnan(finalSlopeBefore) & IsThereAfterSlope ~= 1  %there is a slope before but not after the peak
  %        disp('there is a slope before but not after the peak')
   peakData (entryCounter,4)    = x1(end);    %highest Ca timepoint (X)
   peakData (entryCounter,5)    = y1(end);   %highest Ca  (Y)
   peakData (entryCounter,6)    = x1(1); %beginning of the peak
   peakData (entryCounter,7)    = y1(1); %beginning baseline
   peakData (entryCounter,8)    = nan;% peakEnd line number (X) 
   peakData (entryCounter,9)    = nan;%ending baseline (Y)
   peakData (entryCounter,10)    =trackData(thisTrackCounter,firstTP); %track starting line number

   elseif  isnan(finalSlopeBefore) & IsThereAfterSlope == 1  %there is no slope before but but there is one after the peak
    %      disp('there is no slope before but but there is one after the peak')
   peakData (entryCounter,4)    = x2(1);%highest Calculated Ca Time Point (X)
   peakData (entryCounter,5)    = y2(1);%    highestCalculatedCa(Y)
   peakData (entryCounter,6)    = nan; %beginning of the peak
   peakData (entryCounter,7)    = nan;%beginning baseline
   peakData (entryCounter,8)    = x2(end);%end of peak
   peakData (entryCounter,9)    = y2(end);%ending baseline
   peakData (entryCounter,10)    =trackData(thisTrackCounter,firstTP); %track starting line number

   else %There is no slope either before or after the peak.
   peakData (entryCounter,4)    =nan;   %highest Calculated Ca Time Point (X)
   peakData (entryCounter,5)    =nan;   %    highestCalculatedCa(Y)
   peakData (entryCounter,6)    =nan; %beginning of the peak
   peakData (entryCounter,7)    =nan; %beginning baseline
   peakData (entryCounter,8)    =nan; %end of peak
   peakData (entryCounter,9)    =nan; %ending baseline
   peakData (entryCounter,10)    =trackData(thisTrackCounter,firstTP); %track starting line number
  %        disp('there is no slope before or after the peak')
   end
     
 
%end %end stepping though the tracks
  % disp('peakData columns')
  % disp('1=current track 2 =maxCa 3=maxCaLineNumber 4=highest Calculated Ca Time Point (X) 5=highestCalculatedCa(Y)')

  baseLineSort=sort([ peakData(entryCounter,7)  peakData(entryCounter,9)]); %find the lowest of the two baselines (before and after)
  peakHeight= peakData(entryCounter,5)- baseLineSort(1);%then find the maximum peak height above the baseline

%   if the peak is high enough
%       look for the next highest peak among the remaining timepoints.
%       put that peak in and start the process over.
%       
%   else finish this track.
%   
%   
%   
  
  
 if plotGraph==1
  % fprintf('\n\n current track = %4.0f \n maxCa = %1.4f \n maxCaLineNumber = %1.0f  \n calculated peak time point (X) = %4.2f  \n calculated peak Ca (Y) = %4.2f \n ', peakData(1,:))
 end
  % fprintf('\n\n current track = %4.0f \n maxCa = %1.4f \n maxCaLineNumber = %1.0f  \n calculated peak time point (X) = %4.2f  \n calculated peak Ca (Y) = %4.2f \n \n', peakData(counter,:))
%  if  analyseTheseTracksLineNumber == theseTracks
%end


%Lable positions of peaks in stepData column 16
peakPositions %script
  

if plotConditions==2%ie pause after each one
pause
close all
end

   noPeak= trackData(counter,firstTP)-1+find (stepData(trackData(counter,firstTP):trackData(counter,lastTP),16)<1);%find the lines that don't yet have a peak
% noPeak is a list of the timepoints that are not yet in a peak. Look for
% the maxCa (the seed for the next peak search) among these timepoints.



% if peakNumber ==5    %limit to five peaks only
%     break
%end




  end% Now go look for another peak
  % Now do the next track
 
end %Now go back to CaFluxingOscillatingList 

    % If the peak has slopes before and after, and if the peak corrected Ca is above 0.2 
  truePeaks=find(peakData(:,12)==1 & peakData(:,13)==1 & peakData(:,2)> 0.2);
  peakData (truePeaks,14)=1;
    peakData(truePeaks,15)= (peakData(truePeaks,8) - peakData(truePeaks,6))*timepointInterval/60;%duration of the peak
    peakData(truePeaks,16)= (peakData(truePeaks,2) - peakData(truePeaks,7))./(peakData(truePeaks,2) - peakData(truePeaks,9));% rise / fall ratio

  
pause off
pausing=0;
% now go back to Sparky