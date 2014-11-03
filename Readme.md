Overview
===========

This is a Perl language binding (glue code) for using [Pashua](http://www.bluem.net/jump/pashua) from Perl. Pashua is a Mac OS X application for using native GUI dialog windows in various programming languages.

The repository contains two files: `Pashua.pm`, a Perl module which handles the communication with Pashua, and `example.pl`, a simple script wich uses `Pashua.pm` to display a dialog. The way the module works is neither the best nor the only way to “talk” to Pashua from within Perl, but rather one out of several possibe implementations.


Usage
======
This repository contains two code files:

* “example.pl” is an example script, which does not do much more than define how the dialog window should look like and use the module class in the second file.
* “Pashua.pm” contains the “Pashua” module class `BlueM\Pashua`, which declares two functions. Usually you will only need `show_dialog()`, but if you want to find out where Pashua is, you can also use `locate_pashua()`. You can put “Pashua.pm” anywhere you like, but if it is not in `@INC`, you will have to make sure it can be loaded, for example using a `BEGIN` statement similar to that in “example.pl”.

Of course, you will need Pashua on your Mac to run the example. The code expects Pashua.app in one of the “typical” locations, such as the global or the user’s “Applications” folder, or in the folder which contains “example.pl”.


Compatibility
=============
This code should work with the default Perl installation on every Mac OS X version on which Pashua can run.

It is compatible with Pashua 0.10. It should work with earlier versions of Pashua, but non-ASCII characters will not be displayed correctly, as any versions before 0.10 required an argument for marking input as UTF-8.


Author
=========
This code was written by Carsten Blüm.


License
=========
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
