use 5.008008;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME              => 'Finance::QuoteTW',
    VERSION_FROM      => 'lib/Finance/QuoteTW.pm', # finds $VERSION
    PREREQ_PM         => {
		'Spiffy'             => 0.30,
		'WWW::Mechanize'     => 1.20,
		'HTML::TableExtract' => 2.10,
		'Encode'             => 2.12,
		'LWP::Charset'       => 0.06,

	}, # e.g., Module::Name => 1.1
    ($] >= 5.005 ?     ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM  => 'lib/Finance/QuoteTW.pm', # retrieve abstract from module
       AUTHOR         => 'Alec Chen <alec@cpan.org>') : ()),
);
