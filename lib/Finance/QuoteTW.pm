package Finance::QuoteTW;
use Spiffy -Base;

#---------------------------------------------------------------------------
#  Variables
#---------------------------------------------------------------------------

our $VERSION = 0.02;

my @onshore = qw/capital cathay iit jfrich tisc/;
my @offshore = qw/jfrich franklin schroders blackrock/;
my @all = (@onshore, @offshore);

#---------------------------------------------------------------------------
#  Methods
#---------------------------------------------------------------------------

sub new() {
	my $class = shift;
	my %args = @_;
	$args{encoding} ||= 'big5';
	bless \%args, $class;
}

sub names {
	my $type = shift || '';
	return $type eq 'onshore'  ? @onshore  :
		   $type eq 'offshore' ? @offshore :
		   @all;
}

sub fetch {
	my $class = ucfirst(lc(shift));
	my $fund_name = shift;
	$fund_name = qr/$fund_name/ if $fund_name;

	$class = "Finance::QuoteTW::$class";
	eval "require $class; 1";
	bless $self, $class;
    my @all = $self->fetch(@_);

	bless $self, 'Finance::QuoteTW';
	my @result = $fund_name ? grep {$_->{name} =~ $fund_name} @all : @all;
	return wantarray ? @result : \@result;
}

sub fetch_all {
	my $type = shift || '';
	my @array = $type eq 'onshore'  ? @onshore  :
				$type eq 'offshore' ? @offshore :
				@all;
	my %result = map { $_ => [$self->fetch($_, undef, $type)] } @array;
	return wantarray ? %result : \%result;
}

__END__

=head1 NAME

Finance::QuoteTW - Fetch quotes of mutual funds in Taiwan

=head1 SYNOPSIS

	use Finance::QuoteTW;

	$q = Finance::QuoteTW->new(encoding => 'utf8');  # The default encoding is big5
	@tisc_fund = $q->fetch('tisc');                  # Fetch all fund quotes from www.tisc.com.tw
	$tisc_fund = $q->fetch('tisc');                  # Do the same thing but get an array reference
	@us_funds  = $q->fetch('blackrock', 'taiwan.*'); # Select funds with regex
	%all_funds = $q->fetch_all;                      # Fetch all available fund quotes
	%all_onshore_funds  = $q->fetch_all('onshore');  # Fetch all available onshore fund quotes
	%all_offshore_funds = $q->fetch_all('offshore'); # Fetch all available offshore fund quotes

=head1 DESCRIPTION

Finance::QuoteTW provides a easy way to get the latest fund quotes from various website in Taiwan

=head1 METHODS

=head2 new

Take an optional argument 'encoding'. The default value is big5.

	Finance::QuoteTW->new(encoding => 'utf8');

=head2 names

Return currently available site names.

	$q->names;
	$q->names('onshore');
	$q->names('offshore');

=head2 fetch

Return all fund quotes from specified site. You can use regex to filter the fund quotes.
The return value is a hash of array. Every hash contains a single fund information.
The attributes are: name, date, nav, change, type, currency

	$q->fetch('tisc');
	$q->fetch('blackrock', 'taiwan.*');

=head2 fetch_all

Fetch fund quotes from all available sites. The return value is a hash (or a hash reference).
The keys of the hash is the site abbreviations.

	$q->fetch_all;
	$q->fetch_all('onshore');
	$q->fetch_all('offshore');

=head1 AUTHOR

Alec Chen <alec@cpan.org>

=head1 COPYRIGHT

Copyright (C) 2007 by Alec Chen. All rights reserved.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.

=cut

