package Finance::QuoteTW::Franklin;
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
	my $response = $b->get('http://www.franklin.com.tw/1.FundIntro/1.3FundNet.asp');
	my $current_encoding = getCharset($response);
	my $date = $1 if $b->content =~ /(\d+\/\d+\/\d+)/;

	my $te = HTML::TableExtract->new;
	$te->parse($b->content);

	my @result;
	my @ts = $te->tables;
	foreach my $index (qw/8 12 16/) {
		my @rows = $ts[$index]->rows;
		shift @rows;

		foreach my $row (@rows) {
			next unless $row->[3] =~ /\d+\.\d+/;
			my @data = map { s/\s+//g; $_ } @$row;
			from_to($data[0], $current_encoding, $self->{encoding});
			$data[5] =~ s/\+//;
			$data[5] =~ s/^-$/0/;

			push @result, {
				name     => $data[0],
				date     => $date,
				nav      => $data[3],
				change   => $data[5],
				currency => $data[2],
				type     => $data[1],
			};
		}
	}

	return @result;
}

__END__

=head1 NAME 

Finance::QuoteTW::Franklin - Get fund quotes from www.franklin.com.tw

=head1 SYNOPSIS

See L<Finance::QuoteTW>.

=head1 DESCRIPTION

Get fund quotes from www.franklin.com.tw

=head1 AUTHOR

Alec Chen <alec@cpan.org>

=head1 COPYRIGHT

Copyright (C) 2007 by Alec Chen. All rights reserved.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.

=cut

