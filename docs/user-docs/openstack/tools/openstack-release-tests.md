# Running OpenStack Release Tests

```console

    USAGE: openstack_regression_tests_runner.sh OPTIONS

    Run Openstack regression tests.

    OPTIONS:
        --func-test-target TARGET_NAME
            Provide the name of a specific test target to run.
        --func-test-pr PR_ID
            Provides similar functionality to Func-Test-Pr in commit message.
            Set to zaza-openstack-tests Pull Request ID.
        --skip-modify-bundle-constraints
            By default we modify test bundle constraints to ensure that
            applications have the resources they need. For example nova-compute
            needs to have enough capacity to boot the vms required by the
            tests.
        --help
            This help message.

