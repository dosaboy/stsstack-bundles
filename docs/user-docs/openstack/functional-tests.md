# Running Functional Tests

The `charmed_openstack_functest_runner.sh` script allows you to run Charmed OpenStack functional tests manually in a similar way to how OpenStack CI (OSCI) would execute them. This is useful for validating charms before submission and for local development and testing.

## Prerequisites

Before running functional tests, ensure you have:

- A working Juju 3.x installation (Juju 2.9.x is also supported but 3.x is recommended)
- Access to an OpenStack undercloud (e.g., Serverstack) via `novarc` credentials
- The charm you want to test cloned locally
- Required system tools: `yq`, `uv`, `lxd`, and `ipcalc`
- Sufficient resources on the undercloud for test deployments
- The charm must have an `osci.yaml` file defining test targets

The script will automatically install `yq` and `uv` if not already present.

## Basic Usage

Run the functional tests from within the charm root directory:

```console
./openstack/tools/charmed_openstack_functest_runner.sh
```

This will:
1. Build the charm
2. Identify all test targets defined in `osci.yaml`
3. Run voting tests first, followed by non-voting tests
4. Deploy, configure, and test each target
5. Clean up Juju models between test runs
6. Display a summary of results

## Common Options

### Run Specific Test Targets

To run only specific test targets instead of all targets:

```console
./openstack/tools/charmed_openstack_functest_runner.sh \
  --func-test-target "bionic-train" \
  --func-test-target "focal-ussuri"
```

List available targets:

```console
python3 openstack/tools/func_test_tools/identify_charm_func_test_jobs.py
```

### Skip Building the Charm

If you've already built the charm, save time by skipping the build step:

```console
./openstack/tools/charmed_openstack_functest_runner.sh --skip-build
```

### Manual Test Phases

Run test phases separately (deploy, configure, test) instead of the entire suite:

```console
./openstack/tools/charmed_openstack_functest_runner.sh --manual-functests
```

This allows you to:
- Deploy the test bundle and pause
- Make adjustments if needed
- Configure the deployment
- Run tests

### Re-run a Specific Phase

If a test fails and you want to retry a specific phase without redeploying:

```console
./openstack/tools/charmed_openstack_functest_runner.sh \
  --func-test-target "focal-ussuri" \
  --rerun deploy
```

Available phases: `deploy`, `configure`, `test`

### Don't Wait Before Destroying Models

By default, the script waits for confirmation before destroying test models between runs. Skip this wait:

```console
./openstack/tools/charmed_openstack_functest_runner.sh --no-wait
```

### Build on Remote Host

For faster builds or to offload build work to another machine:

```console
./openstack/tools/charmed_openstack_functest_runner.sh \
  --remote-build "ubuntu@10.171.168.1,~/git/charm-nova-compute"
```

The remote destination must be prepared and authorized for SSH. The charm file will be transferred to your local machine.

### Modify Bundle Constraints

By default, the script modifies test bundle constraints to ensure nova-compute has sufficient resources. To disable this:

```console
./openstack/tools/charmed_openstack_functest_runner.sh \
  --skip-modify-bundle-constraints
```

### Add Sleep Between Steps

To add delays between functional test steps (useful for debugging):

```console
./openstack/tools/charmed_openstack_functest_runner.sh --sleep 10
```

Time is specified in seconds.

### Use a Specific Functional Test PR

To use a pull request from the zaza-openstack-tests repository:

```console
./openstack/tools/charmed_openstack_functest_runner.sh \
  --func-test-pr 1234
```

## Workflow Example

A typical workflow for testing a charm:

```console
# Make changes to the charm
vim src/charm.py

# Run all functional tests
./openstack/tools/charmed_openstack_functest_runner.sh

# If a specific target fails, re-run just that phase
./openstack/tools/charmed_openstack_functest_runner.sh \
  --func-test-target "focal-ussuri" \
  --rerun test
```

## Understanding Test Results

After the test run completes, you'll see a summary:

```
Test results for charm nova-compute functional tests @ commit a1b2c3d:
  * bionic-train: SUCCESS
  * focal-ussuri: SUCCESS (non-voting)
  * jammy-yoga: FAILURE
```

- **SUCCESS**: Test passed
- **FAILURE**: Test failed - review logs for details
- **SKIPPED**: Test was not run (e.g., due to `--rerun` flag)
- **(non-voting)**: Test result doesn't block merging

Results are also saved to a log file that is displayed at the end of the run.

## Important Considerations

### Python Version

Different charms may require different Python versions for building and testing. The script attempts to detect the required version from `tox.ini` using the `basepython` setting. If not found, it defaults to Python 3.12.

### Juju 3.x and /tmp Directory

Juju 3.x is distributed as a confined snap and cannot write to `/tmp`. The script creates a temporary directory in `$HOME` instead: `~/charm-functests-tmp-XXXX`.

### Network Configuration

The script expects:
- A `novarc` file in your home directory with OpenStack credentials
- Access to three networks via the undercloud:
  - `subnet_${OS_USERNAME}-psd` (primary network)
  - `subnet_${OS_USERNAME}-psd-extra` (floating IP network)
  - Test network: `192.168.0.0/16`

### Resource Requirements

Ensure your undercloud has sufficient resources:
- nova-compute bundles need at least 8GB RAM and 80GB root disk to run tests that boot virtual machines
- The script automatically sets these constraints in test bundles

### Hook Errors

Before running a phase, if there are unit hook errors, the script will prompt you to resolve them. These must be cleared before proceeding.

## Troubleshooting

### Missing Dependencies

The script will automatically install `yq` and `uv` if not present. If other tools are missing:

```console
# Install ipcalc
sudo apt install ipcalc

# Initialize LXD
lxd init --auto
```

### Build Failures

- Check that `osci.yaml` exists in the charm root
- Ensure `metadata.yaml` is valid
- Check charmcraft version: the script will use the version specified in `osci.yaml`

### Test Deployment Failures

- Verify undercloud network configuration
- Check Juju model status: `juju status`
- Review Juju debug logs: `juju debug-log`
- Check unit hooks for errors: the script will warn you about these

### SSH/Proxy Issues

If behind a proxy:
- Set `http_proxy`, `https_proxy`, and `no_proxy` environment variables
- The script will automatically configure these for test models

## See Also

- [zaza Documentation](https://github.com/openstack-charmers/zaza)
- [OpenStack CI Configuration](https://github.com/openstack-charmers/zosci-config)
- [Running Charm Tests Guide](https://juju.is/docs/sdk/testing)
