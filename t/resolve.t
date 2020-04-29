#!/usr/bin/perl

use lib '../src';
use Test::Simple tests => 1;
use Resolve;

my $resolver = new Resolve;

# lets resolve to two
my @input = ("R1", "L2", "L1");

ok( $resolver->move(@input)->taxiDistance() == 2, "Can handle a basic doubleback" );

