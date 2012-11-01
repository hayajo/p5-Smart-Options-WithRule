use strict;
use Test::More;

use Smart::Options::WithRule;
use Capture::Tiny ':all';
use Try::Tiny;

subtest 'rule' => sub {
    my $opts = Smart::Options->new
                    ->usage("Usage: $0 -x [num] -y [num]")
                    ->demand('x', 'y')
                    ->rule( x => { isa => 'Num' } )
                    ->describe( x => 'year');

    ok ! capture_stderr { try { $opts->parse(qw(-x 4.9 -y 2.1)) } };

    my $out = capture_stderr { try { $opts->parse(qw(-x hoge -y fuga)) } };
    ok $out and diag $out;

    subtest 'rewrite rule' => sub {
        $opts->rule( x => { isa => 'Num' }, y => { isa => 'Num' } );
        my $out = capture_stderr { try { $opts->parse(qw(-x hoge -y fuga)) } };
        ok $out and diag $out;
    };
};

subtest 'options' => sub {
    my $opts = Smart::Options->new();
    $opts->usage("Usage: $0 -x [num] -y [num]");
    $opts->options(
        f => {
            alias    => 'file',
            default  => '/etc/passwd',
            describe => 'Load a file',
            rule => { isa => 'Str' },
        },
        x => {
            rule => { isa => 'Num' },
        },
    )->demand('x');

    is $opts->parse(qw/-x 100/)->{f}, '/etc/passwd';
};

done_testing;
