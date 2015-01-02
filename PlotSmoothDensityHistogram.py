import numpy as np
import os
import glob
import matplotlib.pyplot as plt
from scipy import stats

def livePlot(file):
        m0,m1,m2 = np.loadtxt(file, unpack=True, skiprows=1)

        if m1.size<2:
                return 0	

        X, Y = np.mgrid[xmin:xmax:100j, ymin:ymax:100j]
        positions = np.vstack([X.ravel(), Y.ravel()])
        values = np.vstack([m1,m2])
        kernel = stats.gaussian_kde(values)
        Z = np.reshape(kernel.evaluate(positions).T, X.shape)
	
        mean=[np.mean(m1),np.mean(m2)]
        mean=float("{0:.2f}".format(np.linalg.norm(mean)))
        stdX=float("{0:.2f}".format(np.std(m1)))
        stdY=float("{0:.2f}".format(np.std(m2)))
        ax.set_title('Average Offset         : '+str(mean)+'\n'+'Standard Deviation X : '+str(stdX)+'\n'+'Standard Deviation Y : '+str(stdY))
        ax.imshow(np.rot90(Z), cmap=plt.cm.jet,
                  extent=[xmin, xmax, ymin, ymax])
        ax.plot(m1,m2, 'o', markersize=3.5, linewidth='3', markerfacecolor='r',markeredgecolor = 'black')
        ax.set_xlim([xmin, xmax])
        ax.set_ylim([ymin, ymax])

        plt.draw()
        ax.cla()

files=sorted(glob.glob('*.csv'))
if files:
        file=files[-1]
	
        xmin = -75
        xmax = 75
        ymin = -75
        ymax = 75
       
        fig = plt.figure(figsize=(8, 8))
        ax = fig.add_subplot(111)
        plt.ion()
        plt.show()

        while(True):
                livePlot(file)
