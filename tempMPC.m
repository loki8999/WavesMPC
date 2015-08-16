%%% tempMPC.m
%%% Daniel Fern�ndez
%%% August 2015
%%% new MPC

clc 
close all
clear global
clear variables
warning('off', 'MATLAB:odearguments:InconsistentDataType')

tic

[ time ] = loadTimeParameters( );
t = time.t;
IC = [0, -20, 0, 0, 0, 0]; %all initial conditions, pos, vel, acc (x and z)
DC = [0, -20, 0, 0, 0, 0]; %all desired conditions, pos, vel, acc (x and z)

waves = loadTempWaves( );
waves.swl = zeros(1, numel(time.t)); %still water line
[ seaParticles, waves ] = getSeaStateParticles( time.t, IC(1), IC(2), waves );

volturnus = loadSeaBotix( time.t, IC, DC );

counter = 1; 
U = [ IC(1), IC(2), seaParticles.vx(1), seaParticles.vz(1), seaParticles.ax(1), seaParticles.az(1) ];
[ volturnus.particlePlots ] = updatePlotHistory( U, volturnus.particlePlots, counter, 0 );

while counter ~= 2 %numel(time.t)- 25
    [ volturnus ] = mpcRobot( time.t, volturnus, waves, counter );
    counter = counter + 1;
end
pErrorX = volturnus.errors.pErrorX;
pErrorZ = volturnus.errors.pErrorZ;
[ volturnus ] = updateErrors( volturnus, counter, pErrorX, pErrorZ );
clear counter U 

toc
%%
%simulator( t(1:numel(t)-20), waves.eta, waves.d, DC, volturnus.robotPlots );

temp2 = [ volturnus.errorPlots.pErrorX; volturnus.errorPlots.pErrorZ ]; 
figure('units','normalized','outerposition',[0 0 1 1]);
subplot(2,1,1)
plot( t(1:numel(t)-20), temp2(1,1:numel(t)-20), 'b' ); 
line( [t(1),t(numel(t)-20)], [0,0],'LineWidth', 1, 'Color', 'r' );
title('Position Error, x');
subplot(2,1,2)
plot( t(1:numel(t)-20), temp2(2,1:numel(t)-20), 'b' );
line( [t(1),t(numel(t)-20)], [0,0],'LineWidth', 1, 'Color', 'r' );
title('Position Error, z');