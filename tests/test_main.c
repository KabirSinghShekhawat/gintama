#include <assert.h>
#include <stdio.h>
#include <string.h>

#include "app.h"

static void test_app_name(void)
{
    assert(strcmp(APP_NAME, "my-c-app") == 0);
    printf("  ok  test_app_name\n");
}

static void test_app_version(void)
{
    assert(strlen(APP_VERSION) > 0);
    printf("  ok  test_app_version\n");
}

int main(void)
{
    printf("Running tests...\n");
    test_app_name();
    test_app_version();
    printf("All tests passed.\n");
    return 0;
}
