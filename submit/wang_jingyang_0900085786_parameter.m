%% Author: Jingyang Wang
% Parameters of the model
clear all

%% PWM
%fsw: carrier frequency [Hz]
fsw=1000000;

%% motor parameter
%r: motor phase resistance [Ohm]
r=6.61;
%l: motor phase inductance [H]
l=1.7E-03;
%taua=0.0002572
%kt: torque constant [Nm/A]
kt=0.137;
%ks: speed constant[rad/s/V]
ks=70;

%% Mechanical Load
J=183e-07;

torque_slope=2.646E-04;
%% supply system parameters
%battery [volt]
vs=72;
%rs: source  resistance [Ohm]
rs=0.72;
%ls: source inductance [mH]
ls=0.72;

%% SPEED REFERENCE of the duty cycle for the repeating sequence%%%
%time, speed value pairs 

period_duty=1;

%% Convertor
max_current = 2.8;
