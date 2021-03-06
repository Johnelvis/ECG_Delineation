function [T_peak,P_peak,x_left_T,x_right_T]=tangent_alg1(fig1,fig2,x,Fs,QRS_sign,Ws,k,handles)
N=length(x);
T_est_peaks1=1;
x_org=x;
x=x+abs(min(x));%normalization 0-to-1
x=x./max(x);
S_prob=false;
clear tmp range result store mean_tmp rr
%Fs=1000;
% factor=1;param=false;
% while factor>0
% if ~param
%     Ws=Ws;
% else
%     Ws=Ws_mod;
% end
chk_t=true;
init=0;
% on=1;
% off=Ws;
% rr=[1];
% store=zeros(0,2);
% W_edge=zeros(0,2);
% values=zeros(0,2);
% for i=1:N/Ws % N for non-overlapping
%     rr=[rr off];
%     tmp=x(on:off);
%     range(i)=max(tmp)-min(tmp);
%     mean_tmp(i,1)=mean(tmp);
%     values=[values;[max(tmp) min(tmp)]];
% %=================%non overlapping window===============
%     store=[store;[x(rr(i)) x(rr(i+1))]]; 
%     on=i*Ws; 
%     off=(i+1)*Ws-1;
% end
rr=[1 4 2*Ws-1:Ws:N]; if size(x,2)==1 x=x'; end
store=([x(rr(1:end-1));x(rr(2:end))])';

tangent=atand((store(:,2)-store(:,1))/Ws);% tangent calculation
tangent(tangent==0)=eps;% replacing the zeros with eps to avoid missed sign detection 
SignChange=find(tangent(1:end-1).*tangent(2:end)<0)+1; % find where the tangent sign changed
if length(x)<fix(Fs/5)% check RR interval if it is smaller than 1/5 of Fs
    T_peak=fix(0.3*length(x));P_peak=fix(0.7*length(x));
    x_left_T=fix(T_peak/2); x_right_T=T_peak+fix(T_peak/2);
    warning('T and P waves cannot be detected, the RR interval is very short')
    return
end
if isempty(SignChange)% check the RR interval curve morphology
    T_peak=fix(0.3*length(x));P_peak=fix(0.7*length(x));
    x_left_T=fix(T_peak/2); x_right_T=T_peak+fix(T_peak/2);
    warning('T and P waves cannot be detected, the RR interval is very short')
    return;
end
if rr(SignChange(1))>fix(0.1*length(x))
    SignChange=[1;SignChange];S_prob=true;
end
if rr(SignChange(end))<fix(length(x))&& (SignChange(end))~=length(tangent)
    SignChange=[SignChange;length(tangent)];
end
TimeDiff=abs(SignChange(1:end-1)-SignChange(2:end));%calculate the time diff between the resulted markers
AmpDiff=abs(store(SignChange(2:end),1)-store(SignChange(1:end-1),1));%calculate the amplitude diff between the resulted markers
RatioAmpTime=AmpDiff./TimeDiff;
KeepMarker=[1];RemoveMarker=[];% threshold=max(AmpDiff)/min(AmpDiff); 
ii=0; Remove=[];Keep=false;len=length(RatioAmpTime);
[a b]=sort(RatioAmpTime,'descend');
if numel(AmpDiff)<3
    k
    warning('The RR interval contains less than one curve, P and T waves can not be detected')
%     clf;plot(x);title('RR interval')
    T_peak=fix(0.3*length(x));P_peak=fix(0.7*length(x));
    x_left_T=fix(T_peak/2); x_right_T=T_peak+fix(T_peak/2);
    return;
end
% keyboard 
sorted2=[];
for j=1:length(SignChange)-1
    if x(rr(SignChange(j+1)))>x(rr(SignChange(j)))
        curve_state(1,j)=1;%curve going up
    else
        curve_state(1,j)=0;%curve going down
    end
end
TP_sep=fix(length(AmpDiff)/2);
T_search=str2num(get(handles.T_block,'string'));
while rr(SignChange(TP_sep))<fix(T_search*length(x)) && TP_sep<length(AmpDiff)
    TP_sep=TP_sep+1;
end
while TP_sep>=2 && chk_t
%===============================================60% of the RR interval for T wave
AmpDiff_T=AmpDiff(1:TP_sep);
AmpDiff_P=AmpDiff((TP_sep)-1:end);
%===============================================
curve_state_T=curve_state(1:numel(AmpDiff_T));
curve_state_P=curve_state(end-numel(AmpDiff_P)+1:end);
%===============================================
Ratio_T=RatioAmpTime(1:numel(AmpDiff_T));
Ratio_P=RatioAmpTime(end-numel(AmpDiff_P)+1:end);
%===============================================
% keyboard
if TP_sep>2
   while numel(T_est_peaks1)<2
   T_est_peaks1=find(AmpDiff_T>mean(AmpDiff_T)-init);
   T_est_peaks2=find(AmpDiff_T>mean(AmpDiff_T)-init);
   init=init+0.01;
   if T_est_peaks1(1)==1 && mean(x(rr(SignChange(2:TP_sep))))>0.5 && (AmpDiff_T(1)<0.5 || rr(SignChange(2))/length(x)<0.2)%elevated T wave
       T_est_peaks1(1)=[];
   end
   end
else
    T_est_peaks1=[1;2];
end
%===============================================
buff=([T_est_peaks1 (curve_state_T(T_est_peaks1))' AmpDiff_T(T_est_peaks1)]);
if S_prob && buff(1,2)==1 && length(buff(:,2))>2 && QRS_sign>0
    buff=buff(2:end,:);
end
%===============================================
if length(T_est_peaks1)==1
    x_left=rr(SignChange(T_est_peaks1(1)-2));
    x_right=rr(SignChange(T_est_peaks1(1)+2));
    cb=1;cm=cb;
    [curve]=T_edges((x(x_left:x_right))',rr(SignChange(T_est_peaks1(cm)+1))-x_left,1,4,0);
% elseif length(T_est_peaks1)>2   
%     x_left=rr(SignChange(T_est_peaks1(2)));
%     x_right=rr(SignChange(T_est_peaks1(3)+1));
%     cb=2;cm=cb+1;
%     [curve]=T_edges((x(x_left:x_right))',rr(SignChange(T_est_peaks1(cm)))-x_left,1,4,0);
% else
%     x_left=rr(SignChange(T_est_peaks1(1)));
%     x_right=rr(SignChange(T_est_peaks1(2)+1));
%     cb=1;cm=cb+1;
%     [curve]=T_edges((x(x_left:x_right))',rr(SignChange(T_est_peaks1(cm)))-x_left,1,4,0);
% end
else
     sorted=flipud(sortrows(buff,3));
     sorted2=sorted(1:2,:);
     sorted2=sortrows(sorted2,1);
     T_est_peaks1=sorted2(:,1);
%     buff_T=[buff(:,1)  buff(:,2) buff(:,3)./buff(:,1)];
%     sorted=flipud(sortrows(buff_T,3));
%     sorted2=sorted(1:2,:);
%     sorted2=sortrows(sorted2,1)
%     T_est_peaks1=sorted2(:,1);
T_thr1=str2num(get(handles.T_thr1,'string'));
T_thr2=str2num(get(handles.T_thr2,'string'));
T_thr3=str2num(get(handles.T_thr3,'string'));
    if (sorted2(1,3)/sorted2(2,3)<T_thr1 && sorted2(2,2)==1) || (T_est_peaks1(2)-T_est_peaks1(1)==2 && AmpDiff_T(T_est_peaks1(1)+1)<T_thr2 && TimeDiff(T_est_peaks1(1)+1)<T_thr3)
        sorted2(1,:)=sorted2(2,:);T_est_peaks1(1)=T_est_peaks1(2);
    end
    
    x_left=rr(SignChange(T_est_peaks1(1)));
    x_right=rr(SignChange(T_est_peaks1(2)+1));
    cb=1;cm=cb+1;
    [curve]=T_edges((x(x_left:x_right))',x_right-x_left+1,1,4,0);
%     [curve]=T_edges((x(x_left:x_right))',rr(SignChange(T_est_peaks1(cm)))-x_left,1,4,0);
end
if sorted2(1,2)==1 && numel(sorted2(:,2))>1% for positive T wave peaks
    [Neg, T_peak]=max((x(x_left:x_right)));
elseif sorted2(1,2)==0 && numel(sorted2(:,2))>1% for negative T wave peaks
    [Neg, T_peak]=min((x_org(x_left:x_right)));
else% for ubnormal T wave peaks
    [Neg, T_peak]=fix(length(x_org(x_left:x_right))/2);
end
T_peak1=T_peak+rr(SignChange(T_est_peaks1(cb)))-1;
% [curve]=T_edges((x(x_left:x_right))',rr(SignChange(T_est_peaks1(cm)))-x_left,1,4,T_peak);
T_peak2=curve+x_left;
%================================================================case 1 sel31
if isempty(sorted2)
    case1=0;
else
[A B]=size(sorted2);
T_status=sorted2(:,2);
for h=1:A
    case1=and(T_status(1),T_status(end));
end
end
if case1
    if rr(SignChange(sorted2(2,1)))==x_left;
        [curve]=T_edges((x(x_left:x_right))',x_right-x_left+1,1,4,0);
        T_peak2=curve+x_left;
        T_peak=T_peak2;
    else
    [curve]=T_edges((x(x_left:x_right))', rr(SignChange(sorted2(2,1)))-x_left,1,4,0);
    T_peak2=curve+x_left;
    T_peak=T_peak2;
    end
else
    T_peak=T_peak1;
end    
T_sorted=sorted2;
x_left_T=x_left;
x_right_T=x_right;
%==========================================================================
% keyboard
P_buff_tmp=[];P_buff=[];remove_buff_tmp=[];
P_est_peaks1=find(AmpDiff_P>mean(AmpDiff_P));
P_status=curve_state(TP_sep-2+P_est_peaks1);
P_buff=[P_est_peaks1 curve_state(TP_sep-2+P_est_peaks1)' (AmpDiff_P(P_est_peaks1))];
if numel(P_est_peaks1)==1
    x_left=rr(SignChange(P_est_peaks1(1)+TP_sep-2));
    x_right=rr(SignChange(P_est_peaks1(1)+TP_sep-1));
    cb=2;sorted2=[P_buff;P_buff];sorted2(2,1)=sorted2(2,1)+1;
else
%     k
%     if P_est_peaks1(end)-P_est_peaks1(end-1) > 5 && numel(P_est_peaks1)>2
%         P_est_peaks1(end)=[];P_buff(end,:)=[];
%     end
        P_buff_tmp=P_buff;
    if numel(P_buff(:,1))>2
    for kk=1:numel(P_buff(:,1))-1
        if P_buff(kk,2)==P_buff(kk+1,2)
            remove_buff_tmp=[remove_buff_tmp kk+1];
            P_buff_tmp(kk,3)=P_buff(kk,3)+P_buff(kk+1,3);
        end
    end
P_buff_tmp(remove_buff_tmp,:)=[];
if length(P_buff_tmp(:,1))==1
    P_buff_tmp(2,:)=P_buff(2,:);
end
sorted_P=flipud(sortrows(P_buff_tmp,3));
sorted2_P=sorted_P(1:2,:);  
sorted2=sortrows(sorted2_P,1);
    elseif numel(P_buff(:,1))<2
        sorted2=[P_buff;P_buff];
    else
        sorted2=P_buff;
    end
% x_left=rr(SignChange(P_est_peaks1(end-1)+TP_sep-2));
% x_right=rr(SignChange(P_est_peaks1(end)+1++TP_sep-2));
x_left=rr(SignChange(sorted2(1,1)+TP_sep-2));
x_right=rr(SignChange(sorted2(2,1)+TP_sep-2));
cb=numel(P_est_peaks1);
end
[Neg, P_peak1]=max(abs(x(x_left:x_right)));
[Neg, P_peak2]=max(x(x_left:x_right));
P_peak=max(P_peak1,P_peak2)+rr(SignChange(sorted2(1,1)+TP_sep-2))-1;
if P_peak-T_peak<fix(0.3*length(x)) && T_peak>round(0.5*length(x))
    TP_sep=TP_sep-1;T_est_peaks1=1;
else
    while P_peak-T_peak<fix(0.1*length(x)) && numel(AmpDiff_P)>2
    AmpDiff_P=AmpDiff_P(2:end);
    P_est_peaks1=find(AmpDiff_P>mean(AmpDiff_P));
    if numel(P_est_peaks1)==1
    x_left=rr(SignChange(P_est_peaks1(1)+TP_sep-2));
    x_right=rr(SignChange(P_est_peaks1(1)+TP_sep-1));
    cb=2;
    else
    x_left=rr(SignChange(P_est_peaks1(end-1)+TP_sep-2));
    x_right=rr(SignChange(P_est_peaks1(end)+1++TP_sep-2));
    cb=numel(P_est_peaks1);
    end
    [Neg, P_peak1]=max(abs(x(x_left:x_right)));
    [Neg, P_peak2]=max(x(x_left:x_right));
    P_peak=max(P_peak1,P_peak2)+rr(SignChange(P_est_peaks1(cb-1)+TP_sep-2))-1;
    chk_t=false;
    end
    [Neg,MAXT]=max(x(1:T_peak));
    Tpoints=T_sorted(:,1);
    if (QRS_sign<0 || (length(Tpoints)>1 && Tpoints(2)-Tpoints(1)>4)) && MAXT<T_peak && MAXT>1 && T_peak>fix(0.5*length(x))% elevated T wave
        chk_t=true;
        TP_sep=TP_sep-1;
        T_est_peaks1=1;
    else
        chk_t=false;
    end
    if sum(T_status)==0
        chk_t=true;
        TP_sep=TP_sep-1;
        T_est_peaks1=1;
    end    
end
end
% end
% end
% if fig1
% figure;plot(x);hold on;plot(rr(SignChange),x(rr(SignChange)),'ro');plot(rr(SignChange(KeepMarker)),x(rr(SignChange(KeepMarker))),...
%     'go','MarkerFaceColor','g')
% set(zoom,'motion','horizontal','enable','on')
% stem(rr(SignChange),RatioAmpTime,'.k')
% plot(rr(SignChange(KeepMarker)),th_store1,'m')
% plot(rr(SignChange(KeepMarker)),th_store2,'-.k')
% plot(rr(SignChange(KeepMarker)),-th_store2,'-.k')
% end
% keyboard
function [curve]=T_edges(T_wing,mark,mark1,type,old_point)
res=[];
curve=0;
point=0;
tit={'Left' 'Right'};
if type==3
    CC=mark;DD=length(T_wing );
elseif type==4
    CC=mark1;DD=mark;
else
    CC=1;DD=mark;
end
% clear res
% T_wing=T_wing+abs(min(T_wing));% negative to positive
xx=[CC:1:DD];%X axis samples for the line 
% yy=[T_wing (CC):-(T_wing (CC)-T_wing (DD))/(length(xx)-1):T_wing (DD)];%line: Y axis values
yy=linspace(T_wing(1), T_wing(DD-CC+1),DD-CC+1 );
% yy=yy(1:length(xx));
for q=1:length(yy)
    res(q,1)=abs(yy(q)-T_wing (xx(q)));% compare the line and curve amplitudes
end
if isempty(res)
    curve=old_point;
else
[Neg, C]=max(res);% find tha max difference in Y axis between the line and curve
point=curve;
curve=CC+(C*1);
end% the index of cutoff point 