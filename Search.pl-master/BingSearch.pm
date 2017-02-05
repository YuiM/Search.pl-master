package BingSearch;

use strict;
use warnings;

use base "Exporter";

use Encode qw{encode_utf8 decode_utf8};
use utf8;
use LWP::Protocol::https ;
use LWP::UserAgent;
use HTTP::Request;
use Digest::MD5 qw/md5_hex/;
use Path::Class qw/dir file/;
use URI;
use JSON qw{decode_json};


#BEGIN { push @INC, '/home/mori/BBS/lib/BBS/Web' }

our @ISA    = qw(Exporter);	
our @EXPORT= qw(function1);

sub function1{

 my  $query= $_[0];
 my  $folderpath = $_[1];
 my  $Downloadmax = $_[2];
 my  $format = $_[3];
 
 print encode_utf8("$query\n");
 print encode_utf8("Debug Break1\n");
 print encode_utf8("$folderpath\n");
 print encode_utf8("Debug Break2\n");
 print encode_utf8("$Downloadmax\n");
 print encode_utf8("Debug Break3\n");
 print encode_utf8("$format\n");
 print encode_utf8("Debug Break4\n");
 
 # my $query = encode_utf8($key);
# print($query);
# my $query       =  "fukuoka";
# my $query       = encode_utf8($key) ;
# print($query);
my $account_key = 'Xi1AE/fUZ7gH0uFR3E1jRScXiT9aDLeYAQK2j8rmeBw=';
my $url         = URI->new('https://api.datamarket.azure.com/Bing/Search/Image');
my $ua          = LWP::UserAgent->new;
#my $dir         = dir('/home/mori/BBS/lib/BBS/Web/ss');
my $dir =dir($folderpath);
# print encode_utf8("$folderpath\n");
 # print encode_utf8("Debug Break2\n");
 
my $page_count     = 0;
my $download_count = 0;

while (1) {
    my $skip = $page_count * 50;
    $url->query_form(
        'Query'   => qq{'$query'},
        #'$top'    => 50,           # number of results
	'$top'    => 50,
        '$skip'   => $skip,        # the offset requested
                                   #   for the starting point of results
        '$format' => 'json',
    );

    my $req = HTTP::Request->new(GET => $url);
    $req->authorization_basic('', $account_key);

    my $res = $ua->request($req);
    die $res->status_line if !$res->is_success;

    my $json = decode_json $res->content;
    last if !defined $json->{d}{results};

    for my $entry (@{ $json->{d}{results} }) {
        my $media_url = $entry->{MediaUrl};
        next unless $media_url =~ /\.jpg$/;
        $download_count++;
        my $filename = md5_hex(encode_utf8($media_url)) . '.jpg';
        my $filepath = $dir->file($filename);
        next if -f $filepath;
        print encode_utf8("$download_count : download... $media_url\n");
        print encode_utf8("$filepath\n");
        $res = $ua->get(
            $media_url,
            ':content_file' => $filepath->stringify
        );
        unless ( $res->content_type =~ m/^image/ ) {
            unlink $filepath;
        }
    }
    $page_count++;
}

}

1;
