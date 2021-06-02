% Filtering for a known signal
fs = 200e3;
ts = 1/fs;

[f1,f2,f3] = inputPara_1();

t = 0:ts:5e-3-ts;

% fixed input signal
y = 5*sin(2*pi*f1*t)+5*sin(2*pi*f2*t)+10*sin(2*pi*f3*t);

figure(1);
subplot(4,1,1);
plot(t,y);
title('Noisy Signal');

nfft1 = length(y);
nfft2 = 2.^nextpow2(nfft1);

fy = fft(y,nfft2);
fy = fy(1:nfft2/2);

xfft = fs.*(0:nfft2/2-1)/nfft2;

subplot(4,1,2);
plot(xfft, abs(fy/max(fy)));
title('Frequency Response of noisy signal');

[fc, order] = inputPara_2(fs);

h = fir1(order, fc);

subplot(4,1,3);
plot(h);
title('Filter Response');

con = conv(y,h);

subplot(4,1,4);
plot(con);
title('Filtered Signal');

% Filtering for any audio file
[filename, pathname] = uigetfile('*.*','Select input audio');
[x,fs] = audioread(num2str(filename));

fsf = 44.1e3;   % sampling frequency   
fp = 6e3;       % passband frequency
fst = 8.4e3;    % stop band frequency
ap = 1;         % passband ripple
ast = 95;       % stopband attenuation

df = designfilt('lowpassfir','PassbandFrequency',fp,'StopbandFrequency',fst,'PassbandRipple',ap,'StopbandAttenuation',ast,'SampleRate',fsf);

fvtool(df);

xn = awgn(x,15,'measured');

y = filter(df,xn);

figure(2);

subplot(3,1,1);
plot(x);
title('Original Signal');
subplot(3,1,2);
plot(xn);
title('Noisy Signal');
subplot(3,1,3);
plot(y);
title('Filtered Signal');

sound(x,fs);    % clean input audio      
pause(5);
sound(xn,fs);   % audio distorted with white noise
pause(5);
sound(y,fs);    % noisy audio is filtered