use strict;
use warnings;
use Test::Most;
use Text::Names::Abbreviate qw(abbreviate);

subtest 'separator option' => sub {
	is(
		abbreviate("John Quincy Adams", { format => 'initials', separator => '-' }),
		'J-Q-A-',
		'separator works'
	);
};

subtest 'single-word works' => sub {
	is(abbreviate('Adams'), 'Adams', 'simple case works');

	is(
		abbreviate("Adams", { style => 'last_first' }),
		'Adams',
		'last_first of simple case works'
	);

	is(
		abbreviate("Adams", { format => 'shortlast' }),
		'Adams',
		'shortlast of simple case works'
	);
};

subtest 'comma normalization' => sub {
	is(abbreviate('Adams,'), 'Adams', 'trailing comma works');

	is(abbreviate(', John'), 'J.', 'leading comma works');
};

subtest 'style for non-default formats' => sub {
	is(
		abbreviate("John Quincy Adams", { format => 'initials', style => 'last_first' }),
		'Q.A.J.',
		'style has effect on initials format'
	);

	is(
		abbreviate("John Quincy Adams", { format => 'compact', style => 'last_first' }),
		'QAJ',
		'style has effect on compact format'
	);
};

subtest 'undefined name check' => sub {
	throws_ok {
		abbreviate(undef)
	} qr/Usage/, 'sanity check for undef as argument'
};

done_testing();
