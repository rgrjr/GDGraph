# $Id: data.t,v 1.15 2003/06/17 01:24:36 mgjv Exp $
use Test;
use strict;

BEGIN { plan tests => 37 }

use GD::Graph::Data;
ok(1);
use Data::Dumper;
ok(1);

my @data = (
	[qw( Jan Feb Mar )],
	[11, 12],
	[21],
	[31, 32, 33, 34],
);

# Test setting up of object
my $data = GD::Graph::Data->new();
ok($data);
ok($data->isa("GD::Graph::Data"));

$GD::Graph::Error::Debug = 4;

# Test that empty object is empty
my @l = $data->get_min_max_x;
ok(@l, 0);

my $err_ar_ref = $data->clear_errors;
ok(@{$err_ar_ref}, 1);

# Fill with the data above
my $rc = $data->copy_from(\@data);
ok($rc);

#@l = $data->get_min_max_x;
#ok(@l, 2);
#ok("@l", "Jan Jan"); # Nonsensical test for non-numeric data

@l = $data->get_min_max_y(1);
ok(@l, 2);
ok("@l", "11 12");

my $nd = $data->num_sets;
ok($nd, 3);

@l = $data->get_min_max_y($nd);
ok(@l, 2);
ok("@l", "31 34");

my $np = $data->num_points;
my $y = $data->get_y($nd, $np-1);
ok($np, 3);
ok($y, 33);

$data->add_point(qw(X3 13 23 35));
$nd = $data->num_sets;
$np = $data->num_points;
$y = $data->get_y($nd, $np-1);
ok($nd, 3);
ok($np, 4);
ok($y, 35);

@l = $data->y_values(3) ;
ok(@l, 4);
ok("@l", "31 32 33 35");

$data->cumulate(preserve_undef => 0) ;
@l = $data->y_values(3);
ok(@l, 4);
ok("@l", "63 44 33 71");

$data->reverse;
@l = $data->y_values(1) ;
ok(@l, 4);
ok("@l", "63 44 33 71");

@l = $data->get_min_max_y_all;
ok(@l, 2);
ok("@l", "0 71");

my $data2 = $data->copy;
ok($data2);
ok($data2->isa("GD::Graph::Data"));
ok(Dumper($data2), Dumper($data));

my $file;

# Read tab-separated file
#
$file =	    -f 'data.tab'   ? 'data.tab'  :
	    -f 't/data.tab' ? 't/data.tab':
	    undef;

$data = GD::Graph::Data->new();
$rc = $data->read(file => $file);
ok(ref $rc, "GD::Graph::Data", "Couldn't read input data.tab input file");

if (!defined $rc)
{
    skip(1, "data.tab not read") for 1..2;
}
else
{
    ok($data->num_sets(), 5);
    ok(scalar $data->num_points(), 4);
}

# Read comma-separated file
#
$file =	    -f 'data.csv'   ? 'data.csv'  :
	    -f 't/data.csv' ? 't/data.csv':
	    undef;

$data = GD::Graph::Data->new();
$rc = $data->read(file => $file, delimiter => qr/,/);
ok(ref $rc, "GD::Graph::Data", "Couldn't read input data.csv input file");

if (!defined $rc)
{
    skip(1, "data.csv not read") for 1..2;
}
else
{
    ok($data->num_sets(), 5);
    ok(scalar $data->num_points(), 4);
}

# Read from DATA
#
# Skip first line of DATA
<DATA>;
$data = GD::Graph::Data->new();
$rc = $data->read(file => \*DATA, delimiter => qr/,/);
# TODO This test cannot fail, because I don't check whether DATA is an
# open file handle in read().
ok(ref $rc, "GD::Graph::Data", "Couldn't read from DATA file handle");

ok($data->num_sets(), 3);
ok(scalar $data->num_points(), 2);

__DATA__
We will skip this line
# And from here on, things should be normal for input files
A,1,2,3
B,1,2,3
