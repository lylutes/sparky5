function [RootName, Z_Planes, TimesUnion, wavesPresent, StagesUnion,...
    fileData, HowManyStagePositions, HowManyTimePoints, HowManyWaves ] = ...
    FileNameAnalyzerFunction (imageFileNames, imagePathName, HowManyFiles)
%find the root name, directory path, wave, timepoint and stage position of the files 



disp('              Start script:          FileNameAnalyzerBits ')

%find the root name

TempRootName =imageFileNames(1,:);
RootPosition = findstr(TempRootName, '_w');    % the root name ends just before  _w
RootName = TempRootName (1:RootPosition-1); 
 disp(['RootName = ', num2str(RootName )])

%frames (ZSecs) is the number of  z-sections 
info = imfinfo(strcat(imagePathName , imageFileNames(1,:)));
frames = size(info);
if frames(1)>frames(2)
     disp('Its like my desk PC')
  
Z_Planes=frames(1);
else
    disp('Its like big Dell-2')
Z_Planes=frames(2);
end
 disp(['There are ', num2str(Z_Planes),' Z planes'])

StagesUnion = [] ;  %initialize
variousWaves = [];%initialize
TimesUnion = [];%initialize


%initiate
wavesPresent= [];


%step through the files
for fileNumber= 1:HowManyFiles(1,1)
    %listOfFileNames is an array that has all the fileNames.
    listOfFileNames(fileNumber).FileName = imageFileNames(fileNumber,:);

 disp(['Parsing file names  ', num2str(fileNumber)]);
 
%calculate timepoint of this file for an unknown number of digits
  
    timepoint=0; %initialize
    t = findstr(imageFileNames(fileNumber,:), '_t');
      EndTpDigits=findstr(imageFileNames(fileNumber,:), '.tif');% find the last digit in the timepoint number

    TpDigits= EndTpDigits-(t(end)+2); %  how many digits in the timepoint number

        for i=0 : TpDigits-1  %turn the digits into a real number
            timepoint = timepoint + (imageFileNames(fileNumber, EndTpDigits-1-i)-48)*10^i; %subtracting 48 turns the ascii code into the correct digit

         %  timepoint = timepoint + (listOfFileNames(fileNumber).FileName(EndTpDigits-1-i)-48)*10^i; %subtracting 48 turns the ascii code into the correct digit
        end %this is the end for turning digits into real numbers
        %timepoint
TimesUnion=union (TimesUnion,timepoint);%this accumulates all the timepoints



%find out which color (wave) this file is
    w = findstr(imageFileNames(fileNumber,:), '_w');
  wave =imageFileNames(fileNumber, w(end)+2)-48;
 wavesPresent =union (wave,wavesPresent);% this makes an array of all the waves as the files are read.

% figure out how many stage positions there are


%Is there a written stage position (_s)?   
ThereIsAn_S = ~isempty(findstr(imageFileNames(fileNumber,:), '_s'));

% Is the _s after the _w? That makes it a real stage position, not a
% spurious _s
s=findstr(imageFileNames(fileNumber,:), '_s');  % find where the _s is.
tempW=findstr(imageFileNames(fileNumber,:), '_w');% find where the _w is.
if ThereIsAn_S && (s(end)>tempW(end))%is there a _s and is it after the _w?
 EndStageDigits=findstr(imageFileNames(fileNumber,:), '_t');% find the last digit in the stage position number    
    StageDigits= EndStageDigits-(s(end)+2); %  how many digits in the stage position number
     StagePosition=0; %initialize
    for i=0 : StageDigits-1  %turn the digits into a real number
     stage = StagePosition + (imageFileNames(fileNumber,EndStageDigits-1-i)-48)*10^i;%subtracting 48 turns the ascii code into the correct digit
    end
else  stage = 1;        
    end % this is the end for turning digits into real numbers 
%     stage
StagesUnion = union(StagesUnion,stage);% this makes an array of all the stage positions as the files are read.
 
 % disp('stage'
%  disp([' Median filtering                         timepoint = ', num2str( timepoint)])



 fileData (wave,stage,timepoint)=fileNumber;

end %end for counting the file numbers

SizeStagesUnion= size(StagesUnion);
HowManyStagePositions = SizeStagesUnion(2) % The number of entries in "StagesUnion" is the total number of stage positions.

SizeTimesUnion = size (TimesUnion);
HowManyTimePoints = SizeTimesUnion(2)  % The  number of entries in "TimesUnion" is the total number of time points

MissingWaves=setdiff ([1,2,3,4],wavesPresent);

wavesPresent
MissingWaves
sizeWavesPresent = size(wavesPresent);
sizeMissingWaves = size(MissingWaves);

HowManyWaves = sizeWavesPresent(2);  % Number of waves in "wavesPresent"

% 
%If wrong it is like the two Dell differences
% frames = size(info);
% if frames(1)>frames(2)
%      disp('Its like my desk PC')
%   
% Z_Planes=frames(1);
% else
%     disp('Its like big Dell-2')
% Z_Planes=frames(2);
% end
%  disp(['There are ', num2str(Z_Planes),' Z planes'])
% 



disp('Finish script FileNameAnalyzerFunction ')

disp('       *')
disp('       *')
disp('       *') 

