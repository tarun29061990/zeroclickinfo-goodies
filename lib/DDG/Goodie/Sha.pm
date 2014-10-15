package DDG::Goodie::Sha;
# ABSTRACT: Compute a SHA sum for a provided string.

use DDG::Goodie;
use Digest::SHA;

zci answer_type => "sha";
zci is_cached   => 1;

primary_example_queries 'SHA this';
secondary_example_queries 'sha-512 that', 'sha512sum dim-dims';
description 'SHA hash cryptography';
name 'SHA';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Sha.pm';
category 'calculations';
topics 'math';
attribution web => [ 'https://www.duckduckgo.com', 'DuckDuckGo' ],
            github => [ 'https://github.com/duckduckgo', 'duckduckgo'],
            twitter => ['http://twitter.com/duckduckgo', 'duckduckgo'];


triggers query => qr/^sha\-?(?<ver>1|224|256|384|512|)(?:sum|) (?<enc>hex|base64|)\s*(?<str>.*)$/i;

handle query => sub {
    my $ver = $+{'ver'} || 1;
    my $enc = lc $+{'enc'} || 'hex';
    my $str = $+{'str'};

    return unless $str;

    my $func_name = 'Digest::SHA::sha' . $ver . '_' . $enc;
    my $func      = \&$func_name;

    my $out = $func->($str);

    return $out,
      structured_answer => {
        input     => [$str],
        operation => $enc . ' SHA-' . $ver . ' hash',
        result    => $out
      };
};

1;
