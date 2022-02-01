function takeStereoPics(v1,v2,PathName,name)
frame1 = getsnapshot(v1);

isnotgoodname = 1;
count = 1;
OutFileName = [name '.jpg'];
while isnotgoodname
    OutFullFile = fullfile([PathName '\Cam1'],OutFileName);
    A = exist(OutFullFile,'file');
    if A == 2
        count = count+1;
        OutFileName = [name '_' num2str(count) '.jpg'];
    else
        isnotgoodname = 0;
    end
end
imwrite(frame1,OutFullFile)



frame2 = getsnapshot(v2);
%image(frame2);


isnotgoodname = 1;
count = 1;
OutFileName = [name '.jpg'];
while isnotgoodname
    OutFullFile = fullfile([PathName '\Cam2'],OutFileName);
    A = exist(OutFullFile,'file');
    if A == 2
        count = count+1;
        OutFileName = [name '_' num2str(count) '.jpg'];
    else
        isnotgoodname = 0;
    end
end
imwrite(frame2,OutFullFile)

end