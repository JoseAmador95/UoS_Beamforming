%% Theoretical Radiation Pattern Generator
% This script plots the theoretical radiation patern of a beamformer given
% by its side-lobe suppressing weights. The number of elements in the
% weight vector denotes the number of antenna elements in the array.
%
% Also, the steering angle may be set by changing the steer variable in the
% for loop section.
%
% This script may be opened as a MATLAB Live Script for better
% visualisation.

%% Initialization
% The weight vecotr may be specified as shown in the code below. It is
% unitary by default, but a vector may be introduced usign MATLAB's Filter
% Designer App.

%W = [0.1204 0.2407 0.3009 0.2407 0.1204];
W = ones(1,2);
ang = linspace(0, 359, 1001) * pi/180;
M = length(W);

%% Process
% The process uses the beamforming equations assuming a optimal beamformer
% (d = lamda / 2).

p_w = zeros(length(ang), 1);
for steer = 30 % Change the steering angle to a scalar or array
%for steer = -90:90
    S = exp(-1i*(0:M-1) * pi .* sind(steer));
    for theta = 1:length(ang) 
        x = exp(-1i*(0:M-1)*pi.*sin(ang(theta)));
        p_w(theta) = sum(x .* conj(W .* S));
    end
    polarplot(ang, abs(p_w)); % The phase pattern may be displayed as well
    drawnow
end 

