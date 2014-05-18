package Log::Minimal::Object;
use 5.008005;
use strict;
use warnings;
use Log::Minimal ();

our $VERSION = "0.01";

use constant {
    ORIGINAL_PRINT => $Log::Minimal::PRINT,
    ORIGINAL_DIE   => $Log::Minimal::DIE,
};

sub new {
    my $class = shift;

    my %args = scalar @_ == 1 ? %{$_[0]} : @_;

    bless {
        color             => $args{color} || 0,
        die               => $args{die} || 0,
        print             => $args{print} || 0,
        autodump          => $args{autodump} || 0,
        trace_level       => $args{trace_level} || 2,
        log_level         => $args{log_level} || 'DEBUG',
        escape_whitespace => $args{escape_whitespace} || 0,
    }, $class;
}

sub critf   { shift->_log('critf',   @_) }
sub warnf   { shift->_log('warnf',   @_) }
sub infof   { shift->_log('infof',   @_) }
sub debugf  { shift->_log('debugf',  @_) }
sub critff  { shift->_log('critff',  @_) }
sub warnff  { shift->_log('warnff',  @_) }
sub infoff  { shift->_log('infoff',  @_) }
sub debugff { shift->_log('debugff', @_) }
sub croakf  { shift->_log('croakf',  @_) }
sub croakff { shift->_log('croakff', @_) }
sub ddf     { shift->_log('ddf',     @_) }

sub _log {
    my $self = shift;
    my $meth = shift;

    local $Log::Minimal::COLOR             = $self->{color};
    local $Log::Minimal::AUTODUMP          = $self->{autodump};
    local $Log::Minimal::TRACE_LEVEL       = $self->{trace_level};
    local $Log::Minimal::LOG_LEVEL         = $self->{log_level};
    local $Log::Minimal::ESCAPE_WHITESPACE = $self->{escape_whitespace};

    local $Log::Minimal::DIE   = $self->{die}   ? $self->{die}   : ORIGINAL_DIE;
    local $Log::Minimal::PRINT = $self->{print} ? $self->{print} : ORIGINAL_PRINT;

    $self->{$meth} ||= Log::Minimal->can($meth);
    $self->{$meth}->(@_);
}

1;
__END__

=encoding utf-8

=head1 NAME

Log::Minimal::Object - Provides the OOP interface of Log::Minimal

=head1 SYNOPSIS

    use Log::Minimal::Object;

    my $logger = Log::Minimal::Object->new();
    $logger->infof("This is info!"); # => 2014-05-18T17:24:02 [INFO] This is info! at eg/sample.pl line 13
    $logger->warnf("This is warn!"); # => 2014-05-18T17:24:02 [WARN] This is warn! at eg/sample.pl line 14

=head1 DESCRIPTION

Log::Minimal::Object is the simple wrapper to provide the OOP interface of L<Log::Minimal>.

This module can have and apply independent settings for each instance, it's intuitive!

=head1 CLASS METHODS

=over 4

=item * Log::Minimal::Object->new(%arg | \%arg)

Creates the instance. This method receives arguments to configure as hash or hashref, like so;

    my $logger = Log::Minimal::Object->new(
        color     => 1,
        log_level => 'WARN',
    );

Please refer to the L</CONFIGURATIONS> to know details of configurable items.

=back

=head1 INSTANCE METHODS

Instance of this module provides the methods that are defined in the L<Log::Minimal/EXPORT FUNCTIONS> (e.g. infof, warnf, and etc).

=head1 CONFIGURATIONS

The configurable keys and its relations are follows (please see also L<Log::Minimal/CUSTOMIZE> to get information of C<$Log::Minimal::*>):

=over 4

=item * color

C<$Log::Minimal::COLOR>

=item * autodump

C<$Log::Minimal::AUTODUMP>

=item * trace_level

C<$Log::Minimal::TRACE_LEVEL>

=item * log_level

C<$Log::Minimal::LOG_LEVEL>

=item * escape_whitespace

C<$Log::Minimal::ESCAPE_WHITESPACE>

=item * print

C<$Log::Minimal::PRINT>

=item * die

C<$Log::Minimal::DIE>

=back

=head1 SEE ALSO

L<Log::Minimal>

=head1 LICENSE

Copyright (C) moznion.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

moznion E<lt>moznion@gmail.comE<gt>

=cut

