Return-path: <mchehab@gaivota>
Received: from perceval.ideasonboard.com ([95.142.166.194]:51317 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757460Ab0LTLiD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Dec 2010 06:38:03 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com
Subject: [RFC/PATCH v4 0/7] OMAP3 ISP driver
Date: Mon, 20 Dec 2010 12:37:48 +0100
Message-Id: <1292845075-7991-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi everybody,

Here's the fourth version of the OMAP3 ISP driver patches, updated to
2.6.37-rc6 and the latest changes in the media controller and sub-device APIs.

You can find the patches in http://git.linuxtv.org/pinchartl/media.git as
usual (media-0004-omap3isp).

The "v4l: Fix a use-before-set in the control framework" and
"v4l: Add subdev sensor g_skip_frames operation" patches have been discussed
on the linux-media mailing list and acked.

The "v4l: subdev: Generic ioctl support" will be discussed separately on the
list in the near future.

Laurent Pinchart (6):
  v4l: subdev: Generic ioctl support
  v4l: Add subdev sensor g_skip_frames operation
  v4l: Include linux/videodev2.h in media/v4l2-ctrls.h
  v4l: Fix a use-before-set in the control framework
  omap3: Add function to register omap3isp platform device structure
  OMAP3 ISP driver

Tuukka Toivonen (1):
  ARM: OMAP3: Update Camera ISP definitions for OMAP3630

 Documentation/video4linux/v4l2-framework.txt |    5 +
 arch/arm/mach-omap2/devices.c                |   48 +-
 arch/arm/mach-omap2/devices.h                |   17 +
 arch/arm/plat-omap/include/plat/omap34xx.h   |   16 +-
 drivers/media/video/Kconfig                  |   13 +
 drivers/media/video/Makefile                 |    2 +
 drivers/media/video/isp/Makefile             |   13 +
 drivers/media/video/isp/cfa_coef_table.h     |  601 +++++++
 drivers/media/video/isp/gamma_table.h        |   90 +
 drivers/media/video/isp/isp.c                | 1980 +++++++++++++++++++++++
 drivers/media/video/isp/isp.h                |  407 +++++
 drivers/media/video/isp/ispccdc.c            | 2236 ++++++++++++++++++++++++++
 drivers/media/video/isp/ispccdc.h            |  221 +++
 drivers/media/video/isp/ispccp2.c            | 1110 +++++++++++++
 drivers/media/video/isp/ispccp2.h            |  101 ++
 drivers/media/video/isp/ispcsi2.c            | 1278 +++++++++++++++
 drivers/media/video/isp/ispcsi2.h            |  169 ++
 drivers/media/video/isp/ispcsiphy.c          |  247 +++
 drivers/media/video/isp/ispcsiphy.h          |   74 +
 drivers/media/video/isp/isph3a.h             |  117 ++
 drivers/media/video/isp/isph3a_aewb.c        |  356 ++++
 drivers/media/video/isp/isph3a_af.c          |  410 +++++
 drivers/media/video/isp/isphist.c            |  505 ++++++
 drivers/media/video/isp/isphist.h            |   40 +
 drivers/media/video/isp/isppreview.c         | 2112 ++++++++++++++++++++++++
 drivers/media/video/isp/isppreview.h         |  214 +++
 drivers/media/video/isp/ispqueue.c           | 1135 +++++++++++++
 drivers/media/video/isp/ispqueue.h           |  184 +++
 drivers/media/video/isp/ispreg.h             | 1655 +++++++++++++++++++
 drivers/media/video/isp/ispresizer.c         | 1721 ++++++++++++++++++++
 drivers/media/video/isp/ispresizer.h         |  149 ++
 drivers/media/video/isp/ispstat.c            | 1093 +++++++++++++
 drivers/media/video/isp/ispstat.h            |  168 ++
 drivers/media/video/isp/ispvideo.c           | 1200 ++++++++++++++
 drivers/media/video/isp/ispvideo.h           |  183 +++
 drivers/media/video/isp/luma_enhance_table.h |  154 ++
 drivers/media/video/isp/noise_filter_table.h |   90 +
 drivers/media/video/v4l2-ctrls.c             |    2 +-
 drivers/media/video/v4l2-subdev.c            |    2 +-
 include/linux/Kbuild                         |    1 +
 include/linux/omap3isp.h                     |  631 ++++++++
 include/media/v4l2-ctrls.h                   |    1 +
 include/media/v4l2-subdev.h                  |    4 +
 43 files changed, 20736 insertions(+), 19 deletions(-)
 create mode 100644 arch/arm/mach-omap2/devices.h
 create mode 100644 drivers/media/video/isp/Makefile
 create mode 100644 drivers/media/video/isp/cfa_coef_table.h
 create mode 100644 drivers/media/video/isp/gamma_table.h
 create mode 100644 drivers/media/video/isp/isp.c
 create mode 100644 drivers/media/video/isp/isp.h
 create mode 100644 drivers/media/video/isp/ispccdc.c
 create mode 100644 drivers/media/video/isp/ispccdc.h
 create mode 100644 drivers/media/video/isp/ispccp2.c
 create mode 100644 drivers/media/video/isp/ispccp2.h
 create mode 100644 drivers/media/video/isp/ispcsi2.c
 create mode 100644 drivers/media/video/isp/ispcsi2.h
 create mode 100644 drivers/media/video/isp/ispcsiphy.c
 create mode 100644 drivers/media/video/isp/ispcsiphy.h
 create mode 100644 drivers/media/video/isp/isph3a.h
 create mode 100644 drivers/media/video/isp/isph3a_aewb.c
 create mode 100644 drivers/media/video/isp/isph3a_af.c
 create mode 100644 drivers/media/video/isp/isphist.c
 create mode 100644 drivers/media/video/isp/isphist.h
 create mode 100644 drivers/media/video/isp/isppreview.c
 create mode 100644 drivers/media/video/isp/isppreview.h
 create mode 100644 drivers/media/video/isp/ispqueue.c
 create mode 100644 drivers/media/video/isp/ispqueue.h
 create mode 100644 drivers/media/video/isp/ispreg.h
 create mode 100644 drivers/media/video/isp/ispresizer.c
 create mode 100644 drivers/media/video/isp/ispresizer.h
 create mode 100644 drivers/media/video/isp/ispstat.c
 create mode 100644 drivers/media/video/isp/ispstat.h
 create mode 100644 drivers/media/video/isp/ispvideo.c
 create mode 100644 drivers/media/video/isp/ispvideo.h
 create mode 100644 drivers/media/video/isp/luma_enhance_table.h
 create mode 100644 drivers/media/video/isp/noise_filter_table.h
 create mode 100644 include/linux/omap3isp.h

-- 
Regards,

Laurent Pinchart

