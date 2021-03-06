__author__ = 'Abhishek'

import arff,os, operator
import numpy as np
import matplotlib.pyplot as plt

def getPurity(filename):
    clusters = int(filename.split('=')[1].split('.')[0])
    countdict = {}
    # print filename
    for row in arff.load(filename):
        clusterid = row.Cluster
        if clusterid not in countdict:
            countdict[clusterid] = {}
        if row.f2 not in countdict[clusterid]:
            countdict[clusterid][row.f2] = 1
        else:
            countdict[clusterid][row.f2] += 1

    # print clusters
    # print countdict

    maxtotal = 0
    alltotal = 0
    for cluster in countdict:
        maxtotal += max(countdict[cluster].values())
        alltotal += sum(countdict[cluster].values())
    purity = float(maxtotal) / alltotal
    return purity

def plotPurity(puritymat):
    plt.plot(puritymat)
    plt.xlabel('Clusters')
    plt.ylabel('Purity')
    plt.title('Variation of purity with clusters')
    plt.show()

if __name__ == "__main__":
    dirname = "Q3Out/clusterwise/"
    filenames = os.listdir(dirname)
    puritymat = np.zeros(len(filenames))    #Sensitive to files with extensions other than '.arff'
    for file in filenames:
        # print "Purity for " + file + "is " + str(purity)
        if file.endswith('arff'):
            clusters = int(file.split('=')[1].split('.')[0])
            puritymat[clusters-1] = getPurity(dirname + file)
            # print clusters, puritymat[clusters-1]
    print puritymat
    plotPurity(puritymat)
    # For k=8, purity = 0.533