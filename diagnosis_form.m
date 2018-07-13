function varargout = diagnosis_form(varargin)
% H_rate1,QT_interval1,QT_corrected1,PR_interv1,QRS_dur1,active_leads
% DIAGNOSIS_FORM M-file for diagnosis_form.fig
%      DIAGNOSIS_FORM, by itself, creates a new DIAGNOSIS_FORM or raises the existing
%      singleton*.
%
%      H = DIAGNOSIS_FORM returns the handle to a new DIAGNOSIS_FORM or the handle to
%      the existing singleton*.
%
%      DIAGNOSIS_FORM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DIAGNOSIS_FORM.M with the given input arguments.
%
%      DIAGNOSIS_FORM('Property','Value',...) creates a new DIAGNOSIS_FORM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before diagnosis_form_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to diagnosis_form_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help diagnosis_form

% Last Modified by GUIDE v2.5 26-Dec-2012 11:34:43

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @diagnosis_form_OpeningFcn, ...
                   'gui_OutputFcn',  @diagnosis_form_OutputFcn, ...
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
% set(handles.uitable1,'Data',Rej_area)

% --- Executes just before diagnosis_form is made visible.
function diagnosis_form_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to diagnosis_form (see VARARGIN)

% Choose default command line output for diagnosis_form
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
data=zeros(13,5);
H_rate1=varargin{1};
PR_interv1=varargin{4};
QRS_dur1=varargin{5};
QT_interval1=varargin{2};
QT_corrected1=varargin{3};
active_leads=varargin{6};
for i=1:numel(active_leads)
data(active_leads(i),1)=H_rate1(i);
data(active_leads(i),2)=PR_interv1(i);
data(active_leads(i),3)=QRS_dur1(i);
data(active_leads(i),4)=QT_interval1(i);
data(active_leads(i),5)=QT_corrected1(i);
end
set(handles.uitable1,'Data',data)


    
% UIWAIT makes diagnosis_form wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = diagnosis_form_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
