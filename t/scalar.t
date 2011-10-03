#!/usr/bin/env perl

use strict;
use warnings;

use lib 't';

use Test::More tests => 8;
use RedisClientTest;
use_ok 'RedisClientTest';

SKIP: { 
    my $redis = RedisClientTest->server;

    skip 'No Redis server available', 7 unless $redis;
    
    ok $redis;
    isa_ok $redis, 'Redis::Client';
    
    my $result = $redis->set( perl_redis_test_var => "foobar" );
    
    is $result, 'OK';

    my $got = $redis->get( 'perl_redis_test_var' );

    is $got, 'foobar';

    $got = 'narf';
    is $got, 'narf';

    # test round-trip
    my $got2 = $redis->get( 'perl_redis_test_var' );
    is $got2, 'narf';

    print $got2;

    my $res = $redis->del( 'perl_redis_test_var' );
    is $res, 1;
}


