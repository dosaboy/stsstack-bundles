# Running Charm Functional Tests

```console

    USAGE: charmed_openstack_functest_runner.sh OPTIONS

    Run OpenStack charms functional tests manually in a similar way to how
    Openstack CI (OSCI) would do it. This tool should be run from within a
    charm root.

    Not all charms use the same versions and dependencies and an attempt is
    made to cover this here but in some cases needs to be dealt with as a
    pre-requisite to running the tool. For example some charms need their
    tests to be run using python 3.8 and others python 3.10. Some tests might
    require Juju 2.9 and others Juju 3.x - the assumption in this runner
    is that Juju 3.x is ok to use.

    OPTIONS:
        --func-test-target TARGET_NAME
            Provide the name of a specific test target to run. If none
            provided all tests are run based on what is defined in osci.yaml
            i.e. will do what osci would do by default. This option can be
            provided more than once.
        --func-test-pr PR_ID
            Provides similar functionality to Func-Test-Pr in commit message.
            Set to zaza-openstack-tests Pull Request ID.
        --no-wait
            By default we wait before destroying the model after a test run.
            This flag can used to override that behaviour.
        --manual-functests
            Runs functest commands separately (deploy,configure,test) instead
            of the entire suite.
        --remote-build USER@HOST,GIT_PATH
            Builds the charm in a remote location and transfers the charm file
            over. The destination needs to be prepared for the build and
            authorized for ssh. Implies --skip-build. Specify parameter as
            <destination>,<path>.

            Example: --remote-build ubuntu@10.171.168.1,~/git/charm-nova-compute
        --skip-build
            Skip building charm if already done to save time.
        --skip-modify-bundle-constraints
            By default we modify test bundle constraints to ensure that
            applications have the resources they need. For example
            nova-compute needs to have enough capacity to boot the vms
            required by the tests.
        --sleep TIME_SECS
            Specify amount of seconds to sleep between functest steps.
        --help
            This help message.

