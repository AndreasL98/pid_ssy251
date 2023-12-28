function child = ga_reproduce(population_c,probability,nBits)
%GA_REPRODUCE create a new child from a population based on a random method
%   This function will generate a new child using three different
%   reproduction methods Replication, Crossover, and Mutation.

% Select randomly the reproduction method:
% [Replication, Crosover, Mutation ]
% We want to reduce the probability of the Mutation method, e.g.
% probability_method=[0.40,0.40,0.2] will add more chances to
% Replication and Crossover methods.
% Tip: you can use the randsample function. Type 'help rand sample'
% in the matlab terminal for more information

%method=['Replication', 'Crosover','Mutation'];
method=randi(3);

maxBit = 2*nBits;
max1_2 = maxBit / 2;

%max1_3 = maxBit/3;
%max2_3 = maxBit/3 * 2;

max1_3 = floor(maxBit / 3);
max2_3 = floor(maxBit / 3 * 2);

switch method
    case 1
        % Task 6b Replication
        disp('---Replication')
        
        % TODO: Select a random individual from the population and assign
        % it as the new child
        % Tip: You can use the function randsample or implement
        % your own selection pool function.
        % Use 'help randsample' to get info about this function
        
        child=population_c(randi(length(population_c))); %% ALT randsample()???
        disp(child)
        
    case 2
        % Task 6c Crossover
        disp('---Crossover')
        
        % TODO: Randomly select two individuals using the probability
        % Tip: you can use again randsample or your own selection
        % pool function. In this case, the function should return
        % two random individuals.

        individuals_c = randsample(population_c, 3, true, probability);
        %individuals_c = randsample(population_c, 2);
        
        disp("//Random selection");
        for i=1:3
            disp(individuals_c(i))
        end
        
        % TODO: Concatenate the coded parameters p(14bit) and d(14bit)
        % of each selected individual in a single 28bits WORD
        i_l(1,:) = [individuals_c(1).p, individuals_c(1).d];
        i_l(2,:) = [individuals_c(2).p, individuals_c(2).d];

        i_l(3,:) = [individuals_c(3).i, individuals_c(3).i];
        
        
        % number of target bits
        m=2;
        % TODO: Random selection of m target bits (2*nBits), see randi.
        rbits=randi([1, 2*nBits], 1, m);
        
        % TODO: Option (1) Swap the target bits (rbits) between 
        % random individual 1 and 2
        for i=1:numel(rbits)

            %CHATGPT #########

            % Store the bit from the first individual temporarily
            temp = i_l(1, rbits(i));
            
            % Swap the bit from the second individual to the first
            i_l(1, rbits(i)) = i_l(2, rbits(i));
            
            % Assign the temporarily stored bit of the first individual to the second
            i_l(2, rbits(i)) = temp;

            %END CHATGPT #######

        end
        
        % TODO: Split the 28bit WORD into two parameters
        % p and d (14 bit) each, and add the two crossover individuals
        % to the child
        disp("//Modified");
        child=[];
        for i=1:2
            %child(i).p=i_l(???);
            %child(i).d=i_l(???);
            %disp(child(i))

            % CHAT GPT #############
           

            % Extract the first 14 bits for p and the next 14 bits for d
           
            %child(i).p = i_l(i, 1:max1);   % The first 14 bits
            %child(i).d = i_l(i, max1+1:maxBit);  % The next 14 bits

            child(i).p = i_l(i, 1:max1_3);   % The first 14 bits
            child(i).d = i_l(i, max1_3+1:max2_3);  % The next 14 bits
            child(i).i = i_l(i, max2_3+1:maxBit);
        
            % Display the child
            disp(child(i))
            
            % END CHAT GPT #########

        end
        
%         % TODO: Option (2) Concatenate 1:rbits from i_l1 and 
%         % rbits+1:n from i_l2
%         % and form a new individual
%         individual_c=[i_l(???) i_l(???)];
% 
%         % TODO: Split the 28bit word into two parameters
%         % p and d (14 bit) each and assign them to the
%         % new child
%         child.p=individual_c(???);
%         child.d=individual_c(???);
%         disp("//Modified");
%         disp(child)
        
    case 3
        % Task 6d Crossover
        disp('---Mutation')
        
        % TODO: Randomly select an individual using the probability
        %individual_c=???;
        individual_c = randsample(population_c, 1, true, probability);
        %individual_c = randsample(population_c, 1);
        
        disp("//Random selection");
        disp(individual_c)
        
        % TODO: Random selection of target bits (1 bit from 2*nBits)
        rbit = randi([1, 2*nBits]);
        
        % TODO: Concatenate the coded parameters p(14bit) and d(14bit)
        % in a single 28 bit word
        i_l = [individual_c.p, individual_c.d];
        
        % TODO: Negate the target bit in the 28bit word i_l
        % NOTE: operator "~" doesn't work for type (char). Then, we need
        % to implement a simple if-else condition.
        if i_l(rbit)=='0'
            i_l(rbit)='1';
        else
            i_l(rbit)='0';
        end
        
        % TODO: Split the 28bit word into two parameters
        % p and d (14 bit) each and assign them to the new child
        
        %child.p = i_l(1:max1);
        %child.d = i_l(max1+1:maxBit);



        child.p = i_l(1:max1_3);   % The first 14 bits
        child.d = i_l(max1_3+1:max2_3);  % The next 14 bits    
        child.i = i_l(max2_3+1:maxBit);
        
        disp("//Modified");
        disp(child)
        
end



end