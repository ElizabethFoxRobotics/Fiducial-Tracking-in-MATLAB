function makeCamDirectory(filename)
%make directory structure for stereo camera setup
mkdir(filename)
mkdir(filename,'Cam1')
mkdir(filename,'Cam1Undist')
mkdir(filename,'Cam1Cal')
mkdir(filename,'Cam2')
mkdir(filename,'Cam2Undist')
mkdir(filename,'Cam2Cal')
end

