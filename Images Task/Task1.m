%%% Submitted By : Amr Wael Leithy , Kareem Atef %%%%%
%%% RGB components %%%
img = imread('peppers.png'); 
red = img(:,:,1); 
green = img(:,:,2); 
blue = img(:,:,3); 
a = zeros(size(img, 1), size(img, 2));
red_component = cat(3, red, a, a);
green_component = cat(3, a, green, a);
blue_component = cat(3, a, a, blue);
figure, imshow(img), title('Original image')
subplot(2,1,2), imshow(red_component), title('Red Component')
subplot(2,2,1),imshow(green_component), title('Green Component')
subplot(2,2,2), imshow(blue_component), title('Blue Component')
%%%% Edge filter %%%%
img_gray = rgb2gray(img);
E = [-1 0 1; -2 0 2; -1 0 1];
vertical = conv2(img_gray, E.', 'same'); 
horizontal = conv2(img_gray, E, 'same'); 
edged_img = sqrt(vertical.^2 + horizontal.^2); 
figure, imshow(uint8(edged_img)), title('Edge Filter')
%%% Image Sharpening %%%
S = [ 0-1 0, -1 5 -1 , 0 -1 0];
red_enh = conv2(red,S,'same');
green_enh = conv2(green,S,'same');
blue_enh = conv2(blue,S,'same');
img_enhanced= cat(3,red_enh,green_enh,blue_enh);
figure, imshow(uint8(img_enhanced)), title('Enhanced  Image')
%%% Image Blurring %%%
B = (1/9)*[ 1 1 1, 1 1 1, 1 1 1]; 
red_blur = conv2(red,B,'same');
green_blur = conv2(green,B,'same');
blue_blur = conv2(blue,B,'same');
img_blurred= cat(3,red_blur,green_blur,blue_blur);
figure, imshow(uint8(img_blurred)), title('Blurred Image')
%%% Image Motion Blurring %%%
MB = 1/16 * [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 ]; 
%%% i increased the ones so that the blurring shows %%
red_Mblur = conv2(red,MB);
green_Mblur = conv2(green,MB);
blue_Mblur = conv2(blue,MB);
img_Mblurred= cat(3,red_Mblur,green_Mblur,blue_Mblur);
figure, imshow(uint8(img_Mblurred)), title('Motion Blurred Image')
%%% Image deblurring %%%
img_fft = fft2(img_Mblurred);
MB_fft = fft2(MB,384,527);
constant = 0.0001; 
MB_fft = MB_fft + constant; %%% add to avoid division by 0
img_fft = img_fft ./ MB_fft;
img_Dblurred = ifft2(img_fft);
img_Dblurred = img_Dblurred(1:384,1:512,:);
figure, imshow(uint8(img_Dblurred)), title('Motion DeBlurred Image')









