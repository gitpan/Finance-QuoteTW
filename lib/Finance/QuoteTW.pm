package Finance::QuoteTW;
use Spiffy -Base;
use Carp;

#---------------------------------------------------------------------------
#  Variables
#---------------------------------------------------------------------------

our $VERSION = 0.04;

my @onshore = qw/capital cathay iit jpmrich tisc/;
my @offshore = qw/jpmrich franklin schroders blackrock/;
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
	my %args = @_;
    my @all = $args{site} =~ /capital/i   ? $self->capital(%args)   :
			  $args{site} =~ /cathay/i    ? $self->cathay(%args)    :
			  $args{site} =~ /iit/i       ? $self->iit(%args)       :
			  $args{site} =~ /jpmrich/i   ? $self->jpmrich(%args)   :
			  $args{site} =~ /tisc/i      ? $self->tisc(%args)      :
			  $args{site} =~ /franklin/i  ? $self->franklin(%args)  :
			  $args{site} =~ /schroders/i ? $self->schroders(%args) :
			  $args{site} =~ /blackrock/i ? $self->blackrock(%args) :
			  croak "Invalid site: $args{site}\n";
			  
	my @result = $args{name} ? grep { $_->{name} =~ $args{name} } @all : @all;
	return wantarray ? @result : \@result;
}

sub fetch_all {
	my $type = shift || '';
	my @array = $type eq 'onshore'  ? @onshore  :
				$type eq 'offshore' ? @offshore :
				@all;
	my %result = map { $_ => [ $self->fetch( site => $_, type => $type ) ] } @array;
	return wantarray ? %result : \%result;
}

sub capital { 
	require Finance::QuoteTW::Capital;
	Finance::QuoteTW::Capital::fetch($self, @_) 
}

sub cathay { 
	require Finance::QuoteTW::Cathay;
	Finance::QuoteTW::Cathay::fetch($self, @_) 
}

sub iit { 
	require Finance::QuoteTW::Iit;
	Finance::QuoteTW::Iit::fetch($self, @_) 
}

sub jpmrich { 
	require Finance::QuoteTW::Jpmrich; 
	Finance::QuoteTW::Jpmrich::fetch($self, @_) 
}

sub tisc { 
	require Finance::QuoteTW::Tisc;
	Finance::QuoteTW::Tisc::fetch($self, @_) 
}

sub franklin { 
	require Finance::QuoteTW::Franklin;
	Finance::QuoteTW::Franklin::fetch($self, @_) 
}

sub schroders {
	require Finance::QuoteTW::Schroders;
	Finance::QuoteTW::Schroders::fetch($self, @_) 
}

sub blackrock {
	require Finance::QuoteTW::Blackrock;
	Finance::QuoteTW::Blackrock::fetch($self, @_) 
}

__END__

=head1 NAME

Finance::QuoteTW - Fetch quotes of mutual funds in Taiwan

=head1 SYNOPSIS

	use Finance::QuoteTW;

	$q = Finance::QuoteTW->new(encoding => 'utf8');  # The default encoding is big5
	@tisc_fund = $q->fetch(site => 'tisc');          # Fetch all fund quotes from www.tisc.com.tw
	$tisc_fund = $q->fetch(site => 'tisc');          # Do the same thing but get an array reference
	@us_funds  = $q->fetch(site => 'blackrock', name => 'taiwan.*'); # Select funds with regex
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

	$q->fetch( site => 'tisc' );
	$q->fetch( site => 'blackrock', name => 'taiwan.*');
	$q->fetch( site => 'jpmrich',   type => 'onshore');

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

