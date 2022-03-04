# Cisco package of Linux PAM

This is the Cisco Linux PAM package, forked from two different
versions of Ubuntu packages:

* The [Ubuntu 18.04 libpam0g
  package](http://archive.ubuntu.com/ubuntu/pool/main/p/pam/pam_1.1.8-3.6ubuntu2.18.04.3.tar.gz)
* The [Ubuntu 20.04 libpam0g
package](http://archive.ubuntu.com/ubuntu/pool/main/p/pam/pam_1.3.1.orig.tar.xz)

Both packages are identical to their original corresponding Ubuntu
packages, with the exception that two additional patches were added to
this package, back-ported from the Linux PAM repository:

* https://github.com/linux-pam/linux-pam/commit/55f206447a1e4ee26e307e7a9c069236e823b1a5,
  and
* https://github.com/linux-pam/linux-pam/commit/80bfda5962e5be3daa70e0fc8c75fc97d1c55121

Additionally, a `cisco-package-version.json` file is included in the
`libpam0g*.deb` file.

These packages are not supported by Ubuntu.
