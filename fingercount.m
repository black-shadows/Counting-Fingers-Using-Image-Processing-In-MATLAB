clc;
close all;
clear all;
video = imaq.VideoDevice('linuxvideo',1,'RGB24_640x480'); 
nframes = 0;

while nframes <= 100   %get frames from video
    
    level = 0.5;       
    frame=step(video);  
    IM1 = uint8(255*frame);
    subplot(3,3,1);imshow(IM1);title('Orginal');                %show original image
    IM2 = rgb2ycbcr(IM1);                                       %convert image to ycbcr
    figure(1);subplot(3,3,2);imshow(IM2);title('YCBCR');        %show converted image
    
        
    IM3 = im2bw(IM2,level);                                     %convert image to binary with level = 0.5
    figure(1);subplot(3,3,3);imshow(IM3);title('Binary');       %show binary image
    
    IM4 = bwareaopen(IM3,21000);                                 %Remove small objects from binary image
    IM4 = imfill(IM4,'holes');                                   %fill the little holes in image
   
    
    se1 = strel('disk',40);
    se = strel('disk',85);
    IM5 = imerode(IM4,se1);                                     %Erode fingers
    IM6 = imdilate(IM5,se);                                     %Dilate palm
    figure(1);subplot(3,3,5);imshow(IM6);title('Palm');
    
    IMFingers = IM4 - IM6;                                      %Substract palm from image
    figure(1);subplot(3,3,6);imshow(IMFingers);title('Fingerovski');    %show only fingers
      
    
    stats = regionprops(IMFingers,'All');
    f = stats.EulerNumber;
    fprintf('Number Of Fingers: #%2d\n',f);

    
end
    

