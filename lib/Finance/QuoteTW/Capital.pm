package Finance::QuoteTW::Capital;
use Spiffy -Base;
use WWW::Mechanize;
use HTML::TableExtract;
use Encode qw/from_to/;
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
	my $response = $b->get('http://www.capitalfund.com.tw/jsp/fund08.jsp');
	my $current_encoding = getCharset($response);

	my $te = HTML::TableExtract->new;
	$te->parse($b->content);

	my @ts = $te->tables;
	my @result;
	my @rows = $ts[8]->rows;
	shift @rows;

	foreach my $row (@rows) {
		next unless $row->[1];
		my @data = map { s/\s+//g; $_ } @$row;
		my $type = 'N/A';
		from_to($data[0], $current_encoding, $self->{encoding});
		$data[3] =~ s/\+//;

		push @result, {
			name     => $data[0],
			date     => $data[1],
			nav      => $data[2],
			change   => $data[3],
			currency => 'TWD',
			type     => $type,
		};
	}

	return @result;
}

__END__

=head1 NAME 

Finance::QuoteTW::Capital - Get fund quotes from www.capitalfund.com.tw

=head1 SYNOPSIS

See L<Finance::QuoteTW>.

=head1 DESCRIPTION

Get fund quotes from www.capitalfund.com.tw

=head1 AUTHOR

Alec Chen <alec@cpan.org>

=head1 COPYRIGHT

Copyright (C) 2007 by Alec Chen. All rights reserved.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.

=cut

