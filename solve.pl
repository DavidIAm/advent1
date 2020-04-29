#!perl
#
# Run with 'cat input | perl solve.pl';

use lib 'src';

use Resolve;

print Resolve->new()->move(split /, ?/, join '', <>)->taxiDistance;

print "\n";
