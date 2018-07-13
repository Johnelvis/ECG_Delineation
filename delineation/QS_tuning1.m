function [Q_e,S_e]=QS_tuning1(filtered_signal,QRS_loca,Fs,handles)
old_point=[];res=[];
MS_PER_SAMPLE=(1000/Fs);
MS200=round(200/MS_PER_SAMPLE);
% MS400=fix(400/MS_PER_SAMPLE+0.5);
% figure;
for i=1:length(QRS_loca)
%     i
    if QRS_loca(i)<MS200
        interv=zeros(1,round(2*MS200));
        interv(MS200-QRS_loca(i)+1:end)=filtered_signal(1:QRS_loca(i)+MS200);
        interv(1:MS200-QRS_loca(i))=interv(9);
        R_loc_tmp=length(interv)-MS200;
    elseif QRS_loca(i)>length(filtered_signal)-MS200
        interv=filtered_signal(QRS_loca(i)-MS200+1:end);
        interv(100)=0;
        if i==length(QRS_loca)
            R_loc_tmp=MS200;
        else
        R_loc_tmp=length(interv)-MS200;
        end
    else
        interv=filtered_signal(QRS_loca(i)-MS200+1:QRS_loca(i)+MS200);
        R_loc_tmp=length(interv)-MS200;
    end
    R_peak=filtered_signal(QRS_loca(i));
    if R_peak<0
        interv=-interv;
    end
    interv=interv-min(interv);% make it positive
    interv=interv./max(abs(interv));% normalization 0:1
    samp1=interv(R_loc_tmp:-1:1);
    samp2=interv(R_loc_tmp:end);
    %============================calculate needed parameters===============
    data_range=max(interv)-min(interv);
    R_peak=filtered_signal(QRS_loca(i));
    [non1 min_loc_samp1 ]=min(samp1);
    [non2 min_loc_samp2 ]=min(samp2);
    tangent_samp1=atand(samp1(1:end-1)-samp1(2:end));
    SignChange_samp1=find(tangent_samp1(1:end-1).*tangent_samp1(2:end)<0)+1;
    tangent_samp2=atand(samp2(1:end-1)-samp2(2:end));
    SignChange_samp2=find(tangent_samp2(1:end-1).*tangent_samp2(2:end)<0)+1;
    if isempty(SignChange_samp2)
        SignChange_samp2=length(samp2);
    end
    if isempty(SignChange_samp1)
        SignChange_samp1=length(samp1);
    end
    %========================= plot================================

%     plot(interv);hold on
%     plot(R_loc_tmp,interv(R_loc_tmp),'Ko','MarkerFaceColor','r')
%     [a1 b1]=min(samp1);
%     plot(R_loc_tmp-b1+1,a1,'Ko','MarkerFaceColor','k')
%     [a2 b2]=min(samp2);
%     plot(R_loc_tmp+b2-1,a2,'Ko','MarkerFaceColor','k')
%     hold on
% %     if R_peak<0
% %         samp1=-samp1;samp2=-samp2;
% %     end
    %=====================================================================================================================================
    QS4_thr=str2num(get(handles.QS4_thr,'string'));
%    if abs(filtered_signal(QRS_loca(i)-min_loc_samp1)/R_peak)<0.4% R is positive with small S
    if (SignChange_samp1(1)<=min_loc_samp1) && (min_loc_samp1<fix(length(samp1)/2))%the min is located in Q wave
       QS1=QRS_edges(samp1,min_loc_samp1+5,1,4,[],res);
       [non max_loc_tmp]=max(samp1(QS1:min_loc_samp1));
       if isempty(max_loc_tmp)
           max_loc_tmp=0;
       end
       if abs(max_loc_tmp+QS1-1-min_loc_samp1+5)<=2 || abs(QS1-min_loc_samp1)<=2
           QS2=QRS_edges(samp1,min_loc_samp1+5,QS1,4,[],res);
       else
           QS2=QRS_edges(samp1,min_loc_samp1+5,max_loc_tmp+QS1-1,4,[],res);
       end
       if QS2<min_loc_samp1 && QS2>QS1
          Q_e(i)=QS2+1;QQ(1)=Q_e(i);
       else
          Q_e(i)=QS1+1;QQ(1)=Q_e(i);
       end
       [Q_e(i)]=recheck(1,samp1,samp2,Q_e(i),min_loc_samp1,QS4_thr);
    else
           QS1=QRS_edges(samp1,min_loc_samp1,1,4,[],res);
           QS2=QRS_edges(samp1,length(samp1),QS1,4,QS1,res);
           QS3=QRS_edges(samp1,min_loc_samp1,QS1,4,QS1,res);
           QS4=QRS_edges(samp1,min_loc_samp1,QS3,4,QS3,res);
           QS3_thr=str2num(get(handles.QS3_thr,'string'));
           if QS2<=min_loc_samp1 && samp1(QS1)/samp1(QS2)>2 && (QS2<=QS3 || QS4<=QS2)
               QS=QS2;
           elseif QS3<=min_loc_samp1 && samp1(QS1)/samp1(QS3)>QS3_thr
               QS=QS3;
           else
               QS=QS1;
           end
           Q_e(i)=QS+1;QQ(1)=Q_e(i);
    end
    %   SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS
        if abs(filtered_signal(QRS_loca(i)+min_loc_samp2-2)/R_peak)>0.5 && min_loc_samp2<=fix(0.5*length(samp2))
        QS=QRS_edges(samp2,fix(0.06*Fs),min_loc_samp2,4,[],res);
        S_e(i)=QS+1;SS(1)=S_e(i);
%        [S_e(i)]=recheck(2,samp1,samp2,S_e(i));
    elseif (SignChange_samp2(1)<=min_loc_samp2) && (min_loc_samp2<fix(length(samp2)/3))% if min close to R
       QS=QRS_edges(samp2,min_loc_samp2+10,1,4,[],res);% 10 sometimes is not enough e.g sel36 ECG1
       S_e(i)=QS+1;SS(1)=S_e(i);
       [S_e(i)]=recheck(2,samp1,samp2,S_e(i),[],QS4_thr);
       if S_e(i)<fix(0.5*length(samp2))&& 0.5*samp2(QS)>samp2(S_e(i))
            QS=QRS_edges(samp2,length(samp2),min_loc_samp2,4,[],res);
            S_e(i)=QS+1;SS(1)=S_e(i);
       end
    else
           QS1=QRS_edges(samp2,min_loc_samp2,1,4,[],res);
           QS1_rev=QRS_edges(samp2,min_loc_samp2,QS1-2,4,[],res);
           QS2=QRS_edges(samp2,length(samp2),QS1,4,QS1,res);
           QS3=QRS_edges(samp2,length(samp2),min_loc_samp2,4,QS1,res);
           QS3_thr1=str2num(get(handles.QSS3_thr1,'string'));
           QS3_thr2=str2num(get(handles.QSS3_thr2,'string'));
           if QS2>length(samp2)
               QS2=length(samp2);
           end
           if QS2<=min_loc_samp2+1 && samp2(QS1)/samp2(QS2)>2 && QS2<=QS3 && QS2<0.7*length(samp2)&&samp2(QS1)/samp2(QS2)<5
               QS=QS2;
           elseif QS3<round((length(samp2))*QS3_thr1) && samp2(QS1)/samp2(QS3)>QS3_thr2 && samp2(QS1)/samp2(QS3)<3
               QS=QS3;
           elseif (QS1_rev-QS1)/(min_loc_samp2-QS1_rev)<0.7
               QS=QS1_rev;
           else
               QS=QS1;
           end
               S_e(i)=QS+1;SS(1)=S_e(i);
    end
%=========================================================================================================================
%  elseif min_loc_samp2<fix(length(samp1)/2) && abs(R_peak/filtered_signal(QRS_loca(i)+min_loc_samp2))<1% for small peaked QRS (deep S)
% %         i
%         disp('tangent used for Q detection')
%         tangent1=atand(samp1(1:end-1)-samp1(2:end));
%         QQ=find(tangent1(3:end)./tangent1(2:end-1)<0.8);% find where the tangent decrease by 0.8 or less
%         Q_e(i)=QQ(1);
%         tangent2=atand(samp2(min_loc_samp2:end-1)-samp2(min_loc_samp2+1:end));
%         SS=find(tangent2(3:end)./tangent2(2:end-1)<0.9);
%         S_e(i)=b2+SS(1)-1;
%=====================================================================================================================
end
%     plot(R_loc_tmp-Q_e,interv(R_loc_tmp-Q_e),'Ko','MarkerFaceColor','g')
%     plot(R_loc_tmp+S_e,interv(R_loc_tmp+S_e),'Ko','MarkerFaceColor','g')
% end


function [curve]=QRS_edges(QRS_wing,mark,mark1,type,old_point,res)
% res=[];
curve=0;
point=0;
tit={'Left' 'Right'};
if type==3
    CC=mark;DD=length(QRS_wing);
elseif type==4
    CC=min([mark1 mark]);DD=max([mark1 mark]);
else
    CC=1;DD=mark;
end
if DD>length(QRS_wing) DD=length(QRS_wing); end
% clear res
xx=[min([CC DD]):1:max([DD CC])];%X axis samples for the line 
% yy=[QRS_wing(CC):-(QRS_wing(CC)-QRS_wing(DD))/(length(xx)-1):QRS_wing(DD)];%line: Y axis values
yy=linspace(QRS_wing(CC),QRS_wing(DD),numel(xx));
% for q=1:length(yy)
%     res(q,1)=abs(yy(q)-QRS_wing(xx(q)));% compare the line and curve amplitudes
% end
res=abs(yy-QRS_wing(xx))';
if isempty(res)&& ~isempty(old_point)
    curve=old_point;
elseif isempty(res)
    keyboard;
else
[Neg, C]=max(res);% find tha max difference in Y axis between the line and curve
point=curve;
curve=CC+(C*1);
end% the index of cutoff point 

%==========================plot==========================
% figure;plot([1:length(QRS_wing)],QRS_wing,'-b')
% hold on
% line(xx,yy,'color','g')
    
function[QS_correct]=recheck(fact,samp1,samp2,win_L,MIN1,QS4_thr)
if fact==1
    wing=samp1;rang=5;
%     if win_L+rang<MIN1+rang
%         rang=(MIN1+rang)-win_L+1;
%     end
else
    wing=samp2;rang=15;
end
[Neg, BB]=min(wing);
QS4=QRS_edges(wing,win_L+rang,win_L,4,win_L,[]);
% if MIN1<QS4
%     QS4=QRS_edges(wing,MIN1+15,MIN1,4,win_L);
% end
if QS4<fix(QS4_thr*length(wing))&& wing(QS4)>wing(win_L)&&BB<=win_L
    QS_correct=QS4;
else
   QS_correct=win_L;
end