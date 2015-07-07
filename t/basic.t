use strict;
use warnings;
use Test::More;
use Test::Warnings ':all';

{
    use warnings;
    no warnings 'illegalproto';
    use warnings::lock;

    use warnings;

    is_deeply warning { eval 'sub ($foo) { }' }, [];

    {
        no warnings::lock;
        use warnings;

        like warning { eval 'sub ($foo) {  }' },
            qr/^Illegal character in prototype /;
    }

    is_deeply warning { eval 'sub ($foo) { }' }, [];
}

{
    use warnings;
    no warnings 'illegalproto';

    use warnings;

    like warning { eval 'sub ($foo) {  }' },
        qr/^Illegal character in prototype /;
}

done_testing;