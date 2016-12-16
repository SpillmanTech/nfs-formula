nfs-formula
===========

Available states
================

.. contents::
    :local:

``nfs.server``
---------------

Install nfs server components

``nfs.client``
---------------

Install nfs client components

``nfs.mount``
---------------

Mount nfs shares via. pillar using the following parameters:
* mountpoint
* location
* opts: default => "vers=3"
* persist: default => True
* mkmnt: default => True

``nfs.unmount``
---------------

Unmount nfs shares via. pillar using the following parameters:
* mountpoint
* location
* persist: default => False

testing
================
Load the included Vagrantfile. Once all machines are up, execute `salt-call state.sls nfs.mount` to test client mounts. Server exports are done during the vagrant provisioning.

The Vagrant environment will have three machines in it, with hostnames `centos`, `debian`, and `ubuntu`.
