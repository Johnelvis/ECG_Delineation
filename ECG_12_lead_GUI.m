function varargout = ECG_12_lead_GUI(varargin)
% ECG_12_LEAD_GUI M-file for ECG_12_lead_GUI.fig
%      ECG_12_LEAD_GUI, by itself, creates a new ECG_12_LEAD_GUI or raises the existing
%      singleton*.
%
%      H = ECG_12_LEAD_GUI returns the handle to a new ECG_12_LEAD_GUI or the handle to
%      the existing singleton*.
%
%      ECG_12_LEAD_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ECG_12_LEAD_GUI.M with the given input arguments.
%
%      ECG_12_LEAD_GUI('Property','Value',...) creates a new ECG_12_LEAD_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ECG_12_lead_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ECG_12_lead_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ECG_12_lead_GUI

% Last Modified by GUIDE v2.5 10-Jun-2014 14:40:41

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ECG_12_lead_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @ECG_12_lead_GUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before ECG_12_lead_GUI is made visible.
function ECG_12_lead_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ECG_12_lead_GUI (see VARARGIN)

% Choose default command line output for ECG_12_lead_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
% axes(handles.axes4)

global counter hh H_rate1 QT_interval1 QT_corrected1 PR_interv1 QRS_dur1   
H_rate1=[];QT_interval1=[];QT_corrected1=[];PR_interv1=[]; QRS_dur1=[];

set(gca,'xticklabel',[])
set(gca,'yticklabel',[])
% set(handles.axes4,'visible','off')
% set(handles.uipanel8,'visible','off');
set(handles.tuningpanel,'visible','off');
set(handles.axes5,'visible','off')
set(allchild(handles.axes5),'visible','off');
image_pic = imread(strcat(char(pwd),'\icons\','zoom-in.png'));
set(handles.zoom_in,'cdata',image_pic);
image_pic = imread(strcat(char(pwd),'\icons\','move.jpg'));
set(handles.move_fig,'cdata',image_pic);
set(handles.sampling_freq,'string',500)
counter=0;

 set(handles.window,'string','2');
 set(handles.AmpTime,'string','4');
 set(handles.QRS_amp_th,'string','0.6');
 set(handles.AmpTime_thr,'string','0.4');
 set(handles.RR_thr,'string','1.33');
 set(handles.adapt_R_peak,'string','0.38');
 set(handles.adapt_AmpTime,'string','0.38');
 set(handles.QS3_thr,'string','1.7');
 set(handles.QSS3_thr1,'string','0.8');
 set(handles.QSS3_thr2,'string','1.5');
 set(handles.QS4_thr,'string','0.6');
 set(handles.TP_window,'string','2');
 set(handles.T_block,'string','0.6');
 set(handles.T_thr1,'string','0.25');
 set(handles.T_thr2,'string','0.01');
 set(handles.T_thr3,'string','2');
 set(handles.tuned_Rpeak,'string','0.6');
 set(handles.tuned_AmpTime,'string','0.5');

  

% UIWAIT makes ECG_12_lead_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure2);


% --- Outputs from this function are returned to the command line.
function varargout = ECG_12_lead_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function DB_name_Callback(hObject, eventdata, handles)
% hObject    handle to DB_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of DB_name as text
%        str2double(get(hObject,'String')) returns contents of DB_name as a double


% --- Executes during object creation, after setting all properties.
function DB_name_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DB_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in load_DB.
function load_DB_Callback(hObject, eventdata, handles)
% hObject    handle to load_DB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global pathname filename ECG_sig H_rate1 QT_interval1 QT_corrected1 PR_interv1 QRS_dur1   
H_rate1=[];QT_interval1=[];QT_corrected1=[];PR_interv1=[]; QRS_dur1=[];
set(handles.convert_data,'backgroundcolor',[0.9412 0.9412 0.9412])
set(handles.sampling_freq,'foregroundcolor','r')
[filename, pathname] = uigetfile({strcat(char(pwd),'\database\','*.mat;*.txt;*.wav')}, 'Choose a File');
 addpath(strcat(pwd,'\delineation'));
 lead_names={'I' 'II' 'III' 'aVR' 'aVL' 'aVF' 'V1' 'V2' 'V3' 'V4' 'V5' 'V6'};
for k=12:-1:1
    set(eval(strcat('handles.lead_',lead_names{k})),'enable','on')
end
 wav_id1=strfind(filename,'wav');wav_id2=strfind(filename,'WAV');
 txt_id1=strfind(filename,'txt');txt_id2=strfind(filename,'TXT');
 mat_id1=strfind(filename,'mat');mat_id2=strfind(filename,'MAT');
 if ~isempty(mat_id1)|~isempty(mat_id2)
    vars = whos('-file',strcat(pathname,filename));
    load(strcat(pathname,filename));
    ECG_sig=eval(vars.name)';
 elseif ~isempty(txt_id1)|~isempty(txt_id2)
     ECG_sig=load(strcat(pathname,filename));
 elseif ~isempty(wav_id1)|~isempty(wav_id2)
     [ECG_sig,FS]=audioread(strcat(pathname,filename));
     if FS ~= str2num(get(handles.sampling_freq,'string'))
         disp('You have Keyed in the wrong sampling frequency')
         disp(FS)
         set(handles.sampling_freq,'string',num2str(FS))
%      ECG_sig=Y;
     end
 end
 [row_sig col_sig]=size(ECG_sig);
 if col_sig<row_sig
     ECG_sig=ECG_sig';
 end
%  ECG_sig=ECG_sig(:,1:75627);
lead_names={'I' 'II' 'III' 'aVR' 'aVL' 'aVF' 'V1' 'V2' 'V3' 'V4' 'V5' 'V6'};
for k=12:-1:size(ECG_sig,1)+1
    set(eval(strcat('handles.lead_',lead_names{k})),'enable','off')
end
 set(handles.DB_name,'string',filename)
 
 %====================clearing old delination results===============
%  set(handles.I_1,'string','');
%  set(handles.I_2,'string','');
%  set(handles.I_3,'string','');
%  set(handles.I_4,'string','');
%  set(handles.II_1,'string','');
%  set(handles.II_2,'string','');
%  set(handles.II_3,'string','');
%  set(handles.II_4,'string','');
%  set(handles.III_1,'string','');
%  set(handles.III_2,'string','');
%  set(handles.III_3,'string','');
%  set(handles.III_4,'string','');
%  set(handles.aVR_1,'string','');
%  set(handles.aVR_2,'string','');
%  set(handles.aVR_3,'string','');
%  set(handles.aVR_4,'string','');
%  set(handles.aVL_1,'string','');
%  set(handles.aVL_2,'string','');
%  set(handles.aVL_3,'string','');
%  set(handles.aVL_4,'string','');
%  set(handles.aVF_1,'string','');
%  set(handles.aVF_2,'string','');
%  set(handles.aVF_3,'string','');
%  set(handles.aVF_4,'string','');
%  set(handles.V1_1,'string','');
%  set(handles.V1_2,'string','');
%  set(handles.V1_3,'string','');
%  set(handles.V1_4,'string','');
%  set(handles.V2_1,'string','');
%  set(handles.V2_2,'string','');
%  set(handles.V2_3,'string','');
%  set(handles.V2_4,'string','');
%  set(handles.V3_1,'string','');
%  set(handles.V3_2,'string','');
%  set(handles.V3_3,'string','');
%  set(handles.V3_4,'string','');
%  set(handles.V4_1,'string','');
%  set(handles.V4_2,'string','');
%  set(handles.V4_3,'string','');
%  set(handles.V4_4,'string','');
%  set(handles.V5_1,'string','');
%  set(handles.V5_2,'string','');
%  set(handles.V5_3,'string','');
%  set(handles.V5_4,'string','');
%  set(handles.V6_1,'string','');
%  set(handles.V6_2,'string','');
%  set(handles.V6_3,'string','');
%  set(handles.V6_4,'string','');
 %check the leads status
 
 




function sampling_freq_Callback(hObject, eventdata, handles)
% hObject    handle to sampling_freq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sampling_freq as text
%        str2double(get(hObject,'String')) returns contents of sampling_freq as a double


% --- Executes during object creation, after setting all properties.
function sampling_freq_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sampling_freq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in lead_V1.
function lead_V1_Callback(hObject, eventdata, handles)
% hObject    handle to lead_V1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of lead_V1


% --- Executes on button press in lead_V2.
function lead_V2_Callback(hObject, eventdata, handles)
% hObject    handle to lead_V2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of lead_V2


% --- Executes on button press in lead_V3.
function lead_V3_Callback(hObject, eventdata, handles)
% hObject    handle to lead_V3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of lead_V3


% --- Executes on button press in lead_V4.
function lead_V4_Callback(hObject, eventdata, handles)
% hObject    handle to lead_V4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of lead_V4


% --- Executes on button press in lead_V5.
function lead_V5_Callback(hObject, eventdata, handles)
% hObject    handle to lead_V5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of lead_V5


% --- Executes on button press in lead_V6.
function lead_V6_Callback(hObject, eventdata, handles)
% hObject    handle to lead_V6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of lead_V6


% --- Executes on button press in lead_I.
function lead_I_Callback(hObject, eventdata, handles)
% hObject    handle to lead_I (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of lead_I


% --- Executes on button press in lead_II.
function lead_II_Callback(hObject, eventdata, handles)
% hObject    handle to lead_II (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of lead_II


% --- Executes on button press in lead_III.
function lead_III_Callback(hObject, eventdata, handles)
% hObject    handle to lead_III (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of lead_III


% --- Executes on button press in lead_aVR.
function lead_aVR_Callback(hObject, eventdata, handles)
% hObject    handle to lead_aVR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of lead_aVR


% --- Executes on button press in lead_aVL.
function lead_aVL_Callback(hObject, eventdata, handles)
% hObject    handle to lead_aVL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of lead_aVL


% --- Executes on button press in lead_aVF.
function lead_aVF_Callback(hObject, eventdata, handles)
% hObject    handle to lead_aVF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of lead_aVF


% --- Executes on button press in all_leads.
function all_leads_Callback(hObject, eventdata, handles)
% hObject    handle to all_leads (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.lead_I,'value')==0
    set(handles.lead_I,'value',1);
    set(handles.lead_II,'value',1);
    set(handles.lead_III,'value',1);
    set(handles.lead_aVR,'value',1);
    set(handles.lead_aVL,'value',1);
    set(handles.lead_aVF,'value',1);
    set(handles.lead_V1,'value',1);
    set(handles.lead_V2,'value',1);
    set(handles.lead_V3,'value',1);
    set(handles.lead_V4,'value',1);
    set(handles.lead_V5,'value',1);
    set(handles.lead_V6,'value',1);
else
    set(handles.lead_I,'value',0);
    set(handles.lead_II,'value',0);
    set(handles.lead_III,'value',0);
    set(handles.lead_aVR,'value',0);
	set(handles.lead_aVL,'value',0);
    set(handles.lead_aVF,'value',0);
    set(handles.lead_V1,'value',0);
    set(handles.lead_V2,'value',0);
    set(handles.lead_V3,'value',0);
    set(handles.lead_V4,'value',0);
    set(handles.lead_V5,'value',0);
    set(handles.lead_V6,'value',0);
end 
% --- Executes on button press in plot_ecg.
function plot_ecg_Callback(hObject, eventdata, handles)
% hObject    handle to plot_ecg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Fs h filename counter ECG_sig lead_status Q_hat4 QRS_old S_hat4 T_on_GUI T_peak_GUI T_off_GUI P_peak_GUI...
    H_rate1 QT_interval1 QT_corrected1 active_leads PR_interv1 QRS_dur1 tot_leads original_signal annot_signal...
     LP_indx L_indx LT_indx PP_indx RP_indx TP_indx PR_indx R_indx RT_indx;
H_rate1=[];
PR_interv1=[];
QRS_dur1=[];
QT_interval1=[];
QT_corrected1=[];
active_leads=[];
original_signal=[];
annot_signal=[];
if ~isempty(h)
    h=[];
end
% set(handles.axes5,'visible','off')
% set(allchild(handles.axes5),'visible','off');
Fs=str2num(get(handles.sampling_freq,'string'));
         addstr = {'Welcome'}; % The string to add to the stack.
         set(handles.listbox1,'str',{addstr{:}});  % Put the new string on top
lead_names={'I' 'II' 'III' 'aVR' 'aVL' 'aVF' 'V1' 'V2' 'V3' 'V4' 'V5' 'V6'};
 lead_status(1)=get(handles.lead_I,'value');
 lead_status(2)=get(handles.lead_II,'value');
 lead_status(3)=get(handles.lead_III,'value');
 lead_status(4)=get(handles.lead_aVR,'value');
 lead_status(5)=get(handles.lead_aVL,'value');
 lead_status(6)=get(handles.lead_aVF,'value');
 lead_status(7)=get(handles.lead_V1,'value');
 lead_status(8)=get(handles.lead_V2,'value');
 lead_status(9)=get(handles.lead_V3,'value');
 lead_status(10)=get(handles.lead_V4,'value');
 lead_status(11)=get(handles.lead_V5,'value');
 lead_status(12)=get(handles.lead_V6,'value');
 active_leads=find(lead_status~=0);
 tot_leads=sum(lead_status);
 if Fs>1000%resamplwe the wav files to 500 Hz
    x_tmp=resample(ECG_sig',1000,Fs);%down sample the ECG to 1000 Hz
    Fs=1000;
    ECG_sig=x_tmp';clear x_tmp;
    set(handles.sampling_freq,'string','1000')
    set(handles.sampling_freq,'foregroundcolor','b')

end
 MS_PER_SAMPLE=(1000/Fs);% it was round(1000/Fs)
 handles.t0=clock;
 Date_name=strrep(datestr(handles.t0),':','.');
 for j=1:tot_leads
%      if lead_status(j)
         lead_No=active_leads(j);
         [Q_hat4,QRS_old,S_hat4,T_on_GUI,T_peak_GUI,T_off_GUI,P_peak_GUI,annot_sig,original_sig]=CBE_single_lead(filename,ECG_sig,lead_No,handles);
         annot_signal=[annot_signal;annot_sig];
         original_signal=[original_signal;original_sig];
         QRS_Amp=annot_sig(QRS_old);
         T_peak_Amp=annot_sig(T_peak_GUI);
         P_peak_Amp=annot_sig(P_peak_GUI);
         Q_Amp=annot_sig(Q_hat4);
         S_Amp=annot_sig(S_hat4);
         clear annot_sig original_sig
         pause(0.01);
         set(handles.uipanel15,'visible','on');
%           if strcmp(get(handles.uipanel8,'visible'),'on')
%              set(handles.uipanel8,'visible','off');
%              set(handles.axes4,'visible','off')
%              set(allchild(handles.axes4),'visible','off');
%           end
%           for i=1:tot_leads
%               if lead_status(j)
pause(1);
if get(handles.popupmenu1,'value')==2
    Plot_sig=annot_signal;
else
    Plot_sig=original_signal;
end
[h]=plot_annots(j,tot_leads,S_hat4,Q_hat4,QRS_old,T_on_GUI,T_off_GUI,T_peak_GUI,P_peak_GUI,Plot_sig,Fs,handles);
%                  h(j)=subplot(tot_leads,1,j,'Parent',handles.uipanel15);
%                  p=get(h(j),'pos');
%                  p = p + [-0.05 0.02 0.08 0.01];
%                  set(h(j), 'pos', p);
%                  set(gca,'FontSize',5)
%                  plot(timeline,ECG_sig(active_leads(j),:));axis tight;
%                  hold on;
%                  plot(timeline(S_hat4),ECG_sig(active_leads(j),S_hat4),'Ko','MarkerFaceColor','g','Markersize',3)
%                  plot(timeline(Q_hat4),ECG_sig(active_leads(j),Q_hat4),'Ko','MarkerFaceColor','g','Markersize',3)
%                  plot(timeline(QRS_old),ECG_sig(active_leads(j),QRS_old),'Ko','MarkerFaceColor','r','Markersize',3)
%                  plot(timeline(T_on_GUI),ECG_sig(active_leads(j),T_on_GUI),'K*')
%                  plot(timeline(T_off_GUI),ECG_sig(active_leads(j),T_off_GUI),'K*')
%                  plot(timeline(T_peak_GUI),ECG_sig(active_leads(j),T_peak_GUI),'Ko','MarkerFaceColor','k','Markersize',3)
%                  plot(timeline(P_peak_GUI),ECG_sig(active_leads(j),P_peak_GUI),'Ko','MarkerFaceColor','k','Markersize',3)
% %                  set(h(j),'xticklabel',[])
%                  hold off
%               end
%           end

%      end

 %======================calculate delineation==================
 switch active_leads(j)
     case 1
         H_rate=fix(60*numel(QRS_old)/(numel(ECG_sig(active_leads(j),:))/Fs));%BPM
         QT_interval=fix(mean(T_off_GUI-Q_hat4(1:length(T_off_GUI)))*MS_PER_SAMPLE);%msec
         QT_corrected=fix(QT_interval/sqrt(60/H_rate));
         PR_interv=Q_hat4(2:end)-P_peak_GUI(1:length(Q_hat4(2:end)));
         PR_interv(PR_interv>200)=0;
         PR_interv=fix(mean(PR_interv)*MS_PER_SAMPLE);
         QRS_dur=fix(mean(S_hat4-Q_hat4(1:length(S_hat4)))*MS_PER_SAMPLE);%msec
         H_rate1=[H_rate1;H_rate];
         QT_interval1=[QT_interval1;QT_interval];
         QT_corrected1=[QT_corrected1;QT_corrected];
         PR_interv1=[PR_interv1;PR_interv];
         QRS_dur1=[QRS_dur1;QRS_dur];
         disp('Lead (I) delineation is done......!')
         oldstr = get(handles.listbox1,'string'); % The string as it is now.
         addstr = {'Lead I'}; % The string to add to the stack.
         set(handles.listbox1,'str',{oldstr{:},addstr{:}});  % Put the new string on top
     case 2
         H_rate=fix(60*numel(QRS_old)/(numel(ECG_sig(active_leads(j),:))/Fs));%BPM
         QT_interval=fix(mean(T_off_GUI-Q_hat4(1:length(T_off_GUI)))*MS_PER_SAMPLE);%msec
         QT_corrected=fix(QT_interval/sqrt(60/H_rate));
         PR_interv=Q_hat4(2:end)-P_peak_GUI(1:length(Q_hat4(2:end)));
         PR_interv(PR_interv>200)=0;
         PR_interv=fix(mean(PR_interv)*MS_PER_SAMPLE);
         QRS_dur=fix(mean(S_hat4-Q_hat4(1:length(S_hat4)))*MS_PER_SAMPLE);%msec
         H_rate1=[H_rate1;H_rate];
         QT_interval1=[QT_interval1;QT_interval];
         QT_corrected1=[QT_corrected1;QT_corrected];
         PR_interv1=[PR_interv1;PR_interv];
         QRS_dur1=[QRS_dur1;QRS_dur];
         disp('Lead (II) delineation is done......!')
         oldstr = get(handles.listbox1,'string'); % The string as it is now.
         addstr = {'Lead II'}; % The string to add to the stack.
         set(handles.listbox1,'str',{oldstr{:},addstr{:}});  % Put the new string on top
     case 3
         H_rate=fix(60*numel(QRS_old)/(numel(ECG_sig(active_leads(j),:))/Fs));%BPM
         QT_interval=fix(mean(T_off_GUI-Q_hat4(1:length(T_off_GUI)))*MS_PER_SAMPLE);%msec
         QT_corrected=fix(QT_interval/sqrt(60/H_rate));
         PR_interv=Q_hat4(2:end)-P_peak_GUI(1:length(Q_hat4(2:end)));
         PR_interv(PR_interv>200)=0;
         PR_interv=fix(mean(PR_interv)*MS_PER_SAMPLE);
         QRS_dur=fix(mean(S_hat4-Q_hat4(1:length(S_hat4)))*MS_PER_SAMPLE);%msec
         H_rate1=[H_rate1;H_rate];
         QT_interval1=[QT_interval1;QT_interval];
         QT_corrected1=[QT_corrected1;QT_corrected];
         PR_interv1=[PR_interv1;PR_interv];
         QRS_dur1=[QRS_dur1;QRS_dur];
         disp('Lead (III) delineation is done......!')
         oldstr = get(handles.listbox1,'string'); % The string as it is now.
         addstr = {'Lead III'}; % The string to add to the stack.
         set(handles.listbox1,'str',{oldstr{:},addstr{:}});  % Put the new string on top
     case 4
         H_rate=fix(60*numel(QRS_old)/(numel(ECG_sig(active_leads(j),:))/Fs));%BPM
         QT_interval=fix(mean(T_off_GUI-Q_hat4(1:length(T_off_GUI)))*MS_PER_SAMPLE);%msec
         QT_corrected=fix(QT_interval/sqrt(60/H_rate));
         PR_interv=Q_hat4(2:end)-P_peak_GUI(1:length(Q_hat4(2:end)));
         PR_interv(PR_interv>200)=0;
         PR_interv=fix(mean(PR_interv)*MS_PER_SAMPLE);
         QRS_dur=fix(mean(S_hat4-Q_hat4(1:length(S_hat4)))*MS_PER_SAMPLE);%msec
         H_rate1=[H_rate1;H_rate];
         QT_interval1=[QT_interval1;QT_interval];
         QT_corrected1=[QT_corrected1;QT_corrected];
         PR_interv1=[PR_interv1;PR_interv];
         QRS_dur1=[QRS_dur1;QRS_dur];
         disp('Lead (aVR) delineation is done......!')
         oldstr = get(handles.listbox1,'string'); % The string as it is now.
         addstr = {'Lead aVR'}; % The string to add to the stack.
         set(handles.listbox1,'str',{oldstr{:},addstr{:}});  % Put the new string on top
     case 5
         H_rate=fix(60*numel(QRS_old)/(numel(ECG_sig(active_leads(j),:))/Fs));%BPM
         QT_interval=fix(mean(T_off_GUI-Q_hat4(1:length(T_off_GUI)))*MS_PER_SAMPLE);%msec
         QT_corrected=fix(QT_interval/sqrt(60/H_rate));
         PR_interv=Q_hat4(2:end)-P_peak_GUI(1:length(Q_hat4(2:end)));
         PR_interv(PR_interv>200)=0;
         PR_interv=fix(mean(PR_interv)*MS_PER_SAMPLE);
         QRS_dur=fix(mean(S_hat4-Q_hat4(1:length(S_hat4)))*MS_PER_SAMPLE);%msec
         H_rate1=[H_rate1;H_rate];
         QT_interval1=[QT_interval1;QT_interval];
         QT_corrected1=[QT_corrected1;QT_corrected];
         PR_interv1=[PR_interv1;PR_interv];
         QRS_dur1=[QRS_dur1;QRS_dur];
         disp('Lead (aVL) delineation is done......!')
         oldstr = get(handles.listbox1,'string'); % The string as it is now.
         addstr = {'Lead aVL'}; % The string to add to the stack.
         set(handles.listbox1,'str',{oldstr{:},addstr{:}});  % Put the new string on top
     case 6
         H_rate=fix(60*numel(QRS_old)/(numel(ECG_sig(active_leads(j),:))/Fs));%BPM
         QT_interval=fix(mean(T_off_GUI-Q_hat4(1:length(T_off_GUI)))*MS_PER_SAMPLE);%msec
         QT_corrected=fix(QT_interval/sqrt(60/H_rate));
         PR_interv=Q_hat4(2:end)-P_peak_GUI(1:length(Q_hat4(2:end)));
         PR_interv(PR_interv>200)=0;
         PR_interv=fix(mean(PR_interv)*MS_PER_SAMPLE);
         QRS_dur=fix(mean(S_hat4-Q_hat4(1:length(S_hat4)))*MS_PER_SAMPLE);%msec
         H_rate1=[H_rate1;H_rate];
         QT_interval1=[QT_interval1;QT_interval];
         QT_corrected1=[QT_corrected1;QT_corrected];
         PR_interv1=[PR_interv1;PR_interv];
         QRS_dur1=[QRS_dur1;QRS_dur];
         disp('Lead (aVF) delineation is done......!')
         oldstr = get(handles.listbox1,'string'); % The string as it is now.
         addstr = {'Lead aVF'}; % The string to add to the stack.
         set(handles.listbox1,'str',{oldstr{:},addstr{:}});  % Put the new string on top
     case 7
         H_rate=fix(60*numel(QRS_old)/(numel(ECG_sig(active_leads(j),:))/Fs));%BPM
         QT_interval=fix(mean(T_off_GUI-Q_hat4(1:length(T_off_GUI)))*MS_PER_SAMPLE);%msec
         QT_corrected=fix(QT_interval/sqrt(60/H_rate));
         PR_interv=Q_hat4(2:end)-P_peak_GUI(1:length(Q_hat4(2:end)));
         PR_interv(PR_interv>200)=0;
         PR_interv=fix(mean(PR_interv)*MS_PER_SAMPLE);
         QRS_dur=fix(mean(S_hat4-Q_hat4(1:length(S_hat4)))*MS_PER_SAMPLE);%msec
         H_rate1=[H_rate1;H_rate];
         QT_interval1=[QT_interval1;QT_interval];
         QT_corrected1=[QT_corrected1;QT_corrected];
         PR_interv1=[PR_interv1;PR_interv];
         QRS_dur1=[QRS_dur1;QRS_dur];
         disp('Lead (V1) delineation is done......!')
         oldstr = get(handles.listbox1,'string'); % The string as it is now.
         addstr = {'Lead V1'}; % The string to add to the stack.
         set(handles.listbox1,'str',{oldstr{:},addstr{:}});  % Put the new string on top
     case 8
         H_rate=fix(60*numel(QRS_old)/(numel(ECG_sig(active_leads(j),:))/Fs));%BPM
         QT_interval=fix(mean(T_off_GUI-Q_hat4(1:length(T_off_GUI)))*MS_PER_SAMPLE);%msec
         QT_corrected=fix(QT_interval/sqrt(60/H_rate));
         PR_interv=Q_hat4(2:end)-P_peak_GUI(1:length(Q_hat4(2:end)));
         PR_interv(PR_interv>200)=0;
         PR_interv=fix(mean(PR_interv)*MS_PER_SAMPLE);
         QRS_dur=fix(mean(S_hat4-Q_hat4(1:length(S_hat4)))*MS_PER_SAMPLE);%msec
         H_rate1=[H_rate1;H_rate];
         QT_interval1=[QT_interval1;QT_interval];
         QT_corrected1=[QT_corrected1;QT_corrected];
         PR_interv1=[PR_interv1;PR_interv];
         QRS_dur1=[QRS_dur1;QRS_dur];
         disp('Lead (V2) delineation is done......!')
         oldstr = get(handles.listbox1,'string'); % The string as it is now.
         addstr = {'Lead V2'}; % The string to add to the stack.
         set(handles.listbox1,'str',{oldstr{:},addstr{:}});  % Put the new string on top
     case 9
         H_rate=fix(60*numel(QRS_old)/(numel(ECG_sig(active_leads(j),:))/Fs));%BPM
         QT_interval=fix(mean(T_off_GUI-Q_hat4(1:length(T_off_GUI)))*MS_PER_SAMPLE);%msec
         QT_corrected=fix(QT_interval/sqrt(60/H_rate));
         PR_interv=Q_hat4(2:end)-P_peak_GUI(1:length(Q_hat4(2:end)));
         PR_interv(PR_interv>200)=0;
         PR_interv=fix(mean(PR_interv)*MS_PER_SAMPLE);
         QRS_dur=fix(mean(S_hat4-Q_hat4(1:length(S_hat4)))*MS_PER_SAMPLE);%msec
         H_rate1=[H_rate1;H_rate];
         QT_interval1=[QT_interval1;QT_interval];
         QT_corrected1=[QT_corrected1;QT_corrected];
         PR_interv1=[PR_interv1;PR_interv];
         QRS_dur1=[QRS_dur1;QRS_dur];
         disp('Lead (V3) delineation is done......!')
         oldstr = get(handles.listbox1,'string'); % The string as it is now.
         addstr = {'Lead V3'}; % The string to add to the stack.
         set(handles.listbox1,'str',{oldstr{:},addstr{:}});  % Put the new string on top
     case 10
         H_rate=fix(60*numel(QRS_old)/(numel(ECG_sig(active_leads(j),:))/Fs));%BPM
         QT_interval=fix(mean(T_off_GUI-Q_hat4(1:length(T_off_GUI)))*MS_PER_SAMPLE);%msec
         QT_corrected=fix(QT_interval/sqrt(60/H_rate));
         PR_interv=Q_hat4(2:end)-P_peak_GUI(1:length(Q_hat4(2:end)));
         PR_interv(PR_interv>200)=0;
         PR_interv=fix(mean(PR_interv)*MS_PER_SAMPLE);
         QRS_dur=fix(mean(S_hat4-Q_hat4(1:length(S_hat4)))*MS_PER_SAMPLE);%msec
         H_rate1=[H_rate1;H_rate];
         QT_interval1=[QT_interval1;QT_interval];
         QT_corrected1=[QT_corrected1;QT_corrected];
         PR_interv1=[PR_interv1;PR_interv];
         QRS_dur1=[QRS_dur1;QRS_dur];
         disp('Lead (V4) delineation is done......!')
         oldstr = get(handles.listbox1,'string'); % The string as it is now.
         addstr = {'Lead V4'}; % The string to add to the stack.
         set(handles.listbox1,'str',{oldstr{:},addstr{:}});  % Put the new string on top
     case 11
         H_rate=fix(60*numel(QRS_old)/(numel(ECG_sig(active_leads(j),:))/Fs));%BPM
         QT_interval=fix(mean(T_off_GUI-Q_hat4(1:length(T_off_GUI)))*MS_PER_SAMPLE);%msec
         QT_corrected=fix(QT_interval/sqrt(60/H_rate));
         PR_interv=Q_hat4(2:end)-P_peak_GUI(1:length(Q_hat4(2:end)));
         PR_interv(PR_interv>200)=0;
         PR_interv=fix(mean(PR_interv)*MS_PER_SAMPLE);
         QRS_dur=fix(mean(S_hat4-Q_hat4(1:length(S_hat4)))*MS_PER_SAMPLE);%msec
         H_rate1=[H_rate1;H_rate];
         QT_interval1=[QT_interval1;QT_interval];
         QT_corrected1=[QT_corrected1;QT_corrected];
         PR_interv1=[PR_interv1;PR_interv];
         QRS_dur1=[QRS_dur1;QRS_dur];
         disp('Lead (V5) delineation is done......!')
         oldstr = get(handles.listbox1,'string'); % The string as it is now.
         addstr = {'Lead V5'}; % The string to add to the stack.
         set(handles.listbox1,'str',{oldstr{:},addstr{:}});  % Put the new string on top
     case 12
         H_rate=fix(60*numel(QRS_old)/(numel(ECG_sig(active_leads(j),:))/Fs));%BPM
         QT_interval=fix(mean(T_off_GUI-Q_hat4(1:length(T_off_GUI)))*MS_PER_SAMPLE);%msec
         QT_corrected=fix(QT_interval/sqrt(60/H_rate));
         PR_interv=Q_hat4(2:end)-P_peak_GUI(1:length(Q_hat4(2:end)));
         PR_interv(PR_interv>200)=0;
         PR_interv=fix(mean(PR_interv)*MS_PER_SAMPLE);
         QRS_dur=fix(mean(S_hat4-Q_hat4(1:length(S_hat4)))*MS_PER_SAMPLE);%msec
         H_rate1=[H_rate1;H_rate];
         QT_interval1=[QT_interval1;QT_interval];
         QT_corrected1=[QT_corrected1;QT_corrected];
         PR_interv1=[PR_interv1;PR_interv];
         QRS_dur1=[QRS_dur1;QRS_dur];
         disp('Lead (V6) delineation is done......!')
         oldstr = get(handles.listbox1,'string'); % The string as it is now.
         addstr = {'Lead V6'}; % The string to add to the stack.
         set(handles.listbox1,'str',{oldstr{:},addstr{:}});  % Put the new string on top
 end
 RR_int=(QRS_old(2:end)-QRS_old(1:end-1))'.*MS_PER_SAMPLE;
 PR_int=(Q_hat4(2:end)-P_peak_GUI(1:length(Q_hat4(2:end))))'.*MS_PER_SAMPLE;
 QRS_int=(S_hat4-Q_hat4(1:length(S_hat4)))'.*MS_PER_SAMPLE;
 QT_int=(T_off_GUI-Q_hat4(1:length(T_off_GUI)))'.*MS_PER_SAMPLE;
 QTc_int=(((QT_int./1000)./sqrt(RR_int./1000))).*1000;
w = actxserver('Excel.Application'); 
W=w.Workbooks.Open(strcat(pwd,'\default.xlsx')); % empty excel file with default style
warning off;mkdir(strcat(pwd,'\Reports\',Date_name));
Sheets = w.ActiveWorkBook.Sheets;% the sheets names
Sheets.Item(1).Activate;% activate first sheet
Activesheet = w.Activesheet;% open the activated sheet for writing
ActivesheetRange = get(Activesheet,'Range','C5:S5');% the range should be automatic according to the Mix and state No.
set(ActivesheetRange,'value',{'RR interval' 'PR interval' 'QRS duration' 'QT interval' 'QTc interval' '||' 'Q-wave loc.' 'R-wave loc.' 'S-wave loc.' 'T-wave loc.' 'P-wave loc.' '||' 'Q-wave Amp.' 'R-wave Amp.' 'S-wave Amp.' 'T-wave Amp.' 'P-wave Amp.'})
ActivesheetRange = get(Activesheet,'Range',strcat('C6:C',num2str(length(RR_int)+5)));% the range should be automatic according to the Mix and state No.
set(ActivesheetRange,'value',RR_int)
ActivesheetRange = get(Activesheet,'Range',strcat('D6:D',num2str(length(PR_int)+5)));% the range should be automatic according to the Mix and state No.
set(ActivesheetRange,'value',PR_int)
ActivesheetRange = get(Activesheet,'Range',strcat('E6:E',num2str(length(QRS_int)+5)));% the range should be automatic according to the Mix and state No.
set(ActivesheetRange,'value',QRS_int)
ActivesheetRange = get(Activesheet,'Range',strcat('F6:F',num2str(length(QT_int)+5)));% the range should be automatic according to the Mix and state No.
set(ActivesheetRange,'value',QT_int)
ActivesheetRange = get(Activesheet,'Range',strcat('G6:G',num2str(length(QTc_int)+5)));% the range should be automatic according to the Mix and state No.
set(ActivesheetRange,'value',QTc_int)
%wave locations
ActivesheetRange = get(Activesheet,'Range',strcat('I6:I',num2str(length(Q_hat4)+5)));% the range should be automatic according to the Mix and state No.
set(ActivesheetRange,'value',Q_hat4'./Fs)
ActivesheetRange = get(Activesheet,'Range',strcat('J6:J',num2str(length(QRS_old)+5)));% the range should be automatic according to the Mix and state No.
set(ActivesheetRange,'value',QRS_old'./Fs)
ActivesheetRange = get(Activesheet,'Range',strcat('K6:K',num2str(length(S_hat4)+5)));% the range should be automatic according to the Mix and state No.
set(ActivesheetRange,'value',S_hat4'./Fs)
ActivesheetRange = get(Activesheet,'Range',strcat('L6:L',num2str(length(T_peak_GUI)+5)));% the range should be automatic according to the Mix and state No.
set(ActivesheetRange,'value',T_peak_GUI'./Fs)
ActivesheetRange = get(Activesheet,'Range',strcat('M6:M',num2str(length(P_peak_GUI)+5)));% the range should be automatic according to the Mix and state No.
set(ActivesheetRange,'value',P_peak_GUI'./Fs)
%wave amplitude (a.u.)
ActivesheetRange = get(Activesheet,'Range',strcat('O6:O',num2str(length(Q_Amp)+5)));% the range should be automatic according to the Mix and state No.
set(ActivesheetRange,'value',Q_Amp')
ActivesheetRange = get(Activesheet,'Range',strcat('P6:P',num2str(length(QRS_Amp)+5)));% the range should be automatic according to the Mix and state No.
set(ActivesheetRange,'value',QRS_Amp')
ActivesheetRange = get(Activesheet,'Range',strcat('Q6:Q',num2str(length(S_Amp)+5)));% the range should be automatic according to the Mix and state No.
set(ActivesheetRange,'value',S_Amp')
ActivesheetRange = get(Activesheet,'Range',strcat('R6:R',num2str(length(T_peak_Amp)+5)));% the range should be automatic according to the Mix and state No.
set(ActivesheetRange,'value',T_peak_Amp')
ActivesheetRange = get(Activesheet,'Range',strcat('S6:S',num2str(length(P_peak_Amp)+5)));% the range should be automatic according to the Mix and state No.
set(ActivesheetRange,'value',P_peak_Amp')
% ActivesheetRange = get(Activesheet,'Range',strcat('C6:C',num2str(CHMMFileNo+5)));% the range should be automatic according to the Mix and state No.
% set(ActivesheetRange, 'value',strrep(CHMMFileName2,'.chmm',''));% copy paste the date into the excel
set(w,'DisplayAlerts',0);
invoke( W, 'SaveAs', strcat(pwd,'\Reports\',Date_name,'\',lead_names{active_leads(j)},'.xlsx'));% save the excel file to the dir:resultFilexsl
invoke( w, 'Quit' );%quit editing excel
delete(w)%delete the activex connection with the excell apps
 end

 LP_indx=[];
 L_indx=original_signal(Q_hat4);
 LT_indx=original_signal(T_on_GUI);
 PP_indx=original_signal(P_peak_GUI);
 RP_indx=original_signal(QRS_old);
 TP_indx=original_signal(T_peak_GUI);
 PR_indx=[];
 R_indx=original_signal(S_hat4);
 RT_indx=original_signal(T_off_GUI);
 
  





% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global H_rate1 QT_interval1 QT_corrected1 active_leads PR_interv1 QRS_dur1
diagnosis_form(H_rate1,QT_interval1,QT_corrected1,PR_interv1,QRS_dur1,active_leads)

% u=get(handles.uipanel8,'visible');
% if strcmp(u,'on')
%     set(handles.uipanel8,'visible','off');
%     set(handles.axes4,'visible','off')
%     set(allchild(handles.axes4),'visible','off');
% else
%     set(handles.axes4,'visible','on')
%     set(allchild(handles.axes4),'visible','on');
%     set(handles.uipanel8,'visible','on');
% end


% --- Executes on button press in zoom_in.
function zoom_in_Callback(hObject, eventdata, handles)
% hObject    handle to zoom_in (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global h
set(handles.uipanel5,'visible','on');
set(zoom,'motion','horizontal','enable','on')


% --- Executes on button press in pick_point.
function pick_point_Callback(hObject, eventdata, handles)
% hObject    handle to pick_point (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global counter hh Fs
MS_PER_SAMPLE=(1000/Fs);%it was round(1000/Fs)
counter =counter+1;
% Fs=1000;
[x1,y1]=ginput(1);
hh(counter)=vline(x1,'r');
[x2,y2]=ginput(1);
hh(counter+1)=vline(x2,'r');
set(handles.pick_duration,'string',num2str(((max([x2 x1]) -min([x2 x1])))*MS_PER_SAMPLE));
counter =counter+1;
% delete(h(2))




function pick_duration_Callback(hObject, eventdata, handles)
% hObject    handle to pick_duration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pick_duration as text
%        str2double(get(hObject,'String')) returns contents of pick_duration as a double


% --- Executes during object creation, after setting all properties.
function pick_duration_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pick_duration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in clear_pick.
function clear_pick_Callback(hObject, eventdata, handles)
% hObject    handle to clear_pick (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global counter hh
for i=1:counter
   delete(hh(i))
end
counter=0;



function TP_window_Callback(hObject, eventdata, handles)
% hObject    handle to TP_window (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TP_window as text
%        str2double(get(hObject,'String')) returns contents of TP_window as a double


% --- Executes during object creation, after setting all properties.
function TP_window_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TP_window (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function T_block_Callback(hObject, eventdata, handles)
% hObject    handle to T_block (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of T_block as text
%        str2double(get(hObject,'String')) returns contents of T_block as a double


% --- Executes during object creation, after setting all properties.
function T_block_CreateFcn(hObject, eventdata, handles)
% hObject    handle to T_block (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function T_thr1_Callback(hObject, eventdata, handles)
% hObject    handle to T_thr1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of T_thr1 as text
%        str2double(get(hObject,'String')) returns contents of T_thr1 as a double


% --- Executes during object creation, after setting all properties.
function T_thr1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to T_thr1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function T_thr2_Callback(hObject, eventdata, handles)
% hObject    handle to T_thr2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of T_thr2 as text
%        str2double(get(hObject,'String')) returns contents of T_thr2 as a double


% --- Executes during object creation, after setting all properties.
function T_thr2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to T_thr2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function T_thr3_Callback(hObject, eventdata, handles)
% hObject    handle to T_thr3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of T_thr3 as text
%        str2double(get(hObject,'String')) returns contents of T_thr3 as a double


% --- Executes during object creation, after setting all properties.
function T_thr3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to T_thr3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function QS3_thr_Callback(hObject, eventdata, handles)
% hObject    handle to QS3_thr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of QS3_thr as text
%        str2double(get(hObject,'String')) returns contents of QS3_thr as a double


% --- Executes during object creation, after setting all properties.
function QS3_thr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to QS3_thr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function QSS3_thr1_Callback(hObject, eventdata, handles)
% hObject    handle to QSS3_thr1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of QSS3_thr1 as text
%        str2double(get(hObject,'String')) returns contents of QSS3_thr1 as a double


% --- Executes during object creation, after setting all properties.
function QSS3_thr1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to QSS3_thr1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function QSS3_thr2_Callback(hObject, eventdata, handles)
% hObject    handle to QSS3_thr2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of QSS3_thr2 as text
%        str2double(get(hObject,'String')) returns contents of QSS3_thr2 as a double


% --- Executes during object creation, after setting all properties.
function QSS3_thr2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to QSS3_thr2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function QS4_thr_Callback(hObject, eventdata, handles)
% hObject    handle to QS4_thr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of QS4_thr as text
%        str2double(get(hObject,'String')) returns contents of QS4_thr as a double


% --- Executes during object creation, after setting all properties.
function QS4_thr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to QS4_thr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function window_Callback(hObject, eventdata, handles)
% hObject    handle to window (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of window as text
%        str2double(get(hObject,'String')) returns contents of window as a double


% --- Executes during object creation, after setting all properties.
function window_CreateFcn(hObject, eventdata, handles)
% hObject    handle to window (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function AmpTime_Callback(hObject, eventdata, handles)
% hObject    handle to AmpTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of AmpTime as text
%        str2double(get(hObject,'String')) returns contents of AmpTime as a double


% --- Executes during object creation, after setting all properties.
function AmpTime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AmpTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function QRS_amp_th_Callback(hObject, eventdata, handles)
% hObject    handle to QRS_amp_th (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of QRS_amp_th as text
%        str2double(get(hObject,'String')) returns contents of QRS_amp_th as a double


% --- Executes during object creation, after setting all properties.
function QRS_amp_th_CreateFcn(hObject, eventdata, handles)
% hObject    handle to QRS_amp_th (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function AmpTime_thr_Callback(hObject, eventdata, handles)
% hObject    handle to AmpTime_thr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of AmpTime_thr as text
%        str2double(get(hObject,'String')) returns contents of AmpTime_thr as a double


% --- Executes during object creation, after setting all properties.
function AmpTime_thr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AmpTime_thr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Tuning_vars.
function Tuning_vars_Callback(hObject, eventdata, handles)
% hObject    handle to Tuning_vars (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
u=get(handles.tuningpanel,'visible');
if strcmp(u,'on')
    set(handles.uipanel2,'visible','on')
    set(handles.plot_ecg,'visible','on');
    set(handles.tuningpanel,'visible','off');
    set(handles.axes5,'visible','off')
    set(allchild(handles.axes5),'visible','off');
else
    set(handles.uipanel2,'visible','off');
    set(handles.plot_ecg,'visible','off');
    set(handles.axes5,'visible','on')
    set(allchild(handles.axes5),'visible','on');
    set(handles.tuningpanel,'visible','on');
end



function RR_thr_Callback(hObject, eventdata, handles)
% hObject    handle to RR_thr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of RR_thr as text
%        str2double(get(hObject,'String')) returns contents of RR_thr as a double


% --- Executes during object creation, after setting all properties.
function RR_thr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RR_thr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function adapt_R_peak_Callback(hObject, eventdata, handles)
% hObject    handle to adapt_R_peak (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of adapt_R_peak as text
%        str2double(get(hObject,'String')) returns contents of adapt_R_peak as a double


% --- Executes during object creation, after setting all properties.
function adapt_R_peak_CreateFcn(hObject, eventdata, handles)
% hObject    handle to adapt_R_peak (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function adapt_AmpTime_Callback(hObject, eventdata, handles)
% hObject    handle to adapt_AmpTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of adapt_AmpTime as text
%        str2double(get(hObject,'String')) returns contents of adapt_AmpTime as a double


% --- Executes during object creation, after setting all properties.
function adapt_AmpTime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to adapt_AmpTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in save_fig.
function save_fig_Callback(hObject, eventdata, handles)
% hObject    handle to save_fig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global h
handles.t0=clock;
figure_name=strrep(datestr(handles.t0),':','.')
% axes(handles.uipanel15);
% orig_axes=gca;
newFig=figure('name',figure_name,'NumberTitle','off');
new4=copyobj(h(1),newFig);
set(new4,'position',[0.13 0.1 0.775 0.815]);
saveas(newFig,strcat(char(pwd),'\figures\',figure_name,'.fig'));
close(newFig)


% --- Executes on button press in move_fig.
function move_fig_Callback(hObject, eventdata, handles)
% hObject    handle to move_fig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(zoom,'motion','horizontal','enable','off')
h = pan;
set(h,'Motion','horizontal','Enable','on');


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tuned_Rpeak_Callback(hObject, eventdata, handles)
% hObject    handle to tuned_Rpeak (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tuned_Rpeak as text
%        str2double(get(hObject,'String')) returns contents of tuned_Rpeak as a double


% --- Executes during object creation, after setting all properties.
function tuned_Rpeak_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tuned_Rpeak (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tuned_AmpTime_Callback(hObject, eventdata, handles)
% hObject    handle to tuned_AmpTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tuned_AmpTime as text
%        str2double(get(hObject,'String')) returns contents of tuned_AmpTime as a double


% --- Executes during object creation, after setting all properties.
function tuned_AmpTime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tuned_AmpTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in record_data.
function record_data_Callback(hObject, eventdata, handles)
% hObject    handle to record_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
winopen(strcat(pwd,'\database\USBECG12\DaqChan16.exe'))


% --- Executes on button press in convert_data.
function convert_data_Callback(hObject, eventdata, handles)
% hObject    handle to convert_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.convert_data,'backgroundcolor',[0.9412 0.9412 0.9412])
directory_name = uigetdir(strcat(pwd,'\database\USBECG12\'),'Pick a Folder');
[filenames, pathname, filterindex] = uigetfile( ...
{strcat(directory_name,'\*.edt')}, ...
   'Pick a file', ...
   'MultiSelect', 'on');
[ECG_Data,file_Name]=convert_merge_edt_to_mat(filenames,pathname);
 save(strcat(pathname,char(file_Name),'.mat'),'ECG_Data');
 set(handles.convert_data,'backgroundcolor',[1 0 0])


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1
global tot_leads S_hat4 Q_hat4 QRS_old T_on_GUI T_off_GUI T_peak_GUI P_peak_GUI...
    Fs annot_signal original_signal
if get(handles.popupmenu1,'value')==2
    ecg_sig=annot_signal;
else
    ecg_sig=original_signal;
end
for j=1:tot_leads
[h]=plot_annots(j,tot_leads,S_hat4,Q_hat4,QRS_old,T_on_GUI,T_off_GUI,T_peak_GUI,P_peak_GUI,ecg_sig,Fs,handles);
end

% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in cut_from.
function cut_from_Callback(hObject, eventdata, handles)
% hObject    handle to cut_from (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns cut_from contents as cell array
%        contents{get(hObject,'Value')} returns selected item from cut_from
global S11
S11=get(handles.cut_from,'value')

% --- Executes during object creation, after setting all properties.
function cut_from_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cut_from (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on selection change in cut_to.
function cut_to_Callback(hObject, eventdata, handles)
% hObject    handle to cut_to (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns cut_to contents as cell array
%        contents{get(hObject,'Value')} returns selected item from cut_to
global S22
S22=get(handles.cut_to,'value')

% --- Executes during object creation, after setting all properties.
function cut_to_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cut_to (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu4.
function popupmenu4_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu4


% --- Executes during object creation, after setting all properties.
function popupmenu4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu8.
function popupmenu8_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu8 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu8
global S2 
S2=get(handles.popupmenu8,'value');



% --- Executes during object creation, after setting all properties.
function popupmenu8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu7.
function popupmenu7_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu7 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from 
global S1 

S1=get(handles.popupmenu7,'value');
% S11=get(handles.cut_from,'value');



% --- Executes during object creation, after setting all properties.
function popupmenu7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cut_cycle.
function cut_cycle_Callback(hObject, eventdata, handles)
% hObject    handle to cut_cycle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global pathname filename ECG_sig Q_hat4 QRS_old S_hat4 T_on_GUI T_peak_GUI T_off_GUI P_peak_GUI S1 S11 Start S2 S22 End Fs original_signal

switch S2
    case 2
        switch S22
            case 2
                End=[];
            case 3
                End=Q_hat4;
            case 4
                End=T_on_GUI;
        end                
    case 3
        switch S22
            case 2
                End=P_peak_GUI;
            case 3
                End=QRS_old;
            case 4
                End=T_peak_GUI;
        end
    case 4
        switch S22
            case 2
                End=[];
            case 3
                End=S_hat4;
            case 4
                End=T_off_GUI;
        end
end
switch S1
    case 2
        switch S11
            case 2
                Start=[];
            case 3
                Start=Q_hat4;
            case 4
                Start=T_on_GUI;
        end                
    case 3
        switch S11
            case 2
                Start=P_peak_GUI;
            case 3
                Start=QRS_old;
            case 4
                Start=T_peak_GUI;
        end
    case 4
        switch S11
            case 2
                Start=[];
            case 3
                Start=S_hat4;
            case 4
                Start=T_off_GUI;
        end
end

P_count=numel(P_peak_GUI);
R_count=numel(QRS_old);
T_count=numel(T_peak_GUI);
load S_MAT
SP=[4, 7,34];
SQRS_1=[10,12,13,15,16,18,37,39,40,41,42,43,45,66,67,69,70,72];
SQRS=[14,17,44];
ST=[19,22,24,25,27,46,49,52,54,73,79];
NP=[29,32,56,59,62];
NP_1=[1,2,3,4,5,6,7,8,9,28,30,31,33,34,35,36,55,57,58,60,61,63];
NQRS_1=[11,14,17,38,44,64,65,68,71];
NT=[19,20,23,26,47,50,5374,76,77];
NT_1=[21,24,25,27,48,51,54,75,78,79,80,81];
[A B]=intersect(s_mat(:,1:4),[S1 S11 S2 S22],'rows');
if get(handles.radiobutton14,'value')==0 && get(handles.radiobutton15,'value')==0
    msgbox('Please select either "Same" or "Next" cycle ....!');
    return;
end
if get(handles.radiobutton14,'value')==1
    if sum(SP==B)>0
        cycle_count=P_count;
        cc=s_mat(B,5); bb=s_mat(B,6);
    elseif sum(SQRS_1==B)>0
        cycle_count=R_count-1;
        cc=s_mat(B,5); bb=s_mat(B,6);
    elseif sum(SQRS==B)>0
        cycle_count=R_count;
        cc=s_mat(B,5); bb=s_mat(B,6);
    elseif sum(ST==B)>0
        cycle_count=T_count;
        cc=s_mat(B,5); bb=s_mat(B,6);
    end
elseif get(handles.radiobutton15,'value')==1
    if sum(NP==B)>0
        cycle_count=P_count;
        cc=s_mat(B,7); bb=s_mat(B,8);
    elseif sum(NP_1==B)>0
        cycle_count=P_count-1;
        cc=s_mat(B,7); bb=s_mat(B,8);
    elseif sum(NQRS_1==B)>0
        cycle_count=R_count-1;
        cc=s_mat(B,7); bb=s_mat(B,8);
    elseif sum(NT==B)>0
        cycle_count=T_count;
        cc=s_mat(B,7); bb=s_mat(B,8);
    elseif sum(NT_1==B)>0
        cycle_count=T_count-1;
        cc=s_mat(B,7); bb=s_mat(B,8);
    end
end
if cc==0 & bb==0;
    msgbox('Wronge selected interval, please check again...!!');
    return;
end
cycle=zeros(52000,cycle_count);
cycle_h=zeros(52000,cycle_count);
if get(handles.checkbox1,'value')==1 % for Database includes 2 Channels (ECG & HSound)
    [M N]=size(ECG_sig);
    if M<N
        ECG_sig=ECG_sig';
        if M>2
            msgbox('The chosen database does not match the 2-channel ECG-Hsound requirements, Please check again...!!');
        end
    end
    while cc~=0
        single_ECG=ECG_sig(Start(cc):End(bb),1);%USE ECG_sig for HS Cutting
    %     single_cyc=resample(single_ECG,16000,44100); %resampling to 16k
        single_h=ECG_sig(Start(cc):End(bb),2);
    %     single_cyc_h=resample(single_h,16000,44100); %resampling to 16k
        kkk(cc)=length(single_ECG);
        hsc(cc)=length(single_h);
    %   cycle(:,i)=vertcat(single_cyc,cycle(:,i));
        cycle([1:kkk(cc)],cc)=single_ECG;
        cycle_h([1:kkk(cc)],cc)=single_h;
        if cc==cycle_count || bb==cycle_count
            break
        end
        bb=bb+1; cc=cc+1;
    end
    len=numel(kkk);
    osama=max(kkk);
    heartData=cycle_h;
    heartData=heartData([1:osama],[1:len]);
else
    while cc~=0
        single_ECG=ECG_sig(Start(cc):End(bb),1);
        kkk(cc)=length(single_ECG);
        cycle([1:kkk(cc)],cc)=single_cyc;
        if cc==cycle_count || bb==cycle_count
            break
        end
        bb=bb+1; cc=cc+1;
    end
end


ECGData=cycle;
cycleLength=kkk;
osama=max(kkk);
len=numel(kkk);
ECGData=ECGData([1:osama],[1:len]);
zz=strfind(pathname,'database')+8;
if isempty(zz)
    msgbox('Please move your database to the "database" folder ... ')
    return;
end
% folder=pathname(zz(end-1):end);
% mkdir(Folder_1);
Folder_1 = [pwd strcat('\Results\extracted',pathname(zz:end))]; 
% Folder_2 = [Folder_1 folder]; 
% mkdir(Folder_2);
file_ext={'.WAV' '.TXT' '.MAT'};
sub_folder=strrep(filename,'.WAV','');
name=strcat(Folder_1,sub_folder,'\');
mkdir(name);
if get(handles.popupmenu4,'value')==4
    for mm=1:2
        switch mm
            case 1
                save(char(strcat(name,'ECG_',sub_folder)),'ECGData','cycleLength')
            case 2
                if get(handles.checkbox1,'value')==1
                    save(char(strcat(name,'HS_',sub_folder)),'heartData','cycleLength')
                end
        end
    end
elseif get(handles.popupmenu4,'value')~=4
    msgbox('This feature is not available yet, please select the default "MAT" format for now.....')
    return;
end

fss=8192; w=1000; s = (0:1/fss:.1); wave=sin(2*pi*w*s);
sound(wave,fss); 

% --- Executes on button press in radiobutton14.
function radiobutton14_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton14
if get(handles.radiobutton14,'value')==1
    set(handles.radiobutton15,'value',0)
end

% --- Executes on button press in radiobutton15.
function radiobutton15_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton15
if get(handles.radiobutton15,'value')==1
    set(handles.radiobutton14,'value',0)
end


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1
