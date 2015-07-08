use strict;
use warnings;

package warnings::lock;
# ABSTRACT: lock down the set of warnings used in a lexical scope

our $VERSION = '1';

use Variable::Magic 'wizard', 'cast';

=head1 SYNOPSIS

    # Set up warnings just the way we want them
    use warnings;
    use feature 'signatures';
    no warnings 'experimental::signatures';

    # Lock warnings into their current state
    use warnings::lock;

    # Import additional modules which try to fiddle with our warning bits
    use Moose;

    # Use of signatures feature will not warn
    sub greeting ($name) { print "Hello $name!" }

=head1 DESCRIPTION

    Lock down the set of warnings used in a lexical scope

=head1 MOTIVATION

=head2 Background

    Generally, we want warnings enabled. So, it seems like a good idea to C<use warnings>.

    However, in some cases, we want to turn particular warnings off. So, we might say something like: C<no warnings 'experimental::signatures'>.

    But, if we later use a module like Foo which not only uses warnings, but (re) imports them, they'll be turned back on.

=head2 Solution + Problem

    We could just switch the order and use Foo before we turn off a particular warning.

    But what if we need the 'no warnings' to come first? Maybe the 'no warnings' is part of site-wide pragma which loads various safety measures?

    We could write a second site-wide pragma to put everything back the way we want it. But, ideally, we could lock our warnings against change by other modules.

    warnings::lock gives you this option.

=head1 ADVANCED USAGE

If you want to change the settings inside a particular code block, you can just issue a C<no warnings::lock> and then disable (or enable) those particular warnings.

    {
        no warnings::lock;
        no warnings 'recursion';

        # deep recursion warnings disabled for the rest of this block
        ...
    }

    # deep recursion warnings enabled again after the block
    ...

=head1 SEE ALSO

=for :list
    * L<warnings>
    * L<feature>

=cut

my $hints_key = __PACKAGE__ . '/desired_warning_bits';

my $wiz = wizard set => sub {
    ${^WARNING_BITS} = $^H{$hints_key}
        if exists $^H{$hints_key};
};

sub import {
    $^H |= 0x20000;
    $^H{$hints_key} = ${^WARNING_BITS};
    cast ${^WARNING_BITS} => $wiz;
}

sub unimport {
    delete $^H{$hints_key};
}

1;
