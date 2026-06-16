#include <stdio.h>
#include <stdlib.h>

#include "app.h"

int main(void)
{
    printf("Hello from %s v%s\n", APP_NAME, APP_VERSION);
    return EXIT_SUCCESS;
}
