use strict;
use warnings;

use Test::Most;

use Text::Names::Abbreviate qw(abbreviate);

subtest 'end-to-end: format + style + separator combinations' => sub {
	my $name = 'John Quincy Adams';

	is(abbreviate($name, { format => 'initials', style => 'first_last', separator => '.' }), 'J.Q.A.', 'initials + default style');
	is(abbreviate($name, { format => 'initials', style => 'last_first', separator => '.' }), 'A.J.Q.', 'initials + last_first');
	is(abbreviate($name, { format => 'compact',  style => 'last_first' }),                   'AJQ',    'compact + last_first');
	is(abbreviate($name, { format => 'shortlast', separator => '-' }),                        'J- Q- Adams', 'shortlast + custom separator');

	done_testing();
};

subtest 'stateful usage: repeated calls consistency' => sub {
	my $name = 'George R R Martin';

	my @results = map { abbreviate($name, { format => 'initials' }) } (1 .. 10);

	is_deeply(\@results, [ ('G.R.R.M.') x 10 ], 'consistent output across repeated calls');

	done_testing();
};

subtest 'stateful usage: varying options over time' => sub {
	my $name = 'John Quincy Adams';

	my @outputs = (
		abbreviate($name),
		abbreviate($name, { format => 'initials' }),
		abbreviate($name, { format => 'compact' }),
		abbreviate($name, { style  => 'last_first' }),
	);

	is_deeply(
		\@outputs,
		[ 'J. Q. Adams', 'J.Q.A.', 'JQA', 'Adams, J. Q.' ],
		'different configurations produce expected sequence',
	);

	done_testing();
};

subtest 'pipeline: normalize -> abbreviate -> reuse output' => sub {
	my $step1 = abbreviate('Adams, John Quincy');
	my $step2 = abbreviate($step1, { format => 'initials' });

	is($step1, 'J. Q. Adams', 'step1 normalized');
	is($step2, 'J.Q.A.',      'step2 reprocessed correctly');

	done_testing();
};

subtest 'pipeline: chaining formats (non-reversible transformations)' => sub {
	my $name = 'George R R Martin';
	my $a    = abbreviate($name, { format => 'compact' });
	my $b    = abbreviate($a,    { format => 'initials' });

	is($a, 'GRRM', 'compact first');
	is($b, 'G.',   'compact output treated as single name (non-reversible)');

	done_testing();
};

subtest 'robustness: mixed realistic inputs' => sub {
	my @names = (
		'John Quincy Adams',
		'Adams, John Quincy',
		'  John   Quincy   Adams  ',
		'George R R Martin',
		'Madonna',
	);

	for my $n (@names) {
		my $out = abbreviate($n);
		ok(defined $out, "output defined for '$n'");
		ok($out ne '',   "non-empty output for '$n'");
	}

	done_testing();
};

subtest 'no cross-call state leakage' => sub {
	my $a = abbreviate('John Quincy Adams', { format => 'initials' });
	my $b = abbreviate('Jane Doe');

	is($a, 'J.Q.A.', 'first call correct');
	is($b, 'J. Doe', 'second call unaffected by first');

	done_testing();
};

subtest 'integration with Text::Trim (if available)' => sub {
	eval { require Text::Trim } or do { plan skip_all => 'Text::Trim not installed'; return };

	my $trimmed = Text::Trim::trim('   John Quincy Adams   ');
	is(abbreviate($trimmed), 'J. Q. Adams', 'works correctly after external trimming');

	done_testing();
};

subtest 'integration with Text::Names (if available)' => sub {
	eval { require Text::Names } or do { plan skip_all => 'Text::Names not installed'; return };

	my $abbrev = abbreviate('John Quincy Adams');
	ok(defined $abbrev,         'abbreviation produced');
	ok($abbrev =~ /Adams/,      'last name preserved');

	done_testing();
};

subtest 'batch processing scenario' => sub {
	my @input = ('John Quincy Adams', 'George R R Martin', 'Jane Doe');

	my @output = map { abbreviate($_, { format => 'initials' }) } @input;

	is_deeply(\@output, [ 'J.Q.A.', 'G.R.R.M.', 'J.D.' ], 'batch processing works correctly');

	done_testing();
};

subtest 'separator persistence across multiple calls (no hidden state)' => sub {
	my $name = 'John Quincy Adams';
	my $a    = abbreviate($name, { separator => '-' });
	my $b    = abbreviate($name);    # must NOT inherit '-'

	is($a, 'J- Q- Adams', 'custom separator applied');
	is($b, 'J. Q. Adams', 'default separator restored');

	done_testing();
};

subtest 'end-to-end realistic workflow' => sub {
	my @raw = ('Adams, John Quincy', 'Martin, George R R', 'Doe, Jane');

	my @processed = map { abbreviate($_, { format => 'initials', style => 'last_first' }) } @raw;

	is_deeply(
		\@processed,
		[ 'A.J.Q.', 'M.G.R.R.', 'D.J.' ],
		'full workflow from raw input to formatted output',
	);

	done_testing();
};

done_testing();
