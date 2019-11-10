<!-- Radio Resource and Spectrum Management -->
## Frequency band selection
In this simulation a grid with three hexagonal sectors is created, where each cell contains four layers of mobile technologies corresponding each layer to a frequency band. The frequency bands considered for this simulation are the following: 2.6 GHz, 2.1 GHz, 1.8 GHz and 900 MHz, which are typical LTE bands. Since in wireless systems, the pathloss is a function of the frequency, it is expected that coverage of the cell is as well, i.e. the higher the frequency, the smaller the cell is:

```sh
Coverage@900MHz > Coverage@1.8GHz > Coverage@2.1GHz > Coverage@2.6GHz
```

The coverage of the cells in the simulation is a function of the 900MHz layer (the biggest coverage), then the coverage area of the layers is considered as follows:

* Layer1800 is 65% of the coverage area of the Laye900.
* Layer2100 is 45% of the coverage area of the Laye900.
* Layer2600 is 30% of the coverage area of the Laye900.

These parameters can be adjusted by modifying the following variables in the initial parameters of the script:

```sh
coverage_1800 = 0.65
coverage_2100 = 0.45
coverage_2600 = 0.30
```

Each cell is a multidimensional array containing cell's hexagons created with the function:

```sh
function [xdim,ydim] = create_hex(ymax,xcoord,ycoord)
```

Where:
* `ymax` : is the long leg of the hexagon
* `xcoord` : is the coordinates of the center of the hexagon in the 'x axis'
* `ycoord` : is the coordinates of the center of the hexagon in the 'y axis'

The resulting grid is as follows:

![Grid](images/grid.png)

### Built With
* [Matlab2018](https://se.mathworks.com/products/matlab.html)