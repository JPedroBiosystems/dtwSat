###############################################################
#                                                             #
#   (c) Victor Maus <vwmaus1@gmail.com>                       #
#       Institute for Geoinformatics (IFGI)                   #
#       University of Muenster (WWU), Germany                 #
#                                                             #
#       Earth System Science Center (CCST)                    #
#       National Institute for Space Research (INPE), Brazil  #
#                                                             #
#                                                             #
#   R Package dtwSat - 2016-01-16                             #
#                                                             #
###############################################################


#' @title Plotting TWDTW matching points 
#' @author Victor Maus, \email{vwmaus1@@gmail.com}
#' 
#' @description Method for plotting the matching points from   
#' TWDTW analysis.
#' 
#' @param x An \code{\link[dtwSat]{twdtw-class}} object.
#' @param p.names A \link[base]{character} or \link[base]{integer}
#' vector with the patterns identification. If not declared the function 
#' will plot one alignment for each pattern in \code{x}.
#' @param n An \link[base]{integer} vector with the number of alignments to plot.
#' It can be use as vector of indices combined with \code{p.names} to plot 
#' specific matches. If not declared the function will plot the best match for 
#' each pattern.
#' @param attr An \link[base]{integer} or \link[base]{character} vector 
#' indicating the attribute for plotting. Default is 1.
#' @param shift A number, it shifts the pattern position in the \code{x}
#' direction. Default is 0.5.
#' @param show.dist show the distance for each alignment. Default is FALSE.
#' @docType methods
#' 
#' @return A \link[ggplot2]{ggplot} object
#' 
#' @seealso 
#' \code{\link[dtwSat]{twdtw-class}}, 
#' \code{\link[dtwSat]{twdtw}}, 
#' \code{\link[dtwSat]{plotPaths}}, 
#' \code{\link[dtwSat]{plotCostMatrix}},
#' \code{\link[dtwSat]{plotAlignments}}, 
#' \code{\link[dtwSat]{plotClassification}}, and 
#' \code{\link[dtwSat]{plotPatterns}}.
#' 
#' @examples
#' 
#' log_fun = logisticWeight(alpha=-0.1, beta=100)
#' matches = twdtw(x=example_ts, patterns=patterns.list, weight.fun = log_fun, 
#'         normalize.patterns=TRUE, patterns.length=23, keep=TRUE)
#' 
#' gp = plotMatches(matches)
#' gp
#' 
#' gp = plotMatches(x=matches, p.names=1)
#' gp
#' 
#' gp = plotMatches(x=matches, p.names="Cotton")
#' gp
#' 
#' gp = plotMatches(x=matches, p.names="Soybean", n = 4)
#' gp
#' 
#' gp = plotMatches(x=matches, p.names=c("Soybean","Cotton"), 
#'      n = c(3,3))
#' gp
#' 
#' @export
plotMatches = function(x, p.names, n, attr=1, shift=0.5, show.dist=FALSE){
  
  if(missing(p.names)) {
    p.names = getPatternNames(x)
  } else {
    p.names = getPatternNames(x, p.names)
  }
  
  ## Get data
  internals  = getInternals(x, p.names)
  if(is.null(internals))
    stop("plot methods requires twdtw internals, set keep=TRUE on twdtw() call")
  matching   = getMatches(x, p.names)
  alignments = getAlignments(x, p.names)  
  ts = getTimeSeries(x)
  patterns = getPatterns(x, p.names)
  
  if(missing(n)) n = rep(1, length(p.names))
  if(length(n)==1) {
    p.names = rep(p.names, each = n)
    n = rep(1:n, length(unique(p.names)))
  }
  if(length(n)!=length(p.names))
    stop("n is not the same length as p.names")
  
  names(n) = p.names
  xx = ts[,attr,drop=FALSE]
  tx = index(xx)
  
  y.labels = pretty_breaks()(range(xx, na.rm = TRUE))
  y.breaks = y.labels
  
  # Get time series 
  df.x = data.frame(Time=tx, xx)
  
  # Build matching points data.frame
  df.list = lapply(seq_along(p.names), function(i){
    p = p.names[i]
    yy = patterns[[p]][,attr,drop=FALSE]
    ty = index(yy)
    
    if(n[i]>length(matching[[p]])){
      warning("alignment index out of bounds", call. = TRUE)
      return(NULL)
    }
      
    map = data.frame(matching[[p]][[n[i]]])
    delay = tx[map$index2[1]]-ty[1]
    if(delay>0)
      delay = delay + diff(range(ty, na.rm = TRUE))*shift
    if(delay<0)
      delay = delay - diff(range(ty, na.rm = TRUE))*shift
    
    df.pt = data.frame(Time=ty[map$index1]+delay, yy[map$index1,,drop=FALSE]+max(xx, na.rm = TRUE))
    df.match.pt = df.pt
    df.match.pt$alig = paste(1:nrow(map),p,n[i],sep="_")
    df.match.x = df.x[map$index2,]
    df.match.x$alig = paste(1:nrow(map),p,n[i],sep="_")
    df.match = rbind(df.match.pt, df.match.x)
    df.pt$Matches = paste(p,n[i])
    df.dist = data.frame(Time=max(ty[map$index1]+delay)+diff(range(df.pt$Time))/3,
                         max(df.pt[,names(yy)]),Dist=alignments$distance[n[i]])
    names(df.dist) = c("Time", names(yy), "Dist")
    list(match=df.match, pt=df.pt, dist=df.dist)
  })
  
  df.pt = do.call("rbind", lapply(df.list, function(df) df$pt))
  df.match = do.call("rbind", lapply(df.list, function(df) df$match))
  
  attr_names = names(df.x)[2]
  gp = ggplot(data=df.x, aes_string(x='Time', y=eval(attr_names))) +
    geom_line() +
    geom_line(data=df.pt, aes_string(x='Time', y=eval(attr_names), 
                                     group='Matches', colour='Matches')) + 
    geom_line(data=df.match, linetype = 2, colour = "grey", 
              aes_string(x='Time', y=eval(attr_names), group='alig')) + 
    scale_y_continuous(breaks=y.breaks, labels=y.labels) +
    scale_x_date(breaks=waiver(), labels=waiver()) +
    ylab(attr_names) 
  
  if(show.dist){
    df.dist = do.call("rbind", lapply(df.list, function(df) df$dist))
    df.dist$Dist = paste("Distance:",round(df.dist$Dist,2))
    gp = gp + geom_text(data=df.dist, mapping = aes_string(x='Time', y=eval(attr_names), label='Dist')) 
  }
  
  gp
}
