Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-09.arcor-online.net ([151.189.21.49]:44757 "EHLO
	mail-in-09.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751323AbZFQAwd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Jun 2009 20:52:33 -0400
Subject: Re: Leadtek Winfast DTV-1000S
From: hermann pitton <hermann-pitton@arcor.de>
To: Michael Krufky <mkrufky@kernellabs.com>
Cc: linux-media <linux-media@vger.kernel.org>, paul10@planar.id.au,
	braddo@tranceaddict.net, Terry Wu <terrywu2009@gmail.com>,
	Sander Pientka <cumulus0007@gmail.com>
In-Reply-To: <37219a840906160833l1c045848o6cc2d5e3e74c6df1@mail.gmail.com>
References: <51276.202.168.20.241.1244411983.squirrel@webmail.velocity.net.au>
	 <1244414375.3823.11.camel@pc07.localdom.local>
	 <37219a840906160833l1c045848o6cc2d5e3e74c6df1@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 17 Jun 2009 02:47:51 +0200
Message-Id: <1245199671.7551.6.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Am Dienstag, den 16.06.2009, 11:33 -0400 schrieb Michael Krufky:
> On Sun, Jun 7, 2009 at 6:39 PM, hermann pitton<hermann-pitton@arcor.de> wrote:
> >
> > Am Montag, den 08.06.2009, 07:59 +1000 schrieb paul10@planar.id.au:
> >> That is fantastic news.  Not only will it be coming soon, but I don't have
> >> to do it myself!!
> >>
> >> How will we know when the test repository is created - will it be
> >> announced on this list?
> >>
> >> Thanks,
> >>
> >> Paul
> >>
> >>
> >> > Henry Wu did send modified saa7134 files with support for this card on
> >> > Tuesday off list.
> >>
> >> > Mike replied, that he will set up a test repository as soon he gets some
> >> > time for doing so.
> >
> > Paul,
> >
> > give Mike some time for it.
> >
> > There are much more variables in question, that can be different on
> > devices now seen in the wild for the first time and a proper framework
> > must be employed.
> >
> > If you can't wait, ask Mike do send you the files, seems they are recent
> > enough for current v4l-dvb, but better is to wait and start with some
> > unified testing base.
> >
> > Cheers,
> > Hermann
> 
> 
> Hello all,
> 
> Apologies for the delay -- I've been extremely busy over the past few
> weeks, but that's nothing new :-P
> 
> Anyhow, I pushed up some code almost 2 weeks ago that should cover the
> DTV1000S in all variations.  Thanks to Terry Wu for the baseband video
> gpio setup.
> 
> I haven't had time to ask anybody to test this yet, so I'd appreciate
> it if you can provide some general feedback.
> 
> This change only adds support for the new card, so I am not interested
> in anybody's experience with other boards -- this ONLY relates to the
> DTV1000S.
> 
> Terry's patches copy the device specific setup from the Hauppauge
> HVR1110 -- this is actually dangerous, as the HVR1110 GPIO / LNA setup
> could cause problems when used on other boards.
> 
> Terry's patches also support a version of the board with a TDA18271c2
> -- I don't know if such a board actually exists, but the way that
> Terry did it doesn't allow for supporting both variations in a single
> kernel.  If the c2 version of the board actually exists, the code that
> I pushed will work on board boards.
> 
> I'd like to see dmesg output while using my tree -- please include
> full device initialization, starting with the line, "Linux video
> capture interface: v2.00" up till the end.
> 
> I am especially interested to see whether or not the TDA8295 driver
> attaches successfully -- I have a feeling that there actually is no
> TDA8295 on that board, but I don't know for sure, offhand.
> 
> Please test the following tree:
> 
> http://kernellabs.com/hg/~mkrufky/dtv1000s
> 
> - saa7134: add initial DVB-T support for the Leadtek DTV1000S
> - saa7134: add support for baseband video capture on Leadtek DTV1000S
> 
>  Documentation/video4linux/CARDLIST.saa7134  |    1
>  drivers/media/video/saa7134/saa7134-cards.c |   22 +++++
>  drivers/media/video/saa7134/saa7134-dvb.c   |   39 ++++++++++
>  drivers/media/video/saa7134/saa7134.h       |    1
>  4 files changed, 63 insertions(+)
> 
> Cheers,
> 
> Mike Krufky

guess Sander with that Zolid hybrid and such hardware with a saa7131e
should give it a try for DVB-T too with card=169 on your testing repo.

If he still has it ;)

Cheers,
Hermann


