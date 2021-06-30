#!/usr/bin/env python

#Library management
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import networkx as nx
import seaborn as sns

# Setup protlink dataframe
print("Opening proteins link file")
protlink_data_frame = pd.read_csv('9096.prot.links.over500.txt', sep=' ', header = None)
protlink = nx.from_pandas_edgelist(protlink_data_frame, source = 0, target = 1)

# Setup domain dataframe
print("Opening PFAM domain file")
domain_data_frame = pd.read_csv('proteins_w_domains.txt', sep='\t', header = 0)
domain_data_frame=domain_data_frame.dropna()
domain_data_frame['over-under'] = np.nan

# Filter singles and Compute the degree
print("Generating the network of the protein linked")
parts_generator = nx.connected_components(protlink)
parts=list(parts_generator)
singles = [list(x)[0] for x in parts[1:]]
protlink.remove_nodes_from(singles)
protlink.degree
degree_list = [d for n, d in protlink.degree]

# Split Entry based on the degree (over and under 100)
print("Splitting the network based on the degree (over and under 100)")
for n, d in protlink.degree:
    if d > 100:
        domain_data_frame['over-under'].mask(domain_data_frame['Protein stable ID']==n,'over', inplace=True)
    elif d <= 100:
        domain_data_frame['over-under'].mask(domain_data_frame['Protein stable ID']==n,'under', inplace=True)




#domain_copy2=domain_data_frame.copy(deep=True)
print("Setting up the plotting dataframe")
domain_plot=domain_data_frame.groupby(['over-under','Protein stable ID']).agg(['nunique','count'])
domain_plot["unique"]=domain_plot["Pfam ID"]["nunique"]
domain_plot=domain_plot.drop(columns=["Pfam ID"]).reset_index(drop=False)

print("Generating the plot")
sns.boxplot(x="over-under", y="unique", data=domain_plot).set(title='Number of unique domain per Ensemble ID over and under 100 degree',
    xlabel='100 degree', 
    ylabel='Number of unique Pfam Domain')
plt.savefig('protein_domains_vs_string_degree.png', dpi=300)
print("Script done")

#ax = sns.boxplot(x="over-under", y="total_bill", data=domain_data_frame)