package Finance::QuoteTW::Allianz;
use Spiffy -Base;
use WWW::Mechanize;
use HTML::TableExtract;
use Encode qw/from_to/;
use Encode::TW;
use LWP::Charset qw(getCharset);

#---------------------------------------------------------------------------
#  Variables
#---------------------------------------------------------------------------

our $VERSION = 0.01;

#---------------------------------------------------------------------------
#  Methods
#---------------------------------------------------------------------------

sub fetch {
	my $b = WWW::Mechanize->new;
	my $response = $b->get(
		'http://www.allianzglobalinvestors.com.tw/frontend/' 
	  . 'Taiwan_SITE/Chinese/Fund/Fund_Price/onshore/fundprice.csv'
	);
	my $current_encoding = 'big5';
	my @content = split /\n+/, $b->content;
	my @result;

	foreach my $line (@content) {
		my @data = map { s/\s+//g; $_ } split /,/, $line;
		my $data_count = scalar @data;
		next if $data_count != 6;

		from_to($data[3], $current_encoding, $self->{encoding});
		(my $nav) = $data[4] =~ /(\d+(\.\d+)?)/;

		push @result, {
			name     => $data[3],
			date     => $data[5],
			nav      => $nav,
			change   => 'N/A',
			currency => 'TWD',
			type     => 'N/A',
		};
	}

	return @result;
}

__END__

=head1 NAME 

Finance::QuoteTW::Allianz - Get fund quotes from www.allianzglobalinvestors.com.tw

=head1 SYNOPSIS

See L<Finance::QuoteTW>.

=head1 DESCRIPTION

Get fund quotes from www.allianzglobalinvestors.com.tw

=head1 AUTHOR

Alec Chen <alec@cpan.org>

=head1 COPYRIGHT

Copyright (C) 2007 by Alec Chen. All rights reserved.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.

=cut

