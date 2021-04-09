function [imageFileNames, imagePathName] = getImageNamesFunction(defaultPath,saveName)
% Opens dialog to select images to be processed.
% Nicholas Pastor, UC Berkeley, 02-28-2008

% Determine default path name based on OS
if (ismac)
  %  defaultPath = '/Users/';
  defaultPath = '/Applications/MATLAB_R2007B/work';
  
elseif (ispc)
  %  defaultPath = 'C:\';   
 %   defaultPath = 'C:\Documents and Settings\Paul\Desktop\small position pollen\';
 %   defaultPath = 'F:\microscopy\two photon\wPpTR031407m3s4\';
 % defaultPath =  'C:\Documents and Settings\Paul\Desktop\';

 try  %see if there is a previously saved default path
    saveName
  
     load (saveName)
    
 catch
     disp('Cant find saved name')
     %otherwise use the default path that was defined when calling the
     %function
 end 
 if 0 == defaultPath ;
     
disp('use this defaultPath   C:\Documents and Settings\Paul\Desktop\')
   defaultPath =   'C:\Documents and Settings\Paul\Desktop\';
 end
else
     defaultPath = '/home/';
end

% Select images; uigetfile opens dialog window with specified
%  characteristics:  types of files to allow, title, path, select more than
%  one file
[imageFileNames1, imagePathName] = uigetfile( ...
        {  '*.*', 'All Files' }, ...
        'Select Image Files', ...
        defaultPath, ...
        'MultiSelect', 'on');
 %         { '*.tif', 'Tiff Files'; ...
%           '*.tif; *.jpg; *.gif','All Image Files'; ...

imageFileNames=char(imageFileNames1);%change from cell array to character array
  defaultPath=imagePathName;

save (saveName,'defaultPath'); %this will be saved to look here the next time.

end


