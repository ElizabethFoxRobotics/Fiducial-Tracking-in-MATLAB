function [v1,v2,PathName] = setupStereoCameras()
%set up stereo cameras for acquisition; must be connected to two cameras
v1 = videoinput('winvideo',2);
v2 = videoinput('winvideo',3); %last variable may need to be changed to ensure MATLAB connects to two webcams
cam1=getselectedsource(v1)
%cam1.FocusMode = 'manual' %turns off autofocus
cam2=getselectedsource(v2)
%cam2.FocusMode = 'manual'


[PathName] = uigetdir(); %select major folder (containing Cam1,Cam2,etc) for experiment
preview(v1)
preview(v2)

end