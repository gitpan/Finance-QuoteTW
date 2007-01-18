package Finance::QuoteTW::Blackrock;
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
	my $response = $b->get('http://www.blackrock.com.tw/retail/mliiffunds/prices.aspx');
	my $current_encoding = getCharset($response);
	my $form = $b->form_name('frmImportant');
	$b->submit;
	my @fund_type = qw/ae ee ge gs pe/;
	my @result;

	foreach my $fund_type (@fund_type) {
		$b->get("http://www.blackrock.com.tw/retail/mliiffunds/prices.aspx?at=eq&g=$fund_type");

		my $te = HTML::TableExtract->new;
		$te->parse($b->content);
		my @ts = $te->tables;
		my @rows = $ts[0]->rows;
		shift @rows;
		my $previous_name;

		foreach my $row (@rows) {
			my @data = map { s/\s+//g if $_; $_ } 
					   map { from_to($_, $current_encoding, $self->{encoding}); $_ } @$row;

			if ($data[0]) {
				$previous_name = $data[0];
			} else {
				$data[0] = $previous_name;
			}
			$data[2] ||= '';
			$data[3] = join '/', reverse split /-/, $data[3];

			push @result, {
				name     => $data[0],
				date     => $data[3],
				nav      => $data[5],
				change   => $data[6],
				currency => $data[4],
				type     => $data[1] . $data[2],
			};
		}
	}

	return @result;
}

__END__

=head1 NAME 

Finance::QuoteTW::Blackrock - Get fund quotes from www.blackrock.com.tw

=head1 SYNOPSIS

See L<Finance::QuoteTW>.

=head1 DESCRIPTION

Get fund quotes from www.blackrock.com.tw

=head1 AUTHOR

Alec Chen <alec@cpan.org>

=head1 COPYRIGHT

Copyright (C) 2007 by Alec Chen. All rights reserved.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.

=cut

