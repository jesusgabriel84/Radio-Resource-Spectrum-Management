<!-- Radio Resource and Spectrum Management -->
## Frequency band selection
In this simulation a grid with three hexagonal sectors is created, where each cell contains four layers of mobile technologies corresponding each layer to a frequency band. The frequency bands considered for this simulation are the following: 2.6 GHz, 2.1 GHz, 1.8 GHz and 900 MHz, which are typical LTE bands. Since in wireless systems, the pathloss is a function of the frequency, it is expected that coverage of the cell is as well, i.e. the higher the frequency, the smaller the cell is:

```sh
Coverage@900MHz > Coverage@1.8GHz > Coverage@2.1GHz > Coverage@2.6GHz
```



### Built With
* [Matlab2018](https://se.mathworks.com/products/matlab.html)