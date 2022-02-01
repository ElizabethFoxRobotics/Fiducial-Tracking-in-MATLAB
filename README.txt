This code set uses MATLAB to run two stereo cameras to track positions of red circular fiducial markers through multiple pictures.
MATLAB's image aquisition and image processing toolboxes are required, as well as checkerboard pattern of known spacing for camera calibration.
It is separated into multiple functions to assist with modularity and to allow for stopping/continuation; however, caution should be 
taken to ensure that camera parameters do not change if system is restarted.


Testing Experimental Procedure:
1.Run makeCamDirectory(‘directoryName’); this creates the directory structure required
2.Run "[v1,v2,PathName] = setupStereoCameras()"; select main folder (‘directoryName’) from step 1; windows with webcam feeds should pop up
•	If errors connecting to cameras, open apps>image Acquisition and find Logitech webcams in Hardware Browser to ensure video feed numbers match
3.Use takeStereoCalibrationPics(v1,v2,PathName)to take at least 20 sets of pictures of checkerboard in full view, at different locations and angles relative to cameras
•	During and after this step DO NOT MOVE OR BUMP CAMERAS or they will need to be recalibrated for future image aquisitions
4.Set up device with fiducials in full view of both cameras; ensure background is clear
5.Set up for static testing; this code takes one picture at a time
6.Run takeStereoPics(v1,v2,PathName,'name') with 'name' describing test settings.  Current code is set up to analyze files named in format ‘Xg_Y’ where X is mass in grams and Y is pressure in kPa

Analysis:
1.Use MATLAB's Stereo Camera Calibrator app to calibrate images
a.	In app, click Add Images button and select paths to calibration folders for each camera ( …/directoryName/Cam1Cal and …/directoryName/Cam2Cal) and set size of checkerboard square correct value
b.	Once images are processed, click “Calibrate” (>15 added pairs required)
d.	Export>Export Camera Parameters>Export Parameters to Workspace as "stereoParams"
2.In main MATLAB window, save StereoParams.mat in directory ‘directoryName’ 
3.Run MATLAB function processStereoPics()and choose ‘directoryName’ when prompted; this will undistort all images using the camera calibrations and save them in the CAMXUndist directories  
4.Run MATLAB GUI fiducial_imageProcessing_Stereo()
a.	In GUI, click Load Image File button, then select folderName/Cam1Undist/0g_0.jpg
b.	Input number of fiducials in popup
c.	Use editable boxes in Area of Interest section to select area with fiducials (note: this area will be the same for all images.  You can hit “Switch Image” to switch to the picture at 0 kPa with the highest mass, but other images may also use larger spaces).  These boxes can be edited at any time in the process.
d.	(optional) Use the “Mask Image” to select areas within image to ignore; this will affect all images so make sure mask does not interfere with fiducial paths in any image.  Unmask Image button will allow you to get rid of any masks in a chosen area.  Masking works with resizing image and with color thresholds.
e.	Use the “Threshold” boxes to set RGB limits to filter; red threshold limits the minimum amount of red in the pixels and green and blue set maximums of those values.
f.	The “Find circles (#)” will display how many circles it has found, and they will be shown on the image.  It is trying to get to exactly the number of fiducials input in step b for each picture in the set. Increase the sensitivity value (options are 0 to 1; higher numbers mean it will find more circles) and change the radii range (output below radii range gives minimum, mean, and maximum values for any found circles)
g.	Tune the RGB thresholds and the sensitivity to get the right number of circles found, without losing too much accuracy on circle location
h.	Click ‘Test Settings’; this will go through all images using the chosen settings; if if cannot find the correct number of fiducials in any image, button will turn red and failed image image will be brought up.  Change settings and try again
i.	Once correct number of fiducials are found for all images in set, “Save Data” button will appear; this will save file ‘Fiducials_Analyzed_n.mat’ (with n increasing as program is run) into the image's directory
5.Repeat Step 4 with images from Cam2Undist
6.Run stereo_to_3d; when prompted, select your directoryName; when prompted again select your Cam1Undist/Fiducials_analyzed_n.mat and then Cam2Undist/Fiducials_analyzed_n.mat. This will plot a graph showing the general fiducial position and will save a file ‘3d_pts+plane.mat’ into directoryName.
7.Run Matlab function stereo3D_getDisplacements; when prompted, select directoryName. This plots the actual displacements of the corners of the rigid links (based on the transformation between the fiducial locations and the link edges) and saves file "newjustflexureData.mat" in the given directory to save data from force, pressure, and angular, vertical, and horizontal displacements from each image
