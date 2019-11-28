%=====================================================
%
%=====================================================

function [MASKTOP,err] = CreateMaskFromImage_v1a_Func(MASKTOP,INPUT)

Status2('busy','Create Mask From Image',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%--------------------------------------------- 
IMG = INPUT.IMG{1};
Im = IMG.Im;
MASK = MASKTOP.MASK;
clear INPUT;

%---------------------------------------------
% Create Mask
%--------------------------------------------- 
func = str2func([MASKTOP.maskfunc,'_Func']);  
INPUT.Im = Im;                  
[MASK,err] = func(MASK,INPUT);
if err.flag
    return
end
IMG.Im = MASK.Mask;

%---------------------------------------------
% Add to Panel Output
%---------------------------------------------
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'',MASKTOP.method,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
if isfield(IMG,'PanelOutput')
    IMG.PanelOutput = [IMG.PanelOutput;PanelOutput;MASK.PanelOutput];
else
    IMG.PanelOutput = [PanelOutput;MASK.PanelOutput];
end
IMG.ExpDisp = PanelStruct2Text(IMG.PanelOutput);
IMG.IMDISP.ImInfo.info = IMG.ExpDisp;

%---------------------------------------------
% Return
%---------------------------------------------
if strfind(IMG.name,'.')
    IMG.name = IMG.name(1:end-4);
end
IMG.name = ['CMASK_',IMG.name];
MASKTOP.IMG = IMG;

Status2('done','',2);
Status2('done','',3);



