%moreGroupStats
%Get the group averages of # of peaks / minute (trackData line 18)


for i =1: size (groupStats,1)
    currentGroup =groupStats(i,1)*1000;
    topLimit=currentGroup+999;
   groupLines1= find( trackData(:,1)>=currentGroup & trackData(:,1)<topLimit & trackData(:,18)>0);% These are the lines in trackData that have the group's definately signaling peaks.
groupStats (i,14)=mean(trackData(groupLines1,18));%  average # of peaks/minute for the signaling tracks
allGroupLines=find( trackData(:,1)>=currentGroup & trackData(:,1)<topLimit);% These are all the trackData lines for the current group
groupStats (i,15)=mean(trackData(allGroupLines,18));%  average # of peaks/minute for the signaling and non signaling tracks 

   groupLines2= find( peakDataSignaling(:,1)>=currentGroup & peakDataSignaling(:,1)<topLimit);% These are the lines in peakDataSignaling that belong to the group.
 groupStats(i,16)  = mean(peakDataSignaling(groupLines2,2).*ratioSTD+ratioAverage);% average maximum CaRatio of signaling peaks (converted from std above average back to CaRatio)

   groupLines3= find( peakDataSignaling(:,1)>=currentGroup & peakDataSignaling(:,1)<topLimit & peakDataSignaling(:,15)>0);% These are the lines in peakDataSignaling that belong to the group.
groupStats(i,17) = mean (peakDataSignaling(groupLines3,12));

groupStats(i,20) = mean (trackData(groupLines1,21));%average CaMax of all peaks above the cutoff

  groupStats(i,21) = mean(peakDataSignaling(groupLines3,12));%peak duration (minutes)
  groupStats(i,22) = mean(peakDataSignaling(groupLines3,21));%   time     rise/fall ratio
  groupStats(i,23) = mean(peakDataSignaling(groupLines3,15));     %Ca     rise/fall ratio


end



