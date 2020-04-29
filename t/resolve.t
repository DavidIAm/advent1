#!/usr/bin/perl

use lib '../src';
use Test::Simple tests => 2;
use Resolve;

my $resolver = new Resolve;

# lets resolve to two
my @input = ("R1", "L2", "L1");
ok( $resolver->move(@input)->taxiDistance() == 2, "Can handle a basic doubleback" );

# lets go back home
my @input = qw(R1 L2 L1 L2);
ok( $resolver->move(@input)->taxiDistance() == 0, "Can handle ending up back home" );


