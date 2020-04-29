#!/usr/bin/perl

use lib '../src';
use Test::More tests => 43;
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

my @input = qw(R1);
my @trace = $resolver->go(5);
  is( $resolver->{x}, 0, "x0th");
  is( $resolver->{y}, 0, "y0th");
  is( $trace[0]->{x}, 1, "x1th");
  is( $trace[0]->{y}, 0, "y1th");
  is( $trace[1]->{x}, 2, "x2th");
  is( $trace[1]->{y}, 0, "y2th");
  is( $trace[2]->{x}, 3, "x3th");
  is( $trace[2]->{y}, 0, "y3th");
  is( $trace[3]->{x}, 4, "yx4th");
  is( $trace[3]->{y}, 0, "y4th");
  is( $trace[4]->{x}, 5, "x5th");
  is( $trace[4]->{y}, 0, "y5th");

# step list

my @steps = $resolver->trace(qw/R8 R4 R4 R8/);
{ my $underTest = shift @steps;
  is( $underTest->{x}, 0, "x0th");
  is( $underTest->{y}, 0, "y0th");
}
{ my $underTest = shift @steps;
  is( $underTest->{x}, 0, "x1th");
  is( $underTest->{y}, 1, "y1th");
}
{ my $underTest = shift @steps;
  is( $underTest->{x}, 0, "x2th");
  is( $underTest->{y}, 2, "y2th");
}
{ my $underTest = shift @steps;
  is( $underTest->{x}, 0, "x3th");
  is( $underTest->{y}, 3, "y3th");
}

# The second test case
is($resolver->stopWhereVisitCountMatches(2, qw/R8 R4 R4 R8/)->taxiDistance(), 4, "Test case second hit");

