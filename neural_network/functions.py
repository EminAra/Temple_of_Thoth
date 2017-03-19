import numpy as np


def linear_combination(variables, weights):
    """Linear Combination.

    Args:
        weights: np.array, n x m
        variables: np.array, 1 x m

    Where m is the number of features and n is the number of classes/neurons.
    """
    return np.dot(variables, weights.T)
