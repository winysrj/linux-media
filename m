Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w2.samsung.com ([211.189.100.13]:51545 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219AbaJHSAo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Oct 2014 14:00:44 -0400
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by usmailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0ND50004O0P7BE20@usmailout3.samsung.com> for
 linux-media@vger.kernel.org; Wed, 08 Oct 2014 14:00:43 -0400 (EDT)
Date: Wed, 08 Oct 2014 15:00:38 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Ulrich Eckhardt <uli-lirc@uli-eckhardt.de>
Cc: linux-media@vger.kernel.org
Subject: Re: Tevii S480 on Unicable SCR System
Message-id: <20141008150038.4ca96c22.m.chehab@samsung.com>
In-reply-to: <54356BB9.5000609@uli-eckhardt.de>
References: <542C4B14.8030708@uli-eckhardt.de>
 <54356BB9.5000609@uli-eckhardt.de>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 08 Oct 2014 18:52:09 +0200
Ulrich Eckhardt <uli-lirc@uli-eckhardt.de> escreveu:

> Hi,
> 
> I have digged a little bit deeper in the code and hopefully found a more general solution 
> by initializing the voltage in dvb_frontend.c in the function dvb_register_frontend.
> This should be a more global approach which may also fix this type of problems
> with other cards. I will test this patch the next days on a different system with a 
> CineS2 V5.5 card.
> 
> Any opinions about this patch or is my first attempt with patching only the code
> for the Tevii S480 a better solution?

You forgot to add your Signed-off-by to your patch...

> -----------------------------------------------------------------------------
> diff -r f62f56c648b0 drivers/media/dvb-core/dvb_frontend.c
> --- a/drivers/media/dvb-core/dvb_frontend.c     Wed Oct 08 17:30:52 2014 +0200
> +++ b/drivers/media/dvb-core/dvb_frontend.c     Wed Oct 08 17:40:20 2014 +0200
> @@ -2622,6 +2622,14 @@
>                              fe, DVB_DEVICE_FRONTEND);
>  
>         /*
> +        * Ensure that frontend voltage is switched off on initialization
> +        */
> +       if (dvb_powerdown_on_sleep) {

I'm wandering why to test if (dvb_powerdown_on_sleep) here...

MODULE_PARM_DESC(dvb_powerdown_on_sleep, "0: do not power down, 1: turn LNB voltage off on sleep (default)");

That controls what happens when the frontend's thread stops, and not
what happens during device initialization.

So, IMHO, it doesn't apply here.

> +               if (fe->ops.set_voltage)
> +                       fe->ops.set_voltage(fe, SEC_VOLTAGE_OFF);

I actually have different feelings with regards to the above: I don't
think that the core should take care of it, as this is part of device
initialization. I mean: the frontend driver should be the one responsible
to power off the voltage during module initialization.

Adding this to the core will add an uneeded initialization for most
drivers that do it already.

On the other hand, adding it would help to avoid one additional bug
to be handled when the developer forgets to add such voltage off
setting at the driver's init code, and the board is bad enough to
turn voltage on at reset.

My vote is to fix it at the driver's level.

Regards,
Mauro

> +       }
> +
> +       /*
>          * Initialize the cache to the proper values according with the
>          * first supported delivery system (ops->delsys[0])
>          */
> 
> -----------------------------------------------------------------------------
> 
> Am 01.10.2014 um 20:42 schrieb Ulrich Eckhardt:
> > Hi,
> > 
> > i have a development computer with a Tevii S480 connected to a Satellite channel
> > router (EN50494). As long as I haven't started a video application this
> > computers blocks any other receiver connected to this cable. I have measured the
> > output of the Tevii card and found, that after start of the computer, the output
> > is set to 18V. This is not reset after loading and initializing the drivers. So
> > no other receiver could sent DiSEqC commands to the SCR until
> > a video application at this computer initializes the voltage correctly. I think
> > the voltage needs to be switched off until this card is really in use by an
> > application.
> > 
> > I have patched the file drivers/media/dvb-frontends/ds3000.c to initialize the
> > voltage to OFF, which works for me. But I am not sure, if this is really the
> > correct solution:
