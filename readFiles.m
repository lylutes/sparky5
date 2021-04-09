%readFiles
disp('            start script:       readFiles ')
disp(['                         timepoint = ', num2str(timepoint ),' of ',num2str(HowManyTimePoints),' total time points'])
sizeWavesPresent=size(wavesPresent)
 for w= 1:sizeWavesPresent(2)
         wave=wavesPresent(w);
              disp(['reading wave  ', num2str( wave)])
 for stage= 1:HowManyStagePositions
          disp(['                    stage = ', num2str( stage)])
    
      
         %for each Z plane
for Z =  1:Z_Planes
 % Loads each Z plane into "images" structure
    [images.waves(wave).stages(stage).plane(Z).image,map] =...
        imread(strcat(imagePathName,imageFileNames(fileData(wave,stage,timepoint),:)),Z);
%disp(['Z = ', num2str(Z )])

%imageFileNames(fileData(w,s,t),:)
     
end %for stepping through the Z planes
%disp([imageFileNames(fileData(w,stage,timepoint),:)])
     end %for wave
 end %for stages
 
 disp('fieldnames= ')
disp( fieldnames(images.waves(wave).stages(stage).plane(1))) 
%This lists the fields that contain the images. like source, destination 





% disp ('highest wave')
% size(images.waves)
% disp ('# of stages')
% size(images.waves(wave).stages)
% disp ('# of planes')
% size(images.waves(wave).stages(stage).plane)

disp(['                         timepoint = ', num2str(timepoint ),' of ',num2str(HowManyTimePoints),' total time points'])
disp('finish script: readFiles' )

disp('       *')
disp('       *')
disp('       *')