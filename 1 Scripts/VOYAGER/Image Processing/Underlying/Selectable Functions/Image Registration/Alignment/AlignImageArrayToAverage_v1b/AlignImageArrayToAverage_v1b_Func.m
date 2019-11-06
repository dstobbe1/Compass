%=========================================================
% 
%=========================================================

function [ALGN,err] = AlignImageArrayToAverage_v1b_Func(ALGN,INPUT)

Status2('busy','Align Image Array To Average',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
IMG = INPUT.IMG{1};
clear INPUT;

%---------------------------------------------
% Get Info
%---------------------------------------------
Im = IMG.Im;
sz = size(Im);
ImArrayLen = sz(4);

%---------------------------------------------
% Alignment Properties
%---------------------------------------------
pixdim = IMG.IMDISP.ImInfo.pixdim;
StatIm = abs(Im(:,:,:,1,1,1));                       
SpaceRef0 = imref3d(size(StatIm),pixdim(1),pixdim(2),pixdim(3));
[optimizer,metric] = imregconfig('monomodal');
%[optimizer,metric] = imregconfig('multimodal');
% optimizer.MaximumStepLength = 0.01; 
% optimizer.MinimumStepLength = 1e-2;                                     % accuracy/time (changing others = detrimental @ first test)
optimizer.GradientMagnitudeTolerance = 1e-5;

%---------------------------------------------
% First Pass Alignment
%---------------------------------------------                 
AveIm = StatIm;
for m = 1:ImArrayLen
    if m == ALGN.pass1alignim
        continue
    end
    Status2('busy',['First pass: align image ',num2str(m),' to ',num2str(ALGN.pass1alignim)],3);
    JiggleIm = abs(Im(:,:,:,m,1,1));
    SpaceRef = imref3d(size(JiggleIm),pixdim(1),pixdim(2),pixdim(3));
    tform = imregtform(JiggleIm,SpaceRef,StatIm,SpaceRef0,'rigid',optimizer,metric,'DisplayOptimization',1);    
    test = tform.T
    if strcmp(ALGN.average,'Abs')
        AveIm = imwarp(abs(Im(:,:,:,m,1,1)),SpaceRef,tform,'OutputView',SpaceRef0) + AveIm;
    elseif strcmp(ALGN.average,'Complex')
        rRegIm = imwarp(real(Im(:,:,:,m,1,1)),SpaceRef,tform,'OutputView',SpaceRef0);
        iRegIm = imwarp(imag(Im(:,:,:,m,1,1)),SpaceRef,tform,'OutputView',SpaceRef0);
        AveIm = rRegIm + 1i*iRegIm + AveIm;
    end
end
AveIm = AveIm/ImArrayLen;

%---------------------------------------------
% Alignment to Average
%---------------------------------------------
StatIm = abs(AveIm);
%RegIm = zeros([size(StatIm) ImArrayLen+1]);
RegIm = zeros([size(StatIm) ImArrayLen]);
for m = 1:ImArrayLen
    Status2('busy',['Second pass: align image ',num2str(m),' to average'],3);
    JiggleIm = abs(Im(:,:,:,m,1,1));
    SpaceRef = imref3d(size(JiggleIm),pixdim(1),pixdim(2),pixdim(3));
    tform = imregtform(JiggleIm,SpaceRef,StatIm,SpaceRef0,'rigid',optimizer,metric,'DisplayOptimization',1);    
    test = tform.T
    rRegIm = imwarp(real(Im(:,:,:,m,1,1)),SpaceRef,tform,'OutputView',SpaceRef0);
    iRegIm = imwarp(imag(Im(:,:,:,m,1,1)),SpaceRef,tform,'OutputView',SpaceRef0);
    RegIm(:,:,:,m) = rRegIm + 1i*iRegIm;
end
%-
%RegIm(:,:,:,ImArrayLen+1) = AveIm;
%-

%---------------------------------------------
% Output
%---------------------------------------------   
IMG.Im = RegIm;

%---------------------------------------------
% Add to Panel Output
%---------------------------------------------
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'',ALGN.method,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
if isfield(IMG,'PanelOutput')
    IMG.PanelOutput = [IMG.PanelOutput;PanelOutput];
else
    IMG.PanelOutput = PanelOutput;
end
IMG.ExpDisp = PanelStruct2Text(IMG.PanelOutput);

%---------------------------------------------
% Return
%---------------------------------------------
ALGN.IMG = IMG;

Status2('done','',2);
Status2('done','',3);

