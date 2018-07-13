function [Tpeak_loc Ppeak_loc k x_left x_right]=TP_waves_detection(original_sig,x,QRS_loc,Q_loc,S_loc,Fs,handles)
% SQ_interval=Q_loc(2:end)-S_loc(1:end-1)
% figure
for k=1:length(QRS_loc)-1
    SQ_interval1=x(S_loc(k):Q_loc(k+1));
%     [QRS_loc]=tangent_alg(1,1,SQ_interval1,Fs,Leftann,Rightann,R)
%================ baseline drift high pass nonzero phase ==================   
% fo=Fs/2;
% ws=[48 52]/fo;
% wp=[49 51]/fo;
% [n,wn]=buttord(wp,ws,1,4);
% [b,a]=butter(n,wn,'stop');
% original_sig2=filter(b,a,original_sig);

Fc=0.37;
Fo=Fc/(Fs/2);
[b a]=butter(2,Fo,'high');
target_signal=filtfilt(b,a,original_sig);
if Fs==500
    sp=5;deg=2;
elseif Fs==250
elseif Fs==1000
    sp=40;deg=30;
elseif Fs==360
else
    sp=40;deg=30;
end
target_signal=smooth(target_signal,sp,'moving',deg);% moving average smoothing
SQ_interval2=target_signal(S_loc(k):Q_loc(k+1));
% keyboard
% k;
TP_window=str2num(get(handles.TP_window,'string'));
[Tpeak_loc(k) Ppeak_loc(k) x_left(k) x_right(k)]=tangent_alg1(0,0,SQ_interval2,Fs,original_sig(QRS_loc(k)),round(TP_window*(Fs/250)),k,handles);%2 is the Ws
if Tpeak_loc(k)==0 && Ppeak_loc(k)==0
    return;
end
end