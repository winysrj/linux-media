Return-path: <mchehab@pedra>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:2528 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739Ab1BDLzz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Feb 2011 06:55:55 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH v5 0/5] OMAP3 ISP driver
Date: Fri, 4 Feb 2011 12:55:50 +0100
Cc: linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com
References: <1296131541-30092-1-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1296131541-30092-1-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201102041255.50253.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thursday, January 27, 2011 13:32:16 Laurent Pinchart wrote:
> Hi everybody,
> 
> Here's the fifth version of the OMAP3 ISP driver patches, updated to
> 2.6.37 and the latest changes in the media controller and sub-device APIs.

Hmm, patch 5/5 is missing. It's probably too big.

Anyway, I got the patch from your git tree and did a review. It's always hard
to review over 21000 lines of driver code :-), so I limited myself to the V4L2
API parts. I can't really comment on the OMAP3 specific parts anyway.

The first issue I found was related to controls: it seems you set up control
handlers for subdevs that don't have any controls. You can just leave
sd->ctrl_handler to NULL in that case and you don't need to use a control handler
at all.

There is also no need to set the core ctrl ops:

+       .queryctrl = v4l2_subdev_queryctrl,
+       .querymenu = v4l2_subdev_querymenu,
+       .g_ctrl = v4l2_subdev_g_ctrl,
+       .s_ctrl = v4l2_subdev_s_ctrl,
+       .g_ext_ctrls = v4l2_subdev_g_ext_ctrls,
+       .try_ext_ctrls = v4l2_subdev_try_ext_ctrls,
+       .s_ext_ctrls = v4l2_subdev_s_ext_ctrls,

These are only necessary if the master driver doesn't use the control
framework but called core.queryctrl directly. That shouldn't be the case
for this driver.

What isn't clear to me is whether the /dev/videoX nodes should give access
to the subdev controls as well. As far as I can see the ctrl_handler pointer
of neither v4l2_device nor video_device is ever set, so that means that the
controls are only accessible through /dev/v4l-subdevX.

I'm not sure whether that is intentional or not.

The other comment I have is regarding include/linux/omap3isp.h: both the
ioctls and the events need to be documented there. A one-liner for each is
probably enough. I also see that struct omap3isp_stat_data has a deprecated
field: perhaps when creating the final pull request the time is right to
remove it?

Finally, I noticed that OMAP3 has its own implementation of videobuf. Are
there plans to move to vb2?

Regards,

	Hans

> 
> You can find the patches in http://git.linuxtv.org/pinchartl/media.git as
> usual (media-0005-omap3isp).
> 
> Laurent Pinchart (2):
>   omap3: Add function to register omap3isp platform device structure
>   OMAP3 ISP driver
> 
> Sergio Aguirre (2):
>   omap3: Remove unusued ISP CBUFF resource
>   omap2: Fix camera resources for multiomap
> 
> Tuukka Toivonen (1):
>   ARM: OMAP3: Update Camera ISP definitions for OMAP3630
> 
>  arch/arm/mach-omap2/devices.c                |   64 +-
>  arch/arm/mach-omap2/devices.h                |   17 +
>  arch/arm/plat-omap/include/plat/omap34xx.h   |   16 +-
>  drivers/media/video/Kconfig                  |   13 +
>  drivers/media/video/Makefile                 |    2 +
>  drivers/media/video/isp/Makefile             |   13 +
>  drivers/media/video/isp/cfa_coef_table.h     |  601 +++++++
>  drivers/media/video/isp/gamma_table.h        |   90 +
>  drivers/media/video/isp/isp.c                | 2221 +++++++++++++++++++++++++
>  drivers/media/video/isp/isp.h                |  427 +++++
>  drivers/media/video/isp/ispccdc.c            | 2280 ++++++++++++++++++++++++++
>  drivers/media/video/isp/ispccdc.h            |  223 +++
>  drivers/media/video/isp/ispccp2.c            | 1189 ++++++++++++++
>  drivers/media/video/isp/ispccp2.h            |  101 ++
>  drivers/media/video/isp/ispcsi2.c            | 1332 +++++++++++++++
>  drivers/media/video/isp/ispcsi2.h            |  169 ++
>  drivers/media/video/isp/ispcsiphy.c          |  247 +++
>  drivers/media/video/isp/ispcsiphy.h          |   74 +
>  drivers/media/video/isp/isph3a.h             |  117 ++
>  drivers/media/video/isp/isph3a_aewb.c        |  374 +++++
>  drivers/media/video/isp/isph3a_af.c          |  429 +++++
>  drivers/media/video/isp/isphist.c            |  520 ++++++
>  drivers/media/video/isp/isphist.h            |   40 +
>  drivers/media/video/isp/isppreview.c         | 2120 ++++++++++++++++++++++++
>  drivers/media/video/isp/isppreview.h         |  214 +++
>  drivers/media/video/isp/ispqueue.c           | 1136 +++++++++++++
>  drivers/media/video/isp/ispqueue.h           |  185 +++
>  drivers/media/video/isp/ispreg.h             | 1589 ++++++++++++++++++
>  drivers/media/video/isp/ispresizer.c         | 1710 +++++++++++++++++++
>  drivers/media/video/isp/ispresizer.h         |  150 ++
>  drivers/media/video/isp/ispstat.c            | 1100 +++++++++++++
>  drivers/media/video/isp/ispstat.h            |  169 ++
>  drivers/media/video/isp/ispvideo.c           | 1264 ++++++++++++++
>  drivers/media/video/isp/ispvideo.h           |  202 +++
>  drivers/media/video/isp/luma_enhance_table.h |  154 ++
>  drivers/media/video/isp/noise_filter_table.h |   90 +
>  include/linux/Kbuild                         |    1 +
>  include/linux/omap3isp.h                     |  631 +++++++
>  38 files changed, 21246 insertions(+), 28 deletions(-)
>  create mode 100644 arch/arm/mach-omap2/devices.h
>  create mode 100644 drivers/media/video/isp/Makefile
>  create mode 100644 drivers/media/video/isp/cfa_coef_table.h
>  create mode 100644 drivers/media/video/isp/gamma_table.h
>  create mode 100644 drivers/media/video/isp/isp.c
>  create mode 100644 drivers/media/video/isp/isp.h
>  create mode 100644 drivers/media/video/isp/ispccdc.c
>  create mode 100644 drivers/media/video/isp/ispccdc.h
>  create mode 100644 drivers/media/video/isp/ispccp2.c
>  create mode 100644 drivers/media/video/isp/ispccp2.h
>  create mode 100644 drivers/media/video/isp/ispcsi2.c
>  create mode 100644 drivers/media/video/isp/ispcsi2.h
>  create mode 100644 drivers/media/video/isp/ispcsiphy.c
>  create mode 100644 drivers/media/video/isp/ispcsiphy.h
>  create mode 100644 drivers/media/video/isp/isph3a.h
>  create mode 100644 drivers/media/video/isp/isph3a_aewb.c
>  create mode 100644 drivers/media/video/isp/isph3a_af.c
>  create mode 100644 drivers/media/video/isp/isphist.c
>  create mode 100644 drivers/media/video/isp/isphist.h
>  create mode 100644 drivers/media/video/isp/isppreview.c
>  create mode 100644 drivers/media/video/isp/isppreview.h
>  create mode 100644 drivers/media/video/isp/ispqueue.c
>  create mode 100644 drivers/media/video/isp/ispqueue.h
>  create mode 100644 drivers/media/video/isp/ispreg.h
>  create mode 100644 drivers/media/video/isp/ispresizer.c
>  create mode 100644 drivers/media/video/isp/ispresizer.h
>  create mode 100644 drivers/media/video/isp/ispstat.c
>  create mode 100644 drivers/media/video/isp/ispstat.h
>  create mode 100644 drivers/media/video/isp/ispvideo.c
>  create mode 100644 drivers/media/video/isp/ispvideo.h
>  create mode 100644 drivers/media/video/isp/luma_enhance_table.h
>  create mode 100644 drivers/media/video/isp/noise_filter_table.h
>  create mode 100644 include/linux/omap3isp.h
> 
> 

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
