Overview
===========

This is a Perl language binding (glue code) for using [Pashua](www.bluem.net/jump/pashua) from Perl. Pashua is a Mac OS X application for using native GUI dialog windows in various programming languages.

The repository contains two files: `Pashua.pm`, a Perl module which handles the communication with Pashua, and `example.pl`, a simple script wich uses `Pashua.pm` to display a dialog. The way the module works is neither the best nor the only way to “talk” to Pashua from within Perl, but rather one out of several possibe implementations.

Requirements
=============
This code requires Perl (any version >= 5.8 will probably work) and Pashua. The Perl version shipped by Apple as part of the last few releases of Mac OS X can be used to run the code.

