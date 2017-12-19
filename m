Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:58660 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751462AbdLSLSa (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Dec 2017 06:18:30 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v2 0/8] Some V4L2 documentation pending patches
Date: Tue, 19 Dec 2017 09:18:16 -0200
Message-Id: <cover.1513682135.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This series contain the patches of a /17 and a /24 series
of documentation that required non-trivial changes.

-

v2: 
 - added acks on patch 3/8
 - added a missing fixup on patch 5/8, for staging/media/imx
 - on patch 6/8, use pad=0 when WARN_ON() if pad is out of range

Mauro Carvalho Chehab (8):
  media: v4l2-device.h: document helper macros
  media: v4l2-ioctl.h: convert debug into an enum of bits
  media: v4l2-async: simplify v4l2_async_subdev structure
  media: v4l2-async: better describe match union at async match struct
  media: v4l2-mediabus: convert flags to enums and document them
  media: v4l2-subdev: get rid of __V4L2_SUBDEV_MK_GET_TRY() macro
  media: v4l2-subdev: document remaining undocumented functions
  media: v4l2-subdev: use kernel-doc markups to document subdev flags

 drivers/media/i2c/adv7180.c                        |  10 +-
 drivers/media/i2c/ml86v7667.c                      |   5 +-
 drivers/media/i2c/mt9m111.c                        |   8 +-
 drivers/media/i2c/ov6650.c                         |  19 +-
 drivers/media/i2c/soc_camera/imx074.c              |   6 +-
 drivers/media/i2c/soc_camera/mt9m001.c             |  10 +-
 drivers/media/i2c/soc_camera/mt9t031.c             |  11 +-
 drivers/media/i2c/soc_camera/mt9t112.c             |  11 +-
 drivers/media/i2c/soc_camera/mt9v022.c             |  16 +-
 drivers/media/i2c/soc_camera/ov5642.c              |   5 +-
 drivers/media/i2c/soc_camera/ov772x.c              |  10 +-
 drivers/media/i2c/soc_camera/ov9640.c              |  10 +-
 drivers/media/i2c/soc_camera/ov9740.c              |  10 +-
 drivers/media/i2c/soc_camera/rj54n1cb0c.c          |  12 +-
 drivers/media/i2c/soc_camera/tw9910.c              |  13 +-
 drivers/media/i2c/tc358743.c                       |  10 +-
 drivers/media/i2c/tvp5150.c                        |   6 +-
 drivers/media/platform/am437x/am437x-vpfe.c        |   6 +-
 drivers/media/platform/atmel/atmel-isc.c           |   2 +-
 drivers/media/platform/atmel/atmel-isi.c           |   2 +-
 drivers/media/platform/davinci/vpif_capture.c      |   4 +-
 drivers/media/platform/exynos4-is/media-dev.c      |   4 +-
 drivers/media/platform/pxa_camera.c                |  10 +-
 drivers/media/platform/qcom/camss-8x16/camss.c     |   2 +-
 drivers/media/platform/rcar-vin/rcar-core.c        |   6 +-
 drivers/media/platform/rcar-vin/rcar-dma.c         |   4 +-
 drivers/media/platform/rcar_drif.c                 |   4 +-
 .../platform/soc_camera/sh_mobile_ceu_camera.c     |   2 +-
 drivers/media/platform/soc_camera/soc_camera.c     |   5 +-
 .../platform/soc_camera/soc_camera_platform.c      |   2 +-
 drivers/media/platform/soc_camera/soc_mediabus.c   |   2 +-
 drivers/media/platform/stm32/stm32-dcmi.c          |   2 +-
 drivers/media/platform/ti-vpe/cal.c                |   2 +-
 drivers/media/platform/xilinx/xilinx-vipp.c        |   2 +-
 drivers/media/v4l2-core/v4l2-async.c               |  16 +-
 drivers/media/v4l2-core/v4l2-dev.c                 |  18 +-
 drivers/media/v4l2-core/v4l2-fwnode.c              |  15 +-
 drivers/media/v4l2-core/v4l2-ioctl.c               |   7 +-
 drivers/staging/media/imx/imx-media-csi.c          |   7 +-
 drivers/staging/media/imx/imx-media-dev.c          |   4 +-
 include/media/v4l2-async.h                         |  33 ++-
 include/media/v4l2-device.h                        | 246 ++++++++++++++++++---
 include/media/v4l2-fwnode.h                        |   4 +-
 include/media/v4l2-ioctl.h                         |  33 +--
 include/media/v4l2-mediabus.h                      | 145 ++++++++----
 include/media/v4l2-subdev.h                        | 143 +++++++++---
 46 files changed, 636 insertions(+), 268 deletions(-)

-- 
2.14.3
