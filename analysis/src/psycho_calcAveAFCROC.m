function [aveROC_struct] = psycho_calcAveAFCROC(AFC_struct)

  subplot_index = 0;
  num_combinations = prod(AFC_struct.ROC_list{1}.num_xfactor_vals);

  %% initialize aveROC_struct to first ROC_struct in ROC_list
  aveROC_struct = AFC_struct.ROC_list{1};
  
  for i_combination = 1 : num_combinations
    xfactor_subindex = ...
	ind2sub(aveROC_struct.num_xfactor_vals, i_combination);
    for i_AFC_ID = 2 : AFC_struct.num_IDs
      aveROC_struct.AFC_ROC{xfactor_subindex} = ...
	  aveROC_struct.AFC_ROC{xfactor_subindex} + ...
	  AFC_struct.ROC_list{i_AFC_ID}.ROC_struct.AFC_ROC{xfactor_subindex};
      aveROC_struct.AFC_AUC(xfactor_subindex) = ...
	  aveROC_struct.AFC_AUC(xfactor_subindex) + ...
	  AFC_struct.ROC_list{i_AFC_ID}.ROC_struct.AFC_AUC(xfactor_subindex);
    end  %% i_AFC_ID
    aveROC_struct.AFC_ROC{xfactor_subindex} = ...
	aveROC_struct.AFC_ROC{xfactor_subindex} / ...
	AFC_struct.num_IDs;
    aveROC_struct.AFC_AUC(xfactor_subindex) = ...
	aveROC_struct.AFC_AUC(xfactor_subindex) / ...
	AFC_struct.num_IDs;    
  end  %% i_combination


  
