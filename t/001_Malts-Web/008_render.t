#!perl -w
package TestApp::Web;
use strict;
use warnings;
use parent qw(Malts Malts::Web);
use Text::Xslate;

sub view_text { $_[0]->{view_conf} = {path => {file => $_[1]}} }
sub view { Text::Xslate->new($_[0]->{view_conf}) }

package main;
use strict;
use warnings;
use utf8;

use Test::More;
use Encode qw(encode_utf8);
use Scope::Container qw(start_scope_container);

my $sc = start_scope_container;
subtest 'testing render' => sub {
    my $res = res(200, 'ascii');
    is_deeply $res->body, ['ascii'];
};

subtest 'testing encoded str' => sub {
    my $res = res(200, '日本語');
    is_deeply $res->body, [encode_utf8 '日本語'];
};

subtest 'testing content_type' => sub {
    my $res = res(200, 'ok', html_content_type => 'text/html; charset=UTF-8');
    is $res->headers->{'content-type'}, 'text/html; charset=UTF-8';
};

subtest 'testing status: 404' => sub {
    res(404, 'not found');
};

sub res {
    my $status = shift;
    my $text = shift;
    my $t = TestApp::Web->new(@_);
    $t->view_text($text);
    my $res = $t->render($status, 'file');
    isa_ok $res, 'Malts::Web::Response', encode_utf8 "\$res(body: $text)";
    is $res->content_length, length($text), encode_utf8 "content_length == length($text)";
    is $res->status, $status, "status: $status";
    return $res;
}

done_testing;
