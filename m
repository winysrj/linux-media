Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:36555 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447AbbEHBMt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 May 2015 21:12:49 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 00/18] Remove media controller entity subtypes and rename types
Date: Thu,  7 May 2015 22:12:22 -0300
Message-Id: <cover.1431046915.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The media controller entity subtype doesn't make much sense,
especially since V4L2 subdevices may also have associated devnodes.

So, better to get rid of it while it is not too late.

Also, the entities namespace is a bit messy, putting tuners under V4L2,
while this kind of entity could also be used by radio and digital TV.

This patchset addresses the entities namespace and gets rid of
entity subtypes.

We need, of course, to keep the old symbols to avoid userspace breakage.

Inside the Kernel, however, the previous subtype defines should not be
used.

The first patches in this series are just namespace renames, and were
done mostly using scripts. So, they shouln't cause much discussons,
except if someone doesn't like the new names I gave :)

Mauro Carvalho Chehab (8):
  media controller: add EXPERIMENTAL to Kconfig option for DVB support
  media controller: deprecate entity subtype
  media controller: use MEDIA_ENT_T_AV_DMA for A/V DMA engines
  media controller: Rename camera entities
  media controller: rename MEDIA_ENT_T_DEVNODE_DVB entities
  media controller: rename analog TV decoder
  media controller: rename the tuner entity
  media controller: add comments for the entity types

The next 9 patches, however, remove the entities subtype dependency
from the drivers and core. They were highly done using cut and paste.
I did several reviews on them, but I won't doubt that some dumb error
were introduced. So, please review them carefully.

The last one is just documentation cleanups.

Mauro Carvalho Chehab (10):
  media controller: add macros to check if subdev or A/V DMA
  media controller: use macros to check for V4L2 subdev entities
  omap3/omap4/davinci: get rid of MEDIA_ENT_T_V4L2_SUBDEV abuse
  s5c73m3: fix subdev type
  s5k5baf: fix subdev type
  davinci_vbpe: stop MEDIA_ENT_T_V4L2_SUBDEV abuse
  omap4iss: stop MEDIA_ENT_T_V4L2_SUBDEV abuse
  v4l2-subdev: use MEDIA_ENT_T_UNKNOWN for new subdevs
  media controller: get rid of entity subtype on Kernel
  DocBook: update descriptions for the media controller entities

 .../DocBook/media/v4l/media-ioc-enum-entities.xml  | 57 +++++++----------
 drivers/media/Kconfig                              |  2 +-
 drivers/media/dvb-core/dvbdev.c                    | 20 +++---
 drivers/media/i2c/adp1653.c                        |  2 +-
 drivers/media/i2c/adv7180.c                        |  2 +-
 drivers/media/i2c/as3645a.c                        |  2 +-
 drivers/media/i2c/cx25840/cx25840-core.c           |  2 +-
 drivers/media/i2c/lm3560.c                         |  2 +-
 drivers/media/i2c/lm3646.c                         |  2 +-
 drivers/media/i2c/m5mols/m5mols_core.c             |  2 +-
 drivers/media/i2c/noon010pc30.c                    |  2 +-
 drivers/media/i2c/ov2659.c                         |  2 +-
 drivers/media/i2c/ov9650.c                         |  2 +-
 drivers/media/i2c/s5c73m3/s5c73m3-core.c           |  4 +-
 drivers/media/i2c/s5k4ecgx.c                       |  2 +-
 drivers/media/i2c/s5k5baf.c                        |  6 +-
 drivers/media/i2c/s5k6aa.c                         |  2 +-
 drivers/media/i2c/smiapp/smiapp-core.c             |  2 +-
 drivers/media/i2c/tvp514x.c                        |  2 +-
 drivers/media/i2c/tvp7002.c                        |  2 +-
 drivers/media/platform/exynos4-is/common.c         |  3 +-
 drivers/media/platform/exynos4-is/fimc-capture.c   |  5 +-
 drivers/media/platform/exynos4-is/fimc-isp-video.c |  3 +-
 drivers/media/platform/exynos4-is/fimc-lite.c      | 10 ++-
 drivers/media/platform/exynos4-is/media-dev.c      |  7 +--
 drivers/media/platform/omap3isp/isp.c              | 14 ++---
 drivers/media/platform/omap3isp/ispccdc.c          | 15 +++--
 drivers/media/platform/omap3isp/ispccp2.c          | 13 ++--
 drivers/media/platform/omap3isp/ispcsi2.c          | 10 ++-
 drivers/media/platform/omap3isp/isppreview.c       | 15 +++--
 drivers/media/platform/omap3isp/ispresizer.c       | 13 ++--
 drivers/media/platform/omap3isp/ispvideo.c         |  7 +--
 drivers/media/platform/s3c-camif/camif-capture.c   |  2 +-
 drivers/media/platform/vsp1/vsp1_video.c           |  9 ++-
 drivers/media/platform/xilinx/xilinx-dma.c         |  8 +--
 drivers/media/usb/cx231xx/cx231xx-cards.c          |  4 +-
 drivers/media/usb/cx231xx/cx231xx-video.c          |  2 +-
 drivers/media/v4l2-core/tuner-core.c               |  2 +-
 drivers/media/v4l2-core/v4l2-dev.c                 |  2 +-
 drivers/media/v4l2-core/v4l2-subdev.c              |  6 +-
 drivers/staging/media/davinci_vpfe/dm365_ipipe.c   |  9 ++-
 drivers/staging/media/davinci_vpfe/dm365_ipipeif.c | 13 ++--
 drivers/staging/media/davinci_vpfe/dm365_isif.c    | 13 ++--
 drivers/staging/media/davinci_vpfe/dm365_resizer.c | 22 ++++---
 drivers/staging/media/davinci_vpfe/vpfe_video.c    | 11 ++--
 drivers/staging/media/omap4iss/iss.c               | 14 ++---
 drivers/staging/media/omap4iss/iss_csi2.c          | 11 +++-
 drivers/staging/media/omap4iss/iss_ipipe.c         |  7 ++-
 drivers/staging/media/omap4iss/iss_ipipeif.c       | 13 ++--
 drivers/staging/media/omap4iss/iss_resizer.c       | 11 +++-
 drivers/staging/media/omap4iss/iss_video.c         |  5 +-
 include/media/media-entity.h                       | 27 ++++++--
 include/uapi/linux/media.h                         | 71 +++++++++++++++++-----
 53 files changed, 294 insertions(+), 202 deletions(-)

-- 
2.1.0

