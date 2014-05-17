package Log::Minimal::Object;
use 5.008005;
use strict;
use warnings;
use Carp ();
use Log::Minimal ();

our $VERSION = "0.01";
our $AUTOLOAD;

sub new {
    my $class = shift;

    my %args = scalar @_ == 1 ? %{$_[0]} : @_;

    for my $key (keys %Log::Minimal::Object::) {
        if ($key =~ /\A[a-z]/ && $key ne 'new' && $key ne 'import') { # XXX
            delete $Log::Minimal::Object::{$key};
        }
    }

    bless {
        color => $args{color} || 0,
        die => $args{die} || 0,
        print => $args{print} || 0,
        autodump => $args{autodump} || 0,
        trace_level => $args{trace_level} || 0,
        log_level => $args{log_level} || 'DEBUG',
        escape_whitespace => $args{escape_whitespace} || 0,
    }, $class;
}

sub AUTOLOAD {
    my $method_name = (split /::/, $AUTOLOAD)[-1];
    if (my $meth = Log::Minimal->can($method_name)) {
        no strict "refs"; ## no critic
        *{$AUTOLOAD} = sub {
            my $self = shift;
            local $Log::Minimal::COLOR             = $self->{color};
            local $Log::Minimal::AUTODUMP          = $self->{autodump};
            local $Log::Minimal::TRACE_LEVEL       = $self->{trace_level};
            local $Log::Minimal::LOG_LEVEL         = $self->{log_level};
            local $Log::Minimal::ESCAPE_WHITESPACE = $self->{escape_whitespace};

            if (my $die = $self->{die}) {
                local $Log::Minimal::DIE = $die;
            }

            if (my $print = $self->{print}) {
                local $Log::Minimal::PRINT = $print;
            }

            $meth->(@_);
        };
        goto &$AUTOLOAD;
    }
    else {
        Carp::croak qq{Can't call method "$method_name" which has not been defined in Log::Minimal};
    }
}

sub DESTROY {}

1;
__END__

=encoding utf-8

=head1 NAME

Log::Minimal::Object - It's new $module

=head1 SYNOPSIS

    use Log::Minimal::Object;

=head1 DESCRIPTION

Log::Minimal::Object is ...

=head1 LICENSE

Copyright (C) moznion.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

moznion E<lt>moznion@gmail.comE<gt>

=cut

