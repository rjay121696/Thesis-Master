function varargout = thesis1(varargin)
% THESIS1 MATLAB code for thesis1.fig
%      THESIS1, by itself, creates a new THESIS1 or raises the existing
%      singleton*.
%
%      H = THESIS1 returns the handle to a new THESIS1 or the handle to
%      the existing singleton*.
%
%      THESIS1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in THESIS1.M with the given input arguments.
%
%      THESIS1('Property','Value',...) creates a new THESIS1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before thesis1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to thesis1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help thesis1

% Last Modified by GUIDE v2.5 02-Sep-2019 22:49:15

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...o
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @thesis1_OpeningFcn, ...
                   'gui_OutputFcn',  @thesis1_OutputFcn, ...
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


% --- Executes just before thesis1 is made visible.
function thesis1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to thesis1 (see VARARGIN)

% Choose default command line output for thesis1
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes thesis1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = thesis1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
    
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%global cam;
%cam = webcam;
%frame = snapshot(cam);
%im = image(app.UIAxes, zeros(size(frame), 'uint8'));
%axis(app.UIAxes, 'image');
%preview(cam,im);
%pause;
clc
camera = webcam; 
nnet = alexnet;

while true
    picture = camera.snapshot;
    picture = imresize(picture, [227,227]);
    
    label = classify(nnet, picture);
    
    image(picture);
    
   
     if label == 'banana'
     %title(char('YES'), 'Color', 'green');
      set(handles.edit1, 'ForegroundColor', 'green', 'string', 'YES');
     set(handles.uipanel2, 'highlightcolor', 'g')
%      for mm = 1:size(picture, 1)
%         for nn = 1:size(picture, 2)
%             if picture(mm,nn,1) < 80 || picture(mm,nn,2) > 80 || picture(mm,nn,3) > 100 
%             gsc = 0.3* picture(mm,nn,1) + 0.59* picture(mm,nn,2) + 0.11 * picture(mm,nn,3);
%             
%             picture(mm,nn,:) = [gsc gsc gsc];
%             end
%         end
%      end
%     if picture(mm,nn,:) 
%         set(handles.edit4, 'ForegroundColor', 'green', 'string', 'YES');
%     else 
%         set(handles.edit4, 'ForegroundColor', 'green', 'string', 'No');
%     end

    diff_im = imsubtract(picture(:,:,2), rgb2gray(picture)); 
    gr=graythresh(diff_im); 
      diff_im = medfilt2(diff_im, [3 3]);
      diff_im = imbinarize(diff_im,0.5);
      diff_im = bwareaopen(diff_im,300);
%       bw = bwlabel(diff_im, 8);
       [L bw2] = bwlabel(diff_im, 8);
      stats = regionprops(bw, 'BoundingBox', 'Centroid');
      
        imshow(picture)
      hold on
      for object = 1:length(stats)
          bb = stats(object).BoundingBox;
          bc = stats(object).Centroid;
          rectangle('Position',bb,'EdgeColor','g','LineWidth',2)
          plot(bc(1),bc(2), '-m+')
          a=text(bc(1)+15,bc(2), strcat('X: ', num2str(round(bc(1))), '    Y: ', num2str(round(bc(2)))));
          set(a, 'FontName', 'Arial', 'FontWeight', 'bold', 'FontSize', 12, 'Color', 'yellow');
      end
      hold off
     else
         
         %title(char('NO'), 'Color', 'red');
        set(handles.edit1, 'ForegroundColor', 'red', 'string', 'NO');
        set(handles.uipanel2, 'highlightcolor', 'r')
        
     diff_im = imsubtract(picture(:,:,2), rgb2gray(picture)); 
      diff_im = medfilt2(diff_im, [3 3]);
      diff_im = imbinarize(diff_im,0.18);
      diff_im = bwareaopen(diff_im,300);
      bw = bwlabel(diff_im, 8);
      stats = regionprops(bw, 'BoundingBox', 'Centroid');
      
        imshow(picture)
      hold on
      for object = 1:length(stats)
          bb = stats(object).BoundingBox;
          bc = stats(object).Centroid;
          rectangle('Position',bb,'EdgeColor','g','LineWidth',2)
          plot(bc(1),bc(2), '-m+')
          a=text(bc(1)+15,bc(2), strcat('X: ', num2str(round(bc(1))), '    Y: ', num2str(round(bc(2)))));
          set(a, 'FontName', 'Arial', 'FontWeight', 'bold', 'FontSize', 12, 'Color', 'yellow');
      end
      hold off
       drawnow;

    end
end
    
% start(camera)
% while(camera.FramesAcquired<=200)
%      data = getsnapshot(camera);
%      [bw, rgb] = bground_remove(data);
%      [bw, rgb] = bground_remove_g(data);
%      [bw, rgb] = bground_remove_g2(data);
%      [bw, rgb] = bground_remove_p(data);
%      [bw, rgb] = bground_remove_r(data);
%      axis(handles.axes4);
% end



% --- Executes during object creation, after setting all properties.
function pushbutton1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% --- Executes during object creation, after setting all properties.


function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1

% --- Executes on key press with focus on pushbutton1 and none of its controls.
function pushbutton1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

clear all; close all; clc;


function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
