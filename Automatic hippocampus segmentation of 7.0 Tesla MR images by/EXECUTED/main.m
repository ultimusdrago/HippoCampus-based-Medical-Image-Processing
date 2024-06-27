function varargout = main(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @main_OpeningFcn, ...
                   'gui_OutputFcn',  @main_OutputFcn, ...
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
function main_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);
function varargout = main_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;
function pushbutton1_Callback(hObject, eventdata, handles)

[FileName,PathName]=uigetfile('*.jpg','Select MRI images');
axes(handles.axes1);
fileid=fopen('fname.txt','w');
fprintf(fileid,'%s',FileName);
fclose(fileid);
imshow(imread(FileName));
function pushbutton3_Callback(hObject, eventdata, handles)
fileid=fopen('fname.txt','r');
filename=fscanf(fileid,'%s');
fclose(fileid);
features(filename,2);
detect(filename);

N = 10;     
C = 2;      
K = 10;    
D = 4;     
M = D+2;   
S = 2;     
tau = 1;   
opts.mapfun = @(theta,R) map_st_rbf(theta,R);    
opts.K = K;
opts.beta = 0.01;  


[r1 r2 r3 r4] = ndgrid(linspace(0,1,5)');
R = [r1(:) r2(:) r3(:) r4(:)];  
omega = randn(K,M);             

for s = 1:S
    data(s).X = randn(N,C);     
    W = randn(C,K);              
    data(s).R = R;      
    F = tlsa_map(opts.mapfun,omega,data(s).R); 
    data(s).Y = normrnd(data(s).X*W*F,sqrt(1/tau));          
    
    
    testdata(s).X = randn(N,C);
    testdata(s).R = R;
    testdata(s).Y = normrnd(testdata(s).X*W*F,sqrt(1/tau));
end
results = tlsa_EM(data,opts);
mu = tlsa_decode_gaussian(data,testdata,results);
figure;
scatter(testdata(1).X(:),mu{1}(:)); lsline
xlabel('Ground truth covariates','FontSize',15);
ylabel('Decoded covariates','FontSize',15);
