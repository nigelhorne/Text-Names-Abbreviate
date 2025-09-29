#!/usr/bin/env perl

use strict;
use warnings;

use Data::Dumper;
use Test::Most;
use Test::Returns 0.02;

BEGIN { use_ok('Text::Names::Abbreviate') }

diag("Text::Names::Abbreviate::abbreviate test case created by https://github.com/nigelhorne/App-Test-Generator");

# Edge-case maps injected from config (optional)
my %edge_cases = (

);
my %type_edge_cases = (

);

# Seed for reproducible fuzzing (if provided)


my %input = (
	'format' => { memberof => [ 'default', 'initials', 'compact', 'shortlast' ], optional => 1, type => 'string' },
	'name' => { min => 1, type => 'string' },
	'separator' => { optional => 1, type => 'string' },
	'style' => { memberof => [ 'first_last', 'last_first' ], optional => 1, type => 'string' }
);

my %output = (
	'type' => 'string'
);

# --- Fuzzer helpers ---
sub _pick_from {
	my ($arrayref) = @_;
	return undef unless $arrayref && ref $arrayref eq 'ARRAY' && @$arrayref;
	return $arrayref->[ int(rand(scalar @$arrayref)) ];
}

sub rand_str {
	my $len = shift || int(rand(10)) + 1;
	join '', map { chr(97 + int(rand(26))) } 1..$len;
}
sub rand_int { int(rand(200)) - 100 }
sub rand_bool { rand() > 0.5 ? 1 : 0 }
sub rand_num { rand() * 200 - 100 }

sub rand_arrayref {
	my $len = shift || int(rand(3)) + 1; # small arrays
	[ map { rand_str() } 1..$len ];
}

sub rand_hashref {
	my $len = shift || int(rand(3)) + 1; # small hashes
	my %h;
	for (1..$len) {
		$h{rand_str(3)} = rand_str(5);
	}
	return \%h;
}

sub fuzz_inputs {
	my @cases;
	for (1..50) {
		my %case;
		foreach my $field (keys %input) {
			my $spec = $input{$field} || {};
			next if $spec->{'memberof'};	# Memberof data is created below
			my $type = $spec->{type} || 'string';

			# 1) Sometimes pick a field-specific edge-case
			if (exists $edge_cases{$field} && rand() < 0.4) {
				$case{$field} = _pick_from($edge_cases{$field});
				next;
			}

			# 2) Sometimes pick a type-level edge-case
			if (exists $type_edge_cases{$type} && rand() < 0.3) {
				$case{$field} = _pick_from($type_edge_cases{$type});
				next;
			}

			# 3) Sormal random generation by type
			if ($type eq 'string') {
				$case{$field} = rand_str();
			}
			elsif ($type eq 'integer') {
				$case{$field} = rand_int();
			}
			elsif ($type eq 'boolean') {
				$case{$field} = rand_bool();
			}
			elsif ($type eq 'number') {
				$case{$field} = rand_num();
			}
			elsif ($type eq 'arrayref') {
				$case{$field} = rand_arrayref();
			}
			elsif ($type eq 'hashref') {
				$case{$field} = rand_hashref();
			}
			else {
				$case{$field} = undef;
			}

			# 4) occasionally drop optional fields
			if ($spec->{optional} && rand() < 0.25) {
				delete $case{$field};
			}
		}
		push @cases, \%case;
	}

	# edge-cases

	# Are any options manadatory?
	my $all_optional = 1;
	my %mandatory_strings;	# List of mandatory strings to be added to all tests, always put at start so it can be overwritten
	foreach my $field (keys %input) {
		my $spec = $input{$field} || {};
		if(!$spec->{optional}) {
			$all_optional = 0;
			if($spec->{'type'} eq 'string') {
				$mandatory_strings{$field} = rand_str();
			} else {
				die 'TODO: type = ', $spec->{'type'};
			}
		}
	}

	if($all_optional) {
		push @cases, {};
	} else {
		# Note that this is set on the input rather than output
		push @cases, { '_STATUS' => 'DIES' };	# At least one argument is needed
	}

	push @cases, { '_STATUS' => 'DIES', map { $_ => undef } keys %input };

	# If it's not in mandatory_strings it sets to 'undef' which is the idea, to test { value => undef } in the args
	push @cases, { map { $_ => $mandatory_strings{$_} } keys %input };

	# generate numeric, string, hashref and arrayref min/max edge cases
	# TODO: For hashref and arrayref, if there's a $spec->{schema} field, use that for the data that's being generated
	foreach my $field (keys %input) {
		my $spec = $input{$field} || {};
		my $type = $spec->{type} || 'string';

		if (exists $spec->{memberof} && ref $spec->{memberof} eq 'ARRAY' && @{$spec->{memberof}}) {
			# Generate edge cases for memberof
			# inside values
			foreach my $val (@{$spec->{memberof}}) {
				push @cases, { %mandatory_strings, $field => $val };
			}
			# outside value
			my $outside;
			if ($type eq 'integer' || $type eq 'number') {
				$outside = (sort { $a <=> $b } @{$spec->{memberof}})[-1] + 1;
			} else {
				$outside = 'INVALID_MEMBEROF';
			}
			push @cases, { %mandatory_strings, $field => $outside, _STATUS => 'DIES' };
		} else {
			# Generate edge cases for min/max
			if ($type eq 'number' || $type eq 'integer') {
				if (defined $spec->{min}) {
					push @cases, { $field => $spec->{min} + 1 };	# just inside
					push @cases, { $field => $spec->{min} };	# border
					push @cases, { $field => $spec->{min} - 1, _STATUS => 'DIES' }; # outside
				} else {
					push @cases, { $field => 0 };	# No min, so 0 should be allowable
					push @cases, { $field => -1 };	# No min, so -1 should be allowable
				}
				if (defined $spec->{max}) {
					push @cases, { $field => $spec->{max} - 1 };	# just inside
					push @cases, { $field => $spec->{max} };	# border
					push @cases, { $field => $spec->{max} + 1, _STATUS => 'DIES' }; # outside
				}
			} elsif ($type eq 'string') {
				if (defined $spec->{min}) {
					my $len = $spec->{min};
					push @cases, { %mandatory_strings, $field => 'a' x ($len + 1) };	# just inside
					push @cases, { %mandatory_strings, $field => 'a' x $len };	# border
					push @cases, { %mandatory_strings, $field => 'a' x ($len - 1), _STATUS => 'DIES' } if $len > 0; # outside
				} else {
					push @cases, { %mandatory_strings, $field => '' };	# No min, empty string should be allowable
				}
				if (defined $spec->{max}) {
					my $len = $spec->{max};
					push @cases, { %mandatory_strings, $field => 'a' x ($len - 1), %mandatory_strings };	# just inside
					push @cases, { %mandatory_strings, $field => 'a' x $len, %mandatory_strings};	# border
					push @cases, { %mandatory_strings, $field => 'a' x ($len + 1), _STATUS => 'DIES', %mandatory_strings }; # outside
				}
			} elsif ($type eq 'arrayref') {
				if (defined $spec->{min}) {
					my $len = $spec->{min};
					push @cases, { $field => [ (1) x ($len + 1) ] };	# just inside
					push @cases, { $field => [ (1) x $len ] };	# border
					push @cases, { $field => [ (1) x ($len - 1) ], _STATUS => 'DIES' } if $len > 0; # outside
				} else {
					push @cases, { $field => [] };	# No min, empty array should be allowable
				}
				if (defined $spec->{max}) {
					my $len = $spec->{max};
					push @cases, { $field => [ (1) x ($len - 1) ] };	# just inside
					push @cases, { $field => [ (1) x $len ] };	# border
					push @cases, { $field => [ (1) x ($len + 1) ], _STATUS => 'DIES' }; # outside
				}
			} elsif ($type eq 'hashref') {
				if (defined $spec->{min}) {
					my $len = $spec->{min};
					push @cases, { $field => { map { "k$_" => 1 }, 1 .. ($len + 1) } };
					push @cases, { $field => { map { "k$_" => 1 }, 1 .. $len } };
					push @cases, { $field => { map { "k$_" => 1 }, 1 .. ($len - 1) }, _STATUS => 'DIES' } if $len > 0;
				} else {
					push @cases, { $field => {} };	# No min, empty hash should be allowable
				}
				if (defined $spec->{max}) {
					my $len = $spec->{max};
					push @cases, { $field => { map { "k$_" => 1 }, 1 .. ($len - 1) } };
					push @cases, { $field => { map { "k$_" => 1 }, 1 .. $len } };
					push @cases, { $field => { map { "k$_" => 1 }, 1 .. ($len + 1) }, _STATUS => 'DIES' };
				}
			} elsif ($type eq 'boolean') {
				if (exists $spec->{memberof} && ref $spec->{memberof} eq 'ARRAY') {
					# memberof already defines allowed booleans
					foreach my $val (@{$spec->{memberof}}) {
						push @cases, { $field => $val };
					}
				} else {
					# basic boolean edge cases
					push @cases, { $field => 0 };
					push @cases, { $field => 1 };
					push @cases, { $field => undef, _STATUS => 'DIES' };
					push @cases, { $field => 2, _STATUS => 'DIES' };	# invalid boolean
				}
			}
		}
	}

	return \@cases;
}

foreach my $case (@{fuzz_inputs()}) {
	my %params;
	# lives_ok { %params = get_params(\%input, %$case) } 'Params::Get input check';
	# lives_ok { validate_strict(\%input, %params) } 'Params::Validate::Strict input check';

	::diag(Dumper[$case]) if($ENV{'TEST_VERBOSE'});

	my $result;
	if(my $status = delete $case->{'_STATUS'} || delete $output{'_STATUS'}) {
		if($status eq 'DIES') {
			dies_ok { $result = $result = Text::Names::Abbreviate::abbreviate($case); } 'function call dies';
		} elsif($status eq 'WARNS') {
			warnings_exist { $result = $result = Text::Names::Abbreviate::abbreviate($case); } qr/./, 'function call warns';
		} else {
			lives_ok { $result = $result = Text::Names::Abbreviate::abbreviate($case); } 'function call survives';
		}
	} else {
		lives_ok { $result = $result = Text::Names::Abbreviate::abbreviate($case); } 'function call survives';
	}

	returns_ok($result, \%output, 'output validates');
}



done_testing();
