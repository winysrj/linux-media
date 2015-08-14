Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:46937 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755411AbbHNO6b (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Aug 2015 10:58:31 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v4 0/6] MC preparation patches
Date: Fri, 14 Aug 2015 11:56:37 -0300
Message-Id: <cover.1439563682.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Those are the initial patches from my previous series of MC changes.

The first patch removes an unused parameter when creating links.

The next 5 patches warrant that all object types (entities, pads and
links) will have an unique ID, as agreed at the MC workshop.

They prepare for the addition of the media interfaces and interface
links.

Mauro Carvalho Chehab (6):
  media: get rid of unused "extra_links" param on media_entity_init()
  media: create a macro to get entity ID
  media: add a common struct to be embed on media graph objects
  media: use media_graph_obj inside entities
  media: use media_graph_obj inside pads
  media: use media_graph_obj inside links

 Documentation/media-framework.txt                  |  2 +-
 Documentation/video4linux/v4l2-framework.txt       |  4 +-
 Documentation/zh_CN/video4linux/v4l2-framework.txt |  4 +-
 drivers/media/dvb-core/dvbdev.c                    |  2 +-
 drivers/media/i2c/ad9389b.c                        |  2 +-
 drivers/media/i2c/adp1653.c                        |  2 +-
 drivers/media/i2c/adv7180.c                        |  2 +-
 drivers/media/i2c/adv7511.c                        |  2 +-
 drivers/media/i2c/adv7604.c                        |  2 +-
 drivers/media/i2c/adv7842.c                        |  2 +-
 drivers/media/i2c/as3645a.c                        |  2 +-
 drivers/media/i2c/cx25840/cx25840-core.c           |  2 +-
 drivers/media/i2c/lm3560.c                         |  2 +-
 drivers/media/i2c/lm3646.c                         |  2 +-
 drivers/media/i2c/m5mols/m5mols_core.c             |  2 +-
 drivers/media/i2c/mt9m032.c                        |  2 +-
 drivers/media/i2c/mt9p031.c                        |  2 +-
 drivers/media/i2c/mt9t001.c                        |  2 +-
 drivers/media/i2c/mt9v032.c                        |  2 +-
 drivers/media/i2c/noon010pc30.c                    |  2 +-
 drivers/media/i2c/ov2659.c                         |  2 +-
 drivers/media/i2c/ov9650.c                         |  2 +-
 drivers/media/i2c/s5c73m3/s5c73m3-core.c           |  4 +-
 drivers/media/i2c/s5k4ecgx.c                       |  2 +-
 drivers/media/i2c/s5k5baf.c                        |  4 +-
 drivers/media/i2c/s5k6a3.c                         |  2 +-
 drivers/media/i2c/s5k6aa.c                         |  2 +-
 drivers/media/i2c/smiapp/smiapp-core.c             |  4 +-
 drivers/media/i2c/tc358743.c                       |  2 +-
 drivers/media/i2c/tvp514x.c                        |  2 +-
 drivers/media/i2c/tvp7002.c                        |  2 +-
 drivers/media/media-device.c                       | 29 +++++++----
 drivers/media/media-entity.c                       | 58 +++++++++++++++++++---
 drivers/media/platform/exynos4-is/fimc-capture.c   |  4 +-
 drivers/media/platform/exynos4-is/fimc-isp-video.c |  2 +-
 drivers/media/platform/exynos4-is/fimc-isp.c       |  2 +-
 drivers/media/platform/exynos4-is/fimc-lite.c      |  4 +-
 drivers/media/platform/exynos4-is/fimc-m2m.c       |  2 +-
 drivers/media/platform/exynos4-is/mipi-csis.c      |  2 +-
 drivers/media/platform/omap3isp/ispccdc.c          |  2 +-
 drivers/media/platform/omap3isp/ispccp2.c          |  2 +-
 drivers/media/platform/omap3isp/ispcsi2.c          |  2 +-
 drivers/media/platform/omap3isp/isppreview.c       |  2 +-
 drivers/media/platform/omap3isp/ispresizer.c       |  2 +-
 drivers/media/platform/omap3isp/ispstat.c          |  2 +-
 drivers/media/platform/omap3isp/ispvideo.c         |  2 +-
 drivers/media/platform/s3c-camif/camif-capture.c   |  4 +-
 drivers/media/platform/vsp1/vsp1_entity.c          |  2 +-
 drivers/media/platform/vsp1/vsp1_video.c           |  6 +--
 drivers/media/platform/xilinx/xilinx-dma.c         |  2 +-
 drivers/media/platform/xilinx/xilinx-tpg.c         |  2 +-
 drivers/media/usb/cx231xx/cx231xx-video.c          |  4 +-
 drivers/media/usb/uvc/uvc_entity.c                 |  4 +-
 drivers/media/v4l2-core/tuner-core.c               |  2 +-
 drivers/media/v4l2-core/v4l2-flash-led-class.c     |  2 +-
 drivers/staging/media/davinci_vpfe/dm365_ipipe.c   |  2 +-
 drivers/staging/media/davinci_vpfe/dm365_ipipeif.c |  2 +-
 drivers/staging/media/davinci_vpfe/dm365_isif.c    |  2 +-
 drivers/staging/media/davinci_vpfe/dm365_resizer.c |  6 +--
 drivers/staging/media/davinci_vpfe/vpfe_video.c    |  2 +-
 drivers/staging/media/omap4iss/iss_csi2.c          |  2 +-
 drivers/staging/media/omap4iss/iss_ipipe.c         |  2 +-
 drivers/staging/media/omap4iss/iss_ipipeif.c       |  2 +-
 drivers/staging/media/omap4iss/iss_resizer.c       |  2 +-
 drivers/staging/media/omap4iss/iss_video.c         |  2 +-
 include/media/media-device.h                       |  8 ++-
 include/media/media-entity.h                       | 48 ++++++++++++++++--
 67 files changed, 200 insertions(+), 97 deletions(-)

-- 
2.4.3

