function [x1,x,QRS_loc,local_max_amp,KeepMarker,SignChange,rr]=R_detect_Lead9(leadNo,fig1,fig2,pathname,filename,ECG_sig,Fs,handles)
%(thr_modified_and_loop removed)


x=ECG_sig(leadNo,:);% signal that will be used 
x1=ECG_sig(leadNo,:);% original signal backup
% x=x./max(abs(x));
% x=ECG_sig(2,:);
% m=length(x); clear xf; clear V2f
%         xf(10:m-11)=(x(1:m-20)+x(2:m-19)+x(3:m-18)+x(4:m-17)+x(5:m-16)+...
%             x(6:m-15)+x(7:m-14)+x(8:m-13)+x(9:m-12)+x(10:m-11)+...
%             x(11:m-10)+x(12:m-9)+x(13:m-8)+x(14:m-7)+x(15:m-6)+...
%             x(16:m-5)+x(17:m-4)+x(18:m-3)+x(19:m-2)+x(20:m-1))/20 - ...
%             (x(21:m)+x(1:m-20))/40;
%         xf(1:9)=xf(10);
%         xf(length(x)-11:length(x))=xf(length(x)-12);
%         x=xf;

%----------- median filter (baseline)--------------------------------
if Fs>1000
    x_tmp=resample(x,1000,Fs);
    Fs=1000;
    x=x_tmp;x1=x_tmp;clear x_tmp;
    set(handles.sampling_freq,'string','1000')
end
b2 = BaseLine1(x,Fs*.3,'md');
x=x-b2;
%---------------- High pass zero phase filter (baseline) ----------- 
% Fc=0.37;
% Fs=250;
% Fo=Fc/(Fs/2);
% [b a]=butter(2,Fo,'high');
% x=filtfilt(b,a,x);
% x=x(250:end);
%=======================wavelet denoising=============================   
% % Rightann=Rightann-mod(length(x),2^3);
x=x(1:length(x)-mod(length(x),2^3));
x1=x1(1:length(x));
swc=swt(x,3,'sym4');
% % A1=wrcoef('a',C,L,'db8',1);
% % D1=wrcoef('d',C,L,'db8',1);
% % D2=wrcoef('d',C,L,'db8',2);
% % D3=wrcoef('d',C,L,'db8',3);
% % swc=[A1;D3;D2;D1];
% % swc=swt(x,3,'db8'); %swt: stationary wavelet transform
ThreshML=wthrmngr('sw1ddenoLVL','sqtwolog',swc,'mln');
% % ThreshML(2)=0;
% % figure;subplot 411;plot(x);
% % subplot 412;plot(swc(2,:));hold on; hline(ThreshML(1),'r');hline(-ThreshML(1),'r');hold off;axis tight
% % subplot 413;plot(swc(3,:));hold on; hline(ThreshML(2),'r');hline(-ThreshML(2),'r');hold off;axis tight
% % subplot 414;plot(swc(4,:));hold on; hline(ThreshML(3),'r');hline(-ThreshML(3),'r');hold off;axis tight
% % 
for j=1:3
swc(j,:)=wthresh(swc(j,:),'s',ThreshML(j));% 'h': soft thresholding
end
% 
% %%reconstruct the signal
xNL=iswt(swc,'sym4');
% xNL=wden(x,'sqtwolog','s','sln',3,'sym6');
x=xNL;
%=====================================================================
%         % Baseline wander suppression filter
% 	    % Forward high-pass recursive filter useing the formula:
% 	    %          Y(i)=C1*(X(i)-X(i-1)) + C2*Y(i-1)
%         xf=x;
%         Hz=360;    % 1000 Hz sampling rate
%         T=1/Hz;        % [s] - sampling period
%         Fc=0.64;               % [Hz]
%         C1=1/[1+tan(Fc*pi*T)];  C2=[1-tan(Fc*pi*T)]/[1+tan(Fc*pi*T)];
%         b=[C1 -C1]; a=[1 -C2];
%         xf=xf-xf(1);
%         ECG=filter(b,a,xf);
%         ECG=fliplr(ECG);
%         ECG=ECG-ECG(1);
%         ECG=filter(b,a,ECG);
%         ECG=fliplr(ECG);
% %=================================================================
% x=ECG;
% Fs=250;
% b2 = BaseLine1(x,Fs*.3,'md');
% x=x-b2;
clear ECG b a xf C1 C2 T Fc Hz m
N=length(x);
clear tmp range result store mean_tmp rr
Ws_tmp=str2num(get(handles.window,'string'));Ws_tmp=Ws_tmp/250;
Ws=fix(Ws_tmp*Fs);%Fs=1000;

rr=[1:Ws:N];if size(x,2)==1 x=x'; end
store=([x(rr(1:end-1)) ;x(rr(2:end))])';

tangent=atand((store(:,2)-store(:,1))/Ws);% tangent calculation
tangent(tangent==0)=eps;% replacing the zeros with eps to avoid missed sign detection 
SignChange=find(tangent(1:end-1).*tangent(2:end)<0)+1; % find where the tangent sign changed
TimeDiff=abs(SignChange(1:end-1)-SignChange(2:end));%calculate the time diff between the resulted markers
AmpDiff=abs(store(SignChange(2:end),1)-store(SignChange(1:end-1),1));%calculate the amplitude diff between the resulted markers
RatioAmpTime=AmpDiff./TimeDiff;
KeepMarker=[1];RemoveMarker=[];% threshold=max(AmpDiff)/min(AmpDiff); 
ii=0; Remove=[];Keep=false;len=length(RatioAmpTime);
AmpTimeRatio=str2num(get(handles.AmpTime,'string'));
[c index] = min(abs(rr(SignChange)-AmpTimeRatio*Fs));% the range 4*Fs is used as RatioAmpTime threshold search area
if index>numel(RatioAmpTime); index=numel(RatioAmpTime); end
[a b]=sort(RatioAmpTime(1:index),'descend');
if abs(x(rr(SignChange(b(1)+1))))>abs(x(rr(SignChange(b(1)))))
    SignChange=SignChange(2:end);
else
    SignChange=SignChange(1:end-1);
end
R_th=[a(1) a(2) a(3) a(4)];% threshold of R estimation
[a1 b1]=max(abs(x(rr(SignChange(rr(SignChange)/Fs<=1)))));
[a2 b2]=max(abs(x(rr(SignChange(rr(SignChange(1:end))./(2*Fs)<=1)))));
[a3 b3]=max(abs(x(rr(SignChange(rr(SignChange(1:end))./(3*Fs)<=1)))));
[a4 b4]=max(abs(x(rr(SignChange(rr(SignChange(1:end))./(4*Fs)<=1)))));
[a5 b5]=max(abs(x(rr(SignChange(rr(SignChange(1:end))./(5*Fs)<=1)))));
% R_peak_tmp=[max(abs(x(1:1*Fs))) max(abs(x(1:1*Fs))) max(abs(x(1:1*Fs))) max(abs(x(1:1*Fs)))];% assuming x > 4 seconds
if a1<0.2*a2
    R_peak_tmp=[a2 a3 a4 a5];
else
    R_peak_tmp=[a1 a2 a3 a4];
end
R_thr_init=str2num(get(handles.QRS_amp_th,'string'));
R_peak_th=R_thr_init*mean(R_peak_tmp);
R_th_mu=mean(R_th);
AmpTime_thr=str2num(get(handles.AmpTime_thr,'string'));
th_tmp=AmpTime_thr*R_th_mu;
% keyboard
local_max_amp=[];RR_dur=[];fact=0.4;First_elem=false;
tag=false;local_max_indx=[0 1 1];maxima_count=1;status=false;positive=true;th_store1=[1];th_store2=[1];
while ii<len-1
%     ii
    ii=ii+1;j=0;kk=ii;
    if ii==1 || ii==local_max_indx(maxima_count)+1;
        maxima_count=maxima_count+1;
    while j~=-1
        if  (ii+j)>length(RatioAmpTime)||rr(SignChange(KeepMarker(end)))>length(x)
            kk=length(RatioAmpTime);j=-1; status=true;
            maxima_count=maxima_count-1;
        elseif  RatioAmpTime(ii+j)>th_tmp && abs(x(rr(SignChange(ii+j))))>R_peak_th 
            if local_max_indx(3)==1 && maxima_count==3 && j>3% to register the first duration
                [add_th BBB]=max(abs(x(rr(SignChange(KeepMarker(end)+3:KeepMarker(end)+j-2)))));
                if RatioAmpTime(rr(SignChange)==rr(SignChange(KeepMarker(end)+BBB+2)))>th_tmp
                    j=BBB+1; R_peak_th=add_th-1;
                end
            end
            tmp_loc=ii+j;add=j;j=-1;
            KeepMarker=[KeepMarker;tmp_loc];local_max_amp=[1,x(rr(SignChange(KeepMarker(2:end))))];
            RR_dur=[rr(SignChange(KeepMarker(2:end)))-rr(SignChange(KeepMarker(1:end-1)))];
            RR_dur(1)=[];
            if RR_dur<0.3*Fs 
                if abs(x(rr(SignChange(KeepMarker(end-1)))))>abs(x(rr(SignChange(KeepMarker(end)))))
                    j=add+1;KeepMarker(end)=[];local_max_amp(end)=[];maxima_count=maxima_count-1;
                else
                   j=-1;KeepMarker(end-1)=[];local_max_amp(end-1)=[];maxima_count=maxima_count-1;
                end
            end
            if tmp_loc~=1
            local_max_amp=[1,x(rr(SignChange(KeepMarker(2:end))))];
            else
                First_elem=true;
            end
            if length(KeepMarker)>3
                if RR_dur(end)<0.25*RR_dur(end-1)&&RR_dur(end)>0.2*RR_dur(end-1)&&local_max_amp(end)<0.8*local_max_amp(end-1)
                    j=add+1;KeepMarker(end)=[];local_max_amp(end)=[];maxima_count=maxima_count-1;
                end
                if RR_dur(end)<0.2*RR_dur(end-1)%if there are two adjacent points, remove the min
                    RR_dur=RR_dur(1);[kk1 kk2]=min(abs([x(rr(SignChange(KeepMarker(end)))),x(rr(SignChange(KeepMarker(end-1))))]));
                    KeepMarker(end-kk2+1)=[];local_max_amp(end-kk2+1)=[];maxima_count=maxima_count-1;j=0;
                end
                               
            elseif length(KeepMarker)==3
                if RR_dur<0.1*Fs
                    [kk1 kk2]=min(abs(local_max_amp(2:end)));RR_dur=[];
                    KeepMarker(kk2+1)=[];local_max_amp(kk2+1)=[];maxima_count=maxima_count-1;j=0;
                end
            end
            RR_dur=mean(RR_dur);
                    
            th_suff1=RatioAmpTime(KeepMarker(end));
            th_suff2=abs(x(rr(SignChange(KeepMarker(end)))));
            R_peak_tmp=[R_peak_tmp(2:end), th_suff2];
            tuned_Rpeak=str2num(get(handles.tuned_Rpeak,'string'));
            R_peak_th=tuned_Rpeak*mean(R_peak_tmp);
            R_th=[R_th(2:end),th_suff1];
            R_th_mu=mean(R_th);
            tuned_AmpTime=str2num(get(handles.tuned_AmpTime,'string'));
            th_tmp=tuned_AmpTime*R_th_mu;
            th_store2=[th_store2,R_peak_th];
            th_store2=th_store2(1:length(KeepMarker));
            th_store1=[th_store1,th_tmp];
            th_store1=th_store1(1:length(KeepMarker));
            local_max_indx(1)=1;
            local_max_indx(maxima_count)=tmp_loc;j=-1;
        elseif  maxima_count>3 
            RR_thr=str2num(get(handles.RR_thr,'string'));
            if rr(SignChange(local_max_indx(maxima_count-1)+j))-rr(SignChange(local_max_indx(maxima_count-1)))>RR_thr*RR_dur
             [add_th BBB]=max(abs(x(rr(SignChange(min([KeepMarker(end)+3,KeepMarker(end)+j-1]):max(KeepMarker(end)+3,KeepMarker(end)+j-1))))));
%              ii
              add_tmp=RatioAmpTime(rr(SignChange)==rr(SignChange(KeepMarker(end)+BBB+2)));% +1 is added coz of +2 in previous line
              adapt_R_peak=str2num(get(handles.adapt_R_peak,'string'));
              adaptAmpTime=str2num(get(handles.adapt_AmpTime,'string'));
            if add_th<R_peak_th && add_th>adapt_R_peak*abs(local_max_amp(end))
                R_peak_th=add_th-1;j=BBB;th_store2(end)=R_peak_th;
            elseif add_tmp<th_tmp && add_th>adaptAmpTime*abs(local_max_amp(end))
                th_tmp=add_tmp-1;j=BBB;th_store1(end)=th_tmp;
            else
                j=j+1;
            end
            else
                j=j+1;
            end
        else
            j=j+1;
        end
        if status
           break
        end
    end
    end
    
end
if First_elem
KeepMarker=unique(KeepMarker);
else
KeepMarker=KeepMarker(2:end);
end
QRS_marks=rr(SignChange(KeepMarker));
th_store2=th_store2(1:end-1);th_store1=th_store1(1:end-1);local_max_amp=local_max_amp(2:end);
% % chk_marker=find(local_max_amp<0);if numel(chk_marker)/length(local_max_amp)<1 
% %     KeepMarker(chk_marker)=[]; th_store2(chk_marker)=[];th_store1(chk_marker)=[];
% % end 
% if KeepMarker(1)==1
%     [non Q_est(1)]=min(x(1:rr(SignChange(KeepMarker(1)))));
%     Q_est(2:length(KeepMarker))=rr(SignChange(KeepMarker(2:end)-1));
% else
%     Q_est=rr(SignChange(KeepMarker-1));
% end

% S_est=rr(SignChange(KeepMarker+1));
% if fig1
% figure;plot(x);hold on;plot(rr(SignChange(KeepMarker)),x(rr(SignChange(KeepMarker))),...
%     'Ko','MarkerFaceColor','r')
% set(zoom,'motion','horizontal','enable','on')
% stem(rr(SignChange),RatioAmpTime,'.k')
% plot(rr(SignChange(KeepMarker)),th_store1,'m','linewidth',1.5)
% plot(rr(SignChange(KeepMarker)),th_store2,'-.k','linewidth',1.5)
% plot(rr(SignChange(KeepMarker)),-th_store2,'-.k','linewidth',1.5)
% legend({'ECG signa';'R-peaks';'Tangents';'\gamma_2';'+\gamma_1';'-\gamma_1'})
% ylabel('Amplitude a.u');xlabel('Samples')
% set(gca,'fontsize',13)
% end
%-----------------------------QRS Location tuning -------------------------
chk_marker_neg=find(local_max_amp<0);
chk_marker_pos=find(local_max_amp>0);
if numel(chk_marker_neg)/length(local_max_amp)<0.5% the negative markers less than the positive
    for i=1:length(chk_marker_neg)%negative markers
%         i
        globalindx=(rr(SignChange(KeepMarker(chk_marker_neg(i)))));
        if globalindx<=round(15*(Fs/250))
            QRS_int=x(globalindx+[-globalindx+1:1:round(5*(Fs/250))]);
        else
            QRS_int=x(globalindx+[-round(15*(Fs/250)):1:round(5*(Fs/250))]);
        end
        [A B]=max(abs(QRS_int));
%         j=2;
%         while i<(length(portion1)-3) & ((portion1(j)<portion1(j-1)) | (portion1(j)<portion1(j+1) | portion1(j)<portion1(i+2) | portion1(i)<portion1(i+3)))
%         j=j+1;
%         end
        QRS_loc(chk_marker_neg(i))=globalindx+5-(length(QRS_int)-B);
    end
    for i=1:length(chk_marker_pos)%positive markers
        globalindx=(rr(SignChange(KeepMarker(chk_marker_pos(i)))));
        if globalindx<round(11*(Fs/250))
            LB=globalindx-1;
        else
            LB=round(10*(Fs/250));
        end
        if globalindx+round(10*(Fs/250))>length(x)
            QRS_int=x(globalindx+[-LB:1:length(x)-globalindx]);
        else
        QRS_int=x(globalindx+[-LB:1:round(10*(Fs/250))]);
        end
        [A B]=max(QRS_int);
        if globalindx<round(11*(Fs/250))
            QRS_loc(chk_marker_pos(i))=B;
        else
            QRS_loc(chk_marker_pos(i))=globalindx+LB-(max([length(QRS_int) 2*LB+1])-B);
        end
    end 
end
if numel(chk_marker_pos)/length(local_max_amp)<0.5 %the positive markers less than the negative
    for i=1:length(chk_marker_neg)%negative markers
    globalindx=(rr(SignChange(KeepMarker(chk_marker_neg(i)))));
    globalindx=globalindx+round(10*(Fs/250));
    if globalindx>length(x)
        globalindx=length(x);
    end
    if chk_marker_neg(i)==1 || globalindx<11
        L_globalindx=1;
    else
        L_globalindx=(rr(SignChange(KeepMarker(chk_marker_neg(i))-2)));
    end
        QRS_int=x(L_globalindx:globalindx);
%         [A B]=max(QRS_int);
%         QRS_loc(chk_marker_neg(i))=L_globalindx+B-1;
        [A B]=min(QRS_int);
        globalindx_new=L_globalindx+B-1;
        portion1=x(L_globalindx:globalindx_new);
        j=(length(portion1)-1);
        if length(portion1)<round(5*(Fs/250))
            j=globalindx_new-L_globalindx+1;
        else
        while((portion1(j)<portion1(j+1)) | (portion1(j)<portion1(j-1) | portion1(j)<portion1(j-2) | portion1(j)<portion1(j-3)))
        j=j-1;
        if j<=4
            break
        end
        end
        end
        QRS_loc_tmp=globalindx_new-(length(portion1)-j);
        if x(QRS_loc_tmp)>=-5 && abs(x(QRS_loc_tmp)/x(globalindx_new))<0.14
            QRS_loc(chk_marker_neg(i))=globalindx_new;
        else
            QRS_loc(chk_marker_neg(i))=globalindx_new-(length(portion1)-j); 
        end
    end
        for i=1:length(chk_marker_pos)%positive markers
        globalindx=(rr(SignChange(KeepMarker(chk_marker_pos(i)))));
        if globalindx<=round(10*(Fs/250))
           QRS_int=x(globalindx+[-(globalindx-1):1:round(10*(Fs/250))]);
        else
% %             i
        QRS_int=x(globalindx+[-round(10*(Fs/250)):1:round(10*(Fs/250))]);
        end
        [A B]=max(QRS_int);
        QRS_loc(chk_marker_pos(i))=globalindx+round(10*(Fs/250))-(length(QRS_int)-B);
    end 
end
% QRS_Exact_loc=QRS_loc;
% Q_loc_err=find(QRS_loc-Q_est<round(3*(Fs/250)));
% if KeepMarker(1)<=2
%     Q_est(Q_loc_err(2:end))=rr(SignChange(KeepMarker(Q_loc_err(2:end))-2));
% else
%     Q_est(Q_loc_err)=rr(SignChange(KeepMarker(Q_loc_err)-2));
% end
%     % correcting Q locations
% jj=1;
% while jj<length(Q_est)% S location tuninig
%     if S_est(jj)<rr(SignChange(KeepMarker(jj)))
%         S_est(jj)=rr(SignChange(KeepMarker(jj)+2));
%     elseif S_est(jj)>rr(SignChange(KeepMarker(jj)))
%         S_est(jj)=rr(SignChange(KeepMarker(jj)+1));
%     end
%     jj=jj+1;
% end
RR_dur=QRS_loc(2:end)-QRS_loc(1:end-1);%QRS_loc=QRS_loc+double(Leftann)-1;
% x1=ECG_sig(leadNo,Leftann:Rightann);
% if fig2
% figure;plot(x);hold on;
% plot(QRS_loc,x(QRS_loc),'Ko','MarkerFaceColor','r')
% plot(S_est,x(S_est),'Ko','MarkerFaceColor','g')
% plot(Q_est,x(Q_est),'Ko','MarkerFaceColor','g')
% set(zoom,'motion','horizontal','enable','on')
%=========================================================================
% figure;plot(Leftann:Rightann,x1);hold on;
% plot(QRS_loc+double(Leftann)-1,x1(QRS_loc),'Ko','MarkerFaceColor','r')
% plot(S_est+double(Leftann)-1,x1(S_est),'Ko','MarkerFaceColor','g')
% plot(Q_est+double(Leftann)-1,x1(Q_est),'Ko','MarkerFaceColor','g')
% set(zoom,'motion','horizontal','enable','on')
% vline(reshape(R,1,numel(R)),'r');
% % vline(reshape(T,1,numel(T)),'g');
% % vline(reshape(P,1,numel(P)),'g');
end
    