function [User] = CompassUserInfo(softwarefolder,Setup)


User.defloc = 'D:\CompassRelated\2 Defaults\';
User.defrootloc = 'D:\CompassRelated\2 Defaults\';
User.lastdefloc = 'D:\CompassScripts\VOYAGER\MriImageGeneral\Scripts\';
User.siemensdefaultloc = 'D:\CompassRelated\2 Defaults\Protocols\PRISMA';

User.trajreconloc = 'D:\CompassRelated\3 ReconFiles';  
User.invfiltloc = 'D:\CompassRelated\4 OtherFiles\Gridding\Inverse Filters\';
User.imkernloc = 'D:\CompassRelated\4 OtherFiles\Gridding\Kernels\';
User.sysresploc = 'D:\CompassRelated\4 OtherFiles\Scanner\GradSysResp';
User.varianshimcalfile = 'D:\CompassRelated\4 OtherFiles\Scanner\Shimming\NaHBC_ShimCal_Jan2015';

User.tempdataloc = 'E:\';
User.lastscriptloc = 'G:\23NaPaper\1-23Male\220930 (23NaSkin_ZZ_BothCoils)\s_20220930_001\data\NaDW_0444_60_01.fid\';
User.experimentsloc = 'R:\BeaulieuLab\Jing\Scans\paper_volunteers\11-46Male\221128(23NaSkin_RS)\s_20221128_001\data\NaDW_0444_60_01.fid\';
User.trajdevloc = 'Y:\2 Trajectories\0 TempHolding\MSYB\ConesComp'; 
User.varianloc = 'V:\sodium\';
User.variandataloc = 'V:\sodium\vnmrsys\data\studies';
User.varianshimfile = 'V:\sodium\vnmrsys\shims\shimRWS';

User.setup = Setup;
User.doCuda = 0;
if strcmp(Setup,'Full') || strcmp(Setup,'Dev') || strcmp(Setup,'Scripts')
    User.doCuda = 1;
end

User.epssave = 'Yes';
User.userinfofile = [softwarefolder,'\Setup\CompassUserInfo.m']; 