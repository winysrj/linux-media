Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:4307 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754268AbZFQUGh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Jun 2009 16:06:37 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Trent Piepho <xyzzy@speakeasy.org>
Subject: Re: bttv problem loading takes about several minutes
Date: Wed, 17 Jun 2009 22:06:26 +0200
Cc: Halim Sahin <halim.sahin@t-online.de>, linux-media@vger.kernel.org
References: <20090617162400.GA11690@halim.local> <Pine.LNX.4.58.0906171001510.32713@shell2.speakeasy.net>
In-Reply-To: <Pine.LNX.4.58.0906171001510.32713@shell2.speakeasy.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906172206.27230.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 17 June 2009 19:11:23 Trent Piepho wrote:
> On Wed, 17 Jun 2009, Halim Sahin wrote:
> > Hi,
> > In the past I could use this card by typing
> > modprobe bttv card=34 tuner=24 gbuffers=16
>
> What card do you actually have?  What is the PCI subsystem vendor/device
> and what tuner does it actually have?
>
> Hans, the problem might be with bttv audio probing.  This card has
> needs_tvaudio set to 0, which used to mean that tvaudio would not be
> probed or loaded.  But with your changes to bttv audio probing this
> behavior has changed.  Now tvaudio is always loaded and probed if another
> audio chip hasn't been detected.  The needs_tvaudio field is totally
> ignored.

The log is from bttv version 0.9.17. The new code is only present in version 
0.9.18. So this is definitely not related to any of my changes.

The text "bttv0: gpio: en=00000000, out=00000000 in=003ff502 [init]" comes 
from the call to bttv_gpio_tracking in bttv_probe, then the next 
text "bttv0: tuner type=24" comes from early in bttv_init_card2, before any 
i2c modules have been loaded.

The code in bttv_probe (bttv-driver.c) does this:

        if (bttv_verbose)
                bttv_gpio_tracking(btv,"init");

        /* needs to be done before i2c is registered */
        bttv_init_card1(btv);

        /* register i2c + gpio */
        init_bttv_i2c(btv);

        /* some card-specific stuff (needs working i2c) */
        bttv_init_card2(btv);

So it looks like it can be either bttv_init_card1 or init_bttv_i2c that is 
causing the delay.

Halim, can you try to put some printk() statements in between the calls 
above to see which call is taking so long? Actually, it would be nice if 
you are able to 'drill-down' as well in whatever function is causing the 
delay, since I truly don't see what might be delaying things for you.

Regards,

	Hans

>
> > Giving this command with current drivers has some problems:
> > 1. it takes several minutes to load bttv module.
> > 2. capturing doesn't work any more (dropped frames etc).
> > Tested with current v4l-dvb from hg, ubuntu 9.04,
> > debian lenny.
> >
> > I have a bt878  based card from leadtek.
> >
> > Here is my output after loading the driver:
> > [ 3013.735459] bttv: driver version 0.9.17 loaded
> > [ 3013.735470] bttv: using 32 buffers with 16k (4 pages) each for
> > capture [ 3013.735542] bttv: Bt8xx card found (0).
> > [ 3013.735562] bttv0: Bt878 (rev 17) at 0000:00:0b.0, irq: 19, latency:
> > 32, mmio
> >
> > : 0xf7800000
> >
> > [ 3013.737762] bttv0: using: Leadtek WinFast 2000/ WinFast 2000 XP
> > [card=34,insm od option]
> > [ 3013.737825] bttv0: gpio: en=00000000, out=00000000 in=003ff502
> > [init] [ 3148.136017] bttv0: tuner type=24
> > [ 3148.136029] bttv0: i2c: checking for MSP34xx @ 0x80... not found
> > [ 3154.536019] bttv0: i2c: checking for TDA9875 @ 0xb0... not found
> > [ 3160.936018] bttv0: i2c: checking for TDA7432 @ 0x8a... not found
> > [ 3167.351398] bttv0: registered device video0
> > [ 3167.351434] bttv0: registered device vbi0
> > [ 3167.351463] bttv0: registered device radio0
> > [ 3167.351485] bttv0: PLL: 28636363 => 35468950 . ok
> > [ 3167.364182] input: bttv IR (card=34) as /class/input/input6
> >
> > Please help!
> > Regards
> > Halim
> >
> >
> > --
> > Halim Sahin
> > E-Mail:
> > halim.sahin (at) t-online.de
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media"
> > in the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
