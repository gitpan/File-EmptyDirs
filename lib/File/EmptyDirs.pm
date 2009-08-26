package File::EmptyDirs;
use strict;
use Carp;
require Exporter;
use vars (qw(@ISA @EXPORT_OK $VERSION));
@ISA = qw(Exporter);
@EXPORT_OK = qw(remove_empty_dirs);
$VERSION = sprintf "%d.%02d", q$Revision: 1.4 $ =~ /(\d+)/g;
use File::Find::Rule::DirectoryEmpty;


sub remove_empty_dirs {
	my $abs = shift;
	-d $abs or Carp::cluck("argument [$abs] is not a dir.") and return;

	my $empty_dirs_removed = 0;	
	my $found_empty_dir=1; #startflag
   
   require Cwd;	
	while ($found_empty_dir){
		 $found_empty_dir=0;
		 
	
		my @ed = File::Find::Rule::DirectoryEmpty->directoryempty->in($abs) ;

		if (scalar @ed){
			EMPTY_DIR: for (@ed){
				my $d = $_;
				next if (Cwd::abs_path($d) eq Cwd::abs_path($abs));
				$found_empty_dir++;	
            
				rmdir($_) 
               or Carp::cluck("cannot rmdir $_, check permissions? $!")
               and next EMPTY_DIR;
            $empty_dirs_removed++;	
			}	
		}
	}

	$empty_dirs_removed;
}

1;

__END__

=pod

=head1 NAME

File::EmptyDirs - find all empty directories in a path and remove recursively

=head1 SYNOPSIS

	use File::EmptyDirs 'remove_empty_dirs';
   
	remove_empty_dirs('/home/myself');

=head1 DESCRIPTION

Ever end up with some miscellaneous empty directories in a messy filesystem and you
just want to clean up all empty dirs?

For example.. If you have..

   /home/myself/tp/this/nada

And the only thing in this is 'nada', and 'nada' does not contain anything, you'd like
to remove both of those. This is what to use.

Nothing exported by default.

The operation  is self exclusive, that is, if you pass dir /home/myself, it will not
delete /home/myself if it is an empty dir.

=head1 SUBS

=head2 remove_empty_dirs()

Argument is an abs path to a directory.
Will remove all empty directories within that filesystem hierarchy, recursively.

Returns number of dirs removed.
Returns undef on failure.

=head1 SEE ALSO

L<File::Find::Rule::DirectoryEmpty> - used internally to find the empty dirs.
L<IO::All>, might want to check this out.
L<ermdir>, included cli.

=head1 AUTHOR

Leo Charre leocharre at cpan dot org

=head1 COPYRIGHT

Copyright (c) 2009 Leo Charre. All rights reserved.

=head1 LICENSE

This package is free software; you can redistribute it and/or modify it under the same terms as Perl itself, i.e., under the terms of the "Artistic License" or the "GNU General Public License".

=head1 DISCLAIMER

This package is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

See the "GNU General Public License" for more details.

=cut

