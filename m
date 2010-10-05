Return-path: <mchehab@pedra>
Received: from perceval.irobotique.be ([92.243.18.41]:60203 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059Ab0JENSn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Oct 2010 09:18:43 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com
Subject: [RFC/PATCH v2 0/6] OMAP3 ISP driver
Date: Tue,  5 Oct 2010 15:18:49 +0200
Message-Id: <1286284734-12292-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi everybody,

Here's the second version of the OMAP3 ISP driver, rebased on top of the latest
media controller and sub-device API patches.

As with the previous version, the V4L/DVB patches come from the upstream
staging/v2.6.37 branch and won't be needed anymore when the driver will be
rebased on top of 2.6.36.

Patch 6/6 (the driver itself) is too big for vger, even in compressed form.
You can find it at
http://git.linuxtv.org/pinchartl/media.git?h=refs/heads/media-0004-omap3isp
(sorry for the inconvenience). I'll try splitting up the patch in the next
version for easier review.

Laurent Pinchart (4):
  v4l: subdev: Generic ioctl support
  V4L/DVB: v4l: Use v4l2_get_subdevdata instead of accessing
    v4l2_subdev::priv
  V4L/DVB: v4l: Add a v4l2_subdev host private data field
  OMAP3 ISP driver

Stanimir Varbanov (1):
  omap3: Export omap3isp platform device structure

Tuukka Toivonen (1):
  ARM: OMAP3: Update Camera ISP definitions for OMAP3630

 Documentation/video4linux/v4l2-framework.txt |   10 +
 arch/arm/mach-omap2/devices.c                |   46 +-
 arch/arm/mach-omap2/devices.h                |   17 +
 arch/arm/plat-omap/include/mach/isp_user.h   |  644 ++++++++
 arch/arm/plat-omap/include/plat/omap34xx.h   |   16 +-
 drivers/media/video/Kconfig                  |   15 +
 drivers/media/video/Makefile                 |    2 +
 drivers/media/video/isp/Makefile             |   13 +
 drivers/media/video/isp/bluegamma_table.h    | 1050 ++++++++++++
 drivers/media/video/isp/cfa_coef_table.h     |  601 +++++++
 drivers/media/video/isp/greengamma_table.h   | 1050 ++++++++++++
 drivers/media/video/isp/isp.c                | 1867 +++++++++++++++++++++
 drivers/media/video/isp/isp.h                |  399 +++++
 drivers/media/video/isp/ispccdc.c            | 2295 ++++++++++++++++++++++++++
 drivers/media/video/isp/ispccdc.h            |  194 +++
 drivers/media/video/isp/ispccp2.c            | 1115 +++++++++++++
 drivers/media/video/isp/ispccp2.h            |   97 ++
 drivers/media/video/isp/ispcsi2.c            | 1217 ++++++++++++++
 drivers/media/video/isp/ispcsi2.h            |  162 ++
 drivers/media/video/isp/ispcsiphy.c          |  246 +++
 drivers/media/video/isp/ispcsiphy.h          |   77 +
 drivers/media/video/isp/isph3a.h             |  116 ++
 drivers/media/video/isp/isph3a_aewb.c        |  354 ++++
 drivers/media/video/isp/isph3a_af.c          |  401 +++++
 drivers/media/video/isp/isphist.c            |  509 ++++++
 drivers/media/video/isp/isphist.h            |   39 +
 drivers/media/video/isp/isppreview.c         | 2293 +++++++++++++++++++++++++
 drivers/media/video/isp/isppreview.h         |  262 +++
 drivers/media/video/isp/ispqueue.c           | 1103 +++++++++++++
 drivers/media/video/isp/ispqueue.h           |  183 ++
 drivers/media/video/isp/ispreg.h             | 1652 ++++++++++++++++++
 drivers/media/video/isp/ispresizer.c         | 1729 +++++++++++++++++++
 drivers/media/video/isp/ispresizer.h         |  142 ++
 drivers/media/video/isp/ispstat.c            | 1039 ++++++++++++
 drivers/media/video/isp/ispstat.h            |  165 ++
 drivers/media/video/isp/ispvideo.c           | 1164 +++++++++++++
 drivers/media/video/isp/ispvideo.h           |  168 ++
 drivers/media/video/isp/luma_enhance_table.h |  154 ++
 drivers/media/video/isp/noise_filter_table.h |   90 +
 drivers/media/video/isp/redgamma_table.h     | 1050 ++++++++++++
 drivers/media/video/mt9m001.c                |   26 +-
 drivers/media/video/mt9m111.c                |   20 +-
 drivers/media/video/mt9t031.c                |   24 +-
 drivers/media/video/mt9t112.c                |   14 +-
 drivers/media/video/mt9v022.c                |   26 +-
 drivers/media/video/ov772x.c                 |   18 +-
 drivers/media/video/ov9640.c                 |   12 +-
 drivers/media/video/rj54n1cb0c.c             |   26 +-
 drivers/media/video/soc_camera.c             |    2 +-
 drivers/media/video/tw9910.c                 |   20 +-
 drivers/media/video/v4l2-subdev.c            |    5 +-
 include/media/v4l2-subdev.h                  |   17 +-
 52 files changed, 23847 insertions(+), 109 deletions(-)
 create mode 100644 arch/arm/mach-omap2/devices.h
 create mode 100644 arch/arm/plat-omap/include/mach/isp_user.h
 create mode 100644 drivers/media/video/isp/Makefile
 create mode 100644 drivers/media/video/isp/bluegamma_table.h
 create mode 100644 drivers/media/video/isp/cfa_coef_table.h
 create mode 100644 drivers/media/video/isp/greengamma_table.h
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
 create mode 100644 drivers/media/video/isp/redgamma_table.h

-- 
Regards,

Laurent Pinchart

