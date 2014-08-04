Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:33664 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253AbaHDPYv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Aug 2014 11:24:51 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Stefan Herbrechtsmeier <stefan@herbrechtsmeier.net>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: Problems with the omap3isp
Date: Mon, 04 Aug 2014 17:25:18 +0200
Message-ID: <5795344.auXD3SfuqM@avalon>
In-Reply-To: <53DF513D.7010501@herbrechtsmeier.net>
References: <53C4FC99.9050308@herbrechtsmeier.net> <3376696.nE771YBFja@avalon> <53DF513D.7010501@herbrechtsmeier.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Stefan,

On Monday 04 August 2014 11:24:13 Stefan Herbrechtsmeier wrote:
> Hi Laurent,
> 
> thank you very much for your help.
> 
> The problem is cross talk on the camera flex cable of the Gumstix Overo.
> The XCLKA signal is beside PCLK and VS.

Right, I should have mentioned that. It's a know issue, and there's not much 
that can be done about it without a hardware redesign. A ground (or power 
supply) signal should really have been inserted on each side of the XCLKA and 
PCLK signals.

> Additionally the OV5647 camera tristate all outputs by default. This leads
> to HS_VS_IRQ interrupts.

This should be taken care of by pull-up or pull-down resistors on the camera 
signals. I've disabled them with the Caspa camera given the low drive strength 
of the buffer on the camera board, but you could enable them on your system.

> I wasn't aware of the interrupts enable during the isp_xclk_prepare.
> 
> Am 01.08.2014 15:57, schrieb Laurent Pinchart:
> > On Thursday 31 July 2014 10:29:37 Stefan Herbrechtsmeier wrote:
> >> Am 31.07.2014 01:10, schrieb Laurent Pinchart:
> >>> On Tuesday 15 July 2014 12:04:09 Stefan Herbrechtsmeier wrote:
> >>>> Hi Laurent,
> >>>> 
> >>>> I have some problems with the omap3isp driver. At the moment I use a
> >>>> linux-stable 3.14.5 with your fixes for omap3xxx-clocks.dtsi.
> >>>> 
> >>>> 1. If I change the clock rate to 24 MHz in my camera driver the whole
> >>>> system freeze at the clk_prepare_enable. The first enable and disable
> >>>> works without any problem. The system freeze during a systemd / udev
> >>>> call of media-ctl.
> >>> 
> >>> I've never seen that before. Where does your sensor get its clock from ?
> >>> Is it connected to the ISP XCLKA or XCLKB output ?
> >> 
> >> XCLKA
> >> 
> >>> What happens if you don't change the clock rate to 24 MHz ? What rate is
> >>> it set to in that case ?
> >> 
> >> It works if I use a clock rate of 12 MHz or 36 MHz.
> >> 
> >> I use the following lines during power enable in the driver:
> >>       clk_set_rate(ov5647->clk, 24000000);
> >>       clk_prepare_enable(ov5647->clk);
> >> 
> >> This works during probe, but the second time I try to power up the
> >> device the system stall after clk_prepare_enable.
> > 
> > Just to make sure I understand properly, if you change the above frequency
> > value to 12000000 or 36000000 without modifying anything else, the problem
> > doesn't occur ?
> 
> Yes.
> 
> > Do you start streaming at all at any point ?
> 
> No, it stops in s_power.
> 
> >> I see the following dump:
> > [snip]
> > 
> > Looks like the CPU spends all its time processing interrupts. Could you
> > please try the following patch ? It should disable the ISP interrupt after
> > 100000 occurrences, and create an isr_account property in sysfs that will
> > report the number of interrupts generated for each source. If my guess is
> > correct, you will hit the 100000 interrupts limit very quickly and the
> > system will unfreeze. If so, please report the content of
> > /proc/interrupts
> ...
>   40:     100001      INTC  24  omap-iommu.0, OMAP3 ISP
> ...
> 
> >   and of
> > 
> > the isr_account property (if I remember correctly it should be located in
> > /sys/class/video4linux/video0/device/media0/ but you might need to search
> > for it).
> 
> 0       0
> ...
> 30      0
> 31      100001

-- 
Regards,

Laurent Pinchart

