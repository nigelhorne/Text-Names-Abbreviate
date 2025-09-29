package Text::Names::Abbreviate;

use strict;
use warnings;

use Exporter 'import';
use Params::Get 0.13;
use Params::Validate::Strict 0.13;

our @EXPORT_OK = qw(abbreviate);
our $VERSION = '0.01';

=head1 NAME

Text::Names::Abbreviate - Create abbreviated name formats from full names

=head1 SYNOPSIS

  use Text::Names::Abbreviate qw(abbreviate);

  say abbreviate("John Quincy Adams");		 # "J. Q. Adams"
  say abbreviate("Adams, John Quincy");		# "J. Q. Adams"
  say abbreviate("George R R Martin", { format => 'initials' }); # "G.R.R.M."

=head1 DESCRIPTION

This module provides simple abbreviation logic for full personal names,
with multiple formatting options and styles.

=head1 SUBROUTINES/METHODS

=head2 abbreviate

Make the abbreviation.
It takes the following optional arguments:

=over

=item format

One of: default, initials, compact, shortlast

=item style

One of: first_last, last_first

=item separator

Customize the spacing/punctuation for initials (default: ". ")

=back

=head3	API SPECIFICATION

=head4	INPUT

  {
    'name' => { 'type' => 'string', 'min' => 1 },
    'format' => {
      'type' => 'string',
      'memberof' => [ 'default', 'initials', 'compact', 'shortlast' ],
      'optional' => 1
    }, 'style' => {
      'type' => 'string',
      'memberof' => [ 'first_last', 'last_first' ],
      'optional' => 1
    }, 'separator' => {
      'type' => 'string',
      'optional' => 1
    }
  }

=head4	OUTPUT

Argument error: croak

  {
    'type' => 'string',
  }

=cut

sub abbreviate
{
        my $params = Params::Validate::Strict::validate_strict({
		args => Params::Get::get_params('name', @_),
		schema => {
			'name' => { 'type' => 'string', 'min' => 1 },
			'format' => {
				'type' => 'string',
				'memberof' => [ 'default', 'initials', 'compact', 'shortlast' ],
				'optional' => 1
			}, 'style' => {
				'type' => 'string',
				'memberof' => [ 'first_last', 'last_first' ],
				'optional' => 1
			}, 'separator' => {
				'type' => 'string',
				'optional' => 1
			}
		}
	});

	my $name = $params->{'name'};

	my $format = $params->{format} // 'default';	# default, initials, compact, shortlast
	my $style = $params->{style} // 'first_last'; # first_last or last_first
	my $sep	= defined $params->{separator} ? $params->{separator} : '. ';

	# Normalize commas (e.g., "Adams, John Q." -> ("Adams", "John Q."))
	my ($last, $rest);
	if ($name =~ /,/) {
		($last, $rest) = map { s/^\s+|\s+$//gr } split(/\s*,\s*/, $name, 2);
		$name = "$rest $last";
	}

	my @parts = split /\s+/, $name;
	return '' unless @parts;

	my $last_name = pop @parts;
	my @initials = map { substr($_, 0, 1) } @parts;

	if ($format eq 'compact') {
		return join('', @initials, substr($last_name, 0, 1));
	}
	elsif ($format eq 'initials') {
		return join('.', @initials, substr($last_name, 0, 1)) . '.';
	}
	elsif ($format eq 'shortlast') {
		return join(' ', map { "$_." } @initials) . " $last_name";
	}
	else { # default: "J. Q. Adams"
		my $joined = join(' ', map { "$_." } @initials);
		return $style eq 'last_first'
			? "$last_name, $joined"
			: "$joined $last_name";
	}
}

1;

__END__

=head1 AUTHOR

Nigel Horne, C<< <njh at nigelhorne.com> >>

=head1 BUGS

=head1 REPOSITORY

L<https://github.com/nigelhorne/Text-Names-Abbreviate>

=head1 SEE ALSO

=over 4

=item * Test coverage report: L<https://nigelhorne.github.io/Text-Names-Abbreviate/coverage/>

=back

=head1 SUPPORT

This module is provided as-is without any warranty.

Please report any bugs or feature requests to C<bug-text-names-abbreviate at rt.cpan.org>,
or through the web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Text-Names-Abbreviate>.
I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

You can find documentation for this module with the perldoc command.

    perldoc Text::Names::Abbreviate

You can also look for information at:

=over 4

=item * MetaCPAN

L<https://metacpan.org/dist/Text-Names-Abbreviate>

=item * RT: CPAN's request tracker

L<https://rt.cpan.org/NoAuth/Bugs.html?Dist=Text-Names-Abbreviate>

=item * CPAN Testers' Matrix

L<http://matrix.cpantesters.org/?dist=Text-Names-Abbreviate>

=item * CPAN Testers Dependencies

L<http://deps.cpantesters.org/?module=Text::Names::Abbreviate>

=back

=head1 LICENCE AND COPYRIGHT

Copyright 2025 Nigel Horne.

Usage is subject to licence terms.

The licence terms of this software are as follows:

=over 4

=item * Personal single user, single computer use: GPL2

=item * All other users (including Commercial, Charity, Educational, Government)
  must apply in writing for a licence for use from Nigel Horne at the
  above e-mail.

=back

=cut
