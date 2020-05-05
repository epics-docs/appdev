# EPICS Application Developers Guide Sources

This repository contains the LaTeX text of the EPICS Application
Developers Guide, and older versions of the Channel Access Protocol
Specification. The master version of the latter has now been converted
to a restructured text file in the specs directory of the
[epics-docs](https://github.com/epics-docs/epics-docs) repository on
GitHub.

The Makefile in this directory generates both HTML and PDF versions of
the Developers Guide and can rsync them into a directory set by the
`INSTALL_DIR` variable. `make all` will generate the files, `make
install` does the installation. Note that the Makefile was developed to
run on RHEL-7 Linux with a copy of TexLive installed (see the
`LATEX_DIR` variable to configure that).

There are 3 branches in this Git repository, related to the release
series of the EPICS Base software. The 3.14 branch is no longer being
updated since that branch of Base is no longer being supported. The 3.15
branch may continue to be updated while that branch is supported. The
master branch contains some additional documentation that was developed
for the 3.16 branch of Base, but that branch is now closed. There is no
7.0 branch of this repository as the text here is being converted into
other documentation formats and moved elsewhere.

- Andrew Johnson, May 2020
