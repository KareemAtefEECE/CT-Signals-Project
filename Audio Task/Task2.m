%%% Submitted By : Amr Wael Leithy , Kareem Atef %%%%%


%% write audio 1 %%

%% as fs represents the numbers of samples in 1 sec 
%%this value considered one of the common sampling frequancies used for odrinary audios

fs1 = 44000;  

%% as the bit number represents each sample in the digital audio signal
%% we can use either (8,16,24,32) bits but we considerd the 16 bits to make balance between quality of signal and the size of the file

bit_number = 16;

Ch = 1;
period = 10;
audio = audiorecorder(fs1,bit_number,Ch);
disp('Recording');
recordblocking(audio,period);
disp('Recorded');
input1=getaudiodata(audio);
audiowrite('input1.wav',input1,fs1);


%% write audio 2 %%
fs2 = 44000;
audio = audiorecorder(fs2,bit_number,Ch);
disp('Recording');
recordblocking(audio,period);
disp('Recorded');
input2=getaudiodata(audio);
audiowrite('input2.wav',input2,fs2);


%%Ploting input 1,2 before filtering%%

[input1,fs1] = audioread('input1.wav');
N=length(input1);
f=(-N/2:N/2-1)*fs1/N;
X1=fft(input1,N);
plot(f,abs(fftshift(X1)/N));
figure;
[input2,fs2] = audioread('input2.wav');
N=length(input2);
f=(-N/2:N/2-1)*fs2/N;
X2=fft(input2,N);
plot(f,abs(fftshift(X2)/N));

%% filtering input 1,2 hear the diffrence and plot them %%

filtered_signal1 = filter(LPF1,input1);
filtered_signal2 = filter(LPF2,input2);

%%hear the diffrences
soundsc(input1, fs1);
pause(10);
soundsc(filtered_signal1, fs1);
pause(10);
soundsc(input2, fs2);
pause(10);
soundsc(filtered_signal2, fs2);
pause(10);

%%plot them
N=length(filtered_signal1);
f=(-N/2:N/2-1)*fs2/N;
X1=fft(filtered_signal1,N);
plot(f,abs(fftshift(X1)/N));
figure;
N=length(filtered_signal2);
f=(-N/2:N/2-1)*fs2/N;
X2=fft(filtered_signal2,N);
plot(f,abs(fftshift(X2)/N));
audiowrite('filtered_input1.wav',filtered_signal1,fs1);
audiowrite('filtered_input2.wav',filtered_signal2,fs2);


%% Transmitted Signal %%

[filtered_input1,fs1] = audioread('filtered_input1.wav');
[filtered_input2,fs2] = audioread('filtered_input2.wav');

minLength = min(length(filtered_input1), length(filtered_input2));

t1 = 0:1/fs1:(minLength-1)/fs1; 
t2 = 0:1/fs2:(minLength-1)/fs2;

fm1=2800;
fm2=2400;

%% fc should be greater than fm and less than fs-fm
fc1=3200;

%% we chose here slighty bigger fc to not let the two signals interfere after modulation
fc2=10000;

modulatedSignal1 = filtered_input1 .* cos(2*pi*fc1*t1).';
modulatedSignal2 = filtered_input2 .* cos(2*pi*fc2*t2).';

combinedSignal = modulatedSignal1 + modulatedSignal2;
N=length(combinedSignal);
f=(-N/2:N/2-1)*fs2/N;
X1=fft(combinedSignal,N);
plot(f,abs(fftshift(X1)/N));
figure;
%% Demodulated Signals%%
demodulatedSignal1 = combinedSignal .* cos(2*pi*fc1*t1).';
demodulatedSignal2 = combinedSignal .* cos(2*pi*fc2*t2).';
output1=filter(LPF1,demodulatedSignal1);
output2=filter(LPF2,demodulatedSignal2);
N=length(output1);
f=(-N/2:N/2-1)*fs2/N;
X1=fft(output1,N);
plot(f,abs(fftshift(X1)/N));
figure;
N=length(output2);
f=(-N/2:N/2-1)*fs2/N;
X1=fft(output2,N);
plot(f,abs(fftshift(X1)/N));
audiowrite('output1.wav',output1,fs1);
audiowrite('output2.wav',output2,fs2);
