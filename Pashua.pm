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
languages) Perl applications under Mac OS X. Pashua.pm is the glue between your
scripts and Pashua. To learn more about Pashua, take a look at the application's
Readme file.

The Perl code that comes with Pashua (example script and this module, Pashua.pm)
is only a suggestion and you are free to write your own code.

=head1 EXAMPLES

A few UI elements are demonstrated in the example above, and you will find
information on the others in the documentation.

Please note in order for the example to work, the Pashua application must be in
the current path, in the calling script's path, in /Applications/ or in
~/Applications/
If none of these paths apply, you will have to specify it manually:
$Pashua::PATH = '/path/to/appfolder';
... before you call Pashua::show_dialog(). You can also create a symlink (a
symlink, NOT a Mac OS X Finder alias) to Pashua in one of the directories
mentioned above. As an alternative, you can supply Pashua.app's path as 2nd
argument to show_dialog().

=head1 AUTHOR / TERMS AND CONDITIONS

This software is copyright (c) 2003-2014 Carsten Bluem and licensed
under the MIT license. For further information, see
https://github.com/BlueM/Pashua-Binding-Perl/blob/master/Readme.md

=cut

require 5.005;

use File::Basename;
use File::Temp qw(tempfile);
use vars qw($VERSION $PATH);

$PATH = '';

# Calls the pashua binary, parses its result string
# and returns a hash containing the result values.
#
# Argument 1: Configuration (dialog description) string
# Argument 2 (optional): Directory that contains Pashua. If not given, only default
#                        locations will be searched.
sub show_dialog {

	# Initialize variables
	my ($fh, $configfile, $path, $result, $arguments);

	# Get name and handle to temporary file
	($fh, $configfile) = File::Temp::tempfile(UNLINK => 1);

	# Get function arguments
	my($confstring, $appdir) = (shift, shift);

	# Write data to temporary file
	print $fh $confstring;
	close $fh or die "Error trying to close $configfile: $!";

	$pashuaPath = locate_pashua(defined $appdir ? $appdir : '');

	# Call pashua binary with config file as argument and read result
	# Note: Using modules such as IPC::System or String::ShellQuote would be
	# a better solution, but both are not available by default on OS X.
	$cmd = "'$pashuaPath' $configfile";
	$result = `$cmd`;

	# Parse result
	my %result = ();
	foreach (split/\n/, $result) {
		/^(\w+)=(.*)$/;
		next unless defined $1;
		$result{$1} = $2;
	}

	return %result;
}

# Searches for Pashua in a number of default locations or in the folder given as
# optional argument
#
# Argument: Folder containing Pashua.app (optional)
sub locate_pashua {

	my $appdir = shift;

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
	if ($appdir) {
		unshift(@searchpaths, "$appdir/$bundlepath");
	}

	# Search for the Pashua binary
	foreach (@searchpaths) {
		next unless -e;
		next unless -x;
		return $_;
	}

	die	"Unable to locate the Pashua application.\n" unless $path;
}
1;
