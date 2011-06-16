function [ROC_struct] = psycho_calcAFC(AFC_struct)

  %% initialize to first subject
  ROC_struct = AFC_struct.ROC_list(1);
  ROC_struct.target_trials = [];
  ROC_struct.AFC_trials = [];
  ROC_struct.AFC_confidence = [];
  ROC_struct.AFC_correct = [];
  ROC_struct.AFC_target_flag = [];
  ROC_struct.AFC_choice = [];
  ROC_struct.AFC_hist = [];
  ROC_struct.AFC_cumsum = [];
  ROC_struct.AFC_bins = [];
  ROC_struct.AFC_ideal = [];
  
  num_combinations = ROC_struct.num_combinations;
  for i_combination = 1 : num_combinations
    ROC_struct.AFC_error{i_combination} = ...
	ROC_struct.AFC_error{i_combination}.^2;
  end
    
  for i_AFC_ID = 2 : AFC_struct.num_IDs
    
    AFC_performance = AFC_struct.ROC_list(i_AFC_ID).AFC_performance;
    AFC_error = AFC_struct.ROC_list(i_AFC_ID).AFC_error;
    AFC_ROC = AFC_struct.ROC_list(i_AFC_ID).AFC_ROC;
    AFC_AUC = AFC_struct.ROC_list(i_AFC_ID).AFC_AUC;
    for i_combination = 1 : num_combinations

      %% compute absolute performance
      ROC_struct.AFC_performance{i_combination} = ...
	  ROC_struct.AFC_performance{i_combination} + ...
	  AFC_performance{i_combination};
      ROC_struct.AFC_error{i_combination} = ...
	  ROC_struct.AFC_error{i_combination} + ...
	  AFC_error{i_combination}.^2;
      
      %% compute ROC histograms for AFC trials
      ROC_struct.AFC_ROC{i_combination} = ...
	  ROC_struct.AFC_ROC{i_combination} + ...
	  AFC_ROC{i_combination};
      ROC_struct.AFC_AUC(i_combination) = ...
	  ROC_struct.AFC_AUC(i_combination) + ...
	  AFC_AUC(i_combination);

    end  %% i_combination
  end  %% i_AFC_ID

  for i_combination = 1 : num_combinations
    disp(['i_combination = ', num2str(i_combination)]);
    x_factor_subindex = zeros(1,ROC_struct.num_x_factors);
    i_residule = i_combination;
    for i_x_factor = ROC_struct.num_x_factors : -1 : 1
      i_x_index = 1 + ...
	  floor((i_residule-1) / ...
		ROC_struct.prod_x_factors(i_x_factor));
      x_factor_subindex(i_x_factor) = i_x_index;
      i_residule = ...
	  i_combination - ...
	  ( i_x_index - 1 ) * ROC_struct.prod_x_factors(i_x_factor);
    end  %% i_x_factor
    disp(['x_factor_subindex = ', num2str(x_factor_subindex)]);

    ROC_struct.AFC_performance{i_combination} = ...
	ROC_struct.AFC_performance{i_combination}  / AFC_struct.num_IDs;
    ROC_struct.AFC_error{i_combination} = ...
	sqrt( ROC_struct.AFC_error{i_combination}  / AFC_struct.num_IDs );

    AFC_performance = ...
	ROC_struct.AFC_performance{i_combination};
    AFC_error = ...
	ROC_struct.AFC_error{i_combination};
    for i_AFC = 1 : AFC_struct.AFC_mode
      disp(['AFC_performance(', num2str(i_AFC), ')', ...
	    ' = ', num2str(AFC_performance(i_AFC)), ...
	    ' +/- ', ...
	    num2str(AFC_error(i_AFC))]);
    end %% i_AFC
    disp(['AFC_performance(', num2str(i_AFC+1), ') = ', ...
	  num2str(AFC_performance(i_AFC+1)), ...
	  ' +/- ', ...
	  num2str(AFC_error(i_AFC+1))]);

    ROC_struct.AFC_ROC{i_combination} = ...
	ROC_struct.AFC_ROC{i_combination}  / AFC_struct.num_IDs;
    ROC_struct.AFC_AUC(i_combination) = ...
	ROC_struct.AFC_AUC(i_combination)  / AFC_struct.num_IDs;
    
    AFC_AUC = ...
	ROC_struct.AFC_AUC(i_combination);
    disp(['AFC_AUC', ' = ', num2str(AFC_AUC)]);

  end