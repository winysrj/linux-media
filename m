Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:46854 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932087Ab0GUOmC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Jul 2010 10:42:02 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com
Subject: [SAMPLE v2 00/12] Further V4L2 API additions and OMAP3 ISP driver
Date: Wed, 21 Jul 2010 16:41:47 +0200
Message-Id: <1279723318-28943-1-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1279722935-28493-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1279722935-28493-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everybody,

Here's the OMAP3 ISP driver along with V4L2 API additions/enhancements that
it depends on, rebased on the media controller v2 patches. Once again please
don't review this set, but use it as sample code for the media controller.

Antti Koskipaa (1):
  v4l: Add crop ioctl to V4L2 subdev API

Laurent Pinchart (8):
  v4l: Move the media/v4l2-mediabus.h header to include/linux
  v4l: Add 16 bit YUYV and SGRBG10 media bus format codes
  v4l-subdev: Add pads operations
  v4l: v4l2_subdev userspace format API
  v4l: Add subdev userspace API to enumerate and configure frame
    interval
  v4l: subdev: Generic ioctl support
  omap34xxcam: Register the ISP platform device during omap34xxcam
    probe
  OMAP3 ISP driver

Stanimir Varbanov (2):
  v4l: Create v4l2 subdev file handle structure
  omap3: Export omap3isp platform device structure

Tuukka Toivonen (1):
  ARM: OMAP3: Update Camera ISP definitions for OMAP3630

 Documentation/video4linux/v4l2-framework.txt |    5 +
 arch/arm/mach-omap2/devices.c                |   46 +-
 arch/arm/mach-omap2/devices.h                |   17 +
 arch/arm/plat-omap/include/mach/isp_user.h   |  637 ++++++++
 arch/arm/plat-omap/include/plat/omap34xx.h   |   16 +-
 drivers/media/video/Kconfig                  |    9 +
 drivers/media/video/Makefile                 |    4 +
 drivers/media/video/isp/Makefile             |   14 +
 drivers/media/video/isp/bluegamma_table.h    | 1040 ++++++++++++
 drivers/media/video/isp/cfa_coef_table.h     |  603 +++++++
 drivers/media/video/isp/greengamma_table.h   | 1040 ++++++++++++
 drivers/media/video/isp/isp.c                | 1686 +++++++++++++++++++
 drivers/media/video/isp/isp.h                |  402 +++++
 drivers/media/video/isp/ispccdc.c            | 2042 +++++++++++++++++++++++
 drivers/media/video/isp/ispccdc.h            |  177 ++
 drivers/media/video/isp/ispccp2.c            | 1035 ++++++++++++
 drivers/media/video/isp/ispccp2.h            |   89 +
 drivers/media/video/isp/ispcsi2.c            | 1214 ++++++++++++++
 drivers/media/video/isp/ispcsi2.h            |  158 ++
 drivers/media/video/isp/ispcsiphy.c          |  245 +++
 drivers/media/video/isp/ispcsiphy.h          |   72 +
 drivers/media/video/isp/isph3a.h             |  111 ++
 drivers/media/video/isp/isph3a_aewb.c        |  307 ++++
 drivers/media/video/isp/isph3a_af.c          |  358 ++++
 drivers/media/video/isp/isphist.c            |  505 ++++++
 drivers/media/video/isp/isphist.h            |   34 +
 drivers/media/video/isp/isppreview.c         | 2263 ++++++++++++++++++++++++++
 drivers/media/video/isp/isppreview.h         |  259 +++
 drivers/media/video/isp/ispqueue.c           | 1074 ++++++++++++
 drivers/media/video/isp/ispqueue.h           |  175 ++
 drivers/media/video/isp/ispreg.h             | 1802 ++++++++++++++++++++
 drivers/media/video/isp/ispresizer.c         | 1637 +++++++++++++++++++
 drivers/media/video/isp/ispresizer.h         |  136 ++
 drivers/media/video/isp/ispstat.c            |  965 +++++++++++
 drivers/media/video/isp/ispstat.h            |  161 ++
 drivers/media/video/isp/ispvideo.c           | 1241 ++++++++++++++
 drivers/media/video/isp/ispvideo.h           |  139 ++
 drivers/media/video/isp/luma_enhance_table.h |  144 ++
 drivers/media/video/isp/noise_filter_table.h |   79 +
 drivers/media/video/isp/redgamma_table.h     | 1040 ++++++++++++
 drivers/media/video/omap34xxcam.c            | 1562 ++++++++++++++++++
 drivers/media/video/omap34xxcam.h            |  137 ++
 drivers/media/video/v4l2-subdev.c            |  177 ++-
 include/linux/v4l2-mediabus.h                |   70 +
 include/linux/v4l2-subdev.h                  |  102 ++
 include/media/soc_mediabus.h                 |    3 +-
 include/media/v4l2-mediabus.h                |   48 +-
 include/media/v4l2-subdev.h                  |   53 +
 48 files changed, 25046 insertions(+), 87 deletions(-)
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
 create mode 100644 drivers/media/video/omap34xxcam.c
 create mode 100644 drivers/media/video/omap34xxcam.h
 create mode 100644 include/linux/v4l2-mediabus.h
 create mode 100644 include/linux/v4l2-subdev.h

-- 
Regards,

Laurent Pinchart

