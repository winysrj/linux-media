Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31624 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750947Ab2LWNxG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Dec 2012 08:53:06 -0500
Date: Sun, 23 Dec 2012 11:39:47 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Frank =?UTF-8?B?U2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v2 16/21] em28xx: rename usb debugging module parameter
 and macro
Message-ID: <20121223113947.072f2d61@redhat.com>
In-Reply-To: <50D70864.4070903@googlemail.com>
References: <1352398313-3698-1-git-send-email-fschaefer.oss@googlemail.com>
	<1352398313-3698-17-git-send-email-fschaefer.oss@googlemail.com>
	<20121222181019.775f8c3f@redhat.com>
	<50D70864.4070903@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 23 Dec 2012 14:34:28 +0100
Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:

> Am 22.12.2012 21:10, schrieb Mauro Carvalho Chehab:
> > Em Thu,  8 Nov 2012 20:11:48 +0200
> > Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:
> >
> >> Rename module parameter isoc_debug to usb_debug and macro
> >> em28xx_isocdbg to em28xx_usb dbg to reflect that they are
> >> used for isoc and bulk USB transfers.
> >>
> >> Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
> >> ---
> >>  drivers/media/usb/em28xx/em28xx-video.c |   58 +++++++++++++++----------------
> >>  1 Datei geändert, 28 Zeilen hinzugefügt(+), 30 Zeilen entfernt(-)
> >>
> >> diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
> >> index d6de1cc..f435206 100644
> >> --- a/drivers/media/usb/em28xx/em28xx-video.c
> >> +++ b/drivers/media/usb/em28xx/em28xx-video.c
> >> @@ -58,13 +58,13 @@
> >>  		printk(KERN_INFO "%s %s :"fmt, \
> >>  			 dev->name, __func__ , ##arg); } while (0)
> >>  
> >> -static unsigned int isoc_debug;
> >> -module_param(isoc_debug, int, 0644);
> >> -MODULE_PARM_DESC(isoc_debug, "enable debug messages [isoc transfers]");
> >> +static unsigned int usb_debug;
> >> +module_param(usb_debug, int, 0644);
> >> +MODULE_PARM_DESC(usb_debug, "enable debug messages [isoc transfers]");
> > NACK: usb_debug is too generic: it could refer to control URB's, stream
> > URB's, and other non-URB related USB debugging.
> 
> Depends on what you think should be the role of this debug parameter.

There is already one debug parameter, for example, that shows all control
URB traffic. There is another one for the I2C commands (also sent via USB).

So, the naming choice here is really unfortunate, IMHO.

> > Also, it can cause some harm for the ones using it.
> >
> > As the rest of this series don't depend on this one, I'll just skip it.
> >
> > IMHO, the better is to either live it as-is, to avoid breaking for
> > someone with "isoc_debug" parameter on their /etc/modprobe.d, or to
> > do a "deprecate" path:
> >
> > 	- adding a new one called "stream_debug" (or something like that);
> > 	- keep the old one for a while, printing a warning message to
> > point that this got removed; 
> > 	- after a few kernel cycles, remove the legacy one.
> 
> So module parameters are part of the API ? Hmmm... that's new to me.

We consider so, as modprobe refuses to load a module if a parameter vanishes.

> 
> > Even better: simply unify all debug params into a single one, where 
> > each bit means one type of debug, like what was done on other drivers.
> 
> Yeah, I agree, that would be the best solution.
> The whole debugging code could need an overhault, but I really can't do
> that all at once.

Yeah, changing it takes some time.

Regards,
Mauro
