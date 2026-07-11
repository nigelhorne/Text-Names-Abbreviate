#!/usr/bin/env perl
# Auto-generated mutant test stubs
# Generated: 2026-07-11 01:05:09
# Generator: scripts/test-generator-index
#
# DO NOT COMMIT without completing the TODO sections.
#
# HIGH/MEDIUM difficulty survivors have TODO stubs — these need real tests.
# LOW difficulty survivors appear as comment hints — worth improving.
#
# Stubs call new() for modules with a constructor, or show a class method
# placeholder for modules without one. Add arguments as needed.

use strict;
use warnings;
use Test::More;

use_ok('Text::Names::Abbreviate');

################################################################
# FILE: lib/Text/Names/Abbreviate.pm
################################################################
# --- SURVIVORS (TODO stubs) ---

# --- SURVIVOR: COND_INV_390_2 (MEDIUM) line 390 in abbreviate() ---
# Source:  if ($format eq $FMT_SHORTLAST) {
# Hint:    Add tests asserting both true and false outcomes
# Mutations on this line (1 variant):
#   Invert condition if to unless
TODO: {
    local $TODO = 'Complete: COND_INV_390_2 line 390 in abbreviate()';
    # NOTE: Text::Names::Abbreviate has no constructor — call class methods directly.
    # e.g. my $result = Text::Names::Abbreviate->method(...);
    # TODO: exercise line 390 in abbreviate() to detect the mutant
    fail('COND_INV_390_2: replace with real assertion');
}

done_testing();
