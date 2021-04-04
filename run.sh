#!/bin/bash

PROJECT_PATH=$(pwd)
DATA_PATH=$PROJECT_PATH/data
RESULTS_PATH=$PROJECT_PATH/results

IS_CLUSTER_AND_LABEL=false
IS_SELF_TRAINING=false
TIME_LIMIT_IN_SECONDS=2

while [[ $# -gt 0 ]]; do
  key="$1"

  case $key in
  -h | --help)
    echo "Usage: $0 [JAR] [OPTIONS]"
    echo "-cl, --cluster-and-label              Run prediction with using algorithm cluster and label"
    echo "-st, --self-training                  Yarn Spark Job Name and hdfs folder output"
    echo "-c, --clean                           Remove results"

    exit 0
    ;;
  -cl | --cluster-and-label)
    IS_CLUSTER_AND_LABEL=true
    shift # past argument
    ;;
  -st | --self-training)
    IS_SELF_TRAINING=true
    shift
    ;;
  -c | --clean)
    rm -rf results
    mkdir "results"
    shift
    ;;
  *)
    echo "Bad parameter $1"
    exit 1
  esac
done

cluster_and_label_script(){
  pseudo_labeled=$1

  pseudo_labeled_flag=""
  pseudo_labeled_name=""

  if [ $pseudo_labeled ]; then
    pseudo_labeled_flag="-p"
    pseudo_labeled_name="_pseudo"
  fi

  #LED
  java -cp moa-release-2021.03.0/lib/moa.jar -javaagent:moa-release-2021.03.0/lib/sizeofag-1.0.4.jar moa.DoTask \
  "EvaluateInterleavedTestThenTrainSemi -b trees.HoeffdingTree -l (semisupervised.ClusterAndLabelClassifier -c (semisupervised.ClustreamSSL -a Euclidean) $pseudo_labeled_flag) \
  -s (SemiSupervisedStream -s generators.LEDGenerator -t 0.95) -i -1 -t $TIME_LIMIT_IN_SECONDS -f 1000 -q 1000 -d $RESULTS_PATH/led_results_cluster${pseudo_labeled_name}_label_95.csv"

  #RBF
  java -cp moa-release-2021.03.0/lib/moa.jar -javaagent:moa-release-2021.03.0/lib/sizeofag-1.0.4.jar moa.DoTask \
  "EvaluateInterleavedTestThenTrainSemi -b trees.HoeffdingTree -l (semisupervised.ClusterAndLabelClassifier -c (semisupervised.ClustreamSSL -a Euclidean) $pseudo_labeled_flag) \
  -s (SemiSupervisedStream -s generators.RandomRBFGenerator -t 0.95) -i -1 -t $TIME_LIMIT_IN_SECONDS -f 1000 -q 1000 -d $RESULTS_PATH/rbf_results_cluster${pseudo_labeled_name}_label_95.csv"

  #RT
  java -cp moa-release-2021.03.0/lib/moa.jar -javaagent:moa-release-2021.03.0/lib/sizeofag-1.0.4.jar moa.DoTask \
  "EvaluateInterleavedTestThenTrainSemi -b trees.HoeffdingTree -l (semisupervised.ClusterAndLabelClassifier -c (semisupervised.ClustreamSSL -a Euclidean) $pseudo_labeled_flag) \
  -s (SemiSupervisedStream -s generators.RandomTreeGenerator -t 0.95) -i -1 -t $TIME_LIMIT_IN_SECONDS -f 1000 -q 1000 -d $RESULTS_PATH/rt_results_cluster${pseudo_labeled_name}_label_95.csv"

  #Electricity with labeled data
  java -cp moa-release-2021.03.0/lib/moa.jar -javaagent:moa-release-2021.03.0/lib/sizeofag-1.0.4.jar moa.DoTask \
  "EvaluateInterleavedTestThenTrainSemi -b trees.HoeffdingTree -l (semisupervised.ClusterAndLabelClassifier -c (semisupervised.ClustreamSSL -a Euclidean) $pseudo_labeled_flag) \
  -s (SemiSupervisedStream -s (ArffFileStream -f $DATA_PATH/elecNormNew.arff) -t 0.95) -i -1 -t $TIME_LIMIT_IN_SECONDS -f 1000 -q 1000 -d $RESULTS_PATH/electricity_results_cluster${pseudo_labeled_name}_label_95.csv"

  #Cover type with labeled data
  java -cp moa-release-2021.03.0/lib/moa.jar -javaagent:moa-release-2021.03.0/lib/sizeofag-1.0.4.jar moa.DoTask \
  "EvaluateInterleavedTestThenTrainSemi -b trees.HoeffdingTree -l (semisupervised.ClusterAndLabelClassifier -c (semisupervised.ClustreamSSL -a Euclidean) $pseudo_labeled_flag) \
  -s (SemiSupervisedStream -s (ArffFileStream -f $DATA_PATH/covtypeNorm.arff) -t 0.95) -i -1 -t $TIME_LIMIT_IN_SECONDS -f 1000 -q 1000 -d $RESULTS_PATH/cover_type_results_cluster${pseudo_labeled_name}_label_95.csv"

  #Airlines with labeled data
  java -cp moa-release-2021.03.0/lib/moa.jar -javaagent:moa-release-2021.03.0/lib/sizeofag-1.0.4.jar moa.DoTask \
  "EvaluateInterleavedTestThenTrainSemi -b trees.HoeffdingTree -l (semisupervised.ClusterAndLabelClassifier -c (semisupervised.ClustreamSSL -a Euclidean) $pseudo_labeled_flag) \
  -s (SemiSupervisedStream -s (ArffFileStream -f $DATA_PATH/airlines.arff) -t 0.95) -i -1 -t $TIME_LIMIT_IN_SECONDS -f 1000 -q 1000 -d $RESULTS_PATH/airlines_results_cluster${pseudo_labeled_name}_label_95.csv"
}

supervised() {
  ### SUPERVISED ###
  # Electricity supervised
  java -cp moa-release-2021.03.0/lib/moa.jar -javaagent:moa-release-2021.03.0/lib/sizeofag-1.0.4.jar moa.DoTask \
  "EvaluateInterleavedTestThenTrainSemi -a -b trees.HoeffdingTree -l (semisupervised.ClusterAndLabelClassifier -c (semisupervised.ClustreamSSL -a Euclidean)) \
  -s (SemiSupervisedStream -s (ArffFileStream -f $DATA_PATH/elecNormNew.arff) -t 0.95) -i -1 -f 1000 -q 1000 -d $RESULTS_PATH/electricity_results_supervised.csv"

  # Cover Type supervised
  java -cp moa-release-2021.03.0/lib/moa.jar -javaagent:moa-release-2021.03.0/lib/sizeofag-1.0.4.jar moa.DoTask \
  "EvaluateInterleavedTestThenTrainSemi -a -b trees.HoeffdingTree -l (semisupervised.ClusterAndLabelClassifier -c (semisupervised.ClustreamSSL -a Euclidean)) \
  -s (SemiSupervisedStream -s (ArffFileStream -f $DATA_PATH/covtypeNorm.arff) -t 0.95) -i -1 -f 1000 -q 1000 -d $RESULTS_PATH/cover_type_results_supervised.csv"

  # Airlines supervised
  java -cp moa-release-2021.03.0/lib/moa.jar -javaagent:moa-release-2021.03.0/lib/sizeofag-1.0.4.jar moa.DoTask \
  "EvaluateInterleavedTestThenTrainSemi -a -b trees.HoeffdingTree -l (semisupervised.ClusterAndLabelClassifier -c (semisupervised.ClustreamSSL -a Euclidean)) \
  -s (SemiSupervisedStream -s (ArffFileStream -f $DATA_PATH/airlines.arff) -t 0.95) -i -1 -f 1000 -q 1000 -d $RESULTS_PATH/airlines_results_supervised.csv"
}

function batch_training_script() {
  name=$1
  threshold=$3
  confidence=$4

  # LED
  java -cp moa-release-2021.03.0/lib/moa.jar -javaagent:moa-release-2021.03.0/lib/sizeofag-1.0.4.jar moa.DoTask \
  "EvaluateInterleavedTestThenTrainSemi -b trees.HoeffdingTree -l (semisupervised.SelfTrainingClassifier -l trees.HoeffdingTree -t ${threshold} -s ${confidence}) \
  -s (SemiSupervisedStream -s generators.LEDGenerator -t 0.95) -i -1 -t $TIME_LIMIT_IN_SECONDS -f 1000 -q 1000 -d $RESULTS_PATH/led_results_self_training_${name}_95.csv"

  # RBF
  java -cp moa-release-2021.03.0/lib/moa.jar -javaagent:moa-release-2021.03.0/lib/sizeofag-1.0.4.jar moa.DoTask \
  "EvaluateInterleavedTestThenTrainSemi -b trees.HoeffdingTree -l (semisupervised.SelfTrainingClassifier -l trees.HoeffdingTree -t ${threshold} -s ${confidence}) \
  -s (SemiSupervisedStream -s generators.RandomRBFGenerator -t 0.95) -i -1 -t $TIME_LIMIT_IN_SECONDS -f 1000 -q 1000 -d $RESULTS_PATH/rbf_results_self_training_${name}_95.csv"

  # RT
  java -cp moa-release-2021.03.0/lib/moa.jar -javaagent:moa-release-2021.03.0/lib/sizeofag-1.0.4.jar moa.DoTask \
  "EvaluateInterleavedTestThenTrainSemi -b trees.HoeffdingTree -l (semisupervised.SelfTrainingClassifier -l trees.HoeffdingTree -t ${threshold} -s ${confidence}) \
  -s (SemiSupervisedStream -s generators.RandomTreeGenerator -t 0.95) -i -1 -t $TIME_LIMIT_IN_SECONDS -f 1000 -q 1000 -d $RESULTS_PATH/rt_results_self_training_${name}_95.csv"

  # Electricity
  java -cp moa-release-2021.03.0/lib/moa.jar -javaagent:moa-release-2021.03.0/lib/sizeofag-1.0.4.jar moa.DoTask \
  "EvaluateInterleavedTestThenTrainSemi -b trees.HoeffdingTree -l (semisupervised.SelfTrainingClassifier -l trees.HoeffdingTree -t ${threshold} -s ${confidence}) \
  -s (SemiSupervisedStream -s (ArffFileStream -f $DATA_PATH/elecNormNew.arff) -t 0.95) -i -1 -t $TIME_LIMIT_IN_SECONDS -f 1000 -q 1000 -d $RESULTS_PATH/electricity_results_self_training_${name}_95.csv"

  # Cover type
  java -cp moa-release-2021.03.0/lib/moa.jar -javaagent:moa-release-2021.03.0/lib/sizeofag-1.0.4.jar moa.DoTask \
  "EvaluateInterleavedTestThenTrainSemi -b trees.HoeffdingTree -l (semisupervised.SelfTrainingClassifier -l trees.HoeffdingTree -t ${threshold} -s ${confidence}) \
  -s (SemiSupervisedStream -s (ArffFileStream -f $DATA_PATH/covtypeNorm.arff) -t 0.95) -i -1 -t $TIME_LIMIT_IN_SECONDS -f 1000 -q 1000 -d $RESULTS_PATH/cover_type_results_self_training_${name}_95.csv"

  # Airlines
  java -cp moa-release-2021.03.0/lib/moa.jar -javaagent:moa-release-2021.03.0/lib/sizeofag-1.0.4.jar moa.DoTask \
  "EvaluateInterleavedTestThenTrainSemi -b trees.HoeffdingTree -l (semisupervised.SelfTrainingClassifier -l trees.HoeffdingTree -t ${threshold} -s ${confidence}) \
  -s (SemiSupervisedStream -s (ArffFileStream -f $DATA_PATH/airlines.arff) -t 0.95) -i -1 -t $TIME_LIMIT_IN_SECONDS -f 1000 -q 1000 -d $RESULTS_PATH/airlines_results_self_training_${name}_95.csv"
}

function incremental_training_script() {
  name=$1
  threshold=$2

  # LED
  java -cp moa-release-2021.03.0/lib/moa.jar -javaagent:moa-release-2021.03.0/lib/sizeofag-1.0.4.jar moa.DoTask \
  "EvaluateInterleavedTestThenTrainSemi -b trees.HoeffdingTree -l (semisupervised.SelfTrainingIncrementalClassifier -l trees.HoeffdingTree -t ${threshold}) \
  -s (SemiSupervisedStream -s generators.LEDGenerator -t 0.95) -i -1 -t $TIME_LIMIT_IN_SECONDS -f 1000 -q 1000 -d $RESULTS_PATH/led_results_self_training_${name}_95.csv"

  # RBF
  java -cp moa-release-2021.03.0/lib/moa.jar -javaagent:moa-release-2021.03.0/lib/sizeofag-1.0.4.jar moa.DoTask \
  "EvaluateInterleavedTestThenTrainSemi -b trees.HoeffdingTree -l (semisupervised.SelfTrainingIncrementalClassifier -l trees.HoeffdingTree -t ${threshold}) \
  -s (SemiSupervisedStream -s generators.RandomRBFGenerator -t 0.95) -i -1 -t $TIME_LIMIT_IN_SECONDS -f 1000 -q 1000 -d $RESULTS_PATH/rbf_results_self_training_${name}_95.csv"

  # RT
  java -cp moa-release-2021.03.0/lib/moa.jar -javaagent:moa-release-2021.03.0/lib/sizeofag-1.0.4.jar moa.DoTask \
  "EvaluateInterleavedTestThenTrainSemi -b trees.HoeffdingTree -l (semisupervised.SelfTrainingIncrementalClassifier -l trees.HoeffdingTree -t ${threshold}) \
  -s (SemiSupervisedStream -s generators.RandomTreeGenerator -t 0.95) -i -1 -t $TIME_LIMIT_IN_SECONDS -f 1000 -q 1000 -d $RESULTS_PATH/rt_results_self_training_${name}_95.csv"

  # Electricity
  java -cp moa-release-2021.03.0/lib/moa.jar -javaagent:moa-release-2021.03.0/lib/sizeofag-1.0.4.jar moa.DoTask \
  "EvaluateInterleavedTestThenTrainSemi -b trees.HoeffdingTree -l (semisupervised.SelfTrainingIncrementalClassifier -l trees.HoeffdingTree -t ${threshold}) \
  -s (SemiSupervisedStream -s (ArffFileStream -f $DATA_PATH/elecNormNew.arff) -t 0.95) -i -1 -t $TIME_LIMIT_IN_SECONDS -f 1000 -q 1000 -d $RESULTS_PATH/electricity_results_self_training_${name}_95.csv"

  # Cover type
  java -cp moa-release-2021.03.0/lib/moa.jar -javaagent:moa-release-2021.03.0/lib/sizeofag-1.0.4.jar moa.DoTask \
  "EvaluateInterleavedTestThenTrainSemi -b trees.HoeffdingTree -l (semisupervised.SelfTrainingIncrementalClassifier -l trees.HoeffdingTree -t ${threshold}) \
  -s (SemiSupervisedStream -s (ArffFileStream -f $DATA_PATH/covtypeNorm.arff) -t 0.95) -i -1 -t $TIME_LIMIT_IN_SECONDS -f 1000 -q 1000 -d $RESULTS_PATH/cover_type_results_self_training_${name}_95.csv"

  # Airlines
  java -cp moa-release-2021.03.0/lib/moa.jar -javaagent:moa-release-2021.03.0/lib/sizeofag-1.0.4.jar moa.DoTask \
  "EvaluateInterleavedTestThenTrainSemi -b trees.HoeffdingTree -l (semisupervised.SelfTrainingIncrementalClassifier -l trees.HoeffdingTree -t ${threshold}) \
  -s (SemiSupervisedStream -s (ArffFileStream -f $DATA_PATH/airlines.arff) -t 0.95) -i -1 -t $TIME_LIMIT_IN_SECONDS -f 1000 -q 1000 -d $RESULTS_PATH/airlines_results_self_training_${name}_95.csv"
}

function weighting_training_script() {
  name=$1
  weighted=$2

  weighted_flag=""

  if [ $weighted ]; then
    weighted_flag="-w"
  fi

  # LED
  java -cp moa-release-2021.03.0/lib/moa.jar -javaagent:moa-release-2021.03.0/lib/sizeofag-1.0.4.jar moa.DoTask \
  "EvaluateInterleavedTestThenTrainSemi -b trees.HoeffdingTree -l (semisupervised.SelfTrainingWeightingClassifier -l trees.HoeffdingTree $weighted_flag) \
  -s (SemiSupervisedStream -s generators.LEDGenerator -t 0.95) -i -1 -t $TIME_LIMIT_IN_SECONDS -f 1000 -q 1000 -d $RESULTS_PATH/led_results_self_training_${name}_95.csv"

  # RBF
  java -cp moa-release-2021.03.0/lib/moa.jar -javaagent:moa-release-2021.03.0/lib/sizeofag-1.0.4.jar moa.DoTask \
  "EvaluateInterleavedTestThenTrainSemi -b trees.HoeffdingTree -l (semisupervised.SelfTrainingWeightingClassifier -l trees.HoeffdingTree $weighted_flag) \
  -s (SemiSupervisedStream -s generators.RandomRBFGenerator -t 0.95) -i -1 -t $TIME_LIMIT_IN_SECONDS -f 1000 -q 1000 -d $RESULTS_PATH/rbf_results_self_training_${name}_95.csv"

  # RT
  java -cp moa-release-2021.03.0/lib/moa.jar -javaagent:moa-release-2021.03.0/lib/sizeofag-1.0.4.jar moa.DoTask \
  "EvaluateInterleavedTestThenTrainSemi -b trees.HoeffdingTree -l (semisupervised.SelfTrainingWeightingClassifier -l trees.HoeffdingTree $weighted_flag) \
  -s (SemiSupervisedStream -s generators.RandomTreeGenerator -t 0.95) -i -1 -t $TIME_LIMIT_IN_SECONDS -f 1000 -q 1000 -d $RESULTS_PATH/rt_results_self_training_${name}_95.csv"

  # Electricity
  java -cp moa-release-2021.03.0/lib/moa.jar -javaagent:moa-release-2021.03.0/lib/sizeofag-1.0.4.jar moa.DoTask \
  "EvaluateInterleavedTestThenTrainSemi -b trees.HoeffdingTree -l (semisupervised.SelfTrainingWeightingClassifier -l trees.HoeffdingTree $weighted_flag) \
  -s (SemiSupervisedStream -s (ArffFileStream -f $DATA_PATH/elecNormNew.arff) -t 0.95) -i -1 -t $TIME_LIMIT_IN_SECONDS -f 1000 -q 1000 -d $RESULTS_PATH/electricity_results_self_training_${name}_95.csv"

  # Cover type
  java -cp moa-release-2021.03.0/lib/moa.jar -javaagent:moa-release-2021.03.0/lib/sizeofag-1.0.4.jar moa.DoTask \
  "EvaluateInterleavedTestThenTrainSemi -b trees.HoeffdingTree -l (semisupervised.SelfTrainingWeightingClassifier -l trees.HoeffdingTree $weighted_flag) \
  -s (SemiSupervisedStream -s (ArffFileStream -f $DATA_PATH/covtypeNorm.arff) -t 0.95) -i -1 -t $TIME_LIMIT_IN_SECONDS -f 1000 -q 1000 -d $RESULTS_PATH/cover_type_results_self_training_${name}_95.csv"

  # Airlines
  java -cp moa-release-2021.03.0/lib/moa.jar -javaagent:moa-release-2021.03.0/lib/sizeofag-1.0.4.jar moa.DoTask \
  "EvaluateInterleavedTestThenTrainSemi -b trees.HoeffdingTree -l (semisupervised.SelfTrainingWeightingClassifier -l trees.HoeffdingTree $weighted_flag) \
  -s (SemiSupervisedStream -s (ArffFileStream -f $DATA_PATH/airlines.arff) -t 0.95) -i -1 -t $TIME_LIMIT_IN_SECONDS -f 1000 -q 1000 -d $RESULTS_PATH/airlines_results_self_training_${name}_95.csv"
}


if $IS_CLUSTER_AND_LABEL ; then
  echo "Running cluster and label"
  cluster_and_label_script false
  cluster_and_label_script true
#  supervised
fi

if $IS_SELF_TRAINING ; then
  echo "Running self training"

  echo "Running Batch training using confidence scores estimated by the learner and fixed confidence threshold"
  batch_training_script bdf Fixed DistanceMeasure

  echo "Running Batch training using confidence scores estimated by the learner and adaptive threshold"
  batch_training_script bda AdaptiveWindowing DistanceMeasure

  echo "Running Batch training using confidence scores estimated by the learner and fixed confidence threshold"
  batch_training_script bpf Fixed FromLearner

  echo "Running Batch training using confidence scores estimated by the learner and adaptive threshold"
  batch_training_script bpa AdaptiveWindowing FromLearner

  echo "Running Batch training using confidence scores estimated by the learner and fixed confidence threshold"
  incremental_training_script ipf Fixed

  echo "Running Batch training using confidence scores estimated by the learner and adaptive threshold"
  incremental_training_script ipa AdaptiveWindowing

  echo "Running Batch training using confidence scores estimated by the learner and adaptive threshold"
  weighting_training_script idw true

  echo "Running Batch training using confidence scores estimated by the learner and adaptive threshold"
  weighting_training_script iew false
fi
