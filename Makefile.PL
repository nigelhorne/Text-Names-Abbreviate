use ExtUtils::MakeMaker;

WriteMakefile(
    NAME         => 'Text::Names::Abbreviate',
    VERSION_FROM => 'lib/Text/Names/Abbreviate.pm',
    ABSTRACT     => 'Generate abbreviated forms of personal names',
    AUTHOR       => 'Nigel Horne <njh@nigelhorne.com>',
    LICENSE      => 'GPL',
    PREREQ_PM    => {
        'Test::More' => 0,
	}, dist => $dist,
	clean		=> { FILES => 'Text-Names-Abbreviate-*' },
	META_MERGE => {
		resources => {
			repository => 'https://github.com/nigelhorne/Text-Names-Abbreviate',
			bugtracker => 'https://github.com/nigelhorne/Text-Names-Abbreviate/issues',
		},
	}
);
