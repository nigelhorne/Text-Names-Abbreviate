[![CPAN version](https://badge.fury.io/pl/Text-Names-Abbreviate.svg)](https://metacpan.org/pod/Text::Names::Abbreviate)
![Perl CI](https://github.com/nigelhorne/Text-Names-Abbreviate/actions/workflows/perl-ci.yml/badge.svg)

# NAME

Text::Names::Abbreviate - Create abbreviated name formats from full names

# SYNOPSIS

    use Text::Names::Abbreviate qw(abbreviate);

    say abbreviate("John Quincy Adams");         # "J. Q. Adams"
    say abbreviate("Adams, John Quincy");        # "J. Q. Adams"
    say abbreviate("George R R Martin", format => 'initials'); # "G.R.R.M."

# DESCRIPTION

This module provides simple abbreviation logic for full personal names,
with multiple formatting options and styles.

# OPTIONS

- format

    One of: default, initials, compact, shortlast

- style

    One of: first\_last, last\_first

- separator

    Customize the spacing/punctuation for initials (default: ". ")
