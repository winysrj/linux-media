Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m49LroC8010639
	for <video4linux-list@redhat.com>; Fri, 9 May 2008 17:53:50 -0400
Received: from mail-in-05.arcor-online.net (mail-in-05.arcor-online.net
	[151.189.21.45])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m49Lrbmi012441
	for <video4linux-list@redhat.com>; Fri, 9 May 2008 17:53:37 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: Andre Auzi <aauzi@users.sourceforge.net>
In-Reply-To: <48247919.8020402@users.sourceforge.net>
References: <482370FD.7000001@users.sourceforge.net>
	<1210296633.2541.26.camel@pc10.localdom.local>
	<1210297053.2541.31.camel@pc10.localdom.local>
	<48247919.8020402@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Date: Fri, 09 May 2008 23:52:32 +0200
Message-Id: <1210369953.3080.31.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: cx88 driver: Help needed to add radio support on
	Leadtek	WINFAST DTV 2000 H (version J)
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


Am Freitag, den 09.05.2008, 18:17 +0200 schrieb Andre Auzi:
> hermann pitton a écrit :
> > Am Freitag, den 09.05.2008, 03:30 +0200 schrieb hermann pitton:
> >> Am Donnerstag, den 08.05.2008, 23:30 +0200 schrieb Andre Auzi:
> > 
> >> Radio on the FMD1216ME/I MK3 is not perfect anyway, on other stuff it
> >> might also only be the best hack around then, but some still claim new
> >> hardware doesn't exist ...
> > 
> > One is missing here.
> > 
> > You might have the newer FMD1216MEX, Steve mentioned sometime
> > previously, it might be slightly different for the radio support.
> > 
> > I do know exactly nothing about it.
> > 
> > Cheers,
> > Hermann
> > 
> > 
> > 
> 
>  From the driver's inf file I read:
> 
> [LR6F2B.AddReg]
> HKR,"DriverData","FMD1216MEX",0x0010001, 0x01, 0x00, 0x00, 0x00
> 
> This probably means you guessed right.
> 
> That's a step forward, isn't it?
> 
> Too bad you cannot say more.
> 
> I'll keep you posted.
> 
> Rgards,
> Andre

It might explain it, but is based only on rumors.

If the MEX is really different, it should have its own tuner definition
and also not point to the FMD1216ME/I H-3 (MK3) in tveeprom anymore.

The rule is to avoid plain duplication, but the slightest difference
justifies a new tuner entry.

On that saa7134 you have I had only a quick look at their website.

There seems not to be a card with saa7135 device, and more important, I
don't see anything pointing to an empress style mpeg encoder, which you
have enabled.

We need complete chip listing, if possible high resolution photos and as
an absolute minimum dmesg with i2c_scan=1 enabled.

The saa7134 chip device there seems to have a well known remote, maybe
you can discover it at the bttv-gallery.de.

We seem also to have a problem how to collect information about new
devices currently, the v4l-wiki is by far not sufficient enough to look
something up and Gunther at the bttv gallery might have it sick, dunno.

I'm not a fan of ASCII art in saa7134-input, that should have a place on
the wiki and/or the bttv-gallery.

Without looking closer, you should _not_ have the keypress at 0x8000 in
the gpiomask of the card in saa7134-cards.c, but only in
saa7134-input.c. If that is not sufficient, something weird is going on.

Most consumer devices in Europe, almost always SCART is used for s-video
here, do only output composite, even on their s-video connectors. That
might explain the black and white only. Also vmux 8 seems to be
untested.

The most astonishing you have is tda9887 port2 inactive and intercarrier
demodulation, and that should work with a claimed FM1216ME/I H-3 (MK3)
on SECAM_L !

Almost impossible for my limited experience.

We need hard facts about that tuner on the board.

Have a look at tuner-types.h/c and what is needed to have the MK3s
functional for all such different standards. To force something in the
card's entry will override all such, and as said, I'm scratching my
head, how you could ever have SECAM_L functional with what you choose ;)

Send new patches and those interested might continue with it there.

Cheers,
Hermann



--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
