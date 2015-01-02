CSGO-aim-heatmaps
=================

The SourceMod plugin AimHeatmapData.sp calculates and saves data which can be used to generate a heatmap of the players aim accuracy. Example: http://i.imgur.com/uzZPBoZ.png

The python script PlotSmoothDensityHistrogram.py allows the plotting of hte recorded data in realtime.

Usage
----------------
Start the recording of aim data with the server command "sm_aimdata_record". The server will save all aim data in ..\sourcemod\ADD_[unique ID].csv until the recording is terminated with "sm_aimdata_stop". The data is recorded for all players on the server and indexed by the players userid in the first column of the output file. The second and thrid column contain x and y offsets from the enemys head.

PlotSmoothDensityHistrogram.py opens the last recorded ADD_*.csv file and plots a smooth density histogramm of the data. This plot is dynamically updated as the input file is updated. Example: http://youtu.be/eL7Y4Bj9-ho.


This work is licensed under cc-by-sa (http://creativecommons.org/licenses/by-sa/4.0/)
