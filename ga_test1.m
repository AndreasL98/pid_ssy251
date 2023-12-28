
%TODO: Define the maximum population
maxPop= 50;
%TODO: Define the number of generations
generations=15;


% Decimal factor to convert integer numbers to float numbers. We will use 2 decimals precision
df=100.0;

% Max parameter value. It corresponds to 10000/100.0=100.0 as max value for
% Kp. We will use maxVal/2 for the values of Kd.
maxVal=10*df;
% Number of bits 
nBits=14; % 14 bits=> It can contain up to 16383>maxVal 
nBits=10; %contain up to 1000

% Container for the population (integer)
population=[];

lowest_ever = -10;


%Task 2: First create an initial random population
% population will be an array of struct 'individual'
for i = 1:maxPop
    % The individuals are structs containing gains p and d.
    % The structs variables are defined using ".", e.g.
    % individual.p=1, individual.d=2, will create a
    % structure 'individual' with two fields.
    % TODO: create the random integer values
    
    randomMax = randi(maxVal);

    individual_d.p=randomMax; %(maxVal)
    individual_d.d=randomMax / 2; %(maxVal/2);

    individual_d.i=randomMax / 5; %(maxVal/2);

    % TODO: append the newly created individual to the array 'population'
    population=[population, individual_d];
end



% Task 7b: Iterate through the number of Generations
for gen = 1:generations
    % Container for the new population
    % In each generation we will create a new population which evolves
    % using the GA
    
    % Container for the new population, created from the reproduction process
    newPop_c=[];
    
    % Container for the binary codified population
    population_c=[];
    
    
    % Container for the fitness values (results of evaluating the
    % individuals in the model.
    fitnessL=[];
    
    fprintf(1,"+++++++++++Generation: %d\n",gen);
    
    %Task 3: Get the fitness value of each individual
    % Evaluate each individual, i.e. each Kp, Kd in the simulink-model and
    % calculate the error (fitness value)
    % Iterate through the size of the population
    
    for i = 1:length(population) %maxPop??
        
        fprintf(1,'{%d}Individual(%d): \n',gen,i);
        disp(population(i)); % --> it can be used with structures!
        
        % TODO: Convert the individuals' parameters (defined as integer numbers
        % by the function --randi--) to floats with 2 decimals
        individual.p=population(i).p/df;
        individual.d=population(i).d/df;

        individual.i=population(i).i/df;

        %individual.p=7500/100;
        %individual.d=3000/100;

        % PRINT HERE TO SHOW THE LOWER P AND D VALUES
        %fprintf(1,'{%d}Individual(%d): \n',gen,i);
        %disp(individual)); % --> it can be used with structures!

        % Run the model using each individual values (p,d), the model
        % will calculate an error function and return it. This value
        % will be used as fitness value.
        % TODO: define the simulation model: 
        % a) 'Pendulum/DSimulator_robot1DOFV.slx' (visualization) or 
        % b) 'Pendulum/DSimulator_robot1DOFV_NG.slx' (No visualization)

        fitness=ga_eval(individual, 1);

        if fitness > lowest_ever
            lowest_ever = fitness;
        end

        %fitness=ga_eval(individual,'Pendulum/DSimulator_robot1DOFV.slx');

        fprintf(1,'Fitness Value: \n');
        disp(fitness);
        
        % TODO: Append the fitness value of the individual(i) to the array
        % The population and fitnessL array will have the same order,
        % i.e. the fitness value of the individual 'population(i)' is
        % fitnessL(i)
        fitnessL=[fitnessL fitness];
        
        % Task 4: Codification using nBits (see dec2bin function)
        individual_c.p=dec2bin((individual.p*df),nBits);
        individual_c.d=dec2bin((individual.d*df),nBits);

        individual_c.i=dec2bin((individual.i*df),nBits);

        %disp(individual.p*df)
        %disp(dec2bin((individual.p*df),nBits))
        %disp(bin2dec(dec2bin((individual.p*df),nBits)))
        
        
        %disp(individual_c);
        
        
        % TODO: add the codified individual (individual_c) to the 
        % Population with binary codification (population_c)
        population_c=[population_c individual_c];
        
        %disp("------------------------");
        
    end
    
    %% Task 5: Probabilities
    % Convert the fitnessL vector into probabilities. The higher the number
    % the higher the probability.
    
    % Tip:  1) define a threshold as the lowest score + 10%
    %       2) substract the threshold
    %       3) get the probabilities
    % probability is an array with the same dimension as fitnessL 

    % CHAT GPT ###########

    threshold = min(fitnessL) + 0.1 * min(fitnessL);
    adjustedFitness = fitnessL - threshold;

    probability = adjustedFitness / sum(adjustedFitness);
    probability = max(probability, 0);


    % END CHAT GPT ########
    
    %% Task 6: Reproduction
    
    % Task 6a Elitsm: choose the individual with the best fitness and add it to
    % the new population.
    % Tip1: remember that population_c and fitnessL have the same order.
    % Tip2: The max function returns the max value found in an array, and
    % its index, type 'help max' to get more information
    [bestFit,bestIdx]=max(fitnessL);
    % TODO: Get the best individual using the obtained index from 'max' 
    bestInd=population_c(bestIdx);
    disp('BEST IND C')
    disp(bestInd)
    %disp(bestInd)
    %disp(fitnessL)
    %disp(bestFit)
    %disp(bestIdx)

    %disp(population(bestIdx))

    disp(ga_eval(population(bestIdx), 1/df))

 
    % TODO: Add the best individual to the new population list
    % In this way, the new population will always have the best
    % individual found during the generations
    newPop_c=[newPop_c bestInd];
    
    % Loop until you have created a new population of size = maxPop
    while length(newPop_c)<maxPop

        % Generate a new child with the function ga_reproduce
        child=ga_reproduce(population_c,probability,nBits);

        %disp(newPop_c)
        %disp(child)
        
        % TODO: add the new child to the new population
        newPop_c=[newPop_c child];
    end
    
    % Task 7 Decode the new population (newPop_c) into a Decimal
    % representation (newPop), using the function bin2dec

    newPop=[];
    for i=1:numel(newPop_c)
        
        individual.p = bin2dec(newPop_c(i).p);
        individual.d = bin2dec(newPop_c(i).d);

        individual.i = bin2dec(newPop_c(i).i);
        
        % TODO: add the decodified individual to the new population
        newPop = [newPop, individual];
    end
    
    % TODO: Assign the new decodeded population (newPop) to the population to
    % process the new generation (iteration)
    population = newPop;
    
    % Save the decoded new population (newPop) and the
    % list of scores (fitnessL) in two cells to print them at the end.
    vGenerations{gen+1}=newPop;
    vFitness{gen}=fitnessL;
    
    fprintf(1,"Best Individual Generation {%d}: PD(%d,%d,%d) c[%f]\n",gen,newPop(1).p/df,newPop(1).i/df,newPop(1).d/df,fitnessL(bestIdx));
    %plot_best_individual(newPop(1).p/df,newPop(1).d/df);
end