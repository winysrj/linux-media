Return-path: <mchehab@gaivota>
Received: from perceval.ideasonboard.com ([95.142.166.194]:53785 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797Ab0KDDes (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Nov 2010 23:34:48 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Bastian Hecht <hechtb@googlemail.com>
Subject: Re: OMAP3530 ISP irqs disabled
Date: Thu, 4 Nov 2010 04:34:53 +0100
Cc: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <AANLkTint8J4NdXQ4v1wmKAKWa7oeSHsdOn8JzjDqCqeY@mail.gmail.com> <4CD161B3.9000709@maxwell.research.nokia.com> <AANLkTikTAo71Kr+Nh8Q8DOMFwWB=gLQSXozgGo8ecYwm@mail.gmail.com>
In-Reply-To: <AANLkTikTAo71Kr+Nh8Q8DOMFwWB=gLQSXozgGo8ecYwm@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011040434.53836.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi Bastian,

On Wednesday 03 November 2010 14:38:25 Bastian Hecht wrote:
> 2010/11/3 Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>:
> > Bastian Hecht wrote:
> >> 2010/11/3 Bastian Hecht <hechtb@googlemail.com>:
> >>> Hello ISP team,
> >>> 
> >>> I succeeded to stream the first images from the sensor to userspace
> >>> using Laurent's media-ctl and yafta. Unfortunately all images are
> >>> black (10MB of zeros).
> >>> Once by chance I streamed some images (1 of 20 about) with content.
> >>> All values were < 0x400, so that I assume the values were correctly
> >>> transferred for my 10-bit pixels.
> >>> 
> >>> I shortly describe my setup:
> >>> As I need xclk_a activated for my sensor to work (I2C), I activate the
> >>> xclk in the isp_probe function. Early hack that I want to remove
> >>> later.
> > 
> > It _might_ be better to have this in isp_get().
> > 
> >>> While I placed my activation in mid of the probe function, I had
> >>> somehow the interrupts disabled when trying to stream using yafta. So
> >>> I hacked in the reenabling of the interrupts somewhere else in probe()
> >>> too.
> > 
> > That should definitely not be necessary. The interrupts are enabled in
> > isp_get().
> > 
> >>> As I dug through the isp code I saw that it is better to place the
> >>> clock activation after the final isp_put in probe() then the
> >>> interrupts keep working, but this way I never got a valid picture so
> >>> far. It's all a mess, I know. I try to transfer the activation to my
> >>> sensor code and board-setup code like in the et8ek8 code.
> >> 
> >> I enabled isr debugging (#define ISP_ISR_DEBUG) and see that only 1
> >> HS_VS_event is generated per second. 1fps corresponds to my clocking,
> >> so 1 vs per second is fine. But shouldn't I see about 2000 hs
> >> interrupts there too? HS_VS_IRQ is described as "HS or VS synchro
> >> event".
> > 
> > Are you getting any other interrupts? Basically every ISP block which is
> > on the pipe will produce interrupts. Which ISP block is writing the
> > images to memory for you?
> 
> I read out the CCDC with this pipeline:
> ./media-ctl -r -l '"mt9p031 2-005d":0->"OMAP3 ISP CCDC":0[1], "OMAP3
> ISP CCDC":1->"OMAP3 ISP CCDC output":0[1]'
> ./media-ctl -f '"mt9p031 2-005d":0[SGRBG10 2592x1944], "OMAP3 ISP
> CCDC":1[SGRBG10 2592x1944]'
> ./yavta -f SGRBG10 -s 2592x1944 -n 4 --capture=4 --skip 3 -F /dev/video2
> 
> I get these interrupts while reading 4 frames:
> 
> [ 3962.689483] s_stream is it! enable: 1
> [ 3962.783843] omap3isp omap3isp: CCDC_VD0_IRQ
> [ 3962.799530] omap3isp omap3isp: HS_VS_IRQ
> [ 3963.532958] omap3isp omap3isp: CCDC_VD1_IRQ
> [ 3963.899505] omap3isp omap3isp: CCDC_VD0_IRQ
> [ 3963.914184] omap3isp omap3isp: HS_VS_IRQ
> [ 3964.647644] omap3isp omap3isp: CCDC_VD1_IRQ
> [ 3965.013153] omap3isp omap3isp: CCDC_VD0_IRQ
> [ 3965.028839] omap3isp omap3isp: HS_VS_IRQ
> [ 3965.762298] omap3isp omap3isp: CCDC_VD1_IRQ
> [ 3966.127838] omap3isp omap3isp: CCDC_VD0_IRQ
> [ 3966.143585] omap3isp omap3isp: HS_VS_IRQ
> [ 3966.370788] omap3isp omap3isp: OMAP3 ISP AEWB: user wants to disable
> module. [ 3966.370819] omap3isp omap3isp: OMAP3 ISP AEWB: module is being
> disabled [ 3966.370849] omap3isp omap3isp: OMAP3 ISP AF: user wants to
> disable module. [ 3966.370880] omap3isp omap3isp: OMAP3 ISP AF: module is
> being disabled [ 3966.370880] omap3isp omap3isp: OMAP3 ISP histogram: user
> wants to disable module.
> [ 3966.370910] omap3isp omap3isp: OMAP3 ISP histogram: module is being
> disabled [ 3966.876983] omap3isp omap3isp: CCDC_VD1_IRQ
> [ 3967.242492] omap3isp omap3isp: CCDC_VD0_IRQ
> [ 3967.242614] s_stream is it! enable: 0
> 
> > Maybe a stupid question, but have you set exposure and gain to a
> > reasonable value? :-)
> 
> First reaction was - that must be it! But hmmm... the flanks on the
> data lines of the camera are mostly high. When I press my finger on
> the sensor they are mostly low. The other values seem to be good too:
> xclk comes in with 6Mhz and pixelclk comes out with 6Mhz (all within
> the limits of the datasheets - camera and omap isp). cam_vs raises for
> about 1 sec goes shortly down and comes up again. cam_hs seems to fit
> too.
> Every 20th try I get data from an image sample the other times only zeros.

The CCDC is configured with a DC subtract value of 64 by default, so it 
subtract 64 from every pixel. If your pixel values are lower than or equal to 
64 you will get a black image. As a quick hack you can replace

ccdc->clamp.dcsubval = 64;

with

ccdc->clamp.dcsubval = 0;

in isp_ccdc_init(). The correct solution is to use the 
VIDIOC_PRIVATE_ISP_CCDC_CFG ioctl to configure the DC subtraction value to 0.

-- 
Regards,

Laurent Pinchart
