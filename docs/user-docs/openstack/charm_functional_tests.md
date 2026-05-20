# Running Charm Functional Tests

The OpenStack charms use the [zaza](https://github.com/openstack-charmers/zaza) test framework to run functional tests maintained in [zaza-openstack-tests](https://github.com/openstack-charmers/zaza-openstack-tests). Which tests are run and what type of deployment they are run against is defined within a charm under src/tests or tests (the former is used by reactive charms and the latter by classic charms).

For stable branches stable/2024.1 (or stable/noble) to stable/yoga (or stable/jammy) the charms support running all CI, tests, linting etc with Python 3.10 and charmcraft 3.x/stable on Jammy.

In stsstack-bundles we provide openstack/tools/charmed_openstack_functest_runner.sh to simplify running these tests in a Prodstack environment. First the charm is built then tested by deploying an Openstack environment and running tests against it.

## Troubleshooting

Zaza executes tests in phases; deploy, configure, test. If one of these phases fails the runner supports re-running a specific phase once the cause of the failure has been resolved. The most
