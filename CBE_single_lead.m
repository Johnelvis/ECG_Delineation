
function [Q_hat4,QRS_old,S_hat4,T_on_GUI,T_peak_GUI,T_off_GUI,P_peak_GUI,annot_signal,original_signal]=CBE_single_lead(filename,ECG_sig,lead_No,handles)

%     clearvars -except  DBNo matFileName2 Fs matfilesource matFileName pathname
Fs=str2num(get(handles.sampling_freq,'string'));
diffQ=[];diffR=[];diffS=[];total_cyc_analysed=0;total_P_waves=0;total_P_waves_analysed=0;
diffP_peaks=[];total_T_waves=0;total_T_waves_analysed=0;diffT_peaks=[];total_QRS=0;
P=[];T=[];
tic

[original_signal,annot_signal,QRS_loc,QRS_amp,QRS_indx,TokenSign,Tokenindx]=R_detect_Lead9(lead_No,0,0,[],filename,ECG_sig,Fs,handles);

%==========================================================================segmentation and denoising of the QRS complex
MS_PER_SAMPLE=round(1000/Fs);
MS200=round(200/MS_PER_SAMPLE);
MS400=fix(400/MS_PER_SAMPLE+0.5);

%========================================================================== extracting the Q and S points
%%
[Q_4,S_4]=QS_tuning1(annot_signal,QRS_loc,Fs,handles);fig=true;

if ~fig
Q_hat1=QRS_loc-Q_1;
S_hat1=QRS_loc+S_1;

Q_hat2=QRS_loc-Q_2;
S_hat2=QRS_loc+S_2;

Q_hat3=QRS_loc-Q_3;
S_hat3=QRS_loc+S_3;
end
if fig
    if Q_4(1)>QRS_loc(1);
        Q_hat4=[];
        Q_hat4(1)=1;
        Q_hat4(2:length(QRS_loc))=QRS_loc(2:end)-Q_4(2:end);
    else
        Q_hat4=QRS_loc-Q_4;
    end
S_hat4=QRS_loc+S_4;
end

QRS_old=QRS_loc;
Q_est4=QRS_loc-Q_4;
S_est4=QRS_loc+S_4;
%======= check QRS if detected wrongly
QS_interv=Q_hat4(2:end)-S_hat4(1:end-1);
remove=[];
for i=1:length(QS_interv)
if QS_interv(i)<(Fs/fix(5*(Fs/250)))
remove=[remove;i];
end
end
QRS_loc(remove+1)=[];
QRS_old(remove+1)=[];
Q_est4(remove+1)=[];
S_est4(remove+1)=[];
Q_hat4(remove+1)=[];
S_hat4(remove+1)=[];
Q_est4(Q_est4<0)=1;

%=================plot original signal=====================================
% figure;signal=ECG_sig(lead_No,:);plot(signal);hold on;
% plot(QRS_loc,signal(QRS_loc),'Ko','MarkerFaceColor','r')
% plot(Q_est4,signal(Q_est4),'Ko','MarkerFaceColor','g')
% plot(S_est4,signal(S_est4),'Ko','MarkerFaceColor','g')
% set(zoom,'motion','horizontal','enable','on')
% title(filename)
%==========================================================================
P_peak_store=[];T_peak_store=[];tt=1;T_peak_loc1=[];P_peak_loc1=[];test=false;
% % keyboard
% disp('total QRS detected =')
% title_fig=strcat('Total QRS detected (',filename,'-',num2str(lead_No),')=',num2str(numel(QRS_loc)))
% figure;plot(1:length(original_signal ),original_signal );hold on;
% plot(QRS_old,original_signal (QRS_old),'Ko','MarkerFaceColor','r');title(title_fig)
[T_peak_loc P_peak_loc Wrong_QRS x_left_loc x_right_loc]=TP_waves_detection(original_signal,annot_signal,QRS_old,Q_hat4,S_hat4,Fs,handles);
% keyboard
T_peak_loc_tmp=T_peak_loc; P_peak_loc_tmp=P_peak_loc;m=0;
while tt
if (T_peak_loc(end)==0 && P_peak_loc(end)==0)
T_peak_loc(end)=[];P_peak_loc(end)=[];
test=true;
disp('you are in the forbidden area')
QRS_old(Wrong_QRS+length(T_peak_loc)+m)=[];QRS_old1=QRS_old(length(T_peak_loc)+1:end);
Q_est4(Wrong_QRS+length(T_peak_loc)+m)=[];Q_hat4(Wrong_QRS+length(T_peak_loc))=[];Q_hat41=Q_hat4(length(T_peak_loc)+1:end);
S_est4(Wrong_QRS+length(T_peak_loc)+m)=[];S_hat4(Wrong_QRS+length(T_peak_loc))=[];S_hat41=S_hat4(length(T_peak_loc)+1:end);
% figure;plot(annot_signal);hold on;plot(QRS_old1,annot_signal(QRS_old1),'ro',Q_hat41,annot_signal(Q_hat41),'ko',S_hat41,annot_signal(S_hat41),'go')
[T_peak_loc1 P_peak_loc1 Wrong_QRS]=TP_waves_detection(original_signal,annot_signal,QRS_old1,Q_hat41,S_hat41,Fs,4,R);
if T_peak_loc1(end)==0 && P_peak_loc1(end)==0
    tt=1;m=m+1;
else
    tt=0;
end
else
    tt=0;T_peak_store=inf;P_peak_store=inf;
end
T_peak_store=[T_peak_store T_peak_loc1];
P_peak_store=[P_peak_store P_peak_loc1];
T_peak_loc=T_peak_store;P_peak_loc=P_peak_store;
if T_peak_store(end)==0 && P_peak_store(end)==0
    T_peak_store(end)=[]; P_peak_store(end)=[];
end
end
if ~test
    T_peak_store=[]; P_peak_store=[];
end
T_peak_loc_tmp(T_peak_loc_tmp==0)=[];
P_peak_loc_tmp(P_peak_loc_tmp==0)=[];
T_peak_loc=[T_peak_loc_tmp T_peak_store];
P_peak_loc=[P_peak_loc_tmp P_peak_store];

%==========================================================================
T_peaks=S_hat4(1:end-1)+T_peak_loc;
P_peaks=S_hat4(1:end-1)+P_peak_loc;
T_left=S_hat4(1:end-1)+x_left_loc;
T_right=S_hat4(1:end-1)+x_right_loc;
%=====================plotting=============================================
T_peaks=S_hat4(1:end-1)+T_peak_loc;
P_peaks=S_hat4(1:end-1)+P_peak_loc;
T_left=S_hat4(1:end-1)+x_left_loc;
T_right=S_hat4(1:end-1)+x_right_loc;
% figure;plot(1:length(original_signal ),original_signal );hold on;
% plot(QRS_old,original_signal (QRS_old),'Ko','MarkerFaceColor','r')
% if ~fig
% plot(S_hat,original_signal (S_hat),'K.')
% plot(Q_hat,original_signal (Q_hat),'K.')
% plot(S_hat1,original_signal (S_hat1),'go')
% plot(Q_hat1,original_signal (Q_hat1),'go')
% plot(S_hat2,original_signal (S_hat2),'m.')
% plot(Q_hat2,original_signal (Q_hat2),'m.')
% plot(S_hat3,original_signal (S_hat3),'r.')
% plot(Q_hat3,original_signal (Q_hat3),'r.')
% end
% if fig
% plot(S_hat4,original_signal (S_hat4),'Ko','MarkerFaceColor','g')
% plot(Q_hat4,original_signal (Q_hat4),'Ko','MarkerFaceColor','g')
% end
% set(zoom,'motion','horizontal','enable','on')
%==========================================================================
% hold on;plot(S_est4(1:end-1)+T_peak_loc,original_signal (T_peaks),'Ko','MarkerFaceColor','K')
% plot(S_est4(1:end-1)+P_peak_loc,original_signal (P_peaks),'Ko','MarkerFaceColor','K')
% plot(S_est4(1:end-1)+x_left_loc,original_signal (T_left),'K*')
% plot(S_est4(1:end-1)+x_right_loc,original_signal (T_right),'K*')
QT_Results=(T_right-Q_hat4(1:end-1))';



T_peak_GUI=S_est4(1:end-1)+T_peak_loc;
P_peak_GUI=S_est4(1:end-1)+P_peak_loc;
T_on_GUI=S_est4(1:end-1)+x_left_loc;
T_off_GUI=S_est4(1:end-1)+x_right_loc;

toc
