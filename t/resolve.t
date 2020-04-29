#!/usr/bin/perl

use lib '../src';
use Test::More tests => 22;
use Resolve;

my $resolver = new Resolve;

# lets resolve to two
my @input = ("R1", "L2", "L1");
is( $resolver->move(@input)->taxiDistance(), 2, "Can handle a basic doubleback" );

is( Resolve->new('5', '4')->taxiDistance(), 9, "distance handles positives" );
is( Resolve->new('5', '-6')->taxiDistance(), 11, "distance handles negatives" );

is( $resolver->{direction}, \&Resolve::NORTH, 'validate assumption init direction');
is( $resolver->taxiDistance(), 0, 'validate assumption init distance');

## around the block left
my $r = $resolver->turnAndGo('L1');
is( $r->{direction}, \&Resolve::WEST, "left and direction north->west") ;
is( $r->taxiDistance(), 1, "left and distance 1") ;

my $s = $r->turnAndGo('L1');
is( $s->{direction}, \&Resolve::SOUTH, "left and direction west->south") ;
is( $s->taxiDistance(), 2, "left and distance 2") ;

my $t = $s->turnAndGo('L1');
is( $t->{direction}, \&Resolve::EAST, "left and direction south->east") ;
is( $t->taxiDistance(), 1, "left and distance 1") ;

my $u = $t->turnAndGo('L1');
is( $u->{direction}, \&Resolve::NORTH, "left and direction east->north") ;
is( $u->taxiDistance(), 0, "left and distance 0") ;

## around the block right
my $r = $resolver->turnAndGo('R1');
is( $r->{direction}, \&Resolve::EAST, "right and direction north->east") ;
is( $r->taxiDistance(), 1, "right and distance 1") ;

my $s = $r->turnAndGo('R1');
is( $s->{direction}, \&Resolve::SOUTH, "right and direction east->south") ;
is( $s->taxiDistance(), 2, "right and distance 2") ;

my $t = $s->turnAndGo('R1');
is( $t->{direction}, \&Resolve::WEST, "right and direction south->west") ;
is( $t->taxiDistance(), 1, "right and distance 1") ;

my $u = $t->turnAndGo('R1');
is( $u->{direction}, \&Resolve::NORTH, "right and direction west->north") ;
is( $u->taxiDistance(), 0, "right and distance 0") ;

# lets go back home
my @input = qw(R1 L2 L1 L2);
ok( $resolver->move(@input)->taxiDistance() == 0, "Can handle ending up back home" );


