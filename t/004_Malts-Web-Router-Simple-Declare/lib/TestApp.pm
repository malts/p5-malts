use strict;
use warnings;

package TestApp;

package TestApp::Web;

use parent qw(Malts Malts::Web);

sub dispatch {
    TestApp::Web::Dispatcher->dispatch(@_) or $_[0]->create_response(404, [], ['404 Not Found!']);
}

package TestApp::Web::Dispatcher;
use Malts::Web::Router::Simple::Declare;

get '/' => 'Root#index';
get '/500' => {controller => 'Root', action => 'action_500'};

package TestApp::Web::Controller::Root;
$INC{'TestApp/Web/Controller/Root.pm'} = __FILE__;

sub index {
    $_[1]->create_response(200, [], ['index!']);
}

sub action_500 {}

1;
