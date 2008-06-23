# --
# Kernel/System/Ticket/Event/ResponsibleAutoSet.pm - a event module for auto set of responible
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: ResponsibleAutoSet.pm,v 1.1 2008-06-23 07:35:37 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::System::Ticket::Event::ResponsibleAutoSet;
use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.1 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get needed objects
    for (qw(ConfigObject TicketObject LogObject UserObject CustomerUserObject SendmailObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }
    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(TicketID Event Config UserID)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # set responsible if first change
    if (
        $Self->{ConfigObject}->Get('Ticket::Responsible')
        && $Self->{ConfigObject}->Get('Ticket::ResponsibleAutoSet')
        )
    {
        my %Ticket = $Self->{TicketObject}->TicketGet(
            TicketID => $Param{TicketID},
            UserID   => $Param{UserID},
        );
        if ( $Ticket{ResponsibleID} == 1 && $Param{UserID} != 1 ) {

            # check responible update
            $Self->{TicketObject}->ResponsibleSet(
                TicketID           => $Param{TicketID},
                NewUserID          => $Ticket{OwnerID},
                SendNoNotification => 1,
                UserID             => $Param{UserID},
            );
        }
    }
    return 1;
}

1;
