#==========================================================================
#              Copyright (c) 1995-1999 Martien Verbruggen
#--------------------------------------------------------------------------
#
#	Name:
#		GD::Graph::utils.pm
#
#	Description:
#		Package of general utilities.
#
# $Id: utils.pm,v 1.4 2000/02/16 12:45:32 mgjv Exp $
#
#==========================================================================
 
package GD::Graph::utils;

$GD::Graph::utils::VERSION = 
	(q($Revision: 1.4 $) =~ /\s([\d.]+)/ ? $1 : "0.0");

use strict;

use vars qw( @EXPORT_OK %EXPORT_TAGS );
require Exporter;

@GD::Graph::utils::ISA = qw( Exporter );
 
@EXPORT_OK = qw(_max _min _round);
%EXPORT_TAGS = (all => [qw(_max _min _round)]);

sub _max { 
	my ($a, $b) = @_; 
	return undef	if (!defined($a) and !defined($b));
	return $a 		if (!defined($b));
	return $b 		if (!defined($a));
	( $a >= $b ) ? $a : $b; 
}

sub _min { 
	my ($a, $b) = @_; 
	return undef	if (!defined($a) and !defined($b));
	return $a 		if (!defined($b));
	return $b 		if (!defined($a));
	( $a <= $b ) ? $a : $b; 
}

sub _round { sprintf "%.0f", shift }

sub version { $GD::Graph::utils::VERSION }

"Just another true value";
