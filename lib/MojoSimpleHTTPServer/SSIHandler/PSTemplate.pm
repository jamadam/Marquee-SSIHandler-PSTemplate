package MojoSimpleHTTPServer::SSIHandler::PSTemplate;
use strict;
use warnings;
use Mojo::Base 'MojoSimpleHTTPServer::SSIHandler';
use Text::PSTemplate;
use File::Spec;
use Mojo::Cache;
use Mojo::Util;
use Mojo::Exception;
use File::Basename 'dirname';
our $VERSION = '0.01';
    
    __PACKAGE__->attr('engine' => sub {
        my $self = shift;
        my $engine = Text::PSTemplate->new;
        $engine->set_filter('=', \&Mojo::Util::html_escape);
        $engine->set_filename_trans_coderef(sub {
            return File::Spec->catfile(
                    $MojoSimpleHTTPServer::CONTEXT->app->document_root, shift);
        });
        return $engine;
    });
    
    ### --
    ### render
    ### --
    sub render {
        my ($self, $path) = @_;
        
        my $output = eval {
            my $engine = Text::PSTemplate->new($self->engine);
            $engine->parse_file($engine->get_file($path, undef));
        };
        
        return $@ ? die Mojo::Exception->new($@) : $output;
    }

1;

__END__

=head1 NAME

MojoSimpleHTTPServer::SSIHandler::PSTemplate - PSTemplate handler

=head1 SYNOPSIS

    $app->add_handler(epl => MojoSimpleHTTPServer::SSIHandler::PSTemplate->new);

=head1 DESCRIPTION

EPL handler.

=head1 ATTRIBUTES

=head1 METHODS

=head2 $instance->render($path)

Renders given template and returns the result. If rendering fails, die with
Mojo::Exception.

=head1 SEE ALSO

L<Mojolicious>

=head1 AUTHOR

Sugama Keita, E<lt>sugama@jamadam.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2012 by Sugama Keita.

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
