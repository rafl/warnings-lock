use strict;
use warnings;

package warnings::lock;
# ABSTRACT: lock down the set of warnings used in a lexical scope

our $VERSION = '1';

use Variable::Magic 'wizard', 'cast';

=head1 SYNOPSIS

    # Set up warnings just the way we want them
    use warnings;
    use feature 'postderef';
    no warnings 'experimental::postderef';

    # Lock warnings into their current state
    use warnings::lock;

    # Import additional modules which try to fiddle with our warning bits
    use Moose;

    # Use of postderef feature will not warn
    []->@*

    {
        no warnings::lock;
        no warnings 'recursion';

        # deep recursion warnings disabled for the rest of this block
        ...
    }

    # deep recursion warnings enabled again after the block
    ...

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
