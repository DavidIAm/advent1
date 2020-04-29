package Resolve;

use List::Util qw/reduce/;

sub new {
  my ($name, $x, $y, $direction) = @_;
  my $self = bless {x => $x +0, y => $y+0, direction => $direction||\&NORTH}, $name;
}

sub turnAndGo {
  my ($self, $move) = @_;
  my ($initial, $distance) = $move =~ /^([RL])([0-9]+)/;
  return $self->turn($initial)->go($distance);
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
  return reduce { $a->goOne } $self, 1..$distance;
}

sub stopWhereVisitCountMatches {
  my ($self, $count, @moves) = @_;

}

sub move {
  my ($self, $first, @moves) = @_;
  return reduce { 
    $a->turnAndGo($b) } $self->turnAndGo($first), @moves;
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
