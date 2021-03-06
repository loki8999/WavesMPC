%%% updatePlotHistory.m 
%%% Daniel Fernández
%%% July 2015
%%% Updates all plotData for robots or waves and produces data which is
%%% immediately readable by the simulator.


function [ plotData ] = updatePlotHistory( state, plotData, count, dt ) 

plotData.px(count+dt) = state(1);
plotData.pz(count+dt) = state(2);
plotData.vx(count+dt) = state(3);
plotData.vz(count+dt) = state(4);
plotData.ax(count+dt) = state(5);
plotData.az(count+dt) = state(6);

return

end