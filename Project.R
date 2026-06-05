wine_data  = read.csv("C:/Users/ajayp/OneDrive/Documents/Stats applied regession/Project/winequality-red.csv",header = TRUE)
wine_data

length(wine_data)

# Create a linear regression model with all predictors (Xi's) predicting Y
model = lm(quality ~ fixed.acidity + volatile.acidity + citric.acid + residual.sugar + chlorides + free.sulfur.dioxide + total.sulfur.dioxide + density + pH + sulphates + alcohol, data = wine_data)
summary(model)

coefficients_table <- coef(summary(model))[-1, ]
t_values <- coefficients_table[, "t value"]
variable_names <- rownames(coefficients_table)
barplot(t_values, names.arg = variable_names, xlab = "Variable", ylab = "t-value", col = "skyblue", main = "T-values of Linear Regression Coefficients", cex.names = 0.8, las = 2)

# Calculate ANOVA table
anova_table <- anova(model)
anova_table

# Extract sum of squares values from ANOVA table
sum_sq_values <- c(16.04, 143.57, 0.02, 0.16, 13.06, 2.97, 30.09, 61.31, 7.15, 55.70, 45.67, 666.41)

# Create variable names
variable_names <- c("fixed acidity", "volatile acidity", "citric acid", "residual sugar", "chlorides", "free sulfur dioxide", "total sulfur dioxide", "density", "pH", "sulphates", "alcohol", "Residuals")

# Plot sum of squares values
barplot(sum_sq_values, names.arg = variable_names, xlab = "Variable", ylab = "Sum of Squares", col = "skyblue", main = "Sum of Squares from ANOVA Table")

pairs(wine_data)

# Predict y_hat using the fitted model and the dataset
y_hat <- predict(model, newdata = wine_data[-12])
y_hat

# Assuming you have the predicted y_hat values stored in a vector named y_hat

# Define a function to create scatter plots of y_hat vs. each variable
plot_y_hat_vs_variable <- function(variable_name, variable_values, y_hat) {
  ggplot(data = data.frame(variable = variable_values, y_hat = y_hat), aes(x = variable, y = y_hat)) +
    geom_point(color = "blue", alpha = 0.6) +
    geom_smooth(method = "lm", se = FALSE, color = "red") +
    labs(title = paste("Predicted y vs.", variable_name),
         x = variable_name, y = "Predicted y") +
    theme_minimal()
}

# Plot y_hat vs. each variable separately
plots <- list()
plots[[1]] <- plot_y_hat_vs_variable("fixed.acidity", wine_data$fixed.acidity, y_hat)
plots[[2]] <- plot_y_hat_vs_variable("volatile.acidity", wine_data$volatile.acidity, y_hat)
plots[[3]] <- plot_y_hat_vs_variable("citric.acid", wine_data$citric.acid, y_hat)
plots[[4]] <- plot_y_hat_vs_variable("residual.sugar", wine_data$residual.sugar, y_hat)
plots[[5]] <- plot_y_hat_vs_variable("chlorides", wine_data$chlorides, y_hat)
plots[[6]] <- plot_y_hat_vs_variable("free.sulfur.dioxide", wine_data$free.sulfur.dioxide, y_hat)
plots[[7]] <- plot_y_hat_vs_variable("total.sulfur.dioxide", wine_data$total.sulfur.dioxide, y_hat)
plots[[8]] <- plot_y_hat_vs_variable("density", wine_data$density, y_hat)
plots[[9]] <- plot_y_hat_vs_variable("pH", wine_data$pH, y_hat)
plots[[10]] <- plot_y_hat_vs_variable("sulphates", wine_data$sulphates, y_hat)
plots[[11]] <- plot_y_hat_vs_variable("alcohol", wine_data$alcohol, y_hat)

# Print the plots
print(plots[[1]])
print(plots[[2]])
print(plots[[3]])
print(plots[[4]])
print(plots[[5]])
print(plots[[6]])
print(plots[[7]])
print(plots[[8]])
print(plots[[9]])
print(plots[[10]])
print(plots[[11]])

# Load the necessary library
library(gridExtra)

# Arrange plots in a grid layout
grid.arrange(
  plots[[1]], plots[[2]], plots[[3]], plots[[4]], plots[[5]],
  plots[[6]], plots[[7]], plots[[8]], plots[[9]], plots[[10]],
  plots[[11]],
  nrow = 3
)



resi = residuals(model)
resi

# Plot residuals vs. y_hat
plot(y_hat, resi, xlab = "Predicted values (y_hat)", ylab = "Residuals",
     main = "Residuals vs. Predicted Values", pch = 16, col = "blue")
abline(h = 0, col = "red")  # Add a horizontal line at y = 0


model1 = lm(log(quality) ~ fixed.acidity + volatile.acidity + citric.acid + chlorides + free.sulfur.dioxide + total.sulfur.dioxide + density + pH + sulphates + alcohol, data = wine_data)
model1
summary(model1)

coefficients_table1 <- coef(summary(model1))[-1, ]
t_values1 <- coefficients_table1[, "t value"]
variable_names1 <- rownames(coefficients_table1)
barplot(t_values1, names.arg = variable_names1, xlab = "Variable", ylab = "t-value", col = "skyblue", main = "T-values of Linear Regression Coefficients", cex.names = 0.8, las = 2)

anova_table1 = anova(model1)
anova_table1

# Define sums of squares from the ANOVA table
sums_of_squares <- c(0.4853, 4.8377, 0.0069, 0.3862, 0.0512, 0.7913, 1.3041, 0.1236, 1.5325, 2.0376)

# Define variable names
variables <- c("fixed.acidity", "volatile.acidity", "citric.acid", "chlorides", 
               "free.sulfur.dioxide", "total.sulfur.dioxide", "density", "pH", 
               "sulphates", "alcohol")

# Plot the graph
barplot(sums_of_squares, names.arg = variables, col = "skyblue",
        main = "Sums of Squares from ANOVA Table", xlab = "Variables", ylab = "Sum of Squares")

model2 = lm((quality)^-0.5 ~ fixed.acidity + volatile.acidity + citric.acid + chlorides + free.sulfur.dioxide + total.sulfur.dioxide + density + pH + sulphates + alcohol, data = wine_data)
model2
summary(model2)


#REduced model
model_red = lm(quality ~ volatile.acidity + chlorides + free.sulfur.dioxide + total.sulfur.dioxide + pH + sulphates + alcohol, data = wine_data)
summary(model_red)



# Load the MASS package
library(MASS)
boxcox(model, lambda = seq(-0.25, 0.75, by = 0.05), plotit = TRUE)
model_cox = lm(quality^0.62 ~ fixed.acidity + volatile.acidity + citric.acid + residual.sugar + chlorides + free.sulfur.dioxide + total.sulfur.dioxide + density + pH + sulphates + alcohol, data = wine_data)
plot(fitted(model_cox), studres(model_cox), col = "dodgerblue",
     pch = 20, cex = 1.5, xlab = "Fitted", ylab = "Residuals")
abline(h = 0, lty = 2, col = "darkorange", lwd = 2)
summary(model_cox)



modelx = lm(log(quality) ~ volatile.acidity + chlorides + free.sulfur.dioxide + total.sulfur.dioxide + density + sulphates + alcohol, data = wine_data)
modelx
summary(modelx)
