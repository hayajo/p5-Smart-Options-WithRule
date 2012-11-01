package Smart::Options::WithRule;
use strict;
use warnings;
our $VERSION = '0.01';

use Smart::Options ();

use Data::Validator;
use Data::Clone;

use Exporter;

sub import {
    my $pkg = shift;
    no strict 'refs';
    no warnings 'redefine';

    *{'Smart::Options::rule'} = sub { shift->_set('rule', @_) };

    my $orig_parse = *{'Smart::Options::parse'}{CODE};
    *{'Smart::Options::parse'} = sub {
        my $argv = $orig_parse->(@_);
        my $self = shift;
        return $argv unless ( keys %{ $self->{rule} } );
        my $rule = clone( $self->{rule} );
        my $v = Data::Validator->new(%$rule)->with(qw{ AllowExtra NoThrow });
        $v->validate(%$argv);
        if ( $v->has_errors ) {
            $self->showHelp;
            print STDERR "\n";
            foreach my $e ( sort { $a->{name} cmp $b->{name} } @{ $v->clear_errors } ) {
                print STDERR $e->{message}, "\n";
            }
            die;
        }
        return $argv;
    };

    return Exporter::export_to_level( 'Smart::Options', 1, @_ );
}

1;
__END__

=head1 NAME

Smart::Options::WithRule - added a rule based validation to L<Smart::Options>.

=head1 SYNOPSIS

  use Smart::Options::WithRule;

  my $opts = Smart::Options->new
                     ->usage("Usage: $0 -y [num]")
                     ->demand('y')
                     ->describe( y => 'year')
                     ->rule( y => { isa => 'Num' } );

  $opts->parse(qw/-y 2012/);

=head1 DESCRIPTION

This is an B<idea>.

Smart::Options::WithRule is a variant of L<Smart::Options>.

Smart::Options::WithRule support a rule based validation by L<Data::Validator>.

=head1 METHODS

L<Smart::Options::WithRule> inherits all methods from L<Smart::Options>.

=head2 C<rule>

a validation rule.

ref. L<Data::Validator>

  use Smart::Options::WithRule;

  my $opts = Smart::Options->new
                     ->usage("Usage: $0 -y [num]")
                     ->demand('y')
                     ->describe( y => 'year')
                     ->rule( y => { isa => 'Num' } );

=head1 AUTHOR

hayajo E<lt>hayajo@cpan.orgE<gt>

=head1 SEE ALSO

L<Smart::Options>, L<Data::Validator>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
