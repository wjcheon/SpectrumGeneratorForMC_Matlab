clc
clear
close all

%% OUTPUT FILE
disp('Start!!')
foutid = fopen('source_140kVp.mac','w');
VerboseLevel = 0;
SourceActivity = 35000;   % becquerel
ActivityUnit = 'becquerel';
ParticleName = 'gamma';
EnergyType = 'Arb';
histoname = 'arb';
ParimayParticleMinE = 0.0 ;
ParimayParticleMaxE = 140.00 ;     % need to change as a proper parameter
EnergyUnit = 'keV';
arbint = 'Lin';
type = 'Volume';
shape = 'Sphere';
radius = .25 ;

minTheta = 0.;
maxTheta = 12.4;
minPhi = 0.;
maxPhi = 360.;
ThetaUnit = 'deg';
centere = [0 0 424.3];
DistanceUnit = 'mm';
angtype = 'iso';

%%
fprintf(foutid,'/gate/source/addSource xraygun\n');
fprintf(foutid,'/gate/source/xraygun/gps/type %s\n',type);
fprintf(foutid,'/gate/source/xraygun/gps/shape %s\n',shape);
fprintf(foutid,'/gate/source/xraygun/gps/radius %.2f %s\n',radius,DistanceUnit);
fprintf(foutid,'/gate/source/verbose %d\n',VerboseLevel);
fprintf(foutid,'/gate/source/xraygun/setActivity %d. %s\n',SourceActivity,ActivityUnit);
fprintf(foutid,'/gate/source/xraygun/gps/verbose %d\n',VerboseLevel);
fprintf(foutid,'/gate/source/xraygun/gps/particle %s\n',ParticleName);
fprintf(foutid,'/gate/source/xraygun/gps/energytype %s\n',EnergyType);
fprintf(foutid,'/gate/source/xraygun/gps/histname %s\n',histoname);
fprintf(foutid,'/gate/source/xraygun/gps/emin %.2f %s\n',ParimayParticleMinE,EnergyUnit);
fprintf(foutid,'/gate/source/xraygun/gps/emax %.2f %s\n',ParimayParticleMaxE,EnergyUnit);


%%
[filename, filepath] = uigetfile('*.txt','Open the SpecCalc Spectrum');
fid = fopen(filename,'r');
fseek(fid,500,'bof');

while ~feof(fid)
    tline = fgets(fid);
    str_location= strfind(tline,'meter');
    if (isempty(str_location)==0)  
%        fseek(fid,ftell(fid)-1,'bof')
       continue
    end
    [KineticEnergy, HeightOfBin] = strtok(tline);
     
    KE = str2double(KineticEnergy);
    HeightBin = str2double(HeightOfBin);
    fprintf(foutid,'/gate/source/xraygun/gps/histpoint %.3f %3.f\n',(KE*0.001), HeightBin);
end
fclose(fid);

%%
fprintf(foutid,'/gate/source/xraygun/gps/arbint %s\n',arbint);
fprintf(foutid,'/gate/source/xraygun/gps/mintheta %.2f %s\n',minTheta,ThetaUnit);
fprintf(foutid,'/gate/source/xraygun/gps/maxtheta %.2f %s\n',maxTheta,ThetaUnit);
fprintf(foutid,'/gate/source/xraygun/gps/minphi %.2f %s\n',minPhi,ThetaUnit);
fprintf(foutid,'/gate/source/xraygun/gps/maxphi %.2f %s\n',maxPhi,ThetaUnit);
fprintf(foutid,'/gate/source/xraygun/gps/angtype %s\n',angtype);
fprintf(foutid,'/gate/source/xraygun/gps/centre  %.2f %.2f %.2f %s\n',centere(1),centere(2),centere(3),DistanceUnit);
fprintf(foutid,'/gate/source/list\n');

fclose(foutid);
clear
disp('Done!!')




