STSStack-Bundles Documentation
==============================

STSStack-Bundles is a tool used to generate different types of Juju deployments. These bundles are designed for use with the `Juju OpenStack provider <https://github.com/juju/juju/tree/main/internal/provider/openstack>`_.

The top-level directory contains a set of modules, each of which has a generate-bundle.sh script which you can use to create a deployment from a number of options (see generate-bundle.sh --help for option info about using that particular module).

Basic usage:

 * give your deployment a name with (--name)
 * add one or more feature overlays depending on what you need (see --list-overlays)
 * resources are stored under a named directory so as to be able to avoid collisions and replay later (--replay)
 * immediate deploy (--run) or save for later


.. toctree::
   :hidden:
   :maxdepth: 2

   Users </user-docs/index>
   Contributors </contrib-docs/index>

In this documentation
---------------------

.. grid:: 1 1 2 2

   .. grid-item-card:: User Docs
      :link: /user-docs/index
      :link-type: doc

      **For users and operators** - how to use and operator STSStack-Bundles.

   .. grid-item-card:: Contributor Docs
      :link: /contrib-docs/index
      :link-type: doc

      **For contributors** - how to contribute to STSStack-Bundles.

