package RedisCoroClientTest;

use strict;
use warnings;

use Redis::Client::Coro;

sub server { 
    my $host = $ENV{PERL_REDIS_TEST_SERVER}   || 'localhost';
    my $port = $ENV{PERL_REDIS_TEST_PORT}     || '6379';
    my $pw   = $ENV{PERL_REDIS_TEST_PASSWORD} || undef;

    my $client = eval { 
        Redis::Client::Coro->new( host => $host,
                                  port => $port,
                                  $pw ? ( password => $pw ) : ( ) );
    };

    return if $@;
    return $client;
}


1;
