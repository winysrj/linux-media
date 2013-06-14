Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:65019 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176Ab3FNUpw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Jun 2013 16:45:52 -0400
Date: Fri, 14 Jun 2013 22:45:15 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: linux-media@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-sh@vger.kernel.org,
	Magnus Damm <magnus.damm@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Prabhakar Lad <prabhakar.lad@ti.com>,
	Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [PATCH v11 00/21] V4L2 clock and asynchronous probing
In-Reply-To: <2342425.VllfyDroN8@avalon>
Message-ID: <Pine.LNX.4.64.1306142244310.11221@axis700.grange>
References: <1371236911-15131-1-git-send-email-g.liakhovetski@gmx.de>
 <2342425.VllfyDroN8@avalon>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent

On Fri, 14 Jun 2013, Laurent Pinchart wrote:

> Hi Guennadi,
> 
> Thank you for the patches.
> 
> On Friday 14 June 2013 21:08:10 Guennadi Liakhovetski wrote:
> > v11 of the V4L2 clock helper and asynchronous probing patch set.
> > Functionally identical to v10, only differences are a couple of comment
> > lines and one renamed struct field - as requested by respectable
> > reviewers :)
> > 
> > Only patches #15, 16 and 18 changed.
> 
> [snip]
> 
> >  .../devicetree/bindings/media/sh_mobile_ceu.txt    |   18 +
> 
>    Documentation/video4linux/v4l2-framework.txt is missing :-)

I know. I will add it as soon as these patches are in.

Thanks
Guennadi

> >  arch/arm/mach-shmobile/board-ap4evb.c              |  103 ++--
> >  arch/arm/mach-shmobile/clock-sh7372.c              |    1 +
> >  drivers/media/i2c/soc_camera/imx074.c              |   32 +-
> >  drivers/media/i2c/soc_camera/mt9m001.c             |   17 +-
> >  drivers/media/i2c/soc_camera/mt9m111.c             |   20 +-
> >  drivers/media/i2c/soc_camera/mt9t031.c             |   19 +-
> >  drivers/media/i2c/soc_camera/mt9t112.c             |   25 +-
> >  drivers/media/i2c/soc_camera/mt9v022.c             |   17 +-
> >  drivers/media/i2c/soc_camera/ov2640.c              |   19 +-
> >  drivers/media/i2c/soc_camera/ov5642.c              |   20 +-
> >  drivers/media/i2c/soc_camera/ov6650.c              |   17 +-
> >  drivers/media/i2c/soc_camera/ov772x.c              |   15 +-
> >  drivers/media/i2c/soc_camera/ov9640.c              |   17 +-
> >  drivers/media/i2c/soc_camera/ov9640.h              |    1 +
> >  drivers/media/i2c/soc_camera/ov9740.c              |   18 +-
> >  drivers/media/i2c/soc_camera/rj54n1cb0c.c          |   17 +-
> >  drivers/media/i2c/soc_camera/tw9910.c              |   24 +-
> >  drivers/media/platform/soc_camera/atmel-isi.c      |   38 +-
> >  drivers/media/platform/soc_camera/mx1_camera.c     |   48 +-
> >  drivers/media/platform/soc_camera/mx2_camera.c     |   41 +-
> >  drivers/media/platform/soc_camera/mx3_camera.c     |   44 +-
> >  drivers/media/platform/soc_camera/omap1_camera.c   |   41 +-
> >  drivers/media/platform/soc_camera/pxa_camera.c     |   46 +-
> >  .../platform/soc_camera/sh_mobile_ceu_camera.c     |  243 +++++--
> >  drivers/media/platform/soc_camera/sh_mobile_csi2.c |  153 +++--
> >  drivers/media/platform/soc_camera/soc_camera.c     |  707 ++++++++++++++---
> >  .../platform/soc_camera/soc_camera_platform.c      |    2 +-
> >  drivers/media/v4l2-core/Makefile                   |    3 +-
> >  drivers/media/v4l2-core/v4l2-async.c               |  280 ++++++++
> >  drivers/media/v4l2-core/v4l2-clk.c                 |  242 +++++++
> >  drivers/media/v4l2-core/v4l2-common.c              |    2 +
> >  include/media/sh_mobile_ceu.h                      |    2 +
> >  include/media/sh_mobile_csi2.h                     |    2 +-
> >  include/media/soc_camera.h                         |   39 +-
> >  include/media/v4l2-async.h                         |  105 +++
> >  include/media/v4l2-clk.h                           |   54 ++
> >  include/media/v4l2-subdev.h                        |   10 +
> >  38 files changed, 2035 insertions(+), 467 deletions(-)
> >  create mode 100644
> > Documentation/devicetree/bindings/media/sh_mobile_ceu.txt create mode
> > 100644 drivers/media/v4l2-core/v4l2-async.c
> >  create mode 100644 drivers/media/v4l2-core/v4l2-clk.c
> >  create mode 100644 include/media/v4l2-async.h
> >  create mode 100644 include/media/v4l2-clk.h
> -- 
> Regards,
> 
> Laurent Pinchart
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
