function varargout = BaryCentricCo(varargin)
% BARYCENTRICCO MATLAB code for BaryCentricCo.fig
% Wrtten by: Sara Alkiswani 
% Last Modified by GUIDE v2.5 06-Jan-2022 15:03:34

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @BaryCentricCo_OpeningFcn, ...
                   'gui_OutputFcn',  @BaryCentricCo_OutputFcn, ...
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


% --- Executes just before BaryCentricCo is made visible.
function BaryCentricCo_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
handles.output = hObject;
hold on;
axis equal;
% Update handles structure
guidata(hObject, handles);
ud.figure = handles.figure1;
ud.index = 0;
ud.indexFound =0;
ud.method='MVC';
set(handles.figure1,'userdata',ud);

% --- Outputs from this function are returned to the command line.
function varargout = BaryCentricCo_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;


% --- Executes on button press in Add_Polygon.
function Add_Polygon_Callback(hObject, eventdata, handles)
ud = get(handles.figure1,'userdata');        
ud.xqq=ud.xq(:);
ud.yqq=ud.yq(:);
hold on
ud.index=ud.index+1; 
seltype = get(gcf,'SelectionType');
       if strcmpi(seltype,'normal')
               ud.polyg{ud.index} = drawpolygon('Color','r','InteractionsAllowed','reshape','LineWidth',0.4);
       end 
ud.s{ud.index} = inROI(ud.polyg{ud.index},ud.xqq,ud.yqq );
x = find(ud.s{ud.index}==1);
ud.x_in = [ud.xqq(x),ud.yqq(x)];
phi=zeros(size(ud.polyg{ud.index}.Position,1),size(ud.x_in,1));
switch(ud.method)
    case('Wachspress')
        for i =1:length(ud.x_in)
            phi(:,i) = Wach2D(ud.polyg{ud.index}.Position,ud.x_in(i,:));
        end 
    case('MVC')
        for i =1:length(ud.x_in)
           phi(:,i) = MeanValue2D(ud.polyg{ud.index}.Position,ud.x_in(i,:));
        end 
end         
ud.WC{ud.index} = phi;
set(handles.figure1,'userdata',ud);

% --- Executes on button press in Deform.
function Deform_Callback(hObject, eventdata, handles)
ud = get(handles.figure1,'userdata'); 
ud.A = zeros(ud.index,1);
ud.deformPol = ud.polyg;
for i=1:ud.index
ud.deformPol{i}.InteractionsAllowed = 'reshape';
end
 waitforbuttonpress;
           for i = 1: ud.index
              ud.A(i,1)= ud.deformPol{i}.Selected;
           end
ud.indexFound = find(ud.A==1);
set(ud.figure,'WindowButtonMotionFcn','animator_GBC move')
set(ud.figure,'WindowButtonUpFcn','animator_GBC stop');
set(handles.figure1,'userdata',ud);


function xfine_Callback(hObject, eventdata, handles)

function xfine_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function yfine_Callback(hObject, eventdata, handles)

function yfine_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Reset.
function Reset_Callback(hObject, eventdata, handles)
cla;
handles.output = hObject;
hold on;
axis auto;
guidata(hObject, handles);
ud.figure = handles.figure1;
ud.method='MVC';
ud.index = 0;
ud.indexFound =0;
set(handles.figure1,'userdata',ud);


% --- Executes on button press in Grid.
function Grid_Callback(hObject, eventdata, handles)
ud = get(handles.figure1,'userdata');
set(handles.Grid,'value',1);
set(handles.Image,'value',0);
resol_row = str2double(get(handles.xfine,'string'));
resol_column = str2double(get(handles.yfine,'string'));
[xfine,yfine] = meshgrid(0:1:resol_row,0:1:resol_column);
hgrid = mesh(xfine,yfine);
delete(hgrid);
Z = zeros(size(xfine,1),size(yfine,1));
ud.hpatch = surf(xfine,yfine,Z,'EdgeColor', 'k','linewidth',1.5,'FaceAlpha',0);
ud.xq = xfine;
ud.yq = yfine;
set(handles.figure1,'userdata',ud);

% --- Executes on button press in Image.
function Image_Callback(hObject, eventdata, handles)
ud = get(handles.figure1,'userdata');
set(handles.Grid,'value',0);
set(handles.Image,'value',1);
resol_row = str2double(get(handles.xfine,'string'));
resol_column = str2double(get(handles.yfine,'string'));
filename=uigetfile('*.*');
Im = imresize(imread(filename),[resol_row,resol_column]);
[xfine,yfine] = meshgrid(1:1:resol_row,1:1:resol_column);
Z = zeros(size(Im,2),size(Im,1));
ud.hpatch = surf(xfine,yfine,Z,Im, 'FaceColor', 'texturemap','EdgeColor', 'none');
ud.xq = xfine;
ud.yq = yfine;
xticks([]);yticks([]);
set(handles.figure1,'userdata',ud);


% --- Executes on button press in WachspressCor.
function WachspressCor_Callback(hObject, eventdata, handles)
ud = get(handles.figure1,'userdata');
set(handles.WachspressCor,'value',1);
set(handles.Mean_ValCo,'value',0);
ud.method ='Wachspress';
set(handles.figure1,'userdata',ud);

% --- Executes on button press in Mean_ValCo.
function Mean_ValCo_Callback(hObject, eventdata, handles)
ud = get(handles.figure1,'userdata');
set(handles.WachspressCor,'value',0);
set(handles.Mean_ValCo,'value',1);
ud.method ='MVC';
set(handles.figure1,'userdata',ud);
