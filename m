Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:47345 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753812Ab1A0McX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Jan 2011 07:32:23 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org, linux-omap@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com
Subject: [PATCH v5 0/5] OMAP3 ISP driver
Date: Thu, 27 Jan 2011 13:32:16 +0100
Message-Id: <1296131541-30092-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi everybody,

Here's the fifth version of the OMAP3 ISP driver patches, updated to
2.6.37 and the latest changes in the media controller and sub-device APIs.

You can find the patches in http://git.linuxtv.org/pinchartl/media.git as
usual (media-0005-omap3isp).

Laurent Pinchart (2):
  omap3: Add function to register omap3isp platform device structure
  OMAP3 ISP driver

Sergio Aguirre (2):
  omap3: Remove unusued ISP CBUFF resource
  omap2: Fix camera resources for multiomap

Tuukka Toivonen (1):
  ARM: OMAP3: Update Camera ISP definitions for OMAP3630

 arch/arm/mach-omap2/devices.c                |   64 +-
 arch/arm/mach-omap2/devices.h                |   17 +
 arch/arm/plat-omap/include/plat/omap34xx.h   |   16 +-
 drivers/media/video/Kconfig                  |   13 +
 drivers/media/video/Makefile                 |    2 +
 drivers/media/video/isp/Makefile             |   13 +
 drivers/media/video/isp/cfa_coef_table.h     |  601 +++++++
 drivers/media/video/isp/gamma_table.h        |   90 +
 drivers/media/video/isp/isp.c                | 2221 +++++++++++++++++++++++++
 drivers/media/video/isp/isp.h                |  427 +++++
 drivers/media/video/isp/ispccdc.c            | 2280 ++++++++++++++++++++++++++
 drivers/media/video/isp/ispccdc.h            |  223 +++
 drivers/media/video/isp/ispccp2.c            | 1189 ++++++++++++++
 drivers/media/video/isp/ispccp2.h            |  101 ++
 drivers/media/video/isp/ispcsi2.c            | 1332 +++++++++++++++
 drivers/media/video/isp/ispcsi2.h            |  169 ++
 drivers/media/video/isp/ispcsiphy.c          |  247 +++
 drivers/media/video/isp/ispcsiphy.h          |   74 +
 drivers/media/video/isp/isph3a.h             |  117 ++
 drivers/media/video/isp/isph3a_aewb.c        |  374 +++++
 drivers/media/video/isp/isph3a_af.c          |  429 +++++
 drivers/media/video/isp/isphist.c            |  520 ++++++
 drivers/media/video/isp/isphist.h            |   40 +
 drivers/media/video/isp/isppreview.c         | 2120 ++++++++++++++++++++++++
 drivers/media/video/isp/isppreview.h         |  214 +++
 drivers/media/video/isp/ispqueue.c           | 1136 +++++++++++++
 drivers/media/video/isp/ispqueue.h           |  185 +++
 drivers/media/video/isp/ispreg.h             | 1589 ++++++++++++++++++
 drivers/media/video/isp/ispresizer.c         | 1710 +++++++++++++++++++
 drivers/media/video/isp/ispresizer.h         |  150 ++
 drivers/media/video/isp/ispstat.c            | 1100 +++++++++++++
 drivers/media/video/isp/ispstat.h            |  169 ++
 drivers/media/video/isp/ispvideo.c           | 1264 ++++++++++++++
 drivers/media/video/isp/ispvideo.h           |  202 +++
 drivers/media/video/isp/luma_enhance_table.h |  154 ++
 drivers/media/video/isp/noise_filter_table.h |   90 +
 include/linux/Kbuild                         |    1 +
 include/linux/omap3isp.h                     |  631 +++++++
 38 files changed, 21246 insertions(+), 28 deletions(-)
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

