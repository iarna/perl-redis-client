package RedisClientTest;

use strict;
use warnings;

sub server { 
    my $host  = $ENV{PERL_REDIS_TEST_SERVER}   || 'localhost';
    my $port  = $ENV{PERL_REDIS_TEST_PORT}     || '6379';
    my $pw    = $ENV{PERL_REDIS_TEST_PASSWORD} || undef;
    my $class = $ENV{PERL_REDIS_TEST_CLASS}    || 'Redis::Client';
    
    eval qq{use $class};

    my $client = eval { 
        $class->new( host => $host,
                     port => $port,
                     $pw ? ( password => $pw ) : ( ) );
    };

    return if $@;
    return $client;
}


1;
