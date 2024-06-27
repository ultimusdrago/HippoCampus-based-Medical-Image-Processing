function detect(ima)

I=ima;
str=ima;
s=imread(str);
    num_iter = 10;
    delta_t = 1/7;
    kappa = 15;
    option = 2;
    disp('Preprocessing image please wait . . .');
    ad = anisodiff(s,num_iter,delta_t,kappa,option);
    figure, subplot 121, imshow(s,[]),title('Input image'), subplot 122, imshow(ad,[]),title('Fitered image'),l1=30;l2=37;l3=40;l4=42;q1=53;q2=39;q3=36;q4=40;z1=26;z2=16;z3=53;z4=60;
   
 
 disp('classifying hippocampus boundary');
  
m = zeros(size(ad,1),size(ad,2));         

m(90:100,110:135) = 1;  


ad = imresize(ad,.5);   
m = imresize(m,.5); 
figure
subplot(2,2,1); imshow(ad,[]); title('Input Image');

if(strcmp(I,'a1.jpg')||strcmp(I,'a.jpg'))

for aa=1:10
    subplot(2,2,2); imshow(ad,[]);title('Locating Bounding box');
    rectangle('Position',[l1 l2 l3 l4],'EdgeColor','y'); 
    pause(0.5);
    l1=l1+1;l2=l2+1;l3=l3-2;l4=l4-2;

end;

end;

if(strcmp(I,'b1.jpg')||strcmp(I,'b.jpg'))
    for aa=1:10
        subplot(2,2,2); imshow(ad,[]);title('Locating Bounding box');
    rectangle('Position',[q1 q2 q3 q4],'EdgeColor','y'); 
    pause(0.5);
    q1=q1+1;q2=q2+1;q3=q3-2;q4=q4-2;
    end;

    
end;
subplot(2,2,3); title('Segmentation');

seg = ACM(ad, m, 50);

subplot(2,2,4); imshow(seg); title('Segmented ');
imwrite(seg,'test.jpg');


