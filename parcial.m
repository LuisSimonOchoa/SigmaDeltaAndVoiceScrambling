function varargout = parcial(varargin)

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @parcial_OpeningFcn, ...
                   'gui_OutputFcn',  @parcial_OutputFcn, ...
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


% --- Executes just before parcial is made visible.
function parcial_OpeningFcn(hObject, eventdata, handles, varargin)
global ID_MICRO ID_PARLA
info=audiodevinfo;
MICRO={'Seleccionar Entrada'};
PARLA={'Seleccionar Salida'};
ID_MICRO = "0";
ID_PARLA = "0";
for i=1:length(info.input)
    MICRO = [MICRO; info.input(i).Name];
    ID_MICRO = [ID_MICRO, info.input(i).ID];
end
for i=1:length(info.output)
    PARLA = [PARLA; info.output(i).Name];
    ID_PARLA = [ID_PARLA, info.output(i).ID];
end
set(handles.popupmenu1,'String',MICRO)
set(handles.popupmenu2,'String',PARLA)
set(findall(handles.uipanel4, '-property', 'enable'), 'enable', 'off')





handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes parcial wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = parcial_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)


function popupmenu1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbuttonGrabar.
function pushbuttonGrabar_Callback(hObject, eventdata, handles)
global ID_MICRO AUDIO_IN Fs
h = get(handles.entradaB16,'Value');
hh = get(handles.entradaB8,'Value');
T = str2double(get(handles.duracionEntrada,'String'));
Fs = str2double(get(handles.frecuenciaEntrada,'String'));


dispoEntrada = get(handles.popupmenu1,"value");
dispoSalida = get(handles.popupmenu2,"value");


nB = 0;
if h == 1
    nB = 16;
end
if hh == 1
    nB = 8;
end

if dispoEntrada ~= 1
    if dispoSalida ~= 1
        if Fs>0
            if T>0
                A = "Audio_" + datestr(now,'yyyy-mm-dd_hh-MM-ss.wav');
                M = str2double(ID_MICRO(dispoEntrada))
                G = audiorecorder(Fs,nB,1,M);
                record(G,T);
                pause(T+1);
                AUDIO_IN = getaudiodata(G,'double');
                audiowrite(char(A),AUDIO_IN,Fs);
                
                %PLOTEO
                T=1/Fs;
                TT = (length(AUDIO_IN)/Fs)-T;
                t=0:T:TT;
                axes(handles.senalEntrada);
                plot(t,AUDIO_IN)
                A = abs(AUDIO_IN);
                B = max(A);
                grid minor;xlabel('Tiempo (seg)');ylabel('Amplitud');title('Señal de entrada');
                axis([0 TT -B B])
                msgbox('Grabacion exitosa', 'Information','help');
                
                set(handles.pushbuttonReproducir,'Enable','on');         
                set(findall(handles.uipanel4, '-property', 'enable'), 'enable', 'on')
                set(handles.senalSNR,'visible','off')
                set(handles.senalSalida,'visible','off')
                set(handles.uipanel5,'Position',[65.8 1.231 112.6 43])
            else
                errordlg('El valor en Tiempo no es correcto','Error','modal');
            end
        else
            errordlg('El valor en Frecuencia no es correcto','Error','modal');
        end  
    else
        errordlg('Se debe seleccionar un Parlante','Error','modal');
    end
else
    errordlg('Se debe seleccionar un Microfono','Error','modal');
end

guidata(hObject,handles);



function frecuenciaEntrada_Callback(hObject, eventdata, handles)



% --- Executes during object creation, after setting all properties.
function frecuenciaEntrada_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function duracionEntrada_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function duracionEntrada_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in entradaB16.
function entradaB16_Callback(hObject, eventdata, handles)


% --- Executes on button press in entradaB8.
function entradaB8_Callback(hObject, eventdata, handles)


% --- Executes on button press in pushbuttonReproducir.
function pushbuttonReproducir_Callback(hObject, eventdata, handles)
global AUDIO_IN ID_PARLA
h = get(handles.entradaB16,'Value');
hh = get(handles.entradaB8,'Value');
Fs = str2double(get(handles.frecuenciaEntrada,'String'));
nB = 0;
dispoSalida = get(handles.popupmenu2,"value");
if h == 1
    nB = 16;
end
if hh == 1
    nB = 8;
end
if ~isempty(AUDIO_IN)


    r=str2double(ID_PARLA(dispoSalida));
    player = audioplayer(AUDIO_IN,Fs,nB,r);
    playblocking(player);
else
    errordlg('No hay nada para reproducir','Error','modal')
end

% hObject    handle to pushbuttonReproducir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function D1_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function D1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function D2_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function D2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function D3_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function D3_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function D4_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function D4_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Rp_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function Rp_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Orden1_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function Orden1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Orden2_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function Orden2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function AA_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function AA_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function K1_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function K1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbuttonProcesar.
function pushbuttonProcesar_Callback(hObject, eventdata, handles)
global  AUDIO_IN AUDIO_OUT Fs Z1 Z2 Z3 Z4 Z5 D




x = AUDIO_IN;
%Datos Entrada
D1=str2double(get(handles.D1,'String'));
D2=str2double(get(handles.D2,'String'));
D3=str2double(get(handles.D3,'String'));
D4=str2double(get(handles.D4,'String'));
Rp=str2double(get(handles.Rp,'String'));
Orden1=str2double(get(handles.Orden1,'String'));
Orden2=str2double(get(handles.Orden2,'String'));
AA=str2double(get(handles.AA,'String'));
K1=str2double(get(handles.K1,'String'));

%L=D=M

D=[D1, D2, D3, D4];
Z1=[];
Z2=[];
Z3=[];
Z4=[];
Z5=[];
Zsnr=[];

if D1>0
    if D2>0
        if D3>0
            if D4>0
                if Rp>0
                    if Orden1>0
                        if Orden2>0
                            if AA>0   
                                if K1>0   
                                    set(handles.pushbuttonGrabar,'Enable','off');
                                    set(handles.pushbuttonReproducir,'Enable','off');
                                    set(findall(handles.uipanel4, '-property', 'enable'), 'enable', 'off')
                                    
                                for i=1:4
                                    
                                L1=D(i);
                                M1=D(i)
                                %SUPERMUESTREADOR
                                z1=[x' ; zeros(L1-1,length(x))];
                                z1=reshape(z1, L1*length(x),1);
                                Z1{i}=z1; %Salida de supermuestreador
                                length(z1)
                                %FILTRO PASABAJAS (ORDEN 1)
                                G1 = L1;
                                Fc = pi/G1;
                                h1 = G1 * fir1(Orden1, Fc/pi);
                                z2 =conv(z1,h1);
                                z2 =z2((Orden1/2)+1:end -(Orden1/2));
                                Z2{i}=z2; %Salida de Filtro1

                               %Modulador sigma delta de primer orden + cuantizador simétrico de 2 niveles
                                N=length(x)
                                P=L1*N   
                                ini1=0.35;  
                                y1(1,1)=ini1;
                                y2(1,1)=K1*AA;

                                for j=1:P
                                    v(j,1)=z2(j,1)-y2(j,1);   % restador
                                    v1(j,1)=v(j,1)+y1(j,1); % sumador
                                    s(j,1)=AA*sign(y1(j,1));  % cuantización simétrica de 2 niveles (SALIDA)
                                    y1(j+1,1)=v1(j,1);
                                    y2(j+1,1)=K1*s(j,1);
                                end 
                                Z3{i}=s; %Salida de SigmaDelta   
                                
                                %FILTRO PASABAJAS (ORDEN 2)
                                G=1;
                                Fc2=pi/G1;
                                h2=G*fir1(Orden2, Fc2/pi);     
                                z3=conv(s,h2);
                                z3=z3((Orden2/2)+1:end-(Orden2/2));  
                                Z4{i}=z3; %Salida de SigmaDelta  
                                
                                %SUBMUESTREADOR
                                z4=z3(1:M1:end);  
                                Z5{i}=z4; %Salida de SUBMUESTREADOR 
                                
                                %RECUANTIZACION POR FACTOR DE ESCALA FIJO                               
                                fe=1;  
                                rk=(2^(Rp-1))-1;
                                z5=fe*round(z4*rk/fe)/rk;  %salida
                                AUDIO_OUT{i}=z5; %Salida de RECUANTIZACION 
                                
                                %SNR
                                e=z5-x;   %vector de error de cuantización
                                Ex=x' * x;      %Energía de la señal original o también Ex=sum(x.*x);
                                Ee=(e'*e)+1E-20;  %Energía del vector de error de cuantización
                                SNR=10*log10(Ex/Ee);   % Cálculo de la SNR en dBs.
                                Zsnr{i}=SNR;

                                end
                                set(handles.edit13,'String',Zsnr{1})
                                set(handles.edit14,'String',Zsnr{2})
                                set(handles.edit15,'String',Zsnr{3})
                                set(handles.edit16,'String',Zsnr{4})
                                %PLOT DE SALIDA *10
                                T=1/Fs;
                                TT = (length(AUDIO_OUT{1})/Fs)-T;
                                t=0:T:TT;
                                axes(handles.senalSalida);
                                A = max(abs(x));
                                plot(t,x,'b'); 
                                hold on 
                                plot(t,AUDIO_OUT{1},'--r'); 
                                plot(t,AUDIO_OUT{2},'.m');
                                plot(t,AUDIO_OUT{3},':K');
                                plot(t,AUDIO_OUT{4},'-.g');
                                
                                
                                hold off
                                grid minor;xlabel('Tiempo (seg)');ylabel('Amplitud');title('Señal de Salida');
                                axis([0 TT -A A])
                                legend('S.In','S.Out D1','S. Out D2','S. Out D3','S. Out D4')
                                
                                set(findall(handles.uipanel4, '-property', 'enable'), 'enable', 'on')
                                set(handles.pushbuttonReproducir,'enable','on')
                                set(handles.pushbuttonGrabar,'enable','on')
                                set(handles.pushbutton4,'enable','on')
                                set(handles.pushbutton5,'enable','on')
                                set(handles.pushbutton6,'enable','on')
                                set(handles.pushbutton7,'enable','on')
                                set(handles.pushbutton8,'enable','on')
                                set(handles.pushbutton9,'enable','on')
                                set(handles.pushbutton10,'enable','on')
                                set(handles.pushbutton11,'enable','on')
                                
                                %PLOT SNR:
                                SNRPlot=[Zsnr{1};Zsnr{2};Zsnr{3};Zsnr{4}];
                                axes(handles.senalSNR);
                                plot(SNRPlot,D,'-b*'); 
                                xmin=min(SNRPlot)-2;
                                xmax=max(SNRPlot)+2;
                                ymin=min(D)-10;
                                ymax=max(D)+10;
                                grid minor;xlabel('SNR');ylabel('D');title('Grafica de salida SNR vs D');
                                axis([xmin xmax ymin ymax])
                                msgbox('Procesamiento Terminado', 'Information','help');
                                set(handles.senalSNR,'visible','on')
                                set(handles.senalSalida,'visible','on')
                                set(handles.uipanel5,'visible','off')
                                
                                else
                                 errordlg('Ingrese un valor valido para k1','modal')
                                end
                            else
                                 errordlg('Ingrese un valor valido para A','Error','modal')
                            end
                        else
                             errordlg('Ingrese un valor valido para Orden2','Error','modal')
                        end
                    else
                         errordlg('Ingrese un valor valido para Orden1','Error','modal');
                    end
                else
                    errordlg('Ingrese un valor valido para Rp','Error','modal');
                end
            else
                errordlg('Ingrese un valor valido para D4','Error','modal');
            end    
        else
            errordlg('Ingrese un valor valido para D3','Error','modal');
        end
    else
        errordlg('Ingrese un valor valido para D2','Error','modal');
    end
else
    errordlg('Ingrese un valor valido para D1','Error','modal');
end
guidata(hObject,handles);




function edit13_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function edit13_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit14_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit14_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit15_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function edit15_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit16_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function edit16_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global AUDIO_OUT ID_PARLA Fs
h = get(handles.entradaB16,'Value');
hh = get(handles.entradaB8,'Value');
nB = 0;
dispoSalida = get(handles.popupmenu2,"value");
if h == 1
    nB = 16;
end
if hh == 1
    nB = 8;
end
if dispoSalida ~= 1
    if ~isempty(AUDIO_OUT{1})


        r=str2double(ID_PARLA(dispoSalida));
        player = audioplayer(AUDIO_OUT{1},Fs,nB,r);
        playblocking(player);
    else
        errordlg('No hay nada para reproducir','Error','modal')
    end
 else
        errordlg('Se debe seleccionar un Parlante','Error','modal');

end



% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global AUDIO_OUT ID_PARLA Fs
h = get(handles.entradaB16,'Value');
hh = get(handles.entradaB8,'Value');
nB = 0;
dispoSalida = get(handles.popupmenu2,"value");
if h == 1
    nB = 16;
end
if hh == 1
    nB = 8;
end
if dispoSalida ~= 1
    if ~isempty(AUDIO_OUT{2})


        r=str2double(ID_PARLA(dispoSalida));
        player = audioplayer(AUDIO_OUT{2},Fs,nB,r);
        playblocking(player);
    else
        errordlg('No hay nada para reproducir','Error','modal')
    end
 else
        errordlg('Se debe seleccionar un Parlante','Error','modal');

end


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global AUDIO_OUT ID_PARLA Fs
h = get(handles.entradaB16,'Value');
hh = get(handles.entradaB8,'Value');
nB = 0;
dispoSalida = get(handles.popupmenu2,"value");
if h == 1
    nB = 16;
end
if hh == 1
    nB = 8;
end
if dispoSalida ~= 1
    if ~isempty(AUDIO_OUT{3})


        r=str2double(ID_PARLA(dispoSalida));
        player = audioplayer(AUDIO_OUT{3},Fs,nB,r);
        playblocking(player);
    else
        errordlg('No hay nada para reproducir','Error','modal')
    end
 else
        errordlg('Se debe seleccionar un Parlante','Error','modal');

end


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global AUDIO_OUT ID_PARLA Fs
h = get(handles.entradaB16,'Value');
hh = get(handles.entradaB8,'Value');
nB = 0;
dispoSalida = get(handles.popupmenu2,"value");
if h == 1
    nB = 16;
end
if hh == 1
    nB = 8;
end
if dispoSalida ~= 1
    if ~isempty(AUDIO_OUT{4})


        r=str2double(ID_PARLA(dispoSalida));
        player = audioplayer(AUDIO_OUT{4},Fs,nB,r);
        playblocking(player);
    else
        errordlg('No hay nada para reproducir','Error','modal')
    end
 else
        errordlg('Se debe seleccionar un Parlante','Error','modal');

end


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global AUDIO_IN Z1 Z2 Z3 Z4 Z5 D Fs
%CONVERSION A FRECUENCIA
[X1,F1] = freqz(AUDIO_IN,2*pi,Fs,'whole'); %Señal entrada
[X2,F2] = freqz(Z1{1},2*pi,Fs,'whole'); %Z1
[X3,F3] = freqz(Z2{1},2*pi,Fs,'whole'); %Z2
[X4,F4] = freqz(Z3{1},2*pi,Fs,'whole'); %Z3
[X5,F5] = freqz(Z4{1},2*pi,Fs,'whole'); %z4
[X6,F6] = freqz(Z5{1},2*pi,Fs,'whole'); %z5
[X7,F7] = freqz(AUDIO_IN,2*pi,Fs,'whole'); %Señal Salida
figure('Name','Procesamiento con D1='+string(D(1)),'NumberTitle','off')
subplot(7,1,1);
plot(F1,X1)
axis([0 2*pi 0 inf])
grid minor;xlabel('Frec (rad)');ylabel('Amplitud');title('Señal original');xticks([0 pi 2*pi]);xticklabels({'0','\pi','2\pi'})
subplot(7,1,2);
plot(F2,X2)
axis([0 2*pi 0 inf])
grid minor;xlabel('Frec (rad)');ylabel('Amplitud');title('Salida del Supermuestreador');xticks([0 pi 2*pi]);xticklabels({'0','\pi','2\pi'})
subplot(7,1,3);
plot(F3,X3)
axis([0 2*pi 0 inf])
grid minor;xlabel('Frec (rad)');ylabel('Amplitud');title('Salida del Filtro del Supermuestreador');xticks([0 pi 2*pi]);xticklabels({'0','\pi','2\pi'})
subplot(7,1,4);
plot(F4,X4)
axis([0 2*pi 0 inf])
grid minor;xlabel('Frec (rad)');ylabel('Amplitud');title('Salida del Modulador Sigma-Delta');xticks([0 pi 2*pi]);xticklabels({'0','\pi','2\pi'})
subplot(7,1,5);
plot(F5,X5)
axis([0 2*pi 0 inf])
grid minor;xlabel('Frec (rad)');ylabel('Amplitud');title('Salida del Filtro Decimador');xticks([0 pi 2*pi]);xticklabels({'0','\pi','2\pi'})
subplot(7,1,6);
plot(F6,X6)
axis([0 2*pi 0 inf])
grid minor;xlabel('Frec (rad)');ylabel('Amplitud');title('Salida del Submuestreador');xticks([0 pi 2*pi]);xticklabels({'0','\pi','2\pi'})
subplot(7,1,7);
plot(F7,X7)
axis([0 2*pi 0 inf])
grid minor;xlabel('Frec (rad)');ylabel('Amplitud');title('Salida final del A/D');xticks([0 pi 2*pi]);xticklabels({'0','\pi','2\pi'})



% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global AUDIO_IN Z1 Z2 Z3 Z4 Z5 D Fs
%CONVERSION A FRECUENCIA
[X1,F1] = freqz(AUDIO_IN,2*pi,Fs,'whole'); %Señal entrada
[X2,F2] = freqz(Z1{2},2*pi,Fs,'whole'); %Z1
[X3,F3] = freqz(Z2{2},2*pi,Fs,'whole'); %Z2
[X4,F4] = freqz(Z3{2},2*pi,Fs,'whole'); %Z3
[X5,F5] = freqz(Z4{2},2*pi,Fs,'whole'); %z4
[X6,F6] = freqz(Z5{2},2*pi,Fs,'whole'); %z5
[X7,F7] = freqz(AUDIO_IN,2*pi,Fs,'whole'); %Señal Salida
figure('Name','Procesamiento con D2='+string(D(2)),'NumberTitle','off')
subplot(7,1,1);
plot(F1,X1)
axis([0 2*pi 0 inf])
grid minor;xlabel('Frec (rad)');ylabel('Amplitud');title('Señal original');xticks([0 pi 2*pi]);xticklabels({'0','\pi','2\pi'})
subplot(7,1,2);
plot(F2,X2)
axis([0 2*pi 0 inf])
grid minor;xlabel('Frec (rad)');ylabel('Amplitud');title('Salida del Supermuestreador');xticks([0 pi 2*pi]);xticklabels({'0','\pi','2\pi'})
subplot(7,1,3);
plot(F3,X3)
axis([0 2*pi 0 inf])
grid minor;xlabel('Frec (rad)');ylabel('Amplitud');title('Salida del Filtro del Supermuestreador');xticks([0 pi 2*pi]);xticklabels({'0','\pi','2\pi'})
subplot(7,1,4);
plot(F4,X4)
axis([0 2*pi 0 inf])
grid minor;xlabel('Frec (rad)');ylabel('Amplitud');title('Salida del Modulador Sigma-Delta');xticks([0 pi 2*pi]);xticklabels({'0','\pi','2\pi'})
subplot(7,1,5);
plot(F5,X5)
axis([0 2*pi 0 inf])
grid minor;xlabel('Frec (rad)');ylabel('Amplitud');title('Salida del Filtro Decimador');xticks([0 pi 2*pi]);xticklabels({'0','\pi','2\pi'})
subplot(7,1,6);
plot(F6,X6)
axis([0 2*pi 0 inf])
grid minor;xlabel('Frec (rad)');ylabel('Amplitud');title('Salida del Submuestreador');xticks([0 pi 2*pi]);xticklabels({'0','\pi','2\pi'})
subplot(7,1,7);
plot(F7,X7)
axis([0 2*pi 0 inf])
grid minor;xlabel('Frec (rad)');ylabel('Amplitud');title('Salida final del A/D');xticks([0 pi 2*pi]);xticklabels({'0','\pi','2\pi'})


% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global AUDIO_IN Z1 Z2 Z3 Z4 Z5 D Fs
%CONVERSION A FRECUENCIA
[X1,F1] = freqz(AUDIO_IN,2*pi,Fs,'whole'); %Señal entrada
[X2,F2] = freqz(Z1{3},2*pi,Fs,'whole'); %Z1
[X3,F3] = freqz(Z2{3},2*pi,Fs,'whole'); %Z2
[X4,F4] = freqz(Z3{3},2*pi,Fs,'whole'); %Z3
[X5,F5] = freqz(Z4{3},2*pi,Fs,'whole'); %z4
[X6,F6] = freqz(Z5{3},2*pi,Fs,'whole'); %z5
[X7,F7] = freqz(AUDIO_IN,2*pi,Fs,'whole'); %Señal Salida
figure('Name','Procesamiento con D3='+string(D(3)),'NumberTitle','off')
subplot(7,1,1);
plot(F1,X1)
axis([0 2*pi 0 inf])
grid minor;xlabel('Frec (rad)');ylabel('Amplitud');title('Señal original');xticks([0 pi 2*pi]);xticklabels({'0','\pi','2\pi'})
subplot(7,1,2);
plot(F2,X2)
axis([0 2*pi 0 inf])
grid minor;xlabel('Frec (rad)');ylabel('Amplitud');title('Salida del Supermuestreador');xticks([0 pi 2*pi]);xticklabels({'0','\pi','2\pi'})
subplot(7,1,3);
plot(F3,X3)
axis([0 2*pi 0 inf])
grid minor;xlabel('Frec (rad)');ylabel('Amplitud');title('Salida del Filtro del Supermuestreador');xticks([0 pi 2*pi]);xticklabels({'0','\pi','2\pi'})
subplot(7,1,4);
plot(F4,X4)
axis([0 2*pi 0 inf])
grid minor;xlabel('Frec (rad)');ylabel('Amplitud');title('Salida del Modulador Sigma-Delta');xticks([0 pi 2*pi]);xticklabels({'0','\pi','2\pi'})
subplot(7,1,5);
plot(F5,X5)
axis([0 2*pi 0 inf])
grid minor;xlabel('Frec (rad)');ylabel('Amplitud');title('Salida del Filtro Decimador');xticks([0 pi 2*pi]);xticklabels({'0','\pi','2\pi'})
subplot(7,1,6);
plot(F6,X6)
axis([0 2*pi 0 inf])
grid minor;xlabel('Frec (rad)');ylabel('Amplitud');title('Salida del Submuestreador');xticks([0 pi 2*pi]);xticklabels({'0','\pi','2\pi'})
subplot(7,1,7);
plot(F7,X7)
axis([0 2*pi 0 inf])
grid minor;xlabel('Frec (rad)');ylabel('Amplitud');title('Salida final del A/D');xticks([0 pi 2*pi]);xticklabels({'0','\pi','2\pi'})


% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
global AUDIO_IN Z1 Z2 Z3 Z4 Z5 D Fs
%CONVERSION A FRECUENCIA
[X1,F1] = freqz(AUDIO_IN,2*pi,Fs,'whole'); %Señal entrada
[X2,F2] = freqz(Z1{4},2*pi,Fs,'whole'); %Z1
[X3,F3] = freqz(Z2{4},2*pi,Fs,'whole'); %Z2
[X4,F4] = freqz(Z3{4},2*pi,Fs,'whole'); %Z3
[X5,F5] = freqz(Z4{4},2*pi,Fs,'whole'); %z4
[X6,F6] = freqz(Z5{4},2*pi,Fs,'whole'); %z5
[X7,F7] = freqz(AUDIO_IN,2*pi,Fs,'whole'); %Señal Salida
figure('Name','Procesamiento con D4='+string(D(4)),'NumberTitle','off')
subplot(7,1,1);
plot(F1,X1)
axis([0 2*pi 0 inf])
grid minor;xlabel('Frec (rad)');ylabel('Amplitud');title('Señal original');xticks([0 pi 2*pi]);xticklabels({'0','\pi','2\pi'})
subplot(7,1,2);
plot(F2,X2)
axis([0 2*pi 0 inf])
grid minor;xlabel('Frec (rad)');ylabel('Amplitud');title('Salida del Supermuestreador');xticks([0 pi 2*pi]);xticklabels({'0','\pi','2\pi'})
subplot(7,1,3);
plot(F3,X3)
axis([0 2*pi 0 inf])
grid minor;xlabel('Frec (rad)');ylabel('Amplitud');title('Salida del Filtro del Supermuestreador');xticks([0 pi 2*pi]);xticklabels({'0','\pi','2\pi'})
subplot(7,1,4);
plot(F4,X4)
axis([0 2*pi 0 inf])
grid minor;xlabel('Frec (rad)');ylabel('Amplitud');title('Salida del Modulador Sigma-Delta');xticks([0 pi 2*pi]);xticklabels({'0','\pi','2\pi'})
subplot(7,1,5);
plot(F5,X5)
axis([0 2*pi 0 inf])
grid minor;xlabel('Frec (rad)');ylabel('Amplitud');title('Salida del Filtro Decimador');xticks([0 pi 2*pi]);xticklabels({'0','\pi','2\pi'})
subplot(7,1,6);
plot(F6,X6)
axis([0 2*pi 0 inf])
grid minor;xlabel('Frec (rad)');ylabel('Amplitud');title('Salida del Submuestreador');xticks([0 pi 2*pi]);xticklabels({'0','\pi','2\pi'})
subplot(7,1,7);
plot(F7,X7)
axis([0 2*pi 0 inf])
grid minor;xlabel('Frec (rad)');ylabel('Amplitud');title('Salida final del A/D');xticks([0 pi 2*pi]);xticklabels({'0','\pi','2\pi'})
