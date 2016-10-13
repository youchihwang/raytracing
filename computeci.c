#include <stdio.h>
#include <immintrin.h>
#include <omp.h>
#include <math.h>
#include <time.h>
#include "computeci.h"

double compute_ci(double *min, double *max, double data[SAMPLE_SIZE])
{
    double mean = 0.0;
    double stddev = 0.0;
    double stderror;
    int i = 0;

    //mean
    for(i = 0; i < SAMPLE_SIZE; i++) {
        mean += data[i];
    }
    mean /= SAMPLE_SIZE;

    //standard deviation
    for(i = 0; i < SAMPLE_SIZE; i++) {
        stddev += (data[i] - mean) * (data[i] - mean);
    }
    stddev = sqrt(stddev / (double)SAMPLE_SIZE);

    //standard deviation
    stderror = stddev / sqrt((double)SAMPLE_SIZE);

    *min = mean - (1.96 * stderror);
    *max = mean + (1.96 * stderror);


    return mean;
}
