import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
from pathlib import Path

plt.close("all")
Path("analyze").mkdir(parents=True, exist_ok=True)


def get_results(suffix):
    return [
        'results/led_results_' + suffix + '.csv',
        'results/rbf_results_' + suffix + '.csv',
        'results/rt_results_' + suffix + '.csv',
        'results/electricity_results_' + suffix + '.csv',
        'results/cover_type_results_' + suffix + '.csv',
        'results/airlines_results_' + suffix + '.csv'
    ]


cluster_label_results = get_results('cluster_label_95')
cluster_pseudo_label_results = get_results('cluster_pseudo_label_95')
supervised_results = get_results('supervised')


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
get_accuracies(supervised_results, supervised_accuracy)

print(cluster_pseudo_label_accuracy)
print(cluster_label_accuracy)
print(supervised_accuracy)

cluster_label = pd.DataFrame(
    data={
        'CL': cluster_label_accuracy,
        'Pseudo-label CL': cluster_pseudo_label_accuracy,
        'Supervised': supervised_accuracy
    },
    index=['LED', 'RBF', 'RT', 'Electricity', 'Cover Type', 'Airlines'])

cluster_label.plot.bar(rot=0)
plt.savefig('analyze/cluster_and_label.png')
