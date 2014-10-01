package DDG::Goodie::SunInfo;
# ABSTRACT: sunrise and sunset information for the client location

use DDG::Goodie;
with 'DDG::GoodieRole::Dates';

use DateTime::Event::Sunrise;
use Try::Tiny;

zci answer_type => "sun_info";
zci is_cached   => 0;

triggers start => 'sunrise', 'sunset', 'what time is sunset', 'what time is sunrise';

primary_example_queries 'sunrise',              'sunset';
secondary_example_queries 'sunrise for aug 30', 'sunset on 2015-01-01';
description 'Compute the sunrise and sunset for a given day';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/SunInfo.pm';
category 'calculations';
topics 'everyday';
attribution github => ['https://github.com/duckduckgo', 'duckduckgo'];

my $time_format = '%l:%M%P';
my $datestring_regex = datestring_regex();

handle remainder => sub {

    my $remainder = shift // '';
    $remainder =~ s/\?//g;    # Strip question marks.
    my ($lat, $lon, $tz) = ($loc->latitude, $loc->longitude, $loc->time_zone);
    my $where = where_string();
    return unless (($lat || $lon) && $tz && $where);    # We'll need a real location and time zone.
    my $dt;
    if (!$remainder) {
        $dt = DateTime->now(time_zone => $tz);
    } elsif ($remainder =~ /^(?:on|for)\s+(?<when>$datestring_regex)$/) {
        try { $dt = parse_datestring_to_date($+{'when'}); $dt->set_time_zone($tz) };
    }
    return unless $dt;                                  # Also going to need to know which day.
    my @table_data = (['Location', $where]);

    my $sun_at_loc = DateTime::Event::Sunrise->new(
        longitude => $lon,
        latitude  => $lat,
        precise   => 1,                                 # Slower but more precise.
        silent    => 1,                                 # Don't fill up STDERR with noise, if we have trouble.
    );
    push @table_data, ['Date', date_output_string($dt)];

    # We don't care for which one they asked, we compute both sunrise and sunset
    push @table_data, ['Sunrise', $sun_at_loc->sunrise_datetime($dt)->strftime($time_format)];
    push @table_data, ['Sunset',  $sun_at_loc->sunset_datetime($dt)->strftime($time_format)];
    my $text = join(' | ', (map { join(' => ', @{$_}) } @table_data));
    return $text, html => to_html(@table_data);
};

sub where_string {
    my @where_bits;
    if (my $city = $loc->city) {
        # If we have the city we can abbrev the region or country, if avail.
        #  - Phoenixville, PA
        @where_bits = ($city, $loc->region || $loc->country_code3);
    } elsif (my $region_name = $loc->region_name) {
        # No city, but a region name; abbreviate the country or continent
        # - Pennsylvania, USA
        @where_bits = ($region_name, $loc->country_code3 || $loc->continent_code);
    } elsif (my $country = $loc->country) {
        # Country and continent, then, I guess.
        # United States, NA
        @where_bits = ($loc->country, $loc->continent_code);
    }
    return join(', ', @where_bits);
}

sub to_html {
    my $results  = "";
    my $minwidth = "90px";
    foreach my $result (@_) {
        $results .=
          "<div><span class=\"suninfo__label text--secondary\">$result->[0]: </span><span class=\"text--primary\">$result->[1]</span></div>";
        $minwidth = "180px" if length($result->[0]) > 10;
    }
    return $results . "<style> .zci--answer .suninfo__label {display: inline-block; min-width: $minwidth}</style>";
}

1;
