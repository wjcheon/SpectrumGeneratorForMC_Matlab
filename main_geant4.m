clc
clear
close all

%% OUTPUT FILE
foutid = fopen('test_geant4.mac','w');
TrackingVerboseLevel = 2;
RunVerboseLevel = 2;
ParticleName = 'gamma';
BeamCenter = [0 0 100];
DistanceUnit = 'cm';
BeamHalfX = 5 ;
BeamHalfY = 5 ;
ParimayParticleMinE = 0 ;
ParimayParticleMaxE = 70 ;                         % need to change for use
EnergyUnit = 'keV';
NumberOfPrimaryParticles = 10^8;


%%
fprintf(foutid,'/tracking/verbose %d\n',TrackingVerboseLevel);
fprintf(foutid,'/run/verbose %d\n',RunVerboseLevel);
fprintf(foutid,'/gps/particle %s\n',ParticleName);
fprintf(foutid,'/gps/pos/type Plane\n');
fprintf(foutid,'/gps/pos/shape Square\n');
fprintf(foutid,'/gps/pos/centre %d %d %d %s\n',BeamCenter(1), BeamCenter(2),BeamCenter(3),DistanceUnit);
fprintf(foutid,'/gps/pos/halfx %d %s\n',BeamHalfX,DistanceUnit);
fprintf(foutid,'/gps/pos/halfy %d %s\n',BeamHalfY,DistanceUnit);
fprintf(foutid,'/gps/ene/min %d %s\n',ParimayParticleMinE,EnergyUnit);
fprintf(foutid,'/gps/ene/max %d %s\n',ParimayParticleMaxE,EnergyUnit);
fprintf(foutid,'/gps/ene/emspec 0\n');

fprintf(foutid,'\n');
fprintf(foutid,'\n');
fprintf(foutid,'## energy spectrum set up ##\n');
fprintf(foutid,'/gps/ene/type User\n');
fprintf(foutid,'/gps/hist/type energy\n');

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
    fprintf(foutid,'/gps/hist/point %.3f %3.f\n',(KE*0.001), HeightBin);
    
end

%%
fprintf(foutid,'\n');
fprintf(foutid,'\n');
fprintf(foutid,'#/gps/hist/inter Exp\n');
fprintf(foutid,'/run/beamOn %d',NumberOfPrimaryParticles);

