package Redis::Client::Coro;
# ABSTRACT: Coroutine friendly Redis client

use Moose;
use Coro::Handle;
use AnyEvent::Socket;
use Carp 'croak';
use utf8;
use namespace::sweep 0.003;

extends 'Redis::Client';

has '+_sock' => (isa=>'Coro::Handle');

sub _build__sock { 
    my $self = shift;
    
    tcp_connect $self->host, $self->port, Coro::rouse_cb;
    my $sock = unblock +(Coro::rouse_wait)[0]
       or die sprintf q{Can't connect to Redis host at %s:%s: %s}, $self->host, $self->port, $@;
    return $sock;
}

__PACKAGE__->meta->make_immutable;

1;

__END__


=pod

=encoding utf8


=head1 SYNOPSIS

    use Redis::Client::Coro;

    my $client = Redis::Client::Coro->new( host => 'localhost', port => 6379 );
    
    # Use it as usual, does not block other coroutines

=head1 DESCRIPTION

Redis::Client::Coro is exactly the same as L<Redis::Client> but uses an
AnyEvent::Socket and Coro::Handle for it's tcp socket and as such, will not
block other active coroutines.

