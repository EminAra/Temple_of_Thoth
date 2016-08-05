library(ggplot2)
library(grid)
library(gridExtra)
#######
#EMing#
#######

#######################################
#Code from interwebz for multiplotting#
#######################################

multiplot <- function(..., plotlist=NULL, file, cols=1, layout=NULL) {
  library(grid)

  # Make a list from the ... arguments and plotlist
  plots <- c(list(...), plotlist)

  numPlots = length(plots)

  # If layout is NULL, then use 'cols' to determine layout
  if (is.null(layout)) {
    # Make the panel
    # ncol: Number of columns of plots
    # nrow: Number of rows needed, calculated from # of cols
    layout <- matrix(seq(1, cols * ceiling(numPlots/cols)),
                     ncol = cols, nrow = ceiling(numPlots/cols))
  }

  if (numPlots==1) {
    print(plots[[1]])

  } else {
    # Set up the page
    grid.newpage()
    pushViewport(viewport(layout = grid.layout(nrow(layout), ncol(layout))))

    # Make each plot, in the correct location
    for (i in 1:numPlots) {
      # Get the i,j matrix positions of the regions that contain this subplot
      matchidx <- as.data.frame(which(layout == i, arr.ind = TRUE))

      print(plots[[i]], vp = viewport(layout.pos.row = matchidx$row,
                                      layout.pos.col = matchidx$col))
    }
  }
}

#its best if mu's aren't too far away
mu.0.real  <- 5
mu.1.real  <- 9

#n.X0 must be smaller
n.X0 <- 400
n.X1 <- 800

X0  <-  rpois(n.X0, mu.0.real)  #50 points from a mu = 5, 20 data points pi.1 = 0.2
X1  <-  rpois(n.X1, mu.1.real) # 50 points from a mu = 10, 80 data points pi.2 = 0.8
#Because R repeats the shorter length, This made me age
X  <-  rbind(X0=X0[seq(X1)],X1)
X <- X[is.na(X)==F]

X  <-  as.data.frame(X)
X0  <- as.data.frame(X0)
X1  <-  as.data.frame(X1)


colnames(X)  <-  'i'
colnames(X0)  <-  'i0'
colnames(X1)  <-  'i1'



p1 <- ggplot(environment=environment()) + geom_histogram(data = X, aes(X$i, fill = '#2980b9'), binwidth=1, alpha = 0.4) +
           geom_histogram(data = X0, aes(X0$i0, fill = '#e74c3c'), binwidth=1, alpha = 0.4) +
           geom_histogram(data = X1, aes(X1$i1, fill = '#f1c40f'), binwidth=1, alpha = 0.4) +
           labs(x='X', y='Count', title='Original Distribution of Mixture of Possions')+
           scale_fill_manual(name="Distributions",values=c('#2980b9','#e74c3c','#f1c40f'),
                    labels=c("#e74c3c"=paste('Pois ~ mu =',round(mu.0.real,2), sep = ' '),
                             "#f1c40f"=paste('Pois ~ mu =',round(mu.1.real,2), sep = ' '),
                             "#2980b9"= 'Mixture of Poissons'))


#log.plot doesnt work

N <- nrow(X)

#initial guesses
mu.0  <- 3
mu.1 <- 15

colnames(X)  <-  'i'

#Parameters to estiate are mu1, mu2, pi.1, pi.2

#Matrix of P(Z), 2x1
pi  <-  matrix( nrow = 2 , ncol = 1 , data = c(0.5,0.5))

#This Q matrix will hold the responsibilities for every run, nx2
Q  <-  matrix( nrow = nrow(X) , ncol = 2, data = 0)

#Matrix of P(x), nx2
pois  <- matrix( nrow = nrow(X) , ncol = 2, data = 0)

#Likelihood improvement
L.q  <-  matrix(-1000)
log.diff  <- 1

while(abs(log.diff[1])>0.0001){
pois[,1] = dpois(X$i , mu.0)
pois[,2] = dpois(X$i , mu.1)

#E-Step
denom  <- (pois %*% pi)
Q[,1] = (pi[1,] * pois[,1])/denom
Q[,2] = (pi[2,] * pois[,2])/denom

#M-Step
N.0  <-  sum(Q[,1])
N.1  <-  sum(Q[,2])

pi[1,1]  <- N.0/N
pi[2,1]  <- N.1/N

mu.0  <- sum(Q[,1]*X)/N.0
mu.1  <- sum(Q[,2]*X)/N.1



#The lower bound log-likelihood
L.q  <- rbind(L.q,sum(Q[,1]*log((pi[1,]*pois[,1])/Q[,1])+Q[,2]*log((pi[2,]*pois[,2])/Q[,2])))
log.diff  <- (tail(L.q[,1],2) - (tail(L.q[,1],1)))/tail(L.q[,1],2)
}
#Plotting the likelihood improvement
L.plot  <-  as.data.frame(L.q[-1])
colnames(L.plot)  <- 'Likelihood'

log.plot <- ggplot(data = L.plot,aes(seq(1,nrow(L.plot)), Likelihood)) +
  geom_point(color='#9b59b6', cex=5, pch = 16) + xlab('Run')


#Assigning data points to clusters
labels  <- matrix(nrow = nrow(X), 0)

#I don't really like to use this for accuracy of clustering because EM is giving a nice
#probablisitic approach
labels[Q[,1]<Q[,2],]  <- 1

X0.  <- as.data.frame(X[labels==0,])
X1.  <- as.data.frame(X[labels==1,])

colnames(X0.) <- 'i0'
colnames(X1.) <- 'i1'

p2 <- ggplot(environment=environment()) +
  geom_histogram(data = X0., aes(X0.$i0, fill = '#e74c3c'), binwidth=1, alpha = 1) +
  geom_histogram(data = X1., aes(X1.$i1, fill = '#f1c40f'), binwidth=1,  alpha = 1) +
  labs(x='X', y='Count', title='Estimated Distribution of Mixture of Possions')+
  scale_fill_manual(name="Estimated Distributions",values=c('#e74c3c','#f1c40f'),
                    labels=c("#e74c3c"=paste('Pois ~ mu =',round(mu.0,2), sep = ' '),
                             "#f1c40f"=paste('Pois ~ mu =',round(mu.1,2), sep = ' ')))






multiplot(p1,p2,cols=2)



#Testing
X.test0 <- matrix(nrow = 20,rpois(20, mu.0.real))
X.test1 <- matrix(nrow = 80,rpois(80, mu.1.real))

X.test0 <- cbind(X.test0,0)
X.test1 <- cbind(X.test1,1)

X.test <- as.data.frame(rbind(X.test0,X.test1))
colnames(X.test) <- c('data','label')

preds <- as.numeric(dpois(X.test$data,mu.0)<dpois(X.test$data,mu.1))

accuracy.score <- sum(X.test$label == preds)/nrow(X.test)

print(accuracy.score)
#The more seperated the clusters are the better the EM performs as in accuracy of 1 and if
#they are overlapping too much all the data points will get assigned to one cluster
