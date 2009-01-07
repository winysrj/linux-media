Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n0700Eja007934
	for <video4linux-list@redhat.com>; Tue, 6 Jan 2009 19:00:14 -0500
Received: from mail-in-17.arcor-online.net (mail-in-17.arcor-online.net
	[151.189.21.57])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n06Nxt22022714
	for <video4linux-list@redhat.com>; Tue, 6 Jan 2009 18:59:56 -0500
From: hermann pitton <hermann-pitton@arcor.de>
To: brian_empson@yahoo.com
In-Reply-To: <121406.44238.qm@web55903.mail.re3.yahoo.com>
References: <121406.44238.qm@web55903.mail.re3.yahoo.com>
Content-Type: text/plain
Date: Wed, 07 Jan 2009 01:00:41 +0100
Message-Id: <1231286441.2618.56.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: Sabrent TVFM Tuner
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Brian,

Am Montag, den 05.01.2009, 10:30 -0800 schrieb Brian Empson:
> I tried updating the dvb v4l drivers and reinstalling the cards to no avail.  None of the tuner options work, the only thing that appears is snow with a few purple flashes every one in awhile.  I did notice that when I go to supply the driver= option to mplayer it does not take v4l2, only v4l.  Is this part of the problem?
> 

sorry, we need more details.

There have been some bugs previously introduced, not to allow the user
to set the TV standard and/or the tuner type anymore.

Such a driver in global operation is almost dead for debugging then
without further details.

Which kernel/driver are you using and can you please post also dmesg
output for the tuners you tried? (saa7134 audio_debug and tuner debug
are also options not yet tried)

Under such circumstances it is very unpleasant for all of us to shot
into the dark and I don't want to send you around in circles on such a
card we can not identify for sure.

Beside of letting us know the exact driver version you are using,
looking it up in details is no fun per distro and not at all, the best
you can do is to provide a listing of all chips on the board, report the
TV standard in your country, exclude that some picture ghosthing
enhancer made it on the board, related to the previous, and have at
least some idea about the tuner on it.

Please read the v4l wiki for adding new cards.
Some previous Sabrent (or whatever) saa7130 stuff is visible on the
bttv-gallery.de

Your previous tests should have give you at least some results for TV
else, if not either limited by recent driver bugs or that it is not one
of all the known tin/can tuners on it, very unlikely.

The working Composite input on vmux = 1 on your card indicates at least
that it should be likely similar to some of them we have seen already.

Cheers,
Hermann


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
