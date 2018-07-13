function [ECG_Data,file_Name]=convert_merge_edt_to_mat(filenames,pathname)
tot_files=length(filenames);
operator=find(filenames{1}=='_');
file_Name=filenames{1};
file_Name=file_Name(1:operator(end)-1);
A=[];
s=0; r=2;n=0;%Fs=500;
for j=1:tot_files
    file_name=strcat(pathname,file_Name,'_',num2str(j),'.edt');
    gg=load(char(file_name));
    
if j==1
for i=1:12
    while s==0
    [m n]=max(gg([r:end],i));
    if m<5000
        s=1;
    else
        r=n+r;
    end
    end
    store(i)=r;
    r=2; s=0;
end
rr=max(store);
else
    rr=2;
end
%     j
    A=[A;gg([rr:end],:)];
%     B=hh([2:end],i);
%     C=jj([2:end],i);
% %     ecg=A;
%     len=length(ecg);
%     t=1/Fs*(0:len-1);
%     figure;plot(t,ecg(:,12))
%     ecg3(:,i)=((ecg>=0).*ecg/max(ecg))+((ecg<=0).*ecg/min(ecg)); %normalization [+1,-1]
%     name={'I','II','III','aVR','aVL','aVF','V1','V2','V3','V4','V5','V6'};
%     filename=strcat(name{i},'_Osama_filtered_no_AC');
%     wavwrite(ecg3,500,16,filename);
    s=0;r=2;n=0;
end
ECG_Data=A;
clear A

