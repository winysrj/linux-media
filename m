Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:1856 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863Ab2BHUaj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Feb 2012 15:30:39 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Ondrej Zary <linux@rainbow-software.org>
Subject: Re: [alsa-devel] tea575x-tuner improvements & use in maxiradio
Date: Wed, 8 Feb 2012 21:30:07 +0100
Cc: alsa-devel@alsa-project.org, linux-media@vger.kernel.org
References: <1328447827-9842-1-git-send-email-hverkuil@xs4all.nl> <201202080829.25201.hverkuil@xs4all.nl> <201202082057.48045.linux@rainbow-software.org>
In-Reply-To: <201202082057.48045.linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201202082130.07888.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday, February 08, 2012 20:57:43 Ondrej Zary wrote:
> On Wednesday 08 February 2012 08:29:25 Hans Verkuil wrote:
> > On Tuesday, February 07, 2012 23:20:19 Ondrej Zary wrote:
> > > On Sunday 05 February 2012 14:17:05 Hans Verkuil wrote:
> > > > These patches improve the tea575x-tuner module to make it up to date
> > > > with the latest V4L2 frameworks.
> > > >
> > > > The maxiradio driver has also been converted to use the tea575x-tuner
> > > > and I've used that card to test it.
> > > >
> > > > Unfortunately, this card can't read the data pin, so the new hardware
> > > > seek functionality has been tested only partially (yes, it seeks, but
> > > > when it finds a channel I can't read back the frequency).
> > > >
> > > > Ondrej, are you able to test these patches for the sound cards that use
> > > > this tea575x tuner?
> > > >
> > > > Note that these two patches rely on other work that I did and that
> > > > hasn't been merged yet. So it is best to pull from my git tree:
> > > >
> > > > http://git.linuxtv.org/hverkuil/media_tree.git/shortlog/refs/heads/radi
> > > >o-pc i2
> > > >
> > > > You can use the v4l-utils repository
> > > > (http://git.linuxtv.org/v4l-utils.git) to test the drivers: the
> > > > v4l2-compliance test should succeed and with v4l2-ctl you can test the
> > > > hardware seek:
> > > >
> > > > To seek down:
> > > >
> > > > v4l2-ctl -d /dev/radio0 --freq-seek=dir=0
> > > >
> > > > To seek up:
> > > >
> > > > v4l2-ctl -d /dev/radio0 --freq-seek=dir=1
> > > >
> > > > To do the compliance test:
> > > >
> > > > v4l2-compliance -r /dev/radio0
> > >
> > > It seems to work (tested with SF64-PCR - snd_fm801) but the seek is
> > > severely broken. Reading the frequency immediately after seek does not
> > > work, it always returns the old value (haven't found a delay that works).
> > > Reading it later (copied back snd_tea575x_get_freq function) works. The
> > > chip seeks randomly up or down, ignoring UP/DOWN flag and often stops at
> > > wrong place (only noise) or even outside the FM range.
> > >
> > > So I strongly suggest not to enable this (mis-)feature. The HW seems to
> > > be completely broken (unless there's some weird bug in the code).
> >
> > Well, it seemed like a good idea at the time :-) I'll remove this
> > 'feature', it's really not worth our time to try and make this work for
> > these old cards.
> >
> > I wonder if you are able to test the ISA radio-sf16fmr2.c driver? I'm not
> > sure if you have the hardware, but since I changed this driver to use the
> > proper isa kernel framework I'd like to have this tested if possible.
> 
> The driver works, provided that linux/slab.h is included. It oopses on rmmod
> because dev_set_drvdata() call is missing from init.
> This patch fixes all of that and also removes (now useless) static fmr2_card:

Thanks! I'll apply the changes for the final pull request. That's probably
going to be in a week or two.

BTW, do you perhaps have a mirosound pcm20 card (or know someone who does)?
I'd like to update the radio-miropcm20 driver as well and it would be nice if
my changes can be tested.

Regards,

	Hans

> 
> --- a/drivers/media/radio/radio-sf16fmr2.c
> +++ b/drivers/media/radio/radio-sf16fmr2.c
> @@ -9,6 +9,7 @@
>  #include <linux/delay.h>
>  #include <linux/module.h>	/* Modules 			*/
>  #include <linux/init.h>		/* Initdata			*/
> +#include <linux/slab.h>
>  #include <linux/ioport.h>	/* request_region		*/
>  #include <linux/io.h>		/* outb, outb_p			*/
>  #include <linux/isa.h>
> @@ -32,7 +33,6 @@ struct fmr2 {
>  
>  /* the port is hardwired so no need to support multiple cards */
>  #define FMR2_PORT	0x384
> -static struct fmr2 fmr2_card;
>  
>  /* TEA575x tuner pins */
>  #define STR_DATA	(1 << 0)
> @@ -188,7 +188,7 @@ static int fmr2_tea_ext_init(struct snd_tea575x *tea)
>  
>  static int __init fmr2_probe(struct device *pdev, unsigned int dev)
>  {
> -	struct fmr2 *fmr2 = &fmr2_card;
> +	struct fmr2 *fmr2;
>  	int err;
>  
>  	fmr2 = kzalloc(sizeof(*fmr2), GFP_KERNEL);
> @@ -229,6 +229,7 @@ static int __init fmr2_probe(struct device *pdev, unsigned int dev)
>  	}
>  
>  	printk(KERN_INFO "radio-sf16fmr2: SF16-FMR2 radio card at 0x%x.\n", fmr2->io);
> +	dev_set_drvdata(pdev, fmr2);
>  	return 0;
>  }
>  
> 
> 
> 
> 
