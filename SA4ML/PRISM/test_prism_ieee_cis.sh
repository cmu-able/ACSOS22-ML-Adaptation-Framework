#!/usr/bin/env bash

VAGRANT_PRISM="/home/vagrant/prism-4.6-linux64/bin/prism"
VAGRANT_BASE_DIR="/home/vagrant/SA4ML/PRISM"

prism=$VAGRANT_PRISM
BASE_DIR=$VAGRANT_BASE_DIR

MODEL="${BASE_DIR}/model/system_model.prism"
PROPERTIES="${BASE_DIR}/model/properties.props"

# PRISM OPTIONS
CUDD_MEM=16g
JAVA_MEM=12g
JAVA_STACK=1g
# available engines:
# - hybrid (default)
# - sparse
# - MTBDD
# - explicit
ENGINE=explicit

APPROXIMATE_MODEL_CHECKING=false
# available approximate model checking methods
# - ci:    confidence inteval
# - aci:   asymptotic confidence interval
SIMULATION_METHOD=ci

# VARIABLES
horizon=$1
expected_num_txns=$2
percent_txns=$3
curr_tnr=$4
curr_tpr=$5
curr_fnr=$6
curr_fpr=$7
fpr_sla_cost=$8
recall_sla_cost=$9
fpr_threshold=${10}
recall_threshold=${11}
new_data=${12}
new_tpr_retrain=${13}
new_tpr_retrain_std=${14}
new_tpr_retrain_5=${15}
new_tpr_retrain_50=${16}
new_tpr_retrain_95=${17}
new_tnr_retrain=${18}
new_tnr_retrain_std=${19}
new_tnr_retrain_5=${20}
new_tnr_retrain_50=${21}
new_tnr_retrain_95=${22}
new_tpr_noRetrain=${23}
new_tpr_noRetrain_std=${24}
new_tpr_noRetrain_5=${25}
new_tpr_noRetrain_50=${26}
new_tpr_noRetrain_95=${27}
new_tnr_noRetrain=${28}
new_tnr_noRetrain_std=${29}
new_tnr_noRetrain_5=${30}
new_tnr_noRetrain_50=${31}
new_tnr_noRetrain_95=${32}
retrain_cost=${33}
retrain_latency=${34}
no_retrain_models=${35}
benefits_model_type=${36}
tactics=${37}


# TACTICS
NOP=0
ALL=1
RETRAIN=2

if [[ "$tactics" == "retrain" ]]; then
    TACTICS=$RETRAIN
else
    TACTICS=$NOP
fi

# BENEFITS MODEL TYPE
DELTA=0
ABS=1

if [[ "$benefits_model_type" == "delta" ]]; then
    MODEL_TYPE=$DELTA
else
    MODEL_TYPE=$ABS
fi

# OUTPUT FILE NAME BASED ON SELECTED TACTIC
if [[ "$tactics" == "retrain" ]]; then
    output_file_name="${BASE_DIR}/adv-retrain"
else
    output_file_name="${BASE_DIR}/adv-nop"
fi

# RUN PRISM
$prism $MODEL $PROPERTIES -prop 2 -const TACTICS=$TACTICS,BENEFITS_MODEL_TYPE=$MODEL_TYPE,NO_RETRAIN_MODELS=$no_retrain_models,HORIZON=$horizon,RETRAIN_COST=$retrain_cost,RETRAIN_LATENCY=$retrain_latency,AVG_TRANSACTIONS=$expected_num_txns,PERCENT_TXS=$percent_txns,INIT_TPR=$curr_tpr,INIT_TNR=$curr_tnr,INIT_FPR=$curr_fpr,INIT_FNR=$curr_fnr,FPR_SLA_COST=$fpr_sla_cost,RECALL_SLA_COST=$recall_sla_cost,FPR_THRESHOLD=$fpr_threshold,RECALL_THRESHOLD=$recall_threshold,CURR_NEW_DATA=$new_data,new_TPR_retrain=$new_tpr_retrain,new_TPR_retrain_std=$new_tpr_retrain_std,new_TPR_retrain_5=$new_tpr_retrain_5,new_TPR_retrain_50=$new_tpr_retrain_50,new_TPR_retrain_95=$new_tpr_retrain_95,new_TNR_retrain=$new_tnr_retrain,new_TNR_retrain_std=$new_tnr_retrain_std,new_TNR_retrain_5=$new_tnr_retrain_5,new_TNR_retrain_50=$new_tnr_retrain_50,new_TNR_retrain_95=$new_tnr_retrain_95,new_TPR_noRetrain=$new_tpr_noRetrain,new_TPR_noRetrain_std=$new_tpr_noRetrain_std,new_TPR_noRetrain_5=$new_tpr_noRetrain_5,new_TPR_noRetrain_50=$new_tpr_noRetrain_50,new_TPR_noRetrain_95=$new_tpr_noRetrain_95,new_TNR_noRetrain=$new_tnr_noRetrain,new_TNR_noRetrain_std=$new_tnr_noRetrain_std,new_TNR_noRetrain_5=$new_tnr_noRetrain_5,new_TNR_noRetrain_50=$new_tnr_noRetrain_50,new_TNR_noRetrain_95=$new_tnr_noRetrain_95 -exportresults $output_file_name.txt -exportadvmdp $output_file_name.tra -$ENGINE
