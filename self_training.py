import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
from pathlib import Path

plt.close("all")
Path("analyze").mkdir(parents=True, exist_ok=True)

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
    last_kappa = data_frame['Kappa Statistic (percent)'][-1:]
    return [pd.to_numeric(last_accuracy.values[0]), pd.to_numeric(last_kappa.values[0])]


def get_accuracies(results, accuracies, kappas):
    for path in results:
        statistic_results = get_accuracy(path)
        accuracies.append(statistic_results[0])
        kappas.append(statistic_results[1])


self_training_bdf_accuracy = []
self_training_bda_accuracy = []
self_training_bpf_accuracy = []
self_training_bpa_accuracy = []
self_training_ipf_accuracy = []
self_training_ipa_accuracy = []
self_training_idw_accuracy = []
self_training_iew_accuracy = []

self_training_bdf_kappa = []
self_training_bda_kappa = []
self_training_bpf_kappa = []
self_training_bpa_kappa = []
self_training_ipf_kappa = []
self_training_ipa_kappa = []
self_training_idw_kappa = []
self_training_iew_kappa = []

get_accuracies(self_training_bdf_results, self_training_bdf_accuracy, self_training_bdf_kappa)
get_accuracies(self_training_bda_results, self_training_bda_accuracy, self_training_bda_kappa)
get_accuracies(self_training_bpf_results, self_training_bpf_accuracy, self_training_bpf_kappa)
get_accuracies(self_training_bpa_results, self_training_bpa_accuracy, self_training_bpa_kappa)
get_accuracies(self_training_ipf_results, self_training_ipf_accuracy, self_training_ipf_kappa)
get_accuracies(self_training_ipa_results, self_training_ipa_accuracy, self_training_ipa_kappa)
get_accuracies(self_training_idw_results, self_training_idw_accuracy, self_training_idw_kappa)
get_accuracies(self_training_iew_results, self_training_iew_accuracy, self_training_iew_kappa)

print(self_training_bdf_accuracy)
print(self_training_bda_accuracy)
print(self_training_bpf_accuracy)
print(self_training_bpa_accuracy)
print(self_training_ipa_accuracy)
print(self_training_ipf_accuracy)
print(self_training_idw_accuracy)
print(self_training_iew_accuracy)

self_training_accuracy = pd.DataFrame(
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

self_training_accuracy.T.to_csv('./analyze/self_training_accuracy.csv')

self_training_kappa = pd.DataFrame(
    data={
        'BDF': np.round(self_training_bdf_kappa, 2),
        'BDA': np.round(self_training_bda_kappa, 2),
        'BPF': np.round(self_training_bpf_kappa, 2),
        'BPA': np.round(self_training_bpa_kappa, 2),
        'IPF': np.round(self_training_ipf_kappa, 2),
        'IPA': np.round(self_training_ipa_kappa, 2),
        'IDW': np.round(self_training_idw_kappa, 2),
        'IEW': np.round(self_training_iew_kappa, 2)
    },
    index=['LED', 'RBF', 'RT', 'Electricity', 'Cover Type', 'Airlines'])

self_training_kappa.T.to_csv('./analyze/self_training_kappa.csv')
