% analyzeGroups

%Identify the individual groups in the list of tracks
groups=floor(trackData(:,1)./1000);
groupsUnique =unique(groups); %this is the list of groups
groupStats=zeros(size(groupsUnique,1),7);
for i=1:size(groupsUnique,1) %step through the groups
group(i).lines=find(groups==groupsUnique(i));%find which lines in trackData belong to the group
group(i).groupNumber=groupsUnique(i);
group(i).numberInGroup = size (group(i).lines,1);

group(i).lowSignaling = group(i).lines(find (trackData(group(i).lines,17)==1));%Low signaling tracks. These are the lines in trackData 
group(i).highSignaling = group(i).lines(find (trackData(group(i).lines,17)==2));%high signaling tracks. These are the lines in trackData 
group(i).otherSignaling = group(i).lines(find (trackData(group(i).lines,17)==3));%other signaling tracks. These are the lines in trackData 

group(i).numberLowSignaling = size (group(i).lowSignaling,1);
group(i).numberHighSignaling = size (group(i).highSignaling,1);
group(i).numberOtherSignaling = size (group(i).otherSignaling,1);

group(i).fractionLowSignaling = group(i).numberLowSignaling/group(i).numberInGroup;
group(i).fractionHighSignaling = group(i).numberHighSignaling/group(i).numberInGroup;
group(i).fractionOtherSignaling = group(i).numberOtherSignaling/group(i).numberInGroup;

end


%to be continued!



% group(i).fractionMaybeSignaling = group(i).numberMaybeSignaling/group(i).numberInGroup;
% group(i).fractionAllSignaling =( group(i).numberMaybeSignaling + group(i).numberDefinatelySignaling )/ group(i).numberInGroup;
% 
% groupStats(i,1) = group(i).groupNumber ; %group number
% groupStats(i,2) = group(i).numberInGroup ;
% groupStats(i,3) = group(i).numberDefinatelySignaling ;
% groupStats(i,4) = group(i).numberMaybeSignaling ;
% groupStats(i,5) = group(i).fractionDefinatelySignaling ;
% groupStats(i,6) = group(i).fractionMaybeSignaling ;
% groupStats(i,7) = group(i).fractionAllSignaling ;
% 
% 
% 
%                     %to get the data back out
% % allSignaling(group(i).lines  ,1)                   %Gives the track numbers
% % allSignaling(group(i).definatelySignaling  ,1)     %Gives the track numbers
% % allSignaling(group(i).maybeSignaling  ,1)          %Gives the track numbers
% % allSignaling(group(i).maybeSignaling  ,5)          %Gives the rSquared value
% % group(i).numberInGroup
% % group(i).numberDefinatelySignaling
% % group(i).numberMaybeSignaling
% % group(i).fractionDefinatelySignaling
% % group(i).fractionMaybeSignaling
% %group(i).fractionAllSignaling
% 
% 
% 
% end
% 
% 
% 








