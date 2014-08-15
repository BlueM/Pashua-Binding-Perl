package Pashua;

=head1 NAME

 Pashua - Interface to Pashua.app

=head1 SYNOPSIS

 use Pashua;

 # Set transparency: 0 is transparent, 1 is opaque
 transparency=0.95

 # Set window title
 title = Introducing Pashua

 # Introductory text
 tb.label = About Pashua
 tb.type = textbox
 tb.default = Pashua is an application for generating dialog windows from programming languages (in this case: Perl) which lack support for creating native GUIs on Mac OS X. Any information you enter in this example window will be returned to the calling script when you hit "OK"; if you decide to click "Cancel" or press "Esc" instead, no values will be returned.[return][return]This window demonstrates about half of the GUI widgets that are available in Pashua. You can find a full list of all GUI elements and their corresponding attributes in section "Table of element types and attributes" of Pashua's documentation (folder "Documentation" on this disk image).
 tb.height = 6
 tb.width = 380

 # Display Pashua's icon
 img.type = image
 img.label = This is Pashua's icon
 img.path = /Volumes/Pashua/Pashua.app/Contents/Resources/Pashua.icns

 # Add a text field
 tx.type = textfield
 tx.label = Example textfield
 tx.default = Textfield content
 tx.width = 380

 # Add a filesystem browser
 ob.type = openbrowser
 ob.label = Example filesystem browser (textfield + open panel)
 ob.width=380
 ob.tooltip = Blabla filesystem browser

 # Define radiobuttons
 rb.type = radiobutton
 rb.label = Example radiobuttons
 rb.option = Radiobutton item #1
 rb.option = Radiobutton item #2
 rb.default = Radiobutton item #1

 # Add a popup menu
 pop.type = popup
 pop.label = Example popup menu
 pop.width = 380
 pop.option = Popup menu item #1
 pop.option = Popup menu item #2
 pop.option = Popup menu item #3
 pop.default = Popup menu item #2

 # Add a cancel button with default label
 cb.type=cancelbutton

 # A default button is added automatically - if you want to
 # change the button title, you should uncomment the next
 # two lines to override the "built-in" default button
 #db.type=defaultbutton
 #db.label=Click here to return the values

 EOCONF

 # ... and save the result in %result
 my %result = Pashua::run($var);

=head1 DESCRIPTION

 Pashua is an application that can be used to provide dialog GUIs
 for (among other languages) Perl applications under Mac OS X.
 Pashua.pm is the glue between your scripty and Pashua. To learn
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

 Pashua and this Perl module are copyright (c) 2003-2005 Carsten Bluem,
 <carsten@bluem.net>. You can use and /or modify this module in any way
 you like. For information on the Pashua license (which is not
 necessarily the same as this module's license) see Pashua's Readme file.
 Pashua can be found on http://www.bluem.net/downloads/pashua_en/

 This software comes with NO WARRANTY of any kind.

=cut


require 5.005;

use File::Basename;
use File::Temp;
use vars qw($VERSION $PATH);

$VERSION = '0.9.4.1';
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
