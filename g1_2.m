% Define the transfer function of the system
s = tf('s');
G_func = 1 / (1 + 5 * s);

% G TRANSFER FUNC
G_tf = tf(1,[5 1],'InputDelay',2) 


% Create a PID controller
Kp = 2; % Proportional gain = 2.8
Ki = 0.5; % Integral gain = 1.6
Kd = 1; % Derivative gain = 1.2

Kp = 1.44; % Proportional gain = 2.8
Ki = 0.26; % Integral gain = 1.6
Kd = 0.72; % Derivative gain = 1.2

%Kp = 2.14; % Proportional gain = 2.8
%Ki = 0.53; % Integral gain = 1.6
%Kd = 1.07; % Derivative gain = 1.2

Kp = 1.47; % Proportional gain = 2.8
Ki = 0.27; % Integral gain = 1.6
Kd = 0.73; % Derivative gain = 1.2

%Kp = 2.12; % Proportional gain = 2.8
%Ki = 0.42; % Integral gain = 1.6
%Kd = 1.06; % Derivative gain = 1.2



controller = pid(Kp, Ki, Kd);

%% Ku = 4.7 || 5
%% Pu = 3.4

% Combine the controller with the system
%closed_loop_system = feedback(controller * G_delayed, 1);
closed_loop_system = feedback(controller * G_tf, 1);

% Simulate the step response
t = 0:0.1:30; % Time vector
step_response = step(closed_loop_system, t);

% Get performance metrics
info = stepinfo(step_response, t);

% Displaying the metrics
disp(info);

info.Overshoot


% Define the desired output (unit step input)
desired_output = ones(size(step_response));

% Calculate the error
error = desired_output - step_response;

% Calculate ISE
ISE = trapz(t, error.^2);

% Calculate IAE
IAE = trapz(t, abs(error));

% Calculate ITAE
ITAE = trapz(t, t.*abs(error));

% Displaying the metrics
disp(['ISE: ', num2str(ISE)]);
disp(['IAE: ', num2str(IAE)]);
%disp(['ITAE: ', num2str(ITAE)]);


% Plot the step response and the step input on the same plot
figure;
plot(t, step_response, 'b-', 'LineWidth', 2); % System response in blue
hold on;
plot(t, ones(size(t)), 'r--', 'LineWidth', 1.5); % Step input in red dashed line
hold off;
title('PID Controlled System Response to Step Input');
xlabel('Time (seconds)');
ylabel('Response / Input');
legend('System Response', 'Step Input (0 to 1)');
grid on;