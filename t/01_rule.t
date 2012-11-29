use strict;
use Test::More;

use Smart::Options;
use Smart::Options::WithRule;
use Capture::Tiny ':all';
use Try::Tiny;

subtest 'rule' => sub {
    my $opts = Smart::Options->new
                    ->usage("Usage: $0 -x [str] -y [num]")
                    ->demand('x', 'y')
                    ->rule( y => { isa => 'Num' } )
                    ->describe( y => 'year');

    subtest 'parse succeed' => sub {
        ok ! capture_stderr { try { $opts->parse(qw(-x 4.9 -y 2.1)) } };
    };

    subtest 'parse failed' => sub {
        my $out = capture_stderr { try { $opts->parse(qw(-x hoge -y fuga)) } };
        ok $out and diag $out;
    };

    subtest 'redefine rule' => sub {
        my @args = qw{ -x hoge -y 2012 };
        ok ! capture_stderr { try { $opts->parse(@args) } };

        $opts->rule( x => { isa => 'Num' }, y => { isa => 'Num' } )
             ->usage("Usage: $0 -x [num] -y [num]");
        my $out = capture_stderr { try { $opts->parse(@args) } };
        ok $out and diag $out;
    };
};

subtest 'options' => sub {
    use Mouse::Util::TypeConstraints;
    subtype 'File', as 'Str', where { -e $_ };
    no Mouse::Util::TypeConstraints;

    my $opts = Smart::Options->new();
    $opts->usage("Usage: $0 -f [/path/to/file] -x [num]");
    $opts->options(
        f => {
            alias    => 'file',
            default  => __FILE__,
            describe => 'Load a file',
            rule => { isa => 'File' },
        },
        y => {
            alias => 'year',
            rule => { isa => 'Num' },
        },
    )->demand('y');

    my @args = qw{ --year 2012 };

    is $opts->parse(@args)->{file}, __FILE__;

    push @args, qw{ --file hoge.txt };
    my $out = capture_stderr { try { $opts->parse(@args) } };
    ok $out and diag $out;

    diag explain $opts->parse(qw/-y 2000/);
};

done_testing;
