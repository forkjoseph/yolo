#!/usr/bin/env python
## example...!
import numpy as np
import matplotlib as mpl
mpl.use('Agg')
import matplotlib.mlab as mlab
import matplotlib.pyplot as plt

# plts...
fig, ax = plt.subplots()

wmu, wsigma = 250, 50
cmu, csigma = 400, 50

wx = wmu + wsigma*np.random.f(25, 150, 50000)
cx = cmu + csigma*np.random.randn(50000)

wx = wx.astype(int)
cx = cx.astype(int)

print 'wx:', wx
print 'cx:', cx

# the histogram of the data
wn, wbins, wpatches = ax.hist(wx, 50, normed=1, facecolor='blue', alpha=0.5)
cn, cbins, cpatches = ax.hist(cx, 50, normed=1, facecolor='red', alpha=0.5)

# add a 'best fit' line
wy = mlab.normpdf(wbins, wmu, wsigma)
cy = mlab.normpdf(cbins, cmu, csigma)

wl = ax.plot(wbins, wy, 'b-', linewidth=1, label='Wifi')
cl = ax.plot(cbins, cy, 'r-', linewidth=1, label='4G')

lg = ax.legend(loc='best', shadow=True)
for label in lg.get_texts():
    label.set_fontsize('large')

for l in lg.get_lines():
    l.set_linewidth(1.5)

plt.xlabel('Latency [in msec]')
plt.ylabel('Probability')
plt.grid(True)

plt.savefig('fig1.png')
# plt.show()

del fig
del ax

# plts...
fig, ax = plt.subplots()

num_bins = 100

# the histogram of the data
wn, wbins = np.histogram(wx, bins=num_bins, normed=True)
cn, cbins = np.histogram(cx, bins=num_bins, normed=True)

wcdf = (np.cumsum(wn) * (wbins[1] - wbins[0]))
ccdf = (np.cumsum(cn) * (cbins[1] - cbins[0]))

ax.plot(wbins[1:], wcdf, 'b-', label='blue')
ax.plot(cbins[1:], wcdf, 'r-', label='red')

lg = ax.legend(loc='best', shadow=True)
for label in lg.get_texts():
    label.set_fontsize('large')

for l in lg.get_lines():
    l.set_linewidth(1.5)

plt.xlabel('x-axis')
plt.ylabel('y-axis')
plt.axis([180, 520, 0, 1.00])
plt.grid(True)

plt.savefig('fig2.png')
# plt.show()

