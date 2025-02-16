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


initParams = [5.0497, 0];  % Initial value
options = optimset('Display','iter');
bestParams = fminsearch(@pi_objective, initParams, options);
fprintf('Best parameters：Kp = %f, Ki = %f\n', bestParams(1), bestParams(2));

% definition of goal function
function J = pi_objective(params)
    Kp = params(1);
    Ki = params(2);
    
    % Set PI controller parameters
    set_param('myDemo/CurrentController', 'P', num2str(Kp));
    set_param('myDemo/CurrentController', 'I', num2str(Ki));
    
    % Start simulation(The simulation time is 1)
    simOut = sim('myDemo', 'StopTime', '1', 'SaveOutput','on','SaveTime','on');
    
    % Obtain the output signal
    try
        y_ts = simOut.get('y_out');
    catch
        error('cant find y_out from simulation，check To Workspace block');
    end
    
    try
        r_ts = simOut.get('r_out'); 
    catch
        error('cant find r_out from simulation，check To Workspace block');
    end
    % calculate the goal function, using MSE here

    r_time = r_ts.Time;   % ref signal time vector
    r_data = r_ts.Data;   % ref signal data
    y_time = y_ts.Time;   % output signal time vector
    y_data = y_ts.Data;

    r_interp = interp1(r_time, r_data, y_time, 'linear', 'extrap');

    J = sum((r_interp - y_data).^2);

    % get time stamp(YYYY-MM-DD HH:MM:SS）
    timestamp = datestr(now, 'yyyy-mm-dd HH:MM:SS');
    
    % write the result to file
    logFile = 'tuning_log.txt';

    fid = fopen(logFile, 'a');
    if fid == -1
        warning('No log file %s to write in。', logFile);
    else
        % stamp, Kp, Ki, error
        fprintf(fid, '%s, Kp = %f, Ki = %f, error = %f\n', timestamp, Kp, Ki, J);
        fclose(fid);
    end
    
    % fprintf
    fprintf('paras now：Kp = %f, Ki = %f, error = %f\n', Kp, Ki, J);
end


