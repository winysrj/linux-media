Return-path: <mchehab@gaivota>
Received: from moutng.kundenserver.de ([212.227.17.8]:57131 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758983Ab1EMUnX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 May 2011 16:43:23 -0400
Date: Fri, 13 May 2011 22:43:08 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sylwester Nawrocki <snjw23@gmail.com>
cc: Josh Wu <josh.wu@atmel.com>, mchehab@redhat.com,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, lars.haring@atmel.com
Subject: Re: [PATCH] [media] at91: add Atmel Image Sensor Interface (ISI)
 support
In-Reply-To: <4DCD960E.3020504@gmail.com>
Message-ID: <Pine.LNX.4.64.1105132242380.29954@axis700.grange>
References: <1305186138-5656-1-git-send-email-josh.wu@atmel.com>
 <Pine.LNX.4.64.1105130956090.26356@axis700.grange> <4DCD960E.3020504@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Fri, 13 May 2011, Sylwester Nawrocki wrote:

> On 05/13/2011 03:50 PM, Guennadi Liakhovetski wrote:
> > On Thu, 12 May 2011, Josh Wu wrote:
> > 
> >> This patch is to enable Atmel Image Sensor Interface (ISI) driver support.
> >> - Using soc-camera framework with videobuf2 dma-contig allocator
> >> - Supporting video streaming of YUV packed format
> >> - Tested on AT91SAM9M10G45-EK with OV2640
> >>
> >> Signed-off-by: Josh Wu<josh.wu@atmel.com>
> >> ---
> ...
> >> diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
> >> index a10e4c3..f734a65 100644
> >> --- a/drivers/media/video/Makefile
> >> +++ b/drivers/media/video/Makefile
> >> @@ -166,6 +166,7 @@ obj-$(CONFIG_VIDEO_SH_MOBILE_CSI2)	+= sh_mobile_csi2.o
> >>   obj-$(CONFIG_VIDEO_SH_MOBILE_CEU)	+= sh_mobile_ceu_camera.o
> >>   obj-$(CONFIG_VIDEO_OMAP1)		+= omap1_camera.o
> >>   obj-$(CONFIG_VIDEO_SAMSUNG_S5P_FIMC) 	+= s5p-fimc/
> > 
> > [OT] hm, wow, who has decided to put a generic V4L driver (set) in the
> > Makefile together with other soc-camera drivers? It has to be converted now;)
> 
> In fact I've already converted that driver, but soc-camera wasn't unfortunately
> my choice, just the media controller ;-) I'll probably move the entry when 
> preparing upstream patches, it just doesn't feel safe here;)

Yeah, you're right - it's a boilerplate here, nothing like safe;)

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
