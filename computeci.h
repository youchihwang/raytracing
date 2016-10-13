#include <stdio.h>

#define CLOCK_ID CLOCK_MONOTONIC_RAW
#define ONE_SEC 1000000000.0
#define SAMPLE_SIZE 5

double compute_ci(double *min, double *max, double data[SAMPLE_SIZE]);

