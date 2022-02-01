function processStereoPics()
%undistorts stereo images
[PathName] = uigetdir();
cd(PathName)
load('StereoParams.mat');

pics=dir(fullfile('Cam1','*.jpg'));
%go through images
%undistort images
for i=1:length(pics)
    p1=imread(['Cam1/' pics(i).name]);
    p1u = undistortImage(p1,stereoParams.CameraParameters1);
    imwrite(p1u,['Cam1Undist/' pics(i).name])
    
    p2=imread(['Cam2/' pics(i).name]);
    p2u = undistortImage(p2,stereoParams.CameraParameters2);
    imwrite(p2u,['Cam2Undist/' pics(i).name])
    
    
end

end

