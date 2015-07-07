use strict;
use warnings;

package warnings::lock;
# ABSTRACT: lock warnings

our $VERSION = '1';

use Variable::Magic 'wizard', 'cast';

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

1;
