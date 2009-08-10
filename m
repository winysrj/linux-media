Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-16.arcor-online.net ([151.189.21.56]:47284 "EHLO
	mail-in-16.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754759AbZHJAFb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 9 Aug 2009 20:05:31 -0400
Subject: Re: Support for Items ITV-301
From: hermann pitton <hermann-pitton@arcor.de>
To: "Michael A. Fallavollita, Ph.D." <mikef@microtech.com>,
	Andre Auzi <aauzi@users.sourceforge.net>
Cc: video4linux-list@redhat.com, linux-media@vger.kernel.org
In-Reply-To: <1249806176.3300.29.camel@pc07.localdom.local>
References: <4A7E5B1D.5060102@microtech.com>
	 <1249806176.3300.29.camel@pc07.localdom.local>
Content-Type: text/plain
Date: Mon, 10 Aug 2009 02:04:08 +0200
Message-Id: <1249862648.3296.36.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Am Sonntag, den 09.08.2009, 10:22 +0200 schrieb hermann pitton:
> Hi Michael,
> 
> Am Samstag, den 08.08.2009, 22:14 -0700 schrieb Michael A. Fallavollita,
> Ph.D.:
> > Hello to the list.
> > 
> > I bought a generic SAA7130 based card from ebay a while back.  After
> > much research I have determined that it is an ITV-301.  I noticed in
> > searching the archives of this list that a patch was posted by Andre
> > Auzi a while back  but it doesn't appear that this card made it into the
> > current source.  I was wondering if anyone has a current build of the 
> > module that includes support for this device or perhaps can point me to 
> > a supported card in the list that works.
> > 
> > Thanks.
> > 
> >     -- Mike
> > 
> > 
> 
> http://article.gmane.org/gmane.comp.video.video4linux/38064
> 
> how can you ever know, it is a ITV-301?
> 
> saa7133[0]: Huh, no eeprom present (err=-5)?
> 
> It can be anything with any tuner.
> 
> Likely this is why that patch never made it in.
> 
> The interesting lines are:
> 
> +                * saa7133[0]: board init: gpio is 4c04c00
> +                * tuner' 2-0043: chip found @ 0x86 (saa7133[0])
> 
> Any such the same?
> 
> Have a look at saa7134-cards.c.
> 
> Anything with vmux = 3 and amux = LINE2 for TV and forced tuner=38
> should work then for TV. Well, we have already a lot of duplicate code.
> 

looked closer to cards without eeprom.

This Items ITV-301 seems to be identical with current Manli MTV301.

http://www.manli.com/eng_products_detail.php?pCatId=63&productId=105#
http://pcgeneral.hu/images/itv301.jpg

Andre in his later patches uses also the IR configuration of prior Manli
cards we have.

The above card(s) use now saa7135 chips, the older ones we have saa7130.

Because of that, there is a flaw in Andre's patch.
He uses, like on saa7130 mono only chips, LINE2 input from tuner to the
saa7135. This is only mono sound from the tuner.

Instead amux = TV should be used to get stereo sound on that board.
(Some older cards still have mono from tuner additionally in their
configuration)

This, in combination with the Manli IR, the different audio clock
compared to the Manli cards and the MK3 tuner would justify a new entry
for the card I think.

Could you try, if .amux = TV works for Television?

Reworked patches must go to linux-media@vger.kernel.org

This is the valid list now and "patchwork", patchwork.kernel.org for
linux-media, tries to collect the patches from that list.

Make sure to run "make checkpatch" before and send also as .patch
attachment. Andre's mailer breaks the lines.

I'm not sure for what that gpiomask is needed, but else you could try
for now with

"options saa7134 card=27 tuner=38 audio_clock_override=0x00187de7"

That will also have only mono sound for Television.

Cheers,
Hermann




