Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:22163 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754440Ab0FJGAd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Jun 2010 02:00:33 -0400
Date: Thu, 10 Jun 2010 08:00:40 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Baruch Siach <baruch@tkos.co.il>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sascha Hauer <kernel@pengutronix.de>,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 0/3] Driver for the i.MX2x CMOS Sensor Interface
In-Reply-To: <20100610052618.GA31840@jasper.tkos.co.il>
Message-ID: <Pine.LNX.4.64.1006100759010.12192@axis700.grange>
References: <cover.1274865040.git.baruch@tkos.co.il> <20100610052618.GA31840@jasper.tkos.co.il>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 10 Jun 2010, Baruch Siach wrote:

> Hi linux-media list,
> 
> Ping?
> Any news on this?

Hi Baruch

Sorry for taking longer to review this version, having a bit of a stressed 
week. I did look through this version briefly, looks good so far. I'll 
look at it again and come back to you, perhaps, end of the next week, or, 
with a lot of luck, today / tomorrow.

Thanks
Guennadi

> 
> baruch
> 
> On Wed, May 26, 2010 at 12:13:15PM +0300, Baruch Siach wrote:
> > This series contains a soc_camera driver for the i.MX25/i.MX27 CSI device, and
> > platform code for the i.MX25 and i.MX27 chips. This driver is based on a 
> > driver for i.MX27 CSI from Sascha Hauer, that  Alan Carvalho de Assis has 
> > posted in linux-media last December[1]. I tested the mx2_camera driver on the 
> > i.MX25 PDK. Sascha Hauer has tested a earlier version of this driver on an 
> > i.MX27 based board. I included in this version some fixes from Sascha that 
> > enable i.MX27 support.
> > 
> > [1] https://patchwork.kernel.org/patch/67636/
> > 
> > Changes v2 -> v3
> >     Address more comments from Guennadi Liakhovetski.
> > 
> >     Applied part of Sashca's patch that I forgot in v2.
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
> >  drivers/media/video/mx2_camera.c         | 1488 ++++++++++++++++++++++++++++++
> >  12 files changed, 1620 insertions(+), 5 deletions(-)
> >  create mode 100644 arch/arm/plat-mxc/include/mach/mx2_cam.h
> >  create mode 100644 drivers/media/video/mx2_camera.c
> > 
> 
> -- 
>                                                      ~. .~   Tk Open Systems
> =}------------------------------------------------ooO--U--Ooo------------{=
>    - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
> 

---
Guennadi Liakhovetski
