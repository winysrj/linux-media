Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2QNP4JS016442
	for <video4linux-list@redhat.com>; Wed, 26 Mar 2008 19:25:04 -0400
Received: from mail-in-09.arcor-online.net (mail-in-09.arcor-online.net
	[151.189.21.49])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2QNOqj5031386
	for <video4linux-list@redhat.com>; Wed, 26 Mar 2008 19:24:52 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: Daniel Gimpelevich <daniel@gimpelevich.san-francisco.ca.us>,
	Peter Missel <peter.missel@t-online.de>
In-Reply-To: <pan.2008.03.16.17.49.51.923202@gimpelevich.san-francisco.ca.us>
References: <20050806200358.12455.qmail@web60322.mail.yahoo.com>
	<200803161724.20459.peter.missel@onlinehome.de>
	<pan.2008.03.16.17.00.26.941363@gimpelevich.san-francisco.ca.us>
	<200803161840.37910.peter.missel@onlinehome.de>
	<pan.2008.03.16.17.49.51.923202@gimpelevich.san-francisco.ca.us>
Content-Type: text/plain
Date: Thu, 27 Mar 2008 00:16:41 +0100
Message-Id: <1206573402.3912.50.camel@pc08.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH] Re: LifeVideo To-Go Cardbus, tuner problems
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

Hi,

Am Sonntag, den 16.03.2008, 10:49 -0700 schrieb Daniel Gimpelevich:
> On Sun, 16 Mar 2008 19:40:37 +0100, Peter Missel wrote:
> 
> > Hi Daniel!
> > 
> >> The 0502 definition is incorrect for this card, due to its GPIO use. The
> >> Mini definition _is_ correct for it, in every way possible.
> > 
> > ... except that the input list isn't. You got SVideo and Composite.
> 
> Yes, it is. Both S-Video and composite work correctly with card=39. Note
> that the Windows .inf file distinguishes between 5168/1502 and 5169/1502
> as different cards.
> 
> > What exactly is the problem with GPIO use? Please give us your regspy results.
> > 
> > Peter
> 
> The GPIO under Windows is 0xc010000 and never changes. V4l card
> definitions that write to GPIO throw the tuning off in various ways.
> 

how do you consider to continue on this.

Peter, we had discussed about the composite over s-video input here,
when Glen Gray added his OEM version of the card. From the original one,
without a working tuner at that time, vmux=0 should have been a valid
option, but neither the contributor nor anybody else was reachable at
that time. So we left it, don't remember offhand what Glen had with it.

On almost all cards with s-video there is composite over s-video, it
doesn't cost a single cent to provide it. Daniel, do you have it?
Works also with s-video plugged.

If not, and Peter seems to have seen such, we remove it, else keep it
and add the card to auto detection. Don't mess around with spaces after
commas on recently added, cards. It is some recent checkpatch.pl
annoyance.

Just add the card, maybe the likely existing OEM saa7133 stuff Peter
suggests. And add a Signed-off-by !

Cheers,
Hermann


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
