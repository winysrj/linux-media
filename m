Return-path: <linux-media-owner@vger.kernel.org>
Received: from tango.tkos.co.il ([62.219.50.35]:55891 "EHLO tango.tkos.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757041Ab0EXNoP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 24 May 2010 09:44:15 -0400
Date: Mon, 24 May 2010 16:43:08 +0300
From: Baruch Siach <baruch@tkos.co.il>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sascha Hauer <kernel@pengutronix.de>,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 0/3] Driver for the i.MX2x CMOS Sensor Interface
Message-ID: <20100524134308.GD3865@jasper.tkos.co.il>
References: <cover.1274706733.git.baruch@tkos.co.il>
 <Pine.LNX.4.64.1005241528410.2611@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1005241528410.2611@axis700.grange>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Mon, May 24, 2010 at 03:34:32PM +0200, Guennadi Liakhovetski wrote:
> On Mon, 24 May 2010, Baruch Siach wrote:
> 
> > This series contains a soc_camera driver for the i.MX25/i.MX27 CSI device, and
> > platform code for the i.MX25 and i.MX27 chips. This driver is based on a 
> > driver for i.MX27 CSI from Sascha Hauer, that  Alan Carvalho de Assis has 
> > posted in linux-media last December[1]. I tested the mx2_camera driver on the 
> > i.MX25 PDK. Sascha Hauer has tested a earlier version of this driver on an 
> > i.MX27 based board. I included in this version some fixes from Sascha that 
> > enable i.MX27 support.
> > 
> > [1] https://patchwork.kernel.org/patch/67636/
> 
> Thanks for the patches! I'll have a look at them in the next couple of 
> days. I presume, you do not expect this driver to make it into 2.6.35? rc1 
> is expected any time now, so, we'll take our time and prepare it for 
> 2.6.36, right?

I don't expect this driver to be in 2.6.35. It's not that urgent. This code 
should also do some time in -next.

Thanks for your continued support.

baruch

> > 
> > Changes v1 -> v2
> >     Addressed the comments of Guennadi Liakhovetski except from the following:
> > 
> >     1. The mclk_get_divisor implementation, since I don't know what this code 
> >        is good for
> > 
> >     2. mx2_videobuf_release should not set pcdev->active on i.MX27, because 
> >        mx27_camera_frame_done needs this pointer
> > 
> >     3. In mx27_camera_emma_buf_init I don't know the meaning of those hard 
> >        coded magic numbers
> > 
> >     Applied i.MX27 fixes from Sascha.
> > 
> > Baruch Siach (3):
> >   mx2_camera: Add soc_camera support for i.MX25/i.MX27
> >   mx27: add support for the CSI device
> >   mx25: add support for the CSI device
> > 
> >  arch/arm/mach-mx2/clock_imx27.c          |    2 +-
> >  arch/arm/mach-mx2/devices.c              |   31 +
> >  arch/arm/mach-mx2/devices.h              |    1 +
> >  arch/arm/mach-mx25/clock.c               |   14 +-
> >  arch/arm/mach-mx25/devices.c             |   22 +
> >  arch/arm/mach-mx25/devices.h             |    1 +
> >  arch/arm/plat-mxc/include/mach/memory.h  |    4 +-
> >  arch/arm/plat-mxc/include/mach/mx25.h    |    2 +
> >  arch/arm/plat-mxc/include/mach/mx2_cam.h |   46 +
> >  drivers/media/video/Kconfig              |   13 +
> >  drivers/media/video/Makefile             |    1 +
> >  drivers/media/video/mx2_camera.c         | 1471 ++++++++++++++++++++++++++++++
> >  12 files changed, 1603 insertions(+), 5 deletions(-)
> >  create mode 100644 arch/arm/plat-mxc/include/mach/mx2_cam.h
> >  create mode 100644 drivers/media/video/mx2_camera.c
> > 
> 
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/

-- 
                                                     ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
