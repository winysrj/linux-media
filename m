Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout10.t-online.de ([194.25.134.21]:44981 "EHLO
	mailout10.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035AbZFRJ60 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Jun 2009 05:58:26 -0400
Date: Thu, 18 Jun 2009 11:58:08 +0200
From: Halim Sahin <halim.sahin@t-online.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Trent Piepho <xyzzy@speakeasy.org>, linux-media@vger.kernel.org
Subject: Re: bttv problem loading takes about several minutes
Message-ID: <20090618095808.GA5685@halim.local>
References: <20090617162400.GA11690@halim.local> <Pine.LNX.4.58.0906171001510.32713@shell2.speakeasy.net> <200906172206.27230.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906172206.27230.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
On Mi, Jun 17, 2009 at 10:06:26 +0200, Hans Verkuil wrote:
> The log is from bttv version 0.9.17. The new code is only present in version 
> 0.9.18. So this is definitely not related to any of my changes.
> 
> The text "bttv0: gpio: en=00000000, out=00000000 in=003ff502 [init]" comes 
> from the call to bttv_gpio_tracking in bttv_probe, then the next 
> text "bttv0: tuner type=24" comes from early in bttv_init_card2, before any 
> i2c modules have been loaded.
> 
> The code in bttv_probe (bttv-driver.c) does this:
> 
>         if (bttv_verbose)
>                 bttv_gpio_tracking(btv,"init");
> 
>         /* needs to be done before i2c is registered */
>         bttv_init_card1(btv);
> 
>         /* register i2c + gpio */
>         init_bttv_i2c(btv);
> 
>         /* some card-specific stuff (needs working i2c) */
>         bttv_init_card2(btv);
> 
> So it looks like it can be either bttv_init_card1 or init_bttv_i2c that is 
> causing the delay.
> 
> Halim, can you try to put some printk() statements in between the calls 
> above to see which call is taking so long? Actually, it would be nice if 
> you are able to 'drill-down' as well in whatever function is causing the 
> delay, since I truly don't see what might be delaying things for you.

So I have tested latest v4l-dvb from hg.
The mentioned code was changed like this:
        if (bttv_verbose)
{
printk ("bttv_gpio_tracking(bt");
                bttv_gpio_tracking(btv,"init");
}

        /* needs to be done before i2c is registered */
printk("bttv_init_card1(btv);");
printk("        bttv_init_card1(btv);");

        bttv_init_card1(btv);

        /* register i2c + gpio */
printk("        init_bttv_i2c(btv);");
        init_bttv_i2c(btv);

Result:
[ 1069.277781] bttv: driver version 0.9.18 loaded
[ 1069.277788] bttv: using 8 buffers with 2080k (520 pages) each for capture
[ 1069.277886] bttv: Bt8xx card found (0).
[ 1069.277906] bttv0: Bt878 (rev 17) at 0000:00:0b.0, irq: 19, latency: 32, mmio
: 0xf7800000
[ 1069.278105] bttv0: using: Leadtek WinFast 2000/ WinFast 2000 XP [card=34,insm
od option]
[ 1069.278167] bttv_gpio_tracking(bt<7>bttv0: gpio: en=00000000, out=00000000 in
=003ff502 [init]
[ 1069.278173] bttv_init_card1(btv);        bttv_init_card1(btv);        init_bt
tv_i2c(btv);<6>bttv0: tuner type=24

 
> Regards,
> 
> 	Hans
> 
> >
> > > Giving this command with current drivers has some problems:
> > > 1. it takes several minutes to load bttv module.
> > > 2. capturing doesn't work any more (dropped frames etc).
> > > Tested with current v4l-dvb from hg, ubuntu 9.04,
> > > debian lenny.
> > >
> > > I have a bt878  based card from leadtek.
> > >
> > > Here is my output after loading the driver:
> > > [ 3013.735459] bttv: driver version 0.9.17 loaded
> > > [ 3013.735470] bttv: using 32 buffers with 16k (4 pages) each for
> > > capture [ 3013.735542] bttv: Bt8xx card found (0).
> > > [ 3013.735562] bttv0: Bt878 (rev 17) at 0000:00:0b.0, irq: 19, latency:
> > > 32, mmio
> > >
> > > : 0xf7800000
> > >
> > > [ 3013.737762] bttv0: using: Leadtek WinFast 2000/ WinFast 2000 XP
> > > [card=34,insm od option]
> > > [ 3013.737825] bttv0: gpio: en=00000000, out=00000000 in=003ff502
> > > [init] [ 3148.136017] bttv0: tuner type=24
> > > [ 3148.136029] bttv0: i2c: checking for MSP34xx @ 0x80... not found
> > > [ 3154.536019] bttv0: i2c: checking for TDA9875 @ 0xb0... not found
> > > [ 3160.936018] bttv0: i2c: checking for TDA7432 @ 0x8a... not found
> > > [ 3167.351398] bttv0: registered device video0
> > > [ 3167.351434] bttv0: registered device vbi0
> > > [ 3167.351463] bttv0: registered device radio0
> > > [ 3167.351485] bttv0: PLL: 28636363 => 35468950 . ok
> > > [ 3167.364182] input: bttv IR (card=34) as /class/input/input6
> > >
> > > Please help!
> > > Regards
> > > Halim
> > >
> > >
> > > --
> > > Halim Sahin
> > > E-Mail:
> > > halim.sahin (at) t-online.de
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-media"
> > > in the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> 
> -- 
> Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Halim Sahin
E-Mail:				
halim.sahin (at) t-online.de
