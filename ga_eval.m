function J = ga_eval(ind, df)

    G_tf = tf(1,[5 1],'InputDelay',2) ;

    Kp = ind.p*df;
    Ki = ind.i*df;
    Kd = ind.d*df;

    controller = pid(Kp, Ki, Kd);

    closed_loop_system = feedback(controller * G_tf, 1);

    t = 0:0.1:50; % Time vector
    step_response = step(closed_loop_system, t);

    info = stepinfo(step_response, t);
    overshoot = info.Overshoot;
    settlingtime = info.SettlingTime;

    % Define the desired output (unit step input)
    desired_output = ones(size(step_response));

    % Calculate the error
    error = desired_output - step_response;

    disp(overshoot);
    fprintf('Type of overshoot: %s\n', class(overshoot));
    fprintf('Size of overshoot: %s\n', mat2str(size(overshoot)));


    IAE = trapz(t, abs(error));
    ISE = trapz(t, error.^2);

    J = -(IAE+ISE)/2;
    %J = -ISE;

    if isfinite(overshoot)
        %J = J - (overshoot/5);
        %J = J - settlingtime/20;
    else
        %J = J-100;
    end

    
    

end


function J = ga_eval0(ind, df)


    kp = 2; % Proportional gain = 2.8
    ki = 0.5; % Integral gain = 1.6
    kd = 1; % Derivative gain = 1.2

    p_diff = abs(kp - ind.p*df);
    i_diff = abs(ki - ind.i*df);
    d_diff = abs(kd - ind.d*df);

    sum_diff = p_diff + i_diff + d_diff;
    J = -sum_diff;

end