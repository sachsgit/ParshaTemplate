package myTorahReading;

use Exporter;
use charnames ();
use Tie::IxHash;
#URL: http://perldoc.perl.org/perluniintro.html
#URL: https://en.wikipedia.org/wiki/Unicode_and_HTML_for_the_Hebrew_alphabet

our @EXPORT = qw ( $alef $bet $gimel $dalet $he $vav $zayin $het $tet
$yod $final_kaf $kaf $lamed $final_mem $mem $final_nun $nun $samekh
$ayin $final_pe $pe $final_tsadi $tsadi $qof $resh $shin $tav $geresh
$gershayim $date $sec $min $hour $mday $month $mon $yr19 $wday $yday
$isdst $year $hFlag $hdate $hyear $hmon $hmonth $hmday %torahReading
%translateHebMonths %doubleParshot %doubleTorahReading 
%specialParshot %specialParshotNames %specialParshotURLs
@wkdy @abbr @hmon_names $parshaWord %parshotHebrewNames
%totalDaysInHebMonths %doubleParshotHebrewNames 
);

tie our %torahReading, 'Tie::IxHash';
%torahReading = (
     "Bereishet"      => "Sefer Bereishet 1:1 - 6:8",
     "Noach"          => "Sefer Bereishet 6:9 - 11:32",
     "Lech Lecha"     => "Sefer Bereishet 12:1 - 17:27",
     "Vayeira"        => "Sefer Bereishet 18:1 - 22:24",
     "Chayei Sarah"   => "Sefer Bereishet 23:1 - 25:18",
     "Toldos"         => "Sefer Bereishet 25:19 - 28:9",
     "Vayeitzei"      => "Sefer Bereishet 28:10 - 32:3",
     "Vayishlach"     => "Sefer Bereishet 32:4 - 36:43",
     "Vayeishev"      => "Sefer Bereishet 37:1 - 40:23",
     "Mikeitz"        => "Sefer Bereishet 41:1 - 44:17",
     "Vayigash"       => "Sefer Bereishet 44:18 - 47:27",
     "Vayechi"        => "Sefer Bereishet 47:28 - 50:26",
     "Shemos"         => "Sefer Shemos 1:1 - 6:1",
     "Va'eira"        => "Sefer Shemos 6:2 - 9:35",
     "Bo"             => "Sefer Shemos 10:1 - 13:16",
     "Beshalach"      => "Sefer Shemos 13:17 - 17:16",
     "Yisro"          => "Sefer Shemos 18:1 - 20:23",
     "Mishpatim"      => "Sefer Shemos 21:1 - 24:18",
     "Terumah"        => "Sefer Shemos 25:1 - 27:19",
     "Tetzaveh"       => "Sefer Shemos 27:20 - 30:10",
     "Ki Sisa"        => "Sefer Shemos 30:11 - 34:35",
     "Vayakhel"       => "Sefer Shemos 35:1 - 38:20",
     "Pekudei"        => "Sefer Shemos 38:21 - 40:38",
     "Vayikra"        => "Sefer Vayikra 1:1 - 5:26",
     "Tzav"           => "Sefer Vayikra 6:1 - 8:36",
     "Shemini"        => "Sefer Vayikra 9:1 - 11:47",
     "Tazria"         => "Sefer Vayikra 12:1 - 13:59",
     "Metzora"        => "Sefer Vayikra 14:1 - 15:33",
     "Acharei Mot"    => "Sefer Vayikra 16:1 - 18:30",
     "Kedoshim"       => "Sefer Vayikra 19:1 - 20:27",
     "Emor"           => "Sefer Vayikra 21:1 - 24:23",
     "Behar"          => "Sefer Vayikra 25:1 - 26:2",
     "Bechukotai"     => "Sefer Vayikra 26:3 - 27:34",
     "Bamidbar"       => "Sefer Bamidbar 1:1 - 4:20",
     "Naso"           => "Sefer Bamidbar 4:21 - 7:89",
     "Baha'aloshecha" => "Sefer Bamidbar 8:1 - 12:16",
     "Shelach"        => "Sefer Bamidbar 13:1 - 15:41",
     "Korach"         => "Sefer Bamidbar 16:1 - 18:32",
     "Chukas"         => "Sefer Bamidbar 19:1 - 22:1",
     "Balak"          => "Sefer Bamidbar 22:2 - 25:9",
     "Pinchas"        => "Sefer Bamidbar 25:10 - 30:1",
     "Matos"          => "Sefer Bamidbar 30:2 - 32:42",
     "Masei"          => "Sefer Bamidbar 33:1 - 36:13",
     "Devarim"        => "Sefer Devarim 1:1 - 3:22",
     "Va'eschanan"    => "Sefer Devarim 3:23 - 7:11",
     "Eikev"          => "Sefer Devarim 7:12 - 11:25",
     "Re'eh"          => "Sefer Devarim 11:26 - 16:17",
     "Shoftim"        => "Sefer Devarim 16:18 - 21:9",
     "Ki Seitzei"     => "Sefer Devarim 21:10 - 25:19",
     "Ki Savo"        => "Sefer Devarim 26:1 - 29:8",
     "Nitzavim"       => "Sefer Devarim 29:9 - 30:20",
     "Vayelech"       => "Sefer Devarim 31:1 - 31:30",
     "Ha'azinu"       => "Sefer Devarim 32:1 - 32:52",
     "Vzos HaBeracha" => "Sefer Devarim 33:1 - 34:12"
);

tie our %doubleParshot, 'Tie::IxHash';
%doubleParshot = (
     "Vayakhel"    => "Vayakhel-Pekudei",
     "Pekudei"     => "Vayakhel-Pekudei",
     "Tazria"      => "Tazria-Metzora",
     "Metzora"     => "Tazria-Metzora",
     "Acharei Mot" => "Acharei Mot-Kedoshim",
     "Kedoshim"    => "Acharei Mot-Kedoshim",
     "Behar"       => "Behar-Bechukotai",
     "Bechukotai"  => "Behar-Bechukotai",
     "Chukas"      => "Chukas-Balak",
     "Balak"       => "Chukas-Balak",
     "Matos"       => "Matos-Masei",
     "Masei"       => "Matos-Masei",
     "Nitzavim"    => "Nitzavim-Vayelech",
     "Vayelech"    => "Nitzavim-Vayelech"
);

tie our %doubleTorahReading, 'Tie::IxHash';
%doubleTorahReading = (
     "Vayakhel-Pekudei"     => "Sefer Shemos 38:21 - 40:38",
     "Tazria-Metzora"       => "Sefer Vayikra 12:1 - 15:33",
     "Acharei Mot-Kedoshim" => "Sefer Vayikra 16:1 - 20:27",
     "Behar-Bechukotai"     => "Sefer Vayikra 25:1 - 27:34",
     "Chukas-Balak"         => "Sefer Bamidbar 19:1 - 25:9",
     "Matos-Masei"          => "Sefer Bamidbar 30:2 - 36:13",
     "Nitzavim-Vayelech"    => "Sefer Devarim 29:9 - 31:30"
);

our $alef        = charnames::string_vianame("HEBREW LETTER ALEF");
our $bet         = charnames::string_vianame("HEBREW LETTER BET");
our $gimel       = charnames::string_vianame("HEBREW LETTER GIMEL");
our $dalet       = charnames::string_vianame("HEBREW LETTER DALET");
our $he          = charnames::string_vianame("HEBREW LETTER HE");
our $vav         = charnames::string_vianame("HEBREW LETTER VAV");
our $zayin       = charnames::string_vianame("HEBREW LETTER ZAYIN");
our $het         = charnames::string_vianame("HEBREW LETTER HET");
our $tet         = charnames::string_vianame("HEBREW LETTER TET");
our $yod         = charnames::string_vianame("HEBREW LETTER YOD");
our $kaf         = charnames::string_vianame("HEBREW LETTER KAF");
our $final_kaf   = charnames::string_vianame("HEBREW LETTER FINAL KAF");
our $lamed       = charnames::string_vianame("HEBREW LETTER LAMED");
our $mem         = charnames::string_vianame("HEBREW LETTER MEM");
our $final_mem   = charnames::string_vianame("HEBREW LETTER FINAL MEM");
our $nun         = charnames::string_vianame("HEBREW LETTER NUN");
our $final_nun   = charnames::string_vianame("HEBREW LETTER FINAL NUN");
our $samekh      = charnames::string_vianame("HEBREW LETTER SAMEKH");
our $ayin        = charnames::string_vianame("HEBREW LETTER AYIN");
our $pe          = charnames::string_vianame("HEBREW LETTER PE");
our $final_pe    = charnames::string_vianame("HEBREW LETTER FINAL PE");
our $tsadi       = charnames::string_vianame("HEBREW LETTER TSADI");
our $final_tsadi = charnames::string_vianame("HEBREW LETTER FINAL TSADI");
our $qof         = charnames::string_vianame("HEBREW LETTER QOF");
our $resh        = charnames::string_vianame("HEBREW LETTER RESH");
our $shin        = charnames::string_vianame("HEBREW LETTER SHIN");
our $tav         = charnames::string_vianame("HEBREW LETTER TAV");
our $geresh      = charnames::string_vianame("HEBREW PUNCTUATION GERESH");
our $gershayim   = charnames::string_vianame("HEBREW PUNCTUATION GERSHAYIM");

our $parshaWord = "${pe}${resh}${shin}${tav}";

tie our %parshotHebrewNames, 'Tie::IxHash';
%parshotHebrewNames = (
     "Bereishet"      => "${bet}${resh}${alef}${shin}${yod}${tav}",
     "Noach"          => "${nun}${het}",
     "Lech Lecha"     => "${lamed}${final_kaf} ${lamed}${final_kaf}",
     "Vayeira"        => "${vav}${yod}${resh}${alef}",
     "Chayei Sarah"   => "${het}${yod}${yod} ${shin}${resh}${he}",
     "Toldos"         => "${tav}${vav}${lamed}${dalet}${tav}",
     "Vayeitzei"      => "${vav}${yod}${tsadi}${alef}",
     "Vayishlach"     => "${vav}${yod}${shin}${lamed}${het}",
     "Vayeishev"      => "${vav}${yod}${shin}${bet}",
     "Mikeitz"        => "${mem}${qof}${final_tsadi}",
     "Vayigash"       => "${vav}${yod}${gimel}${shin}",
     "Vayechi"        => "${vav}${yod}${het}${yod}",
     "Shemos"         => "${shin}${mem}${vav}${tav}",
     "Va'eira"        => "${vav}${alef}${resh}${alef}",
     "Bo"             => "${bet}${alef}",
     "Beshalach"      => "${bet}${shin}${lamed}${het}",
     "Yisro"          => "${yod}${tav}${resh}${vav}",
     "Mishpatim"      => "${mem}${shin}${pe}${tet}${yod}${final_mem}",
     "Terumah"        => "${tav}${resh}${vav}${mem}${he}",
     "Tetzaveh"       => "${tav}${tsadi}${vav}${he}",
     "Ki Sisa"        => "${qof}${yod} ${tav}${shin}${alef}",
     "Vayakhel"       => "${vav}${yod}${qof}${he}${lamed}",
     "Pekudei"        => "${pe}${qof}${vav}${dalet}${yod}",
     "Vayikra"        => "${vav}${yod}${qof}${resh}${alef}",
     "Tzav"           => "${tsadi}${vav}",
     "Shemini"        => "${shin}${mem}${yod}${nun}${yod}",
     "Tazria"         => "${tav}${zayin}${resh}${yod}${ayin}",
     "Metzora"        => "${mem}${tsadi}${resh}${ayin}",
     "Acharei Mot"    => "${alef}${het}${resh}${yod} ${mem}${vav}${tav}",
     "Kedoshim"       => "${qof}${dalet}${shin}${yod}${final_mem}",
     "Emor"           => "${alef}${mem}${resh}",
     "Behar"          => "${bet}${he}${resh}",
     "Bechukotai"     => "${bet}${het}${qof}${tav}${yod}",
     "Bamidbar"       => "${bet}${mem}${dalet}${bet}${resh}",
     "Naso"           => "${nun}${shin}${alef}",
     "Baha'aloshecha" => "${bet}${he}${ayin}${lamed}${tav}${final_kaf}",
     "Shelach"        => "${shin}${lamed}${het}",
     "Korach"         => "${qof}${resh}${he}",
     "Chukas"         => "${het}${qof}${tav}",
     "Balak"          => "${bet}${lamed}${qof}",
     "Pinchas"        => "${pe}${yod}${nun}${het}${samekh}",
     "Matos"          => "${mem}${tet}${vav}${tav}",
     "Masei"          => "${mem}${samekh}${ayin}${yod}",
     "Devarim"        => "${dalet}${bet}${resh}${yod}${final_mem}",
     "Va'eschanan"    => "${vav}${alef}${tav}${het}${nun}${final_nun}",
     "Eikev"          => "${ayin}${qof}${bet}",
     "Re'eh"          => "${resh}${alef}${he}",
     "Shoftim"        => "${shin}${pe}${tet}${yod}${final_mem}",
     "Ki Seitzei"     => "${kaf}${yod} ${tav}${tsadi}${alef}",
     "Ki Savo"        => "${kaf}${yod} ${tav}${bet}${vav}${alef}",
     "Nitzavim"       => "${nun}${tsadi}${bet}${yod}${final_mem}",
     "Vayelech"       => "${vav}${yod}${lamed}${final_kaf}",
     "Ha'azinu"       => "${he}${alef}${zayin}${yod}${nun}${vav}",
     "Vzos HaBeracha" => "${vav}${zayin}${alef}${tav}"
                         . " ${he}${bet}${resh}${kaf}${he}"
);

tie our %doubleParshotHebrewNames, 'Tie::IxHash';
%doubleParshotHebrewNames = (
    "Vayakhel-Pekudei" => "${vav}${yod}${qof}${he}${lamed} - ${pe}${qof}${vav}${dalet}${yod}",
    "Tazria-Metzora" => "${tav}${zayin}${resh}${yod}${ayin} - ${mem}${tsadi}${resh}${ayin}",
    "Acharei Mot-Kedoshim" => "${alef}${het}${resh}${yod} ${mem}${vav}${tav} - ${qof}${dalet}${shin}${yod}${final_mem}",
    "Behar-Bechukotai" => "${bet}${he}${resh} - ${bet}${het}${qof}${tav}${yod}",
    "Chukas-Balak" => "${het}${qof}${tav} - ${bet}${lamed}${qof}",
    "Matos-Masei" => "${mem}${tet}${vav}${tav} - ${mem}${samekh}${ayin}${yod}",
    "Nitzavim-Vayelech" => "${nun}${tsadi}${bet}${yod}${final_mem} - ${vav}${yod}${lamed}${final_kaf}",
);

our $date        = "";
our $sec         = "";
our $min         = "";
our $hour        = "";
our $mday        = "";
our $month       = "";
our $mon         = "";
our $yr19        = "";
our $wday        = "";
our $yday        = "";
our $isdst       = "";
our $year        = "";
our $hFlag       = $FALSE;
our $hdate       = "";
our $hyear       = "";
our $hmon        = "";
our $hmonth      = "";
our $hmday       = "";
our @wkdy = qw(Sun Mon Tue Wed Thu Fri Sat);
our @wkdy_full = qw(Sunday Monday Tuesday Wednesday Thursday Friday Saturday);
our @abbr = qw(Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec);
our @mon_names = qw(January February March April May June July August
          September October November December);
our @hmon_names = ("Nissan", "Iyyar", "Sivan", "Tammuz", "Menachem Av",
         "Elul", "Tishrei", "Cheshvan", "Kislev", "Tevet", "Shevat",
          "Adar", "Adar II");

tie our %translateHebMonths, 'Tie::IxHash';
%translateHebMonths = (
     "Nissan"      => "${nun}${yod}${samekh}${final_nun}",
     "Iyyar"       => "${alef}${yod}${yod}${resh}",
     "Sivan"       => "${samekh}${yod}${nun}${final_nun}",
     "Tammuz"      => "${tav}${mem}${vav}${zayin}",
     "Av"          => "${alef}${bet}",
     "Menachem Av" => "${mem}${nun}${he}${final_mem} ${alef}${bet}",
     "Elul"        => "${alef}${lamed}${alef}${lamed}",
     "Tishrei"     => "${tav}${shin}${resh}${yod}",
     "Cheshvan"    => "${het}${shin}${vav}${final_nun}",
     "Kislev"      => "${kaf}${samekh}${lamed}${vav}",
     "Tevet"       => "${tet}${bet}${tav}",
     "Shevat"      => "${shin}${bet}${tet}",
     "Adar"        => "${alef}${dalet}${resh}",
     "Adar I"      => "${alef}${dalet}${resh} ${alef}${geresh}",
     "Adar II"     => "${alef}${dalet}${resh} ${bet}${geresh}"
);

tie our %totalDaysInHebMonths, 'Tie::IxHash';
%totalDaysInHebMonths = (
    "Nissan"      => 30,
    "Iyyar"       => 29,
    "Sivan"       => 30,
    "Tammuz"      => 29,
    "Menachem Av" => 30,
    "Av"          => 30,
    "Elul"        => 29,
    "Tishrei"     => 30,
    "Cheshvan"    => 29,
    "Cheshvan_"   => 30,
    "Kislev"      => 30,
    "Kislev_"     => 29,
    "Tevet"       => 29,
    "Shevat"      => 30,
    "Adar"        => 29,
    "Adar I"      => 30,
    "Adar II"     => 29
);

tie our %specialParshot, 'Tie::IxHash';
%specialParshot = (
     "Shuvah"    => "Shabbat of Return, the Shabbat During Ten Days of Repentance",
     "Shekalim"  => "Shabbat Before Rosh Chodesh Adar",
     "Zachor"    => "Shabbat [of] Rememberance, Shabbat before Purim",
     "Parah"     => "Shabbat [of the] Red Heifer",
     "HaChodesh" => "Shabbat before Rosh Chodesh Nissan",
     "HaGadol"   => "[The] Great Shabbat, which is just before or on first day of Pesach",
     "Chazon"    => "Shabbat of Vision, Prior to Tisha B'Av",
     "Nachamu"   => "Shabbat of Comfort/ing, Seven Weeks before Rosh HaShana"
);

tie our %specialParshotNames, 'Tie::IxHash';
%specialParshotNames = (
     "Shuvah"    => "${shin}${bet}${tav} ${shin}${vav}${bet}${he}",
     "Shekalim"  => "${shin}${bet}${tav} ${shin}${kaf}${lamed}${yod}${final_mem}",
     "Zachor"    => "${shin}${bet}${tav} ${zayin}${kaf}${vav}${resh}",
     "Parah"     => "${shin}${bet}${tav} ${pe}${resh}${he}",
     "HaChodesh" => "${shin}${bet}${tav} ${he}${het}${vav}${dalet}${shin}",
     "HaGadol"   => "${shin}${bet}${tav} ${he}${gimel}${dalet}${vav}${lamed}",
     "Chazon"    => "${shin}${bet}${tav} ${het}${zayin}${vav}${final_nun}",
     "Nachamu"   => "${shin}${bet}${tav} ${nun}${het}${mem}${final_nun}"
);

tie our %specialParshotURLs, 'Tie::IxHash';
%specialParshotURLs = (
     "Shuvah"    => "https://www.hebcal.com/holidays/shabbat-shuva",
     "Shekalim"  => "https://www.hebcal.com/holidays/shabbat-shekalim",
     "Zachor"    => "https://www.hebcal.com/holidays/shabbat-zachor",
     "Parah"     => "https://www.hebcal.com/holidays/shabbat-parah",
     "HaChodesh" => "https://www.hebcal.com/holidays/shabbat-hachodesh",
     "HaGadol"   => "https://www.hebcal.com/holidays/shabbat-hagadol",
     "Chazon"    => "https://www.hebcal.com/holidays/shabbat-chazon",
     "Nachamu"   => "https://www.hebcal.com/holidays/shabbat-nachamu"
);

1;
