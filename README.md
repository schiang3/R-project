# R-project
#Principal component analysis
/We applied Principal component analysis to do dimension reduction because there are strongly correlated variables in the dataset by checking corr.test, colSums(MTest) - 1 (psych package) and ggplot. 
PCA is a statistical procedure, and it helps us to determine the importance of variables and convert the correlated variance into new subsets which are components. 
After checking correlation, we create PCA by prcomp. We use rotation of loading and scree plot to choose components. 
These components become new variances, and they can conduct to Linear Discriminant Analysis and random forest to classify diagnosis. 

Random forest
Random forest is similar to decision tree method, but it corrects the overfitting problem. 
Overfitting occurs in the situation when the accuracy of training data is much higher than the accuracy of test data.
It creates multiple decision trees by random select sample in training set, and the predictive classification of test set is based on majority vote between trees in training set. 
It can be used in classification and regression. It is capable of handling missing values and huge dataset [7]. 
We use this method to predict the class label of diagnosis.

#Results 
#PCA
We use a scree plot to visualize the Principal Components to choose suitable numbers of components. In the scree plot, evaluating components by drawing the line at the eigenvalues is equal to one, so we select the components that the eigenvalues above one. In the scree plot, it shows elbow is located at component 3; there are six components are greater than eigenvalues = 1. We use utilize PCA plots to visualize what variances are included in each component. The result from Principal component analysis shows the dataset needs 29 components to explain 100% of the total variation. We initial use six components with varimax rotation and check its loading using cutoff value 0.4 to 0.6. Aftering trying two to six of components with different cutoff values, the best result is to use six components with varimax rotation and cutoff=.568 because it shows less cross loading problem, and six components can explain 88.76% of the total variation. These six components are RC1, RC2, RC5, RC3, RC4, and RC6. The variable Compactness_worst isn’t included in the result because it exists in RC2 and RC5 and several variables will also cross load into RC2 and RC5 if we set cutoff = 0.5.
The correlation plot shows variables in each component are strongly or moderately correlated. The biggest square of one component has 12 variables in it which is RC1.

The result of using psych::principal(cancer3, rotate="varimax", nfactors=6, scores=TRUE), and print(bc2$loadings, cutoff=.568, sort=T) shows as table 1.

Table 1
RC1	0.955* radius_mean  +0.955* perimeter_mean+ 0.97* area_mean+0.662* concavity_mean + 0.815*concave.points_mean +0.827* radius_se + 0.815* perimeter_se  +0.872* area_se  +0.952* radius_worst   +0.948* perimeter_worst  +0.954*area_worst  +0.7* concave.points_worst
RC2	0.569* compactness_mean+ 0.896*compactness_se +0.887* concavity_se +0.732*concave.points_se + 0.862*fractal_dimension_se +0.575*concavity_worst
RC3	0.64*texture_se+ 0.768* smoothness_se
RC4	0.909*texture_mean +0.953*texture_worst
RC5	0.833*smoothness_mean+0.589*fractal_dimension_mean+0.943* smoothness_worst+0.658* fractal_dimension_worst
RC6	0.721* symmetry_mean + 0.769* symmetry_se + 0.745* symmetry_worst

PCA has 6 components and explains 88% of total variables. 
#Random forest
We do train test split before using random forest, 80% of data into training set and 20% of data into test set.  
We train the model in the training set and apply the model on test set. 
Using confusion matrix to evaluate prediction on test set, there’re two cases are false negative, and two cases are false positives. 
The accuracy of the Random forest using PCA components (thresh = 0.99) is 96.46%. 
The false negative rate is 4.76%. The sensitivity is 95.24%.
Table: confusion matrix from test set using random forest:
	        Reference
Prediction	M	  B
          M 40	2
          B	2	 69
 
