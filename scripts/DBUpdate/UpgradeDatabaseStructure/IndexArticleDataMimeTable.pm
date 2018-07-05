# --
# Copyright (C) 2001-2018 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package scripts::DBUpdate::UpgradeDatabaseStructure::IndexArticleDataMimeTable;    ## no critic

use strict;
use warnings;

use parent qw(scripts::DBUpdate::Base);

our @ObjectDependencies = ();

=head1 NAME

scripts::DBUpdate::UpgradeDatabaseStructure::IndexArticleDataMimeTable - Index article_data_mime table on article_id.

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    # Create index on article_data_mime table for article_id.
    my @XMLStrings = (
        '<TableAlter Name="article_data_mime">
            <IndexCreate Name="article_data_mime_article_id">
                <IndexColumn Name="article_id"/>
            </IndexCreate>
        </TableAlter>',
        '<TableAlter Name="article_data_mime">
            <ForeignKeyCreate ForeignTable="article">
                <Reference Local="article_id" Foreign="id"/>
            </ForeignKeyCreate>
        </TableAlter>'
    );

    return if !$Self->ExecuteXMLDBArray(
        XMLArray => \@XMLStrings,
    );

    return 1;
}

1;
