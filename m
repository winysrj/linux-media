Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51750 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496AbbLKNe3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Dec 2015 08:34:29 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 00/10] Some cleanups after the Media Controller Next gen
Date: Fri, 11 Dec 2015 11:34:05 -0200
Message-Id: <cover.1449840443.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This series address the comments from Laurent to this patch:
	[PATCH v8.4 24/83] [media] media: convert links from array to list

Most of the patches here are trivial. The most relevant one is the patch
that updates the media framework documentation,  moving it from a
pure text file into the device-drivers.xml DocBook and updating the documentation
to reflect the MC next generation changes.

Mauro Carvalho Chehab (10):
  media-device: put headers in alphabetic order
  media-device: better name Kernelspace/Userspace links
  media framework: rename pads init function to media_entity_pads_init()
  media-entity.h: get rid of revision and group_id fields
  DocBook: Move media-framework.txt contend to media-device.h
  media-entity.h: convert media_entity_cleanup to inline
  media-device.h: Improve documentation and update it
  media-entity.c: remove two extra blank lines
  media-entity: get rid of forward __media_entity_remove_link()
    declaration
  media_entity: get rid of an unused var

 Documentation/DocBook/device-drivers.tmpl          |   1 +
 .../DocBook/media/v4l/media-ioc-enum-entities.xml  |  13 +-
 Documentation/media-framework.txt                  | 371 ---------------------
 Documentation/video4linux/v4l2-framework.txt       |   8 +-
 Documentation/zh_CN/video4linux/v4l2-framework.txt |   8 +-
 drivers/media/dvb-core/dvbdev.c                    |   4 +-
 drivers/media/dvb-frontends/au8522_decoder.c       |   2 +-
 drivers/media/i2c/ad9389b.c                        |   2 +-
 drivers/media/i2c/adp1653.c                        |   2 +-
 drivers/media/i2c/adv7180.c                        |   2 +-
 drivers/media/i2c/adv7511.c                        |   2 +-
 drivers/media/i2c/adv7604.c                        |   2 +-
 drivers/media/i2c/adv7842.c                        |   2 +-
 drivers/media/i2c/as3645a.c                        |   2 +-
 drivers/media/i2c/cx25840/cx25840-core.c           |   2 +-
 drivers/media/i2c/lm3560.c                         |   2 +-
 drivers/media/i2c/lm3646.c                         |   2 +-
 drivers/media/i2c/m5mols/m5mols_core.c             |   2 +-
 drivers/media/i2c/mt9m032.c                        |   2 +-
 drivers/media/i2c/mt9p031.c                        |   2 +-
 drivers/media/i2c/mt9t001.c                        |   2 +-
 drivers/media/i2c/mt9v032.c                        |   2 +-
 drivers/media/i2c/noon010pc30.c                    |   2 +-
 drivers/media/i2c/ov2659.c                         |   2 +-
 drivers/media/i2c/ov9650.c                         |   2 +-
 drivers/media/i2c/s5c73m3/s5c73m3-core.c           |   4 +-
 drivers/media/i2c/s5k4ecgx.c                       |   2 +-
 drivers/media/i2c/s5k5baf.c                        |   4 +-
 drivers/media/i2c/s5k6a3.c                         |   2 +-
 drivers/media/i2c/s5k6aa.c                         |   2 +-
 drivers/media/i2c/smiapp/smiapp-core.c             |   6 +-
 drivers/media/i2c/tc358743.c                       |   2 +-
 drivers/media/i2c/tvp514x.c                        |   2 +-
 drivers/media/i2c/tvp7002.c                        |   2 +-
 drivers/media/media-device.c                       |  35 +-
 drivers/media/media-entity.c                       |  84 ++---
 drivers/media/platform/exynos4-is/fimc-capture.c   |   4 +-
 drivers/media/platform/exynos4-is/fimc-isp-video.c |   2 +-
 drivers/media/platform/exynos4-is/fimc-isp.c       |   2 +-
 drivers/media/platform/exynos4-is/fimc-lite.c      |   4 +-
 drivers/media/platform/exynos4-is/fimc-m2m.c       |   2 +-
 drivers/media/platform/exynos4-is/mipi-csis.c      |   2 +-
 drivers/media/platform/omap3isp/ispccdc.c          |   2 +-
 drivers/media/platform/omap3isp/ispccp2.c          |   2 +-
 drivers/media/platform/omap3isp/ispcsi2.c          |   2 +-
 drivers/media/platform/omap3isp/isppreview.c       |   2 +-
 drivers/media/platform/omap3isp/ispresizer.c       |   2 +-
 drivers/media/platform/omap3isp/ispstat.c          |   2 +-
 drivers/media/platform/omap3isp/ispvideo.c         |   2 +-
 drivers/media/platform/s3c-camif/camif-capture.c   |   4 +-
 drivers/media/platform/vsp1/vsp1_entity.c          |   2 +-
 drivers/media/platform/vsp1/vsp1_video.c           |   2 +-
 drivers/media/platform/xilinx/xilinx-dma.c         |   2 +-
 drivers/media/platform/xilinx/xilinx-tpg.c         |   2 +-
 drivers/media/usb/au0828/au0828-video.c            |   6 +-
 drivers/media/usb/cx231xx/cx231xx-video.c          |   4 +-
 drivers/media/usb/uvc/uvc_entity.c                 |   4 +-
 drivers/media/v4l2-core/tuner-core.c               |   2 +-
 drivers/media/v4l2-core/v4l2-flash-led-class.c     |   2 +-
 drivers/staging/media/davinci_vpfe/dm365_ipipe.c   |   2 +-
 drivers/staging/media/davinci_vpfe/dm365_ipipeif.c |   2 +-
 drivers/staging/media/davinci_vpfe/dm365_isif.c    |   2 +-
 drivers/staging/media/davinci_vpfe/dm365_resizer.c |   6 +-
 drivers/staging/media/davinci_vpfe/vpfe_video.c    |   2 +-
 drivers/staging/media/omap4iss/iss_csi2.c          |   2 +-
 drivers/staging/media/omap4iss/iss_ipipe.c         |   2 +-
 drivers/staging/media/omap4iss/iss_ipipeif.c       |   2 +-
 drivers/staging/media/omap4iss/iss_resizer.c       |   2 +-
 drivers/staging/media/omap4iss/iss_video.c         |   2 +-
 include/media/media-device.h                       | 331 ++++++++++++++++++
 include/media/media-entity.h                       | 157 ++++++++-
 71 files changed, 621 insertions(+), 539 deletions(-)
 delete mode 100644 Documentation/media-framework.txt

-- 
2.5.0


