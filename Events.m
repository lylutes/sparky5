%Events
%find the events as defined by Ellen.

events=[]; %initialize

% stepData(2365:2370,13)=1;
% stepData(2371,10)=3;

%events columns are:
%{
1= event number   2 = track number 
3= event beginning line             4= event ending line
5= event beginning timepoint           6=event ending timepoint
7= event has a beginning in the track    8 = event has an ending in the track     9 = event has a begining and and end in the track
10= duration: timepoints  11= duration: seconds
12= average corrected calcium of this event
13= maximum corrected calcium of this event
14= type of track  (1=low 2=high 3=other)
15= length of the original track
%}
eventNumber = 0; %initialize
 for i=1:size(trackData,1) %step through the tracks


%lookForEvent is a marker that moves to indicate which steps have already
%been evaluated.
lookForEvent=trackData(i,2); %Initialize at the first line of the track
 step = lookForEvent; %initialize
 while step >=lookForEvent & step <=trackData(i,3)-specs(1,2)/specs(1,1) %keep going until you hit the end of the track
   
        if stepData(step,13)>specs(1,5) %look for Ca > 0.2?  I have found an event!
            eventNumber = eventNumber + 1;
            events(eventNumber,1) =  eventNumber; %put in the event number
            events(eventNumber,2) = trackData(i,1); %put in the track number
            events(eventNumber,3) = trackData(i,2); % Temporarily put the first line as the first line of the track. This may be changed by line 37 (events(eventNumber,3) = stepBack+1 ;)
            events(eventNumber,4) = trackData(i,3); % Temporarily put the last line as the last line of the track. This may be changed by line 53 (events(eventNumber,4) = stepForward-1  ;)
            events(eventNumber,5) =   stepData(trackData(i,2),2);  % Temporarily put the first timepoint as the first timepoint of the track. This may be changed by line 38 (events(eventNumber,3)-trackData(i,2))
            events(eventNumber,6) = stepData(trackData(i,3),2)  ; % Temporarily put the last timepoint as the last timepoint of the track. This may be changed by line 48 (events(eventNumber,4) = stepForward-1  ;)
            events(eventNumber,16) = step;
            events(eventNumber,17) = stepData(step,2);
     
            events(eventNumber,7:12) = 0; %initialize
            
            for stepBack = step-1:-1:lookForEvent %step backwards looking for the beginning of the event.
                if stepData(stepBack,13)<specs(1,6) && stepData(stepBack,10)>specs(1,7) % Ca less than 0.1 and interval speed > 6um? This is the timepoint before the event begins.
            events(eventNumber,3) = stepBack+1 ; % this is the first line of the event.            
            events(eventNumber,5) = stepData (stepBack+1,2); % this is the first line of the event. 
            events(eventNumber,7) = 1; %event has a beginning in the movie
   
            break %stop steping back to find the beginning.
                end %looking for the beginning of the event
                  events(eventNumber,3) = stepBack;
               %stepBack
            end %steping back
                
                
                for stepForward = step+1:trackData(i,3)-specs(1,2)/specs(1,1) %step forwards looking for the end of the event. Stop when there is no more long interval distance.
                   % stepForward
                    reporter=stepForward; % Keep track of how far you have gone looking for the end
                     if stepData(stepForward,13)<specs(1,6) && stepData(stepForward,10)>specs(1,7) % Ca less than 0.1 and interval speed > 6um? This is the timepoint after the event ends.
                     events(eventNumber,4) = stepForward-1  ; % this is the last line of the event.

        events(eventNumber,6) = stepData (stepForward-1,2); % this is the last line of the event.
        events(eventNumber,8) = 1; %event has an end in the movie
            break %stop steping forward to find the end of the event.
                     end
     %                 events(eventNumber,8)=stepForward;
                end % steping Forward 
            if events(eventNumber,7) == 1 && events(eventNumber,8) == 1 %The event has both a beginning and an end in the track.
            events(eventNumber,9) = 1; 
            end
      lookForEvent=stepForward-1;
      step = stepForward;
  events(eventNumber,15) =      trackData(i,3)-  trackData(i,2)+1; % length of the track
      end %I found an event!
      step=step+1;
      
      
end      %while
end%i %end stepping through the tracks

if isempty(events);% If there are no events, skip the rest of this script. Go back to Sparky script.
    return
end %if there are events

% Put in the beginning timepoint for events that start before the movie starts
% noBeginning=find(events(:,7)==0); %these have no beginning
% events(noBeginning,3) = 1;

% Put in the ending timepoint for events that end after the movie ends.

noEnding= find(events(:,8)==0); %These have no end
% for eventsLineCounter=1: size(events,1)
% startline= trackData(   find(trackData(:,2)==noEnding),2)
% events(noEnding,4)=    trackData(noEnding,3)- trackData(noEnding,2)+1;
% end
events(:,10) = events(:,4) - events(:,3) + 1; %duration: timepoints
events(:,11) = events(:,10)* specs (1,1);     %duration: seconds
for eventsStep = 1:size(events,1)
events(eventsStep,12) = mean (stepData(events(eventsStep,3):events(eventsStep,4),13)); % average corrected Ca ratio of the event
events(eventsStep,13) = max (stepData(events(eventsStep,3):events(eventsStep,4),13));  % maximum corrected Ca ratio of the event
events(eventsStep,14) = trackData(find(trackData(:,1)==events(eventsStep,2)),17); %  type of track  (1=low 2=high 3=other)
end

 events(:,2:end) = sortrows(events(:,2:end),-13); %sort by low, high, other -descending. Don't sort the first column.


%put in the timepoints relative to the event trigger

uniqueTracks =unique (events(:,2)); %list of tracks that have events

for i=1:size (uniqueTracks,1);
uniqueTracks(i,2)= size(find( events(:,2)==uniqueTracks(i,1)),1); %column 2 tells how many events in each track.
end

stepData (:,17)=NaN;
for i=1:size (uniqueTracks,1) % step through them
   eventsStep= find(events (:,2)==uniqueTracks(i,1),1,'first'); %find the first instance of the ith track in the events list
theseStepDataLines = find( stepData(:,1)==events(eventsStep,2)); %these are the lines in stepData for this track
trackDataLine= find (trackData(:,1)==events(eventsStep,2));%this is the line in TrackData
   stepData(theseStepDataLines,17)= [trackData(trackDataLine,2):trackData(trackDataLine,3)]- events(eventsStep,16); %stepData column 17 is the position relative to the trigger event.
  %                                   from the beginning to the end lines of the track        event triger line                   
end
    
    
    
    
    
    
    







