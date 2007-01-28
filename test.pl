#!/usr/bin/perl

use strict;
use warnings;
use ExtUtils::testlib;
use Finance::QuoteTW;
use Data::Dumper;

my $q = Finance::QuoteTW->new;
print Dumper( $q->fetch_all );
