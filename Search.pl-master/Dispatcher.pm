package BBS::Web::Dispatcher;
use strict;
use warnings;

use Amon2::Web::Dispatcher::Lite;

#use FindBin;
#use lib "$FindBin::Bin/lib";

BEGIN { push @INC, '/home/mori/BBS/lib/BBS/Web' }

use File::Spec;
use File::Basename;
use local::lib File::Spec->catdir(dirname(__FILE__), 'extlib');
use lib File::Spec->catdir(dirname(__FILE__), 'lib');

use BingSearch;

any '/' => sub {
    my ($c) = @_;

    my @entries = $c->db->search(
        entry => {
        }, {
            order_by => 'entry_id DESC',
            limit    => 15,
        }
    );
    return $c->render( "index.tx" => { entries => \@entries, } );
};

post '/post' => sub {

    my ($c) = @_;
    &function1($c->req->param('keyword'),$c->req->param('folderpath'),$c->req->param('MaxDownLoad'),$c->req->param('Format'));
    # my ($c) = @_;

    # if (my $body = $c->req->param('body')) {
        # $c->db->insert(
            # entry => +{
                # body => $body,
            # }
        # );
    # }
    # return $c->redirect('/');
};

post '/post2' => sub {
     my ($c) = @_;
    &function1($c);
    # my ($c) = @_;

   
    #return $c->redirect('/');
};

post '/post3' => sub {
    my ($c) = @_;
    &function1($c);

   
    #return $c->redirect('/');
};





1;
