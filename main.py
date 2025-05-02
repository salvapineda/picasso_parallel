import os
import random  
import pandas as pd  # Ensure pandas is imported
import numpy as np  # Ensure numpy is imported
import time  # Import time for the delay

# Function to simulate a computational task with a delay
def f(a, b, c):
    time.sleep(5)  # Wait for 5 seconds to simulate a time-consuming task
    return a + b + c

# Create a DataFrame with random numbers between 0 and 1
cases = pd.DataFrame({
    'a': np.random.rand(100),  # Random values for column 'a'
    'b': np.random.rand(100),  # Random values for column 'b'
    'c': np.random.rand(100)   # Random values for column 'c'
})
print('n_cases=', len(cases))  # Print the total number of cases

# Function to create subcases for parallel processing
# Divides the cases into smaller chunks based on the number of tasks (sarray)
def subcases(n_cases, sarray, slurm):
    if n_cases % sarray != 0:
        # Ensure the number of cases is divisible by the number of tasks
        raise ValueError(f"n_cases ({n_cases}) is not divisible by sarray ({sarray}).")
    else:  
        n_tasks = n_cases // sarray  # Calculate the number of tasks per subcase
        numbers = list(range(n_cases))  # Create a list of case indices
        random.seed(0)  # Set seed for reproducibility
        random.shuffle(numbers)  # Shuffle the indices randomly
        # Split the indices into sublists for each task
        sublists = [numbers[i:i + n_tasks] for i in range(0, n_cases, n_tasks)]
        return sublists[slurm]  # Return the sublist for the current SLURM job

# Determine the number of parallel jobs to be sent to the cluster
sarray = 20  # Number of tasks to divide the cases into

# SLURM job index (set to 0 for local testing)
slurm = 0
# Uncomment the following line when running on a SLURM cluster
# slurm = int(os.environ['SLURM_ARRAY_TASK_ID']) - 1

# Run the function for the subcases associated with the current SLURM job
for i in subcases(len(cases), sarray, slurm):
    # Extract the values for the current case
    a = cases.loc[i, 'a']
    b = cases.loc[i, 'b']
    c = cases.loc[i, 'c']
    # Compute the result using the function `f`
    z = f(a, b, c)
    # Write the results to a CSV file named after the SLURM job index
    file_handle = open(str(slurm) + '.csv', 'a')  # Open file in append mode
    file_handle.write(str(a) + ',' + str(b) + ',' + str(c) + ',' + str(z) + '\n')  # Write the result
    file_handle.close()  # Close the file
