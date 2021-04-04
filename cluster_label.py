import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
from pathlib import Path

plt.close("all")
Path("analyze").mkdir(parents=True, exist_ok=True)

cluster_label_results = [
    'results/led_results_cluster_label_95.csv',
    'results/rbf_results_cluster_label_95.csv',
    'results/rt_results_cluster_label_95.csv',
    'results/electricity_results_cluster_label_95.csv',
    'results/cover_type_results_cluster_label_95.csv',
    'results/airlines_results_cluster_label_95.csv'
]
cluster_pseudo_label_results = [
    'results/led_results_cluster_pseudo_label_95.csv',
    'results/rbf_results_cluster_pseudo_label_95.csv',
    'results/rt_results_cluster_pseudo_label_95.csv',
    'results/electricity_results_cluster_pseudo_label_95.csv',
    'results/cover_type_results_cluster_pseudo_label_95.csv',
    'results/airlines_results_cluster_pseudo_label_95.csv'
]

supervised_results = [
    'results/electricity_results_supervised.csv',
    'results/cover_type_results_supervised.csv',
    'results/airlines_results_supervised.csv'
]


def get_accuracy(path_to_result):
    data_frame = pd.read_csv(path_to_result)
    last_accuracy = data_frame['classifications correct (percent)'][-1:]
    return pd.to_numeric(last_accuracy.values[0])


def get_accuracies(results, accuracies):
    for path in results:
        accuracies.append(get_accuracy(path))


cluster_label_accuracy = []
cluster_pseudo_label_accuracy = []
supervised_accuracy = []

get_accuracies(cluster_label_results, cluster_label_accuracy)
get_accuracies(cluster_pseudo_label_results, cluster_pseudo_label_accuracy)
# get_accuracies(supervised_results, supervised_accuracy)

print(cluster_pseudo_label_accuracy)
print(cluster_label_accuracy)
print(supervised_accuracy)

cluster_label = pd.DataFrame(
    data={
        'CL': cluster_label_accuracy,
        'Pseudo-label CL': cluster_pseudo_label_accuracy
        # 'Supervised': supervised_accuracy
    },
    index=['LED', 'RBF', 'RT', 'Electricity', 'Cover Type', 'Airlines'])

cluster_label.plot.bar(rot=0)
plt.savefig('analyze/cluster_and_label.png')
