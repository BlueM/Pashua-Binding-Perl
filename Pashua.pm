package Pashua;

=head1 NAME

Pashua - Interface to Pashua.app

=head1 SYNOPSIS

 use Pashua;

 my $conf = "
 *.title = Introducing Pashua

 tx.type = textfield
 tx.label = Example textfield
 tx.default = Textfield content
 tx.width = 380

 rb.type = radiobutton
 rb.label = Example radiobuttons
 rb.option = Radiobutton item #1
 rb.option = Radiobutton item #2
 rb.default = Radiobutton item #1

 pop.type = popup
 pop.label = Example popup menu
 pop.width = 380
 pop.option = Popup menu item #1
 pop.option = Popup menu item #2
 pop.option = Popup menu item #3
 pop.default = Popup menu item #2

 # Add a cancel button with default label
 cb.type=cancelbutton";

 my %result = Pashua::run($conf, 'utf8');

 if (%result) {
	 print "  Pashua returned the following hash keys and values:\n";
	 while (my($k, $v) = each(%result)) {
		 print "    $k = $v\n";
	 }
	 }
 else {
	 print "  No result returned. Looks like the 'Cancel' button was pressed.";
 }

=head1 DESCRIPTION

Pashua is an application that can be used to provide dialog GUIs for (among other
languages) Perl applications under Mac OS X. Pashua.pm is the glue between your scripty and Pashua. To learn
more about Pashua, take a look at the application's Readme file.

The Perl code that comes with Pashua (example script and this module,
Pashua.pm) is only a suggestion and you are free to write your own code.
For instance, the Perl code is in no way "idiomatic", and maybe you'd
prefer some sort of OOP approach. It's up to you :-)

=head1 EXAMPLES

Many GUI elements that are available are demonstrated in the example
above, so there's mot much more to show ;-) To learn more about the
configuration syntax, take a look at the documentation which is
included with Pashua.

Please note in order for the example to work, the Pashua application
must be in the current path, in the calling script's path, in
/Applications/ or in ~/Applications/
If none of these paths apply, you will have to specify it manually:
$Pashua::PATH = '/path/to/appfolder';
before you call Pashua::run(). You can also create a symlink (a symlink,
NOT a Mac OS X Finder alias) to Pashua in one of the directories
mentioned above. As an alternative, you can supply Pashua.app's path
as 3rd argument to sub run.

=head1 AUTHOR / TERMS AND CONDITIONS

This software is copyright (c) 2003-2014 Carsten Bluem and licensed
under the MIT license. For details, see
https://github.com/BlueM/Pashua-Binding-Perl/blob/master/LICENSE.txt

=cut


require 5.005;

use File::Basename;
use File::Temp;
use vars qw($VERSION $PATH);

$VERSION = '0.9.5.1';
$PATH = '';


# Pashua::run - Calls the pashua binary, parses its result string
# and generates a Perl hash that's returned. Attention: This sub
# uses the module File::Temp, which is included with OSX 10.3's
# Perl, but not with OS versions prior to 10.3. For convenience
# reasons, I have copied the File::Basename code into this file.
# If you are running 10.3 or later, you can remove this part and
# simply use the line use File::Temp qw(tempfile) above.
#  Argument 1: Configuration (dialog description) string
#  Argument 2 (optional): Config. string text encoding, see documentation
#  Argument 3 (optional): Directory that contains Pashua
sub run {

	# Initialize variables
	my ($fh, $configfile, $path, $result, $arguments);

	# Get name and handle to temporary file
	($fh, $configfile) = File::Temp::tempfile(UNLINK => 1);

	# Get function arguments
	my($confstring, $encoding, $appdir) = (shift, shift, shift);

	# Write data to temporary file
	print $fh $confstring;
	close $fh or die "Error trying to close $configfile: $!";

	# Try to figure out the path to pashua
	my $bundlepath = "Pashua.app/Contents/MacOS/Pashua";

	# Set the paths where to search for Pashua
	my @searchpaths = (
		dirname($0)."/Pashua",
		dirname($0)."/$bundlepath",
		"$PATH/$bundlepath",
		"./$bundlepath",
		"/Applications/$bundlepath",
		"$ENV{HOME}/Applications/$bundlepath"
	);

	# Use the directory given as argument
	if (defined $appdir) {
		if (!-d $appdir or !-e "$appdir/$bundlepath") {
			die ("The path $appdir/$bundlepath is invalid");
		}
		unshift(@searchpaths, "$appdir/$bundlepath");
	}

	# Search for the Pashua binary
	foreach (@searchpaths) {
		next unless -e;
		next unless -x;
		$path = $_;
		last;
	}

	die	"Unable to locate the Pashua application.\n" unless $path;

	# Pass encoding as argument to Pashua
	if (defined $encoding and $encoding =~ m/^\w+$/) {
		$arguments = "-e $encoding ";
	}
	else {
		$arguments = "";
	}

	# Call pashua binary with config file as argument and read result
	$cmd = "'$path' $arguments $configfile";
	$result = `$cmd`;

	# Parse result
	my %result = ();
	foreach (split/\n/, $result) {
		/^(\w+)=(.*)$/;
		next unless defined $1;
		$result{$1} = $2;
	}

	# Return resulting hash
	return %result;

} # sub run

1;
