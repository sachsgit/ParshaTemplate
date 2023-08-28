#!/usr/bin/perl -w
use strict;
use constant::boolean;
use Cwd qw(abs_path);
use Data::Dump qw(dump);
use Date::Convert;
use DateTime::Event::Sunrise;
use DateTime;
use Encode;
use File::Basename;
use File::Find;
use File::Spec;
use HTML::TreeBuilder::XPath;
use JSON;
use LWP::Simple qw($ua get);
use Lingua::EN::Numbers qw(num2en_ordinal num2en);
use List::MoreUtils qw(first_index);
use OpenOffice::OODoc;
use Switch;
use Time::Piece;
use Tie::IxHash;

# g/\(\w\+\); # \(\w\+\)/s//\2; # \1/
use constant DEBUG                  => FALSE; # TRUE;
use constant DEBUG_HEADER           => FALSE; # TRUE;
use constant DEBUG_NEXTPARSHA       => FALSE; # TRUE;
use constant DEBUG_NEXTHMONTH       => FALSE; # TRUE;
use constant DEBUG_SHABBATMEVARCHIM => FALSE; # TRUE;
use constant DEBUG_TITLE            => FALSE; # TRUE;
use constant DEBUG_YEAR             => FALSE; # TRUE;
use constant NOT_FOUND              => -1;

use constant BLOG_ID => "6494936020449971947";

use constant DRIVE_LETTER => "F:";

my $strParshotPath = DRIVE_LETTER . "\\Parshot";
$strParshotPath = "." if ( ! -d $strParshotPath);

my $path = dirname(abs_path($0));
my @arMods = (
     File::Spec->catfile($path, "lib", "MyTorahReading.pm"),
     File::Spec->catfile($path, "lib", "MyCommonFuncs.pm")
);
foreach my $mod ( @arMods ) {
     require ($mod);
} # end foreach mod

my $API_KEY = myCommonFuncs::getSecret();


no warnings 'once';
my $alef        = $myTorahReading::alef;
my $bet         = $myTorahReading::bet;
my $gimel       = $myTorahReading::gimel;
my $dalet       = $myTorahReading::dalet;
my $he          = $myTorahReading::he;
my $vav         = $myTorahReading::vav;
my $zayin       = $myTorahReading::zayin;
my $het         = $myTorahReading::het;
my $tet         = $myTorahReading::tet;
my $yod         = $myTorahReading::yod;
my $final_kaf   = $myTorahReading::final_kaf;
my $kaf         = $myTorahReading::kaf;
my $lamed       = $myTorahReading::lamed;
my $final_mem   = $myTorahReading::final_mem;
my $mem         = $myTorahReading::mem;
my $final_nun   = $myTorahReading::final_nun;
my $nun         = $myTorahReading::nun;
my $samekh      = $myTorahReading::samekh;
my $ayin        = $myTorahReading::ayin;
my $final_pe    = $myTorahReading::final_pe;
my $pe          = $myTorahReading::pe;
my $final_tsadi = $myTorahReading::final_tsadi;
my $tsadi       = $myTorahReading::tsadi;
my $qof         = $myTorahReading::qof;
my $resh        = $myTorahReading::resh;
my $shin        = $myTorahReading::shin;
my $tav         = $myTorahReading::tav;
my $geresh      = $myTorahReading::geresh;
my $gershayim   = $myTorahReading::gershayim;
my $date        = $myTorahReading::date;
my $sec         = $myTorahReading::sec;
my $min         = $myTorahReading::min;
my $hour        = $myTorahReading::hour;
my $mday        = $myTorahReading::mday;
my $month       = $myTorahReading::month;
my $mon         = $myTorahReading::mon;
my $yr19        = $myTorahReading::yr19;
my $wday        = $myTorahReading::wday;
my $yday        = $myTorahReading::yday;
my $isdst       = $myTorahReading::isdst;
my $year        = $myTorahReading::year;
my $hFlag       = $myTorahReading::hFlag;
my $hdate       = $myTorahReading::hdate;
my $hyear       = $myTorahReading::hyear;
my $hmon        = $myTorahReading::hmon;
my $hmonth      = $myTorahReading::hmonth;
my $hmday       = $myTorahReading::hmday;
my $parshaWord  = $myTorahReading::parshaWord;

tie my %doubleParshot            , 'Tie::IxHash' , %myTorahReading::doubleParshot;
tie my %doubleParshotHebrewNames , 'Tie::IxHash' , %myTorahReading::doubleParshotHebrewNames;
tie my %doubleTorahReading       , 'Tie::IxHash' , %myTorahReading::doubleTorahReading;
tie my %parshotHebrewNames       , 'Tie::IxHash' , %myTorahReading::parshotHebrewNames;
tie my %specialParshot           , 'Tie::IxHash' , %myTorahReading::specialParshot;
tie my %specialParshotNames      , 'Tie::IxHash' , %myTorahReading::specialParshotNames;
tie my %specialParshotURLs       , 'Tie::IxHash' , %myTorahReading::specialParshotURLs;
tie my %torahReading             , 'Tie::IxHash' , %myTorahReading::torahReading;
tie my %totalDaysInHebMonths     , 'Tie::IxHash' , %myTorahReading::totalDaysInHebMonths;
tie my %translateHebMonths       , 'Tie::IxHash' , %myTorahReading::translateHebMonths;

my @wkdy       = @myTorahReading::wkdy;
my @abbr       = @myTorahReading::abbr;
my @hmon_names = @myTorahReading::hmon_names;
use warnings;

my $isDouble          = FALSE;
my $isShabbatMevakhim = FALSE;
my $parshaName        = "";
my $specialShabbat    = "";

while ($#ARGV > -1) {
     switch ($ARGV[0]) {
         case qr/^-dp$/    { $isDouble = TRUE; }
         case qr/^-p$/     { $parshaName = $ARGV[1]; shift; }
         case qr/^-sm$/    { $isShabbatMevakhim = TRUE; }
         case qr/^-ss$/    { $specialShabbat = $ARGV[1]; shift; }
         case qr/^-(h|\?)/ { &syntax(); exit -3; }
         else              { die "Unknown parameter: \"$ARGV[0]\"\n"; }
     }
     shift;
} # end if

printf "%-20s %-10s\n", "\$isDouble", myCommonFuncs::displayTF($isDouble);

if ($specialShabbat ne "") {
     my @arSpecial = keys %specialParshot;
     my $spIndex = first_index { $_ eq $specialShabbat } @arSpecial;
     die "Did not found $specialShabbat\n" if ($spIndex < 0);

     printf "%-20s %-10s %30s\n", "\$specialShabbat", $specialShabbat,
          $specialParshot{$specialShabbat};
} # end if

my $dt = DateTime->now();
$dt->set_time_zone('America/New_York');

my $sunrise = DateTime::Event::Sunrise->new (
     longitude => '-77.3',
     latitude => '38.7'
);

my $cmp = DateTime->compare($dt, $sunrise->sunset_datetime($dt));

## Key
## switch ($cmp) {
##     case -1 { print "Before sunset\n"; }
##     case 0  { print "At sunset\n"; }
##     case 1  { print "After sunset\n"; }
##     else    { print "Unknown case $cmp\n"; }
## } # end switch

$isShabbatMevakhim = isShabbatMevakhim($dt->month, $dt->day, $dt->year);

$mon = $abbr[$dt->month()];
$date = new Date::Convert::Gregorian($dt->year(),$dt->month(),$dt->day());
convert Date::Convert::Hebrew $date;

$hdate  = $date->date_string;
$hyear  = $1 if ($hdate =~ /^(\d{4})\s+.*\s+\d+$/);
$hmon   = $1 if ($hdate =~ /^\d{4}\s+(.*)\s+\d+$/);
$hmon = "Tevet" if ($hmon eq "Teves");
$hmday  = $1 if ($hdate =~ /^\d{4}\s+.*\s+(\d+)$/);
$hmday++ if ($cmp == 1); # After Sunset, Next Day
$hmon   = $hmon . " I" if ($date->is_leap && $hmon eq "Adar");

$hdate = $hmday . " " . $hmon . " " . $hyear;

my $timestamp = $dt->day_abbr() . ", " . $dt->month_abbr() . " "
     . $dt->day() . ", " . $dt->year() . " | " . $hdate;

printf "%-20s %-10s\n", "\$isShabbatMevakhim", myCommonFuncs::displayTF($isShabbatMevakhim);

my $strLastParshotFile = "";
if ($parshaName eq "" ) {
    find(\&FindLastParshot, $strParshotPath);
} else {
    $strLastParshotFile = "XXX Parsha $parshaName.odt";
}
print STDERR "\$strLastParshotFile: \"$strLastParshotFile\"\n"
     if (DEBUG == TRUE);

my $ParshaCount = substr($strLastParshotFile, 0, 3);
$ParshaCount++ if ($ParshaCount ne "XXX");
print STDERR "\$ParshaCount is $ParshaCount\n" if DEBUG == TRUE;

my $strLastParsha = substr($strLastParshotFile, 10);
$strLastParsha = substr($strLastParsha, 1,
     index($strLastParsha, ".") - 1) if ($strLastParsha =~ /\./);

$strLastParsha = $1 if ($strLastParsha =~ /^(.*) - (Shabb|Parsha).*$/);
$strLastParsha = myCommonFuncs::trim($strLastParsha);
print "Last Parsha: \"$strLastParsha\"\n" if (DEBUG == TRUE);

my $nextParsha = FindNextParshot($strLastParsha);
print "Next Parsha: \"$nextParsha\"\n" if (DEBUG == TRUE);

$nextParsha = $doubleParshot{$nextParsha} if ($isDouble == TRUE);
print "Double Parsha: \"$nextParsha\"\n" if (DEBUG == TRUE);

my $header = $bet . $samekh . $gershayim . $dalet;
my $doc = odfDocument(
     file   => "..\\resources\\" . $ParshaCount . " Parsha " . $nextParsha .  ".odt",
     create => 'text'
);
my $rightStyle = $doc->createStyle(
     "RightStyle",
     family     => 'paragraph',
     parent     => 'Standard',
     properties => {
          '-area'             => 'paragraph',
          'fo:text-align'     => 'right',
          'style:font-name'   => 'Times New Roman'
     }
);
my $leftStyle = $doc->createStyle(
     "LeftStyle",
     family     => 'paragraph',
     parent     => 'Standard',
     properties => {
          '-area'             => 'paragraph',
          'fo:text-align'     => 'left',
          'style:font-name'   => 'Times New Roman'
     }
);
$doc->appendParagraph(
     text => encode_utf8 $header,
     style => "RightStyle"
);

# Current Hebrew/Jewish Year
my $hlyear = "${he}${geresh}${tav}${shin}${pe}${gershayim}${bet}";
my $hlday = CalcHebNumForDay($hmday);

$doc->appendParagraph(
     text => "$timestamp | " . encode_utf8 $hlday . " "
          . $translateHebMonths{$hmon} . " " . $hlyear . "\n",
     style => "RightStyle"
);

my $parshaHebrewName = ($isDouble == TRUE
    ? $doubleParshotHebrewNames{$nextParsha} 
    : $parshotHebrewNames{$nextParsha});
$doc->appendParagraph(
     text => "\nParsha $nextParsha \/ "
          . encode_utf8($parshaWord)
          . " "
          . encode_utf8($parshaHebrewName),
     style => "LeftStyle"
);
my $reading = ($isDouble == TRUE
    ? $doubleTorahReading{$nextParsha} : $torahReading{$nextParsha});
die "Unable to find Torah Reading\n" if ($reading eq "");

print "Reading: \"$reading\"\n" if (DEBUG == TRUE);
$doc->appendParagraph(
     text => "$reading\n",
     style => "LeftStyle"
);

if ($specialShabbat ne "") {
     $doc->appendParagraph(
         text => "Shabbat $specialShabbat \/ "
          . encode_utf8($specialParshotNames{$specialShabbat}),
          style => "LeftStyle"
     );
} # end if

my $pChayenu = $doc->appendParagraph(
     text => "Translation Source: Chayenu, Margolin"
               . " Edition Chumash-Rashi\n",
     style => "LeftStyle"
);
$doc->setHyperlink($pChayenu, "Chayenu", "http://www.chayenu.org");

my $p = $doc->appendParagraph(
     text => "",
     style => "LeftStyle"
);

if ($isShabbatMevakhim == TRUE) {
    $hmon = "Menachem Av" if ($hmon eq "Av");
    my $monthIndex = first_index { $_ eq $hmon } @hmon_names;
    $monthIndex = 0 if (($monthIndex + 1) > 12);
    print "\$monthIndex: $monthIndex\n" if DEBUG_NEXTHMONTH == TRUE;
    my $nextHmon = $hmon_names[$monthIndex + 1];
    $nextHmon = $nextHmon . " I" if ($date->is_leap && $nextHmon eq "Adar");
    $nextHmon = $hmon_names[0] if (!$date->is_leap && $nextHmon eq "Adar II");
    print "\$nextHmon: $nextHmon\n" if DEBUG_NEXTHMONTH == TRUE;
    my $shabbatMevakhim = "${shin}${bet}${tav} "
     . "${mem}${bet}${resh}${kaf}${yod}${final_mem} "
     . $translateHebMonths{$nextHmon};
    my $p = $doc->appendParagraph(
          text => "Shabbat Mevarchim " . $nextHmon . " / "
          . encode_utf8($shabbatMevakhim)
          . "\nMolad for " . $nextHmon . " will be on \n",
          style => "LeftStyle"
    );

    $p = $doc->appendParagraph(
          text => "",
          style => "LeftStyle"
    );
}

my @arDoubleParshotKeys = keys %doubleParshot;
my $couldBeDouble = first_index { $_ eq $nextParsha } @arDoubleParshotKeys;
my $pastPosts = "Past Posts:";
for (my $yrIndex = ($hyear - 1); $yrIndex > 5772; $yrIndex--) {
    if ($isDouble == TRUE) {
        my @parts = split /-/, $nextParsha, 2;
		$pastPosts = $pastPosts . " $parts[0] $yrIndex, $parts[1] $yrIndex,";
    } # Is Double, Include parts
    $pastPosts = $pastPosts . " $nextParsha $yrIndex,";
	if ($couldBeDouble > NOT_FOUND) {
		$pastPosts = $pastPosts . " $doubleParshot{$nextParsha} $yrIndex,";
	} # Not Double, But Include
} #end for each year
$pastPosts = $pastPosts . " and $nextParsha 5772\n";

my $pPastPosts = $doc->appendParagraph(
     text => $pastPosts,
     style => "LeftStyle"
);

my @arParshot = keys %torahReading;
my $doubleParsha = "";
if ($isDouble == TRUE) {
     $doubleParsha = $nextParsha;
     $nextParsha = $2 if ($nextParsha =~ /(\w+)-(\w+)/);
}
my $parshaIndex = first_index { $_ eq $nextParsha } @arParshot;
$parshaIndex++; # Zero-Offset
my $pos = index($torahReading{$nextParsha}, ' ',
     index($torahReading{$nextParsha}, ' ') + 1);
my $sefer = substr($torahReading{$nextParsha}, 0, $pos);
$sefer = myCommonFuncs::trim($sefer);

tie my %arSeferParshot, 'Tie::IxHash';
foreach my $key ( keys %torahReading ) {
     $arSeferParshot{$key} = $torahReading{$key}
          if ($torahReading{$key} =~ /$sefer/);
} # end foreach Parshot/Sefer

my @arSeferParsha = keys %arSeferParshot;
my $parshaSeferIndex = first_index { $_ eq $nextParsha } @arSeferParsha;
$parshaSeferIndex++; # Offset

my $parshaCount = $#arSeferParsha + 1; # Offset

$nextParsha = $doubleParsha if ($isDouble == TRUE);

my $isLast = ($parshaSeferIndex == $parshaCount);
printf "%-20s %-10s\n", "\$isLast", myCommonFuncs::displayTF($isLast);
printf "%-20s %-10s\n", "\$nextParsha", $nextParsha;

$doc->appendParagraph(
     text => "\n\nThis week Parsha is " .
     ($isDouble == TRUE ? "a double " :  "a ")
     . "Parsha $nextParsha,"
     . " which is the "
     . ($isLast ?  "last" : num2en_ordinal($parshaSeferIndex) )
     . " Parshot of " . $sefer . ", which has "
     . num2en($parshaCount) . " Parshot, and the "
     . num2en_ordinal($parshaIndex) . " Parshot "
     . " within the entire Torah, which is divided into "
     . num2en(scalar keys %torahReading) . " Parshot in total.\n\n",
     style => "LeftStyle"
);

if ($isLast == TRUE) {
     my $chazak = encode_utf8 ${het} . ${zayin} . ${qof};
     my $vnitchazek = encode_utf8 ${vav} . ${nun} . ${tav} . ${het}
          . ${zayin} . ${qof};
     $doc->appendParagraph(
          text => "As this is the last Parshot of " . $sefer
          . ", we say, \"Chazak! Chazak! V'nitchazek! ("
          . $chazak . "! " . $chazak . "! " . $vnitchazek . "!"
          . ")\" which means, \"Be strong! Be strong!"
          . " May we be strengthen!\"\n",
          style => "LeftStyle"
     );
}

if ($specialShabbat ne "") {
    my $pSpecialShabbat = $doc->appendParagraph(
        text => "Shabbat $specialShabbat is the "
          . "$specialParshot{$specialShabbat}.\n",
        style => "LeftStyle"
    );
    $doc->setHyperlink($pSpecialShabbat, "Shabbat $specialShabbat",
         $specialParshotURLs{$specialShabbat});
}

my $url = "https://www.googleapis.com/blogger/v3/blogs/"
     . BLOG_ID . "/posts?"
     . "&labels=" . $nextParsha
     . "&key=" . $API_KEY;

print "URL: \"$url\"\n" if DEBUG_TITLE == TRUE;

my $json_data = myCommonFuncs::geturl($url);

my $objData = from_json($json_data);

my %links;
my @items = @{ $objData->{'items'} } if defined $objData->{'items'};
my @arXPaths = (
    "//div[2]/span[1]",
    "//div[2]/text()",
    "//div[3]/span[1]",
    "//div[1]/span[1]",
    "//div[1]/text()",
    "//div[2]/span[2]/span",
    "//div[1]/span[4]/text()",
    "//div[4]/text()",
    "//div[2]/span[2]/span/text()",
    "//div[3]/text()",
    "//p[3]/font/text()",
    "//p[4]/font[1]/font[1]/text()",
    "//p[2]/span/text()",
    "//p[3]/span/text()",
    "//p[4]/span/text()",
    "//p[4]/text()",
);
foreach my $item ( @items) {
     my $tree = HTML::TreeBuilder::XPath->new;
     $tree->parse("<blog>" . $item->{"content"} . "</blog>");
     my $span = $tree->findvalue( $arXPaths[0] );
     $span = myCommonFuncs::trim($span);
     binmode(STDOUT, ":utf8");
     print "\$span[$arXPaths[0] (0)] is \"$span\"\n" if (DEBUG_YEAR == TRUE);
     my $year = "";
     if ($span =~ / (57\d\d)[ \/]/m) {
          $year = $1;
     } elsif ($span =~ / \w+ (57\d\d)$/m) {
          $year = $1;
     } elsif ($span =~ / 20\d\d \/ (57\d\d)/m) {
          $year = $1;
     } elsif ($span =~ /, (57\d\d)/m) {
          $year = $1;
     }
     my $i = 1;
     while ($year eq "" && $i <= $#arXPaths) {
          $span = $tree->findvalue( $arXPaths[$i] );
          $span = myCommonFuncs::trim($span);
          print "\$span[$arXPaths[$i] ($i)] is \"$span\"\n"
              if (DEBUG_YEAR == TRUE);
          if ($span =~ / (57\d\d)[ \/]/m) {
              $year = $1;
          } elsif ($span =~ / \w+ (57\d\d)$/m) {
              $year = $1;
          } elsif ($span =~ / 20\d\d \/ (57\d\d)/m) {
              $year = $1;
          } elsif ($span =~ /, (57\d\d)/m) {
              $year = $1;
          }
          $i++;
     } # End If $year is empty
     if ($year eq "") {
          my $outFile = "Test_Contents.txt";
          if (DEBUG_YEAR == TRUE) {
               open(OUT,">$outFile") || die "Cannot create $outFile\n";
               for (my $j = 0; $j < $#arXPaths + 1; $j++) {
                    $span = $tree->findvalue( $arXPaths[$j] );
                    $span = myCommonFuncs::trim($span);
                    binmode(OUT, ":utf8");
                    print OUT "\$span[$arXPaths[$j]] is \"$span\"\n";
               }
               print OUT "\n\n";
               print OUT '-' x 80;
               print OUT "\n\n";
               binmode(OUT, ":utf8");
               print OUT $item->{"content"}, "\n";
               close(OUT);
               print "OUT: \"$outFile\"\n";
          }
          die "Cannot find year in " . $item->{"title"} . "\n";
     } # End If Year is still empty

     my $title = $item->{"title"};
     if ($title =~ / - /) {
          my @Words = split(" - ", $title, 2);
          $title = $Words[0];
     }
     $title = myCommonFuncs::trim($title); # Remove (lead|tail)ing whitespaces
     print "Trim_: \$title: \"$title\"\n" if (DEBUG_TITLE == TRUE);
     $title = $1 if ($title =~ /^Parsha ([\w']+([ -]{0,1}[\w']+){0,2})/);
     print "Parse: \$title: \"$title\"\n" if (DEBUG_TITLE == TRUE);
     my $linkName = $title . " " . $year;
     print "\$linkName: \"$linkName\"\t\$nextParsha: \"$nextParsha\"\n"
          if (DEBUG_TITLE == TRUE);
     $links{$linkName} = $item->{"url"}
          if ($linkName =~ /$nextParsha/);
    if ($isDouble == TRUE) {
        my @parts = split /-/, $nextParsha, 2;
        $links{$linkName} = $item->{"url"} if ($linkName =~ /$parts[0]/);
        $links{$linkName} = $item->{"url"} if ($linkName =~ /$parts[1]/);
    } # Is Double, Include parts
} # end foreach item

foreach my $name ( keys %links ) {
     $doc->setHyperlink($pPastPosts, $name, $links{$name});
} # ForEach Links

$doc->save if (DEBUG == FALSE);
print "Document: \"${ParshaCount} Parsha ${nextParsha}.odt\"";
if (DEBUG == FALSE) {
     print " was created.\n";
} else {
     print " was NOT created. DEBUG MODE\n";
}

exit 0;
### End of Main ###

### -- Begin of Subroutines --- ###
sub FindLastParshot {
     my $file = $_;
     my $num = 0;
     if ($file =~ /(\d+) Parsha/) {
          my $fileNum = $1;
          if ($num < $fileNum) {
               $num = $fileNum;
               $strLastParshotFile = $file;
          } # end if not last
     } #end if
} # end FindLastParshot

sub FindNextParshot {
     my $strParsha = shift;

     my @doubleParshot = values %doubleParshot;
     my $doubleIndex = first_index { $_ eq $strParsha } @doubleParshot;
     print "Double Parsha: TRUE\n"
          if ($doubleIndex > NOT_FOUND && DEBUG_NEXTPARSHA == TRUE);

     my $dummy;
     ($dummy, $strParsha) = split("-", $strParsha, 2)
        if ($doubleIndex > NOT_FOUND);
     $strParsha = $2 if ($strParsha =~ /((\w+)( \w+)?) \-+\s+Shabbat \w+/);

     print "Old Parsha: \"${strParsha}\"\n" if (DEBUG_NEXTPARSHA == TRUE);

     my $isFound = FALSE;
     my $debugFile = "parshaComparison";
     open (DEBUGFILE, ">${debugFile}")
          || die "Cannot write to $debugFile\n$!\n";
     foreach my $Parsha (keys %torahReading) {
          if ($isFound == TRUE) {
               print "Next Parsha: \"${Parsha}\"\n"
                    if (DEBUG_NEXTPARSHA == TRUE);
               return $Parsha;
          } #end if
          if ($Parsha eq $strParsha) {
               $isFound = TRUE;
          } elsif (DEBUG_NEXTPARSHA == TRUE) {
               print DEBUGFILE "\"$Parsha\" <--> \"$strParsha\"\n";
          }
     } #end foreach Parsha
     close (DEBUGFILE);
     unlink (${debugFile}) if ( -z $debugFile);

     if ($isFound == TRUE) { # We return to the beginning
          my @keys = keys %torahReading;
          print "Found: \"$keys[0]\"\n" if (DEBUG_NEXTPARSHA == TRUE);
          return $keys[0];
     } # If Found

     # Else, what happened?
     die "DIE! Next Parsha Not Found.\n"
          . "\$strParsha: \"$strParsha\"\n"
          . "\$isFound: \"" . myCommonFuncs::displayTF($isFound) . "\"\n";
} # end FindNextParshot

sub CalcHebNumForDay {
     my $day = shift;

     my @h1letters = ("", $alef, $bet, $gimel, $dalet, $he, $vav, $zayin,
          $het, $tet, $yod);
     my @h2letters = ("", $yod, $kaf, $lamed);

     my $hday = "";
     if ($day < 11) {
          $hday = $h1letters[$day] . $geresh;
     } elsif ($day == 15) {
          $hday = "${tet}${gershayim}${vav}";
     } elsif ($day == 16) {
          $hday = "${tet}${gershayim}${zayin}";
     } else {
          my $second = int ($day / 10);
          my $first = int ($day % 10);
          $hday = $h2letters[$second]
               . $gershayim
               . $h1letters[$first];
     } #end-else
     return $hday;
} # end CalcHebNumForDay

sub syntax {
     printf("%10s\t%40s\n" , "^-dp\$"     , "is Double Parsha");
     printf("%10s\t%40s\n" , "^-p\$"      , "Set Parsha Name");
     printf("%10s\t%40s\n" , "^-sm\$"     , "is Shabbat Mevakhim");
     printf("%10s\t%40s\n" , "^-ss\$"     , "Special Shabbat");
     printf("%10s\t%40s\n" , "^-(h|\?)\$" , "syntax (this)");
} # end syntax

sub isShabbatMevakhim {
     my ($smMonth, $smMday, $smYear) = @_;

     my $dt = DateTime->new(
         year  => $smYear,
         month => $smMonth,
         day   => $smMday,
     );

     my $smWday  = $dt->day_abbr;
     print "Original WDay is $smWday\n" if (DEBUG_SHABBATMEVARCHIM == TRUE);
     my $dayIndex = first_index { $_ eq $smWday } @wkdy;
     print "DayIndex is $dayIndex\n" if (DEBUG_SHABBATMEVARCHIM == TRUE);
     my $daydiff = 6 - $dayIndex; # Zero Offer (7-1)
     print "DayDiff is $daydiff\n" if (DEBUG_SHABBATMEVARCHIM == TRUE);
     $dt->set_day($smMday)->add(days => $daydiff);
     $smMday  = $dt->day;
     $wday    = $dt->day_abbr;
     my $smSDate = sprintf("%s %s/%02d/%04d", $wday, $smMonth,
         $smMday, $smYear);
     print "Updated Secular Date: $smSDate\n"
        if (DEBUG_SHABBATMEVARCHIM == TRUE);

     my $smDate = new Date::Convert::Gregorian($smYear,$smMonth,$smMday);
     convert Date::Convert::Hebrew $smDate;

     my $smHdate    = $smDate->date_string;
     my $smHsmYear  = $1 if ($smHdate =~ /^(\d{4})\s+.*\s+\d+$/);
     my $smHsmMon   = $1 if ($smHdate =~ /^\d{4}\s+(.*)\s+\d+$/);
     $smHsmMon = $smHsmMon . " I" if ($smDate->is_leap && $smHsmMon eq "Adar");
     $smHsmMon = "Tevet" if ($smHsmMon eq "Teves");
     my $smHsmMDay  = $1 if ($smHdate =~ /^\d{4}\s+.*\s+(\d+)$/);

     print "Hebrew Date: $smHsmMDay $smHsmMon $smHsmYear\n"
        if (DEBUG_SHABBATMEVARCHIM == TRUE);

     print "\$totalDaysInHebMonths{$smHsmMon}: \""
        . $totalDaysInHebMonths{$smHsmMon} . "\"\n"
        if (DEBUG_SHABBATMEVARCHIM == TRUE);
     my $totalDays = $totalDaysInHebMonths{$smHsmMon};
     print "Total Days in \"$smHsmMon\" is \"$totalDays\"\n"
        if (DEBUG_SHABBATMEVARCHIM == TRUE);
     my $offset = 0;
     $offset = 1 if ($totalDays == 29);
     my $diff = $totalDays - $smHsmMDay + $offset;
        # Remove Zero Offset if Days == 29
     print "Difference is $diff\n" if (DEBUG_SHABBATMEVARCHIM == TRUE);

     if ($diff < 8) {
         return TRUE;
     }
     return FALSE;
} # End isShabbatMevakhim

### -- End of Subroutines --- ###
###--- End of File ---###
