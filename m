Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:63759 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025Ab2AYUdG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Jan 2012 15:33:06 -0500
Received: by eekc14 with SMTP id c14so2787025eek.19
        for <linux-media@vger.kernel.org>; Wed, 25 Jan 2012 12:33:05 -0800 (PST)
Message-ID: <4F2066FC.5090907@gmail.com>
Date: Wed, 25 Jan 2012 21:33:00 +0100
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
	Matt Sealey <matt@genesi-usa.com>,
	Linux ARM Kernel ML <linux-arm-kernel@lists.infradead.org>
Subject: Re: Common clock API for i.MX
References: <CAKGA1bkHgnJQs3_n6QtQjf-8xaPn0YnxMmE2Q=+opWcsp10zQA@mail.gmail.com> <20120125084533.GD1068@n2100.arm.linux.org.uk> <CAKGA1bm_rLyMB-Xr-XZQHQRVDySu9JuCoVZL=FFv9sa1y6eD1A@mail.gmail.com> <20120125144439.GH1068@n2100.arm.linux.org.uk>
In-Reply-To: <20120125144439.GH1068@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/25/2012 03:44 PM, Russell King - ARM Linux wrote:
> On Wed, Jan 25, 2012 at 07:45:15AM -0600, Matt Sealey wrote:
>> On Wed, Jan 25, 2012 at 2:45 AM, Russell King - ARM Linux
>> <linux@arm.linux.org.uk>  wrote:
>>> On Tue, Jan 24, 2012 at 07:54:08PM -0600, Matt Sealey wrote:
>>>> Hi Arnd/RMK/Sascha,
>>>>
>>>> We're trying to bring up a good batch of drivers here for MX51 and
>>>> EfikaMX systems and noticed that the released 3.2 kernel doesn't
>>>> include the common clock stuff that all the other platforms seem to be
>>>> using.
>>>
>>> As far as I know, it still isn't ready (if it was, surely it would've
>>> been merged?)
>>>
>>> Grepping for clk_prepare() it looks like very few people have converted
>>> over to this - it's just the AMBA stuff, a few bits of OMAP and MXS.
>>> So even if the common clock stuff comes in, almost nothing will be able
>>> to use it:
>>>
>>> arch/arm/common/sa1111.c
>>> arch/arm/common/timer-sp.c
>>> arch/arm/mach-omap2/clock2xxx.c
>>> arch/arm/mach-omap2/clock.h
>>> arch/arm/mach-omap2/prcm.c
>>> arch/arm/mach-omap2/clock2430_data.c
>>> arch/arm/mach-omap2/clock2xxx.h
>>> arch/arm/mach-omap2/clock2420_data.c
>>> arch/arm/mach-mxs/clock-mx23.c
>>> arch/arm/mach-mxs/clock.c
>>> arch/arm/mach-mxs/timer.c
>>> arch/arm/mach-mxs/system.c
>>> arch/arm/mach-mxs/clock-mx28.c
>>> arch/arm/mach-mxs/mach-mx28evk.c
>>> arch/arm/kernel/smp_twd.c
>>> drivers/gpio/gpio-pxa.c
>>> drivers/tty/serial/amba-pl011.c
>>> drivers/tty/serial/mxs-auart.c
>>> drivers/tty/serial/amba-pl010.c
>>> drivers/amba/bus.c
>>> drivers/net/ethernet/freescale/fec.c
>>> drivers/net/can/flexcan.c
>>> drivers/video/omap2/dss/dsi.c
>>> drivers/video/amba-clcd.c
>>> drivers/video/mxsfb.c
>>> drivers/staging/tidspbridge/include/dspbridge/clk.h
>>> drivers/staging/tidspbridge/core/dsp-clock.c
>>> drivers/spi/spi-pl022.c
>>> drivers/mmc/host/mmci.c
>>> drivers/mmc/host/mxs-mmc.c
>>> drivers/dma/mxs-dma.c
>>> drivers/mtd/nand/gpmi-nand/gpmi-lib.c
>>>
>>> My conclusion, therefore, is that there's very little actual interest
>>> amongst the ARM community to move towards a common clk API.
>>
>> Maybe it's a chicken-egg thing; nobody wants to work on it until someone else
>> has done some legwork? :)
> 
> That was the precise problem which clk_prepare() was meant to solve.
> Precisely nothing was happening in terms of mainline with all the
> discussions going around in circles.

There are some pending V4L API developments depending on common struct clk,
required for sub-device drivers reuse and needed for works on DT support.
Unfortunately none of the media drivers is converted to clk_prepare yet.
This is where clock APIs are used (drivers/media/):

video/atmel-isi.c
video/davinci/dm355_ccdc.c
video/davinci/dm644x_ccdc.c
video/davinci/isif.c
video/davinci/vpbe.c
video/fsl-viu.c
video/mx1_camera.c
video/mx2_camera.c
video/mx3_camera.c
video/omap1_camera.c
video/omap24xxcam.c
video/omap3isp/isp.c
video/omap3isp/ispvideo.c
video/pxa_camera.c
video/s5p-fimc/fimc-core.c
video/s5p-fimc/fimc-mdevice.c
video/s5p-fimc/mipi-csis.c
video/s5p-mfc/s5p_mfc_pm.c
video/s5p-tv/hdmi_drv.c
video/s5p-tv/mixer_drv.c
video/s5p-tv/sdo_drv.c

Seems like people are unaware the clk_prepare support is needed first.
So let's convert these modules now, rather than waiting for the common
struct clk conversion to magically happen. As it is really needed and 
the efforts seem insignificant, at least for drivers/media/.

 
> We managed to settle on how to solve the problem where some platforms
> want different characteristics from clk_enable(), and nothing happened.
> The discussion kept going around in circles.
> 
> The whole point of getting clk_prepare() in early was to avoid a big-bang
> day where everything had to be converted in one big step when a platform
> decides to use the common API.
> 
> We know _definitely_ that a common API is going to need clk_prepare(),
> which is why I invested time into kicking that off.  Given the lack of
> uptake of it, I don't know why I bothered - I don't even know why I
> bothered getting involved in the totally useless discussions first time
> around.  It's just been a complete and utter waste of my time.
> 
> Like many things in the ARM community, trying to motivate people is an
> impossibility.  It can be seen time and time again.  Like the restart
> changes.
> 
> It's times like this I don't know why I bother.  That's why I've been
> hacking on the old SA11x0 platforms since Christmas.  At least I don't
> have to deal with trying to get concensus between arguing factions
> which _never_ makes progress even when there's agreement.  I don't have
> to bother with kicking people to get them to update their own hairy code.
> With obsolete hardware there _aren't_ any factions to kick together to
> agree.
> 
> As I said, I've lost interest in the common clk API.  Totally.  Completely.
> I really don't care so long as it doesn't create difficulties for me and
> the platforms I care about.  That's all I'm going to care about over the
> common clk API in future.  Not whether it solves other peoples problems.
> Call me selfish, but I think it's one of the times I'm justified to be
> given how much work I've tried to put in to that area.

--

Thanks,
Sylwester
