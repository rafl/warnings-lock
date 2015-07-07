use strict;
use warnings;
use Test::More;
use Test::Warnings ':all';

{
    use warnings;
    use feature 'postderef';
    no warnings 'experimental::postderef';
    use warnings::lock;

    use warnings;

    is_deeply warning { eval 'sub { () = []->@* }' }, [];
}

{
    use warnings;
    use feature 'postderef';
    use warnings::lock;

    use warnings;

    like warning { eval 'sub { () = []->@* }' },
        qr/^Postfix dereference is experimental/;
}

done_testing;