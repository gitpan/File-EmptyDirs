package File::EmptyDirs;
use strict;
require Exporter;
use vars (qw(@ISA @EXPORT_OK $VERSION));
@ISA = qw(Exporter);
@EXPORT_OK = qw(remove_empty_dirs);
$VERSION = sprintf "%d.%02d", q$Revision: 1.2 $ =~ /(\d+)/g;
use File::Find::Rule::DirectoryEmpty;
use Cwd;

sub remove_empty_dirs {
	my $abs = shift;
	-d $abs or carp("remove_empty_dirs(), argument [$abs] is not a dir.") and return;

	my $empty_dirs_removed = 0;	
	my $found_empty_dir=1; #startflag
	
	while ($found_empty_dir){
		 $found_empty_dir=0;
		 
	
		my @ed = File::Find::Rule::DirectoryEmpty->directoryempty->in($abs) ;

		if (scalar @ed){
			for (@ed){
				my $d = $_;
				next if (Cwd::abs_path($d) eq Cwd::abs_path($abs));
				rmdir ($_);
				$found_empty_dir++;	$empty_dirs_removed++;	
			}	
		}
	}

	return $empty_dirs_removed;
}

1;

__END__

=pod

=head1 NAME

File::EmptyDirs  - subs to help remove all empty dirs recursively

=head1 DESCRIPTION

Nothing exported by default.
The code is self exclusive, that is, if you pass dir /home/myself, it will not
delete /home/myself if it is an empty dir.

=head1 SYNOPSIS

	use File::Empty::Dirs 'remove_empty_dirs';

	remove_empty_dirs('/home/myself');

=head2 remove_empty_dirs()

argument is an abs path to a directory
will remove all empty directories within that filesystem hierarchy
returns number of dirs removed

=head1 AUTHOR

Leo Charre leocharre at cpan dor org

=head1 SEE ALSO

L<File::Find::Rule::DirectoryEmpty>

=cut
