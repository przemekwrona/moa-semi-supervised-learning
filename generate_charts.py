import numpy as np
import matplotlib.pyplot as plt
import pandas as pd

plt.close("all")

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

self_training_bdf_results = [
    'results/led_results_self_training_bdf_95.csv',
    'results/rbf_results_self_training_bdf_95.csv',
    'results/rt_results_self_training_bdf_95.csv',
    'results/electricity_results_self_training_bdf_95.csv',
    'results/cover_type_results_self_training_bdf_95.csv',
    'results/airlines_results_self_training_bdf_95.csv'
]

self_training_bda_results = [
    'results/led_results_self_training_bda_95.csv',
    'results/rbf_results_self_training_bda_95.csv',
    'results/rt_results_self_training_bda_95.csv',
    'results/electricity_results_self_training_bda_95.csv',
    'results/cover_type_results_self_training_bda_95.csv',
    'results/airlines_results_self_training_bda_95.csv'
]

self_training_bpf_results = [
    'results/led_results_self_training_bpf_95.csv',
    'results/rbf_results_self_training_bpf_95.csv',
    'results/rt_results_self_training_bpf_95.csv',
    'results/electricity_results_self_training_bpf_95.csv',
    'results/cover_type_results_self_training_bpf_95.csv',
    'results/airlines_results_self_training_bpf_95.csv'
]

self_training_bpa_results = [
    'results/led_results_self_training_bpa_95.csv',
    'results/rbf_results_self_training_bpa_95.csv',
    'results/rt_results_self_training_bpa_95.csv',
    'results/electricity_results_self_training_bpa_95.csv',
    'results/cover_type_results_self_training_bpa_95.csv',
    'results/airlines_results_self_training_bpa_95.csv'
]

self_training_ipf_results = [
    'results/led_results_self_training_ipf_95.csv',
    'results/rbf_results_self_training_ipf_95.csv',
    'results/rt_results_self_training_ipf_95.csv',
    'results/electricity_results_self_training_ipf_95.csv',
    'results/cover_type_results_self_training_ipf_95.csv',
    'results/airlines_results_self_training_ipf_95.csv'
]

self_training_ipa_results = [
    'results/led_results_self_training_ipa_95.csv',
    'results/rbf_results_self_training_ipa_95.csv',
    'results/rt_results_self_training_ipa_95.csv',
    'results/electricity_results_self_training_ipa_95.csv',
    'results/cover_type_results_self_training_ipa_95.csv',
    'results/airlines_results_self_training_ipa_95.csv'
]

self_training_idw_results = [
    'results/led_results_self_training_idw_95.csv',
    'results/rbf_results_self_training_idw_95.csv',
    'results/rt_results_self_training_idw_95.csv',
    'results/electricity_results_self_training_idw_95.csv',
    'results/cover_type_results_self_training_idw_95.csv',
    'results/airlines_results_self_training_idw_95.csv'
]

self_training_iew_results = [
    'results/led_results_self_training_iew_95.csv',
    'results/rbf_results_self_training_iew_95.csv',
    'results/rt_results_self_training_iew_95.csv',
    'results/electricity_results_self_training_iew_95.csv',
    'results/cover_type_results_self_training_iew_95.csv',
    'results/airlines_results_self_training_iew_95.csv'
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

self_training_bdf_accuracy = []
self_training_bda_accuracy = []
self_training_bpf_accuracy = []
self_training_bpa_accuracy = []
self_training_ipf_accuracy = []
self_training_ipa_accuracy = []
self_training_idw_accuracy = []
self_training_iew_accuracy = []

get_accuracies(cluster_label_results, cluster_label_accuracy)
get_accuracies(cluster_pseudo_label_results, cluster_pseudo_label_accuracy)
# get_accuracies(supervised_results, supervised_accuracy)

get_accuracies(self_training_bdf_results, self_training_bdf_accuracy)
get_accuracies(self_training_bda_results, self_training_bda_accuracy)
get_accuracies(self_training_bpf_results, self_training_bpf_accuracy)
get_accuracies(self_training_bpa_results, self_training_bpa_accuracy)
get_accuracies(self_training_ipa_results, self_training_ipa_accuracy)
get_accuracies(self_training_ipf_results, self_training_ipf_accuracy)
get_accuracies(self_training_idw_results, self_training_idw_accuracy)
get_accuracies(self_training_iew_results, self_training_iew_accuracy)

print(cluster_pseudo_label_accuracy)
print(cluster_label_accuracy)
print(supervised_accuracy)

print(self_training_bdf_accuracy)
print(self_training_bda_accuracy)
print(self_training_bpf_accuracy)
print(self_training_bpa_accuracy)
print(self_training_ipa_accuracy)
print(self_training_ipf_accuracy)
print(self_training_idw_accuracy)
print(self_training_iew_accuracy)

cluster_label = pd.DataFrame(
    data={
        'CL': cluster_label_accuracy,
        'Pseudo-label CL': cluster_pseudo_label_accuracy
        # 'Supervised': supervised_accuracy
    },
    index=['LED', 'RBF', 'RT', 'Electricity', 'Cover Type', 'Airlines'])

cluster_label.plot.bar(rot=0)
plt.savefig('analise/cluster_and_label.png')

self_training = pd.DataFrame(
    data={
        'BDF': np.round(self_training_bdf_accuracy, 2),
        'BDA': np.round(self_training_bda_accuracy, 2),
        'BPF': np.round(self_training_bpf_accuracy, 2),
        'BPA': np.round(self_training_bpa_accuracy, 2),
        'IPF': np.round(self_training_ipf_accuracy, 2),
        'IPA': np.round(self_training_ipa_accuracy, 2),
        'IDW': np.round(self_training_idw_accuracy, 2),
        'IEW': np.round(self_training_iew_accuracy, 2)
    },
    index=['LED', 'RBF', 'RT', 'Electricity', 'Cover Type', 'Airlines'])

self_training.T.to_csv('analise/self_training_results.csv')

# plt.show()
