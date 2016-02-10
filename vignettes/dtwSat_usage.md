---
title: "Time series analysis and visualization using dtwSat"
author: "Victor Maus^[National Institute for Space Research, Avenida dos Astronautas 1758, 12227010, São José dos Campos, Brazil.], ^[Institute for Geoinformatics, University of Münster, Heisenbergstraße 2, 48149 Münster, Germany]"
date: "2016-01-20"
output: 
  rmarkdown::html_vignette:
bibliography: references.bib
vignette: >
  %\VignetteIndexEntry{Time series analysis and visualization using dtwSat}
  %\VignetteEngine{knitr::rmarkdown}
  %\VignetteEncoding{UTF-8}
---

[dtwSat](https://cran.r-project.org/web/packages/dtwSat/index.html) implements the Time-Weighted Dynamic Time Warping (TWDTW) for multi-band satellite image time series analysis. It includes methods for analysis and visualization of results and for land use and land cover changes analysis. In this chapter we show the usage of [dtwSat](https://cran.r-project.org/web/packages/dtwSat/index.html) to perform a time series analysis and give some examples of the visualization methods. We use some predefined temporal patterns and a few samples of time series to highlight the potential of TWDTW for land use and land cover changes analysis using remote sensing time series.

### Introduction

[dtwSat](https://cran.r-project.org/web/packages/dtwSat/index.html) provides a Time-Weighted Dynamic Time Warping for remote sensing time series analysis developed. Its implementation allows the user define the weighting function, which can be used together with several families of step patterns imported from [dtw](https://cran.r-project.org/web/packages/dtw/index.html) (Giorgino 2009). The package has a set of methods for time series analysis and visualization as well as for land use and land cover changes analysis.

In this chapter give some details of the package implementation an examples of its usage for satellite time series analysis and classification.

### 

### References

Giorgino, Toni. 2009. “Computing and Visualizing Dynamic Time Warping Alignments in R: The dtw Package.” *Journal of Statistical Software* 31 (7): 1–24. doi:[10.18637/jss.v031.i07](http://dx.doi.org/10.18637/jss.v031.i07).

[1] National Institute for Space Research, Avenida dos Astronautas 1758, 12227010, São José dos Campos, Brazil.

[2] Institute for Geoinformatics, University of Münster, Heisenbergstraße 2, 48149 Münster, Germany