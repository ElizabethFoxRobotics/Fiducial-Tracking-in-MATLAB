function stereo_to_3d()
%gets 3D points from fiducials
[PathName] = uigetdir();
%PathName='C:\Users\efox\Documents\MATLAB\ARMlab\fiducial_test\Stereo\1-16-19';
cd(PathName)
load('StereoParams.mat');

[FileName,PathName] = uigetfile('Fiducials_Analyzed_1.mat','Select Camera 1 File','Multiselect','off');
%FileName = 'Fiducials_Analyzed_2.mat';
%PathName='C:\Users\efox\Documents\MATLAB\ARMlab\fiducial_test\Stereo\1-16-19\Cam1Undist\';
c1_pts=load(fullfile(PathName,FileName));
[FileName,PathName] = uigetfile('Fiducials_Analyzed_1.mat','Select Camera 2 File','Multiselect','off');
%FileName='Fiducials_Analyzed_2.mat';
%PathName='C:\Users\efox\Documents\MATLAB\ARMlab\fiducial_test\Stereo\1-16-19\Cam2Undist\';
c2_pts = load(fullfile(PathName,FileName));

c1_x = c1_pts.DataOutput.locsX;
c1_y = c1_pts.DataOutput.locsY;
c2_x = c2_pts.DataOutput.locsX;
c2_y = c2_pts.DataOutput.locsY;

allpts=[];

%go through images
%undistort images
for i=1:length(c1_x)
    fid_c1 = [c1_x(:,i) c1_y(:,i)];
    fid_c2 = [c2_x(:,i) c2_y(:,i)];
    
    worldPoints=triangulate(fid_c1,fid_c2,stereoParams);
    %cla;
    hold on;
    scatter3(worldPoints(:,1),worldPoints(:,2),worldPoints(:,3))
    line([worldPoints(1,1) worldPoints(2,1)],[worldPoints(1,2) worldPoints(2,2)],[worldPoints(1,3) worldPoints(2,3)])
    line([worldPoints(2,1) worldPoints(3,1)],[worldPoints(2,2) worldPoints(3,2)],[worldPoints(2,3) worldPoints(3,3)])
    line([worldPoints(3,1) worldPoints(4,1)],[worldPoints(3,2) worldPoints(4,2)],[worldPoints(3,3) worldPoints(4,3)])
    bdist(i) = sqrt((worldPoints(1,1)-worldPoints(2,1))^2+(worldPoints(1,2)-worldPoints(2,2))^2+(worldPoints(1,3)-worldPoints(2,3))^2);
    tdist(i) = sqrt((worldPoints(3,1)-worldPoints(4,1))^2+(worldPoints(3,2)-worldPoints(4,2))^2+(worldPoints(3,3)-worldPoints(4,3))^2);
    distdiff(i) = bdist(i)-tdist(i);
    axis equal
    allpts = [allpts; worldPoints];
    
end
[plane,gof]=fit(allpts(:,1:2),allpts(:,3),'poly11')

depth = plane.p00/sqrt(plane.p01^2+plane.p10^2+1);

mass = c1_pts.DataOutput.mass;
pres = c1_pts.DataOutput.pres;
save('3d_pts+plane.mat','allpts','bdist','tdist','plane','gof','mass','pres','depth')
end

