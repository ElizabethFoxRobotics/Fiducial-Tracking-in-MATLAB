function stereo3d_getDisplacements()

[PathName] = uigetdir();
%FileName = 'Fiducials_Analyzed_2.mat';
%PathName='C:\Users\efox\Documents\MATLAB\ARMlab\fiducial_test\Stereo\1-16-19\Cam1Undist\';
load(fullfile(PathName,'3d_pts+plane.mat'));



D = plane.p00;
A=plane.p10;
B=plane.p01;
C=-1;
V = [A;B;C];

fid1 = [];
fid2=[];
fid3=[];
fid4=[];
%1. project points
%2. convert plane to xy plane?
%3. get dx, dy, dtheta
for i = 1:size(allpts,1)/4
    x1 = allpts(4*i-3,:)
    t01 = -(dot(V,x1)+D)/(A^2+B^2+C^2);
    x1p= x1' + t01*V;
    
    
    x2 = allpts(4*i-2,:)
    t02 = -(dot(V,x2)+D)/(A^2+B^2+C^2);
    x2p= x2' + t02*V;
    
    x3 = allpts(4*i-1,:)
    t03 = -(dot(V,x3)+D)/(A^2+B^2+C^2);
    x3p= x3' + t03*V;
    
    x4 = allpts(4*i,:)
    t04 = -(dot(V,x4)+D)/(A^2+B^2+C^2);
    x4p= x4' + t04*V;
    
    V2 = [0 0 1];
    angrot = -acos(dot(V,V2)/sqrt(A^2+B^2+C^2)); %angle between "plane" and x-y plane

    b = -D/B;
    u=-B/sqrt(A^2+B^2);
    v=A/sqrt(A^2+B^2);

    Matx = [(u^2+v^2*cos(angrot)) u*v*(1-cos(angrot)) v*sin(angrot) -u*b*v*(1-cos(angrot));
        u*v*(1-cos(angrot)) (v^2+u^2*cos(angrot)) -u*sin(angrot) (b*u^2)*(1-cos(angrot));
        -v*sin(angrot) u*sin(angrot) cos(angrot) -b*u*sin(angrot);
        0 0 0 1];
    x1f = Matx*[x1p; 1]
    x2f = Matx*[x2p; 1]
    x3f = Matx*[x3p; 1]
    x4f = Matx*[x4p; 1]
    
    %check to make sure points projected properly onto xy plane:
    if max([x1f(3) x2f(3) x3f(3) x4f(3)]) > 10^-10
        input('Bad projection')
    end
    fid1 = [fid1; -x1f(1) x1f(2)];
    fid2 = [fid2; -x2f(1) x2f(2)];
    fid3 = [fid3; -x3f(1) x3f(2)];
    fid4 = [fid4; -x4f(1) x4f(2)];
end

%normalize around fiducial 1:
fid4 = fid4 -fid1;
fid3 = fid3 -fid1;
fid2 = fid2 -fid1;
fid1 = fid1 -fid1;

%scale to inches
fid2 = fid2/25.4;
fid3 = fid3/25.4;
fid4 = fid4/25.4;

normAng = -90-atan2(fid2(:,2)-fid1(:,2),fid2(:,1)-fid1(:,1))*(180/pi); % angle from horizontal

%rotate s.t. fid1+fid2 are vertical
for i = 1:size(fid1,1)
    R = [cosd(normAng(i)) -sind(normAng(i)); sind(normAng(i)) cosd(normAng(i))]
    fid2(i,:)=R*fid2(i,:)';
    fid3(i,:)=R*fid3(i,:)';
    fid4(i,:)=R*fid4(i,:)';
end
ang = atan2(fid4(:,2)-fid3(:,2),fid4(:,1)-fid3(:,1))*(180/pi);
ang = ang+90;%normAng;
%ppia = (sqrt((fid1(:,1)-fid2(:,1)).^2+(fid1(:,2)-fid2(:,2)).^2))/.5;
%ppi2a = (sqrt((fid3(:,1)-fid4(:,1)).^2+(fid3(:,2)-fid4(:,2)).^2))/.5;
%ppim=(sqrt((fid3(:,1)-fid2(:,1)).^2+(fid3(:,2)-fid2(:,2)).^2))/1

%ppi = mean(sqrt((fid1(:,1)-fid2(:,1)).^2+(fid1(:,2)-fid2(:,2)).^2))/.5;
%ppi2 = mean(sqrt((fid3(:,1)-fid4(:,1)).^2+(fid3(:,2)-fid4(:,2)).^2))/.5;
force = mass/1000*9.81;
%pres = fid.pres(1,:);
figure(1)
cla;
hold on;
%fid.locsX = fid.locsX/ppi;
%fid.locsY = fid.locsY/ppi;


scatter(fid1(:,1),-fid1(:,2))
scatter(fid2(:,1),-fid2(:,2))
scatter(fid3(:,1),-fid3(:,2))
scatter(fid4(:,1),-fid4(:,2))

p1 = [fid1(:,1); fid1(:,2)];
p2 = [fid2(:,1); fid2(:,2)];
p3 = [fid3(:,1); fid3(:,2)];
p4 = [fid4(:,1); fid4(:,2)];


L = .125;
%x0 = fid1(:,1)-L*sind(-normAng)-((2.5-.8)/2-.6)*cosd(-normAng);
%y0 = -fid1(:,2)-L*cosd(normAng)-((2.5-.8)/2-.6)*sind(-normAng);
normAng = normAng+90
%{
x2 = fid2(:,1)+L*sind(-normAng);
y2 = -fid2(:,2)+L*cosd(normAng);

x3 = fid3(:,1)-L*sind(ang+normAng);
y3 = -fid3(:,2)-L*cosd(ang+normAng);
%}
x2 = fid2(:,1);
y2 = -fid2(:,2)+L;

x3 = fid3(:,1)-L*sind(ang);
y3 = -fid3(:,2)-L*cosd(ang);
L3 = sqrt((x3-x2).^2+(y3-y2).^2);
a3 = 90-atan2(y3-y2,x3-x2)*180/pi;
xx3 = x2+L3.*sind(a3+normAng);
yy3 = y2+L3.*cosd(a3+normAng);

%x3 = fid4(:,1)+L*sind(ang+normAng)+((2.5-.8)/2-.6)*cosd(ang+normAng);
%y3 = -fid4(:,2)+L*cosd(ang+normAng)-((2.5-.8)/2-.6)*sind(ang+normAng);


figure()
hold on;
%scatter(x0,y0,'filled')
%scatter(x1,y1,'filled')
scatter(fid2(:,1),-fid2(:,2))
scatter(fid3(:,1),-fid3(:,2))
scatter(x2,y2,'filled')
scatter(x3,y3,'filled')
axis equal

legend('DO2','DO3','2','3')

x = x3-x2;
y = y3-y2;


len = sqrt(x.^2+y.^2)

figure()
hold on;
scatter(fid1(:,1),-fid1(:,2))
scatter(fid2(:,1),-fid2(:,2))
scatter(fid3(:,1),-fid3(:,2))
scatter(fid4(:,1),-fid4(:,2))
scatter(x2,y2,'filled')
scatter(x3,y3,'filled')
%scatter(xx3,yy3,'filled')
axis equal

ll = 0.8 + 1/16;
ll = (0.47601069+.125)
for i = 1:length(x2)
    line([fid1(i,1) fid2(i,1)], -[fid1(i,2) fid2(i,2)])
    line([fid2(i,1) x2(i)], [-fid2(i,2) y2(i)])
    %line([x2(i) x3(i)], [y2(i) y3(i)])
    line([x3(i) fid3(i,1)], [y3(i) -fid3(i,2)])
    %line([fid3(i,1) fid4(i,1)], -[fid3(i,2) fid4(i,2)])
    
    line(x2(i)+[0 ll],y2(i)+[0 0],'Color','red')
    line(x3(i)+[0 ll*cosd(ang(i))],y3(i)+[0 -ll*sind(ang(i))],'Color','red')
end
legend('DO1','DO2','DO3','DO4','2','3')


%save(fullfile(PathName,'flexureData.mat'),'ang','force','pres','xt','yt')
save(fullfile(PathName,'newjustflexureData.mat'),'ang','force','pres','x','y')


end