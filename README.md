[![CPAN version](https://badge.fury.io/pl/Text-Names-Abbreviate.svg)](https://metacpan.org/pod/Text::Names::Abbreviate)
![Ubuntu CI](https://github.com/nigelhorne/Text-Names-Abbreviate/actions/workflows/ubuntu.yml/badge.svg)

# NAME

Text::Names::Abbreviate - Create abbreviated name formats from full names

# SYNOPSIS

    use Text::Names::Abbreviate qw(abbreviate);

    say abbreviate("John Quincy Adams");           # "J. Q. Adams"
    say abbreviate("Adams, John Quincy");         # "J. Q. Adams"
    say abbreviate("George R R Martin", { format => 'initials' }); # "G.R.R.M."

# DESCRIPTION

This module provides simple abbreviation logic for full personal names,
with multiple formatting options and styles.

# SUBROUTINES/METHODS

## abbreviate

Make the abbreviation.
It takes the following optional arguments:

- format

    One of: default, initials, compact, shortlast

- style

    One of: first\_last, last\_first

- separator

    Customize the spacing/punctuation for initials (default: ". ")

### API SPECIFICATION

#### INPUT

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

#### OUTPUT

Argument error: croak

    {
      'type' => 'string',
    }

# AUTHOR

Nigel Horne, `<njh at nigelhorne.com>`

# BUGS

# REPOSITORY

[https://github.com/nigelhorne/Text-Names-Abbreviate](https://github.com/nigelhorne/Text-Names-Abbreviate)

# SEE ALSO

- Test coverage report: [https://nigelhorne.github.io/Text-Names-Abbreviate/coverage/](https://nigelhorne.github.io/Text-Names-Abbreviate/coverage/)

# SUPPORT

This module is provided as-is without any warranty.

Please report any bugs or feature requests to `bug-text-names-abbreviate at rt.cpan.org`,
or through the web interface at
[http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Text-Names-Abbreviate](http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Text-Names-Abbreviate).
I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

You can find documentation for this module with the perldoc command.

    perldoc Text::Names::Abbreviate

You can also look for information at:

- MetaCPAN

    [https://metacpan.org/dist/Text-Names-Abbreviate](https://metacpan.org/dist/Text-Names-Abbreviate)

- RT: CPAN's request tracker

    [https://rt.cpan.org/NoAuth/Bugs.html?Dist=Text-Names-Abbreviate](https://rt.cpan.org/NoAuth/Bugs.html?Dist=Text-Names-Abbreviate)

- CPAN Testers' Matrix

    [http://matrix.cpantesters.org/?dist=Text-Names-Abbreviate](http://matrix.cpantesters.org/?dist=Text-Names-Abbreviate)

- CPAN Testers Dependencies

    [http://deps.cpantesters.org/?module=Text::Names::Abbreviate](http://deps.cpantesters.org/?module=Text::Names::Abbreviate)

# LICENCE AND COPYRIGHT

Copyright 2025 Nigel Horne.

Usage is subject to licence terms.

The licence terms of this software are as follows:

- Personal single user, single computer use: GPL2
- All other users (including Commercial, Charity, Educational, Government)
  must apply in writing for a licence for use from Nigel Horne at the
  above e-mail.
