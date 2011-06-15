#!perl

use warnings;
use strict;
use Test::More;
use Test::Exception;
use Test::Deep;
use IO::String;
use Redis;
use Redis::Dump;

use lib 't/tlib';
use Test::SpawnRedisServer;

my ( $c, $srv ) = redis();
END { $c->() if $c }

ok( my $r = Redis->new( server => $srv ),
    'connected to our test redis-server' );
ok( my $dump = Redis::Dump->new( server => $srv ), 'run redis-dump' );

$r->set( foo => 1 );
$r->set( 'bar-test' => 2 );

is_deeply( [ $dump->_get_keys ], [ 'foo', 'bar-test' ] );
is_deeply( { $dump->run }, { 'bar-test' => '2', 'foo' => '1' } );

done_testing();
