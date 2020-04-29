package Resolve;

use List::Util qw/reduce/;

sub new {
  my ($name, $x, $y, $direction) = @_;
  my $self = bless {x => $x +0, y => $y+0, direction => $direction||\&NORTH}, $name;
}

sub parseMove {
  my ($self, $move) = @_;
  return ($initial, $distance) = $move =~ /^([RL])([0-9]+)/;
}

sub turnAndTrace {
  my ($self, $move) = @_;
  my ($initial, $distance) = $self->parseMove($move);
  return $self->turn($initial)->go($distance);
}

sub turnAndGo {
  my ($self, $move) = @_;
  return ($self->turnAndTrace($move))[-1];
}

sub turn {
  my ($self, $direction) = @_;
  return Resolve->new($self->{x}, $self->{y}, $self->{direction}->()->{$direction});
}

sub goOne {
  my ($self) = @_;
  return Resolve->new(
    $self->{x} + $self->{direction}->()->{dx},
    $self->{y} + $self->{direction}->()->{dy},
    $self->{direction});
}

sub go {
  my ($self, $distance) = @_;
  my @stack = ();
  for (1..$distance) {
    push @stack, ($stack[-1]||$self)->goOne;
  }
  return @stack;
}

sub stopWhereVisitCountMatches {
  my ($self, $count, @moves) = @_;
  my %visitCounter = {};
  foreach ($self->trace(@moves)) {
    $visitCounter->{$_->{x}}->{$_->{y}} ++;
    return $_ if $visitCounter->{$_->{x}}->{$_->{y}} == $count;
  }
  return $self;
}

sub trace {
  my ($self, @moves) = @_;
  my @stack = ($self);
  foreach (@moves) {
    push @stack, ($stack[-1])->turnAndTrace($_);
  }
  return @stack;
}

sub move {
  my ($self, @moves) = @_;
  return reduce { 
    $a->turnAndGo($b) } $self, @moves;
}

sub taxiDistance {
  my ($self) = @_;
  return abs($self->{x}) + abs($self->{y});
}

sub NORTH {
  { L => \&WEST,
    R => \&EAST,
    dx => 1,
    dy => 0 }
}

sub WEST {
  { L => \&SOUTH,
    R => \&NORTH,
    dx => 0,
    dy => -1 }
}

sub SOUTH {
  { L => \&EAST,
    R => \&WEST,
    dx => -1,
    dy => 0 }
}

sub EAST {
  { L => \&NORTH,
    R => \&SOUTH,
    dx => 0,
    dy => 1 }
}

1;
