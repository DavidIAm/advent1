#!perl
#
# Run with 'cat input | perl solve.pl';

use lib 'src';

use Resolve;

print Resolve->new()->stopWhereVisitCountMatches(2, split /, ?/, join '', <>)->taxiDistance;

print "\n";
