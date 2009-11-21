Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-14.arcor-online.net ([151.189.21.54]:53890 "EHLO
	mail-in-14.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753623AbZKUAuB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Nov 2009 19:50:01 -0500
Subject: Re: [PATCH] em28xx: fix for "Leadtek winfast tv usbii deluxe"
From: hermann pitton <hermann-pitton@arcor.de>
To: Magnus Alm <magnus.alm@gmail.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <1258763382.3261.15.camel@pc07.localdom.local>
References: <156a113e0911130048p67ddbabfv263293de9f7f04d9@mail.gmail.com>
	 <1258763382.3261.15.camel@pc07.localdom.local>
Content-Type: text/plain
Date: Sat, 21 Nov 2009 01:44:10 +0100
Message-Id: <1258764250.3261.23.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

[...]
> > diff -r 19c0469c02c3 linux/drivers/media/video/em28xx/em28xx-cards.c
> > --- a/linux/drivers/media/video/em28xx/em28xx-cards.c	Sat Nov 07
> > 15:51:01 2009 -0200
> > +++ b/linux/drivers/media/video/em28xx/em28xx-cards.c	Fri Nov 13
> > 09:40:40 2009 +0100
> > @@ -466,21 +466,30 @@
> >  		.name         = "Leadtek Winfast USB II Deluxe",
> >  		.valid        = EM28XX_BOARD_NOT_VALIDATED,
> >  		.tuner_type   = TUNER_PHILIPS_FM1216ME_MK3,
> > -		.tda9887_conf = TDA9887_PRESENT,
> > +		.has_ir_i2c   = 1,
> > +		.tvaudio_addr = 0x58,
> > +		.tda9887_conf = TDA9887_PRESENT |
> > +				TDA9887_PORT2_ACTIVE |
> > +				TDA9887_QSS,
> 
> just on a first look, where you have this TDA9887_QSS from?
> 
> It should still be "int" and qss is default.
> 
> Also TDA9887_PORT2_ACTIVE is default on this tuner since some years.
> 

On a second fly over, TDA9887_QSS is not that wrong, but there is still
a plan to remove card specific tda9887 settings from the driver entries,
IIRC, all such was once planned to be even moved into user space.

So repeating tuner defaults in driver specific card entries is not
recommended. We have some very few hardware specific cases on which we
don't know how to avoid it.

Maybe I did not follow close enough, then please excuse, but I can't see
for what you need anything else as TDA9887_PRESENT ?

Cheers,
Hermann




