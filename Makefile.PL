use ExtUtils::MakeMaker;

my $dist = {
	COMPRESS => 'gzip -9f',	# Compress tarball using gzip
	SUFFIX => 'gz',	# File suffix for tarball
};

if($^O eq 'darwin') {
	$dist->{'TAR'} = 'gtar';
}

WriteMakefile(
    NAME         => 'Text::Names::Abbreviate',
    VERSION_FROM => 'lib/Text/Names/Abbreviate.pm',
    ABSTRACT     => 'Generate abbreviated forms of personal names',
    AUTHOR       => 'Nigel Horne <njh@nigelhorne.com>',
    LICENSE      => 'GPL',
	PREREQ_PM => {
		'Carp' => 0,
		'Params::Get' => 0.13,
		'Params::Validate::Strict' => 0.13
	}, TEST_REQUIRES => {
		'autodie' => 0,
		'Class::Simple' => 0,
		'Date::Random' => 0,
		'File::Glob' => 0,
		'File::Slurp' => 0,
		'File::stat' => 0,
		'IPC::System::Simple' => 0,
		'JSON::MaybeXS' => 0,
		'POSIX' => 0,
		'Readonly' => 0,
		'Test::DescribeMe' => 0,
		'Test::Most' => 0,
		'Test::Needs' => 0,
		'Test::Returns' => 0
	}, dist => $dist,
	clean		=> { FILES => 'Text-Names-Abbreviate-*' },
	META_MERGE => {
		resources => {
			repository => 'https://github.com/nigelhorne/Text-Names-Abbreviate',
			bugtracker => 'https://github.com/nigelhorne/Text-Names-Abbreviate/issues',
		},
	}
);
