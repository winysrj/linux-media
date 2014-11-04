Return-path: <linux-media-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:60792 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752697AbaKDJzP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Nov 2014 04:55:15 -0500
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-api@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [PATCH 00/15] [media] Make mediabus format subsystem neutral
Date: Tue,  4 Nov 2014 10:54:55 +0100
Message-Id: <1415094910-15899-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

This patch series prepares the use of media bus formats outside of
the V4L2 subsytem (my final goal is to use it in the Atmel HLCDC DRM
driver where I have to configure my DPI/RGB bus according to the
connected display).

The series first defines a new enum with a neutral name (media_bus_format),
and then replace all references to the old enum and its values within the
kernel.

It also deprecates the v4l2_mbus_pixelcode enum and the v4l2-mediabus.h
header. Kernel users can't use the v4l2_mbus_pixelcode enum anymore and new
user-space users are encouraged to move to the media_bus_format enum
and include v4l2-mbus.h.

Hans, I'm not sure this is exactly what you had in mind for
v4l2_mbus_pixelcode deprecation. If you agree with this approach, and think
it is worth it, I can reorder the series and squash the last 4 patches into
previous ones (patches 4, 9, 6 and 8)

Best Regards,

Boris

Boris Brezillon (15):
  [media] Move mediabus format definition to a more standard place
  [media] v4l: Update subdev-formats doc with new MEDIA_BUS_FMT values
  [media] Make use of the new media_bus_format definitions
  [media] i2c: Make use of media_bus_format enum
  [media] pci: Make use of media_bus_format enum
  [media] platform: Make use of media_bus_format enum
  [media] usb: Make use of media_bus_format enum
  staging: media: Make use of media_bus_format enum
  gpu: ipu-v3: Make use of media_bus_format enum
  [media] v4l: Forbid usage of V4L2_MBUS_FMT definitions inside the
    kernel
  [media] Deprecate v4l2_mbus_pixelcode
  [media] i2c: Replace v4l2-mediabus.h inclusion with v4l2-mbus.h
  gpu: ipu-v3: Replace v4l2-mediabus.h inclusion with v4l2-mbus.h
  [media] platform: Replace v4l2-mediabus.h inclusion with v4l2-mbus.h
  staging: media: Replace v4l2-mediabus.h inclusion with v4l2-mbus.h

 Documentation/DocBook/media/Makefile               |   4 +-
 Documentation/DocBook/media/v4l/subdev-formats.xml | 308 ++++++++++-----------
 Documentation/video4linux/soc-camera.txt           |   2 +-
 arch/arm/mach-davinci/board-dm355-evm.c            |   2 +-
 arch/arm/mach-davinci/board-dm365-evm.c            |   4 +-
 arch/arm/mach-davinci/dm355.c                      |   6 +-
 arch/arm/mach-davinci/dm365.c                      |   6 +-
 arch/arm/mach-shmobile/board-mackerel.c            |   2 +-
 arch/sh/boards/mach-ap325rxa/setup.c               |   2 +-
 drivers/gpu/ipu-v3/ipu-csi.c                       |  68 ++---
 drivers/media/i2c/adv7170.c                        |  16 +-
 drivers/media/i2c/adv7175.c                        |  16 +-
 drivers/media/i2c/adv7180.c                        |   6 +-
 drivers/media/i2c/adv7183.c                        |   6 +-
 drivers/media/i2c/adv7604.c                        |  72 ++---
 drivers/media/i2c/adv7842.c                        |   6 +-
 drivers/media/i2c/ak881x.c                         |   8 +-
 drivers/media/i2c/cx25840/cx25840-core.c           |   2 +-
 drivers/media/i2c/m5mols/m5mols_core.c             |   6 +-
 drivers/media/i2c/ml86v7667.c                      |   6 +-
 drivers/media/i2c/mt9m032.c                        |   8 +-
 drivers/media/i2c/mt9p031.c                        |   8 +-
 drivers/media/i2c/mt9t001.c                        |  10 +-
 drivers/media/i2c/mt9v011.c                        |   6 +-
 drivers/media/i2c/mt9v032.c                        |  14 +-
 drivers/media/i2c/noon010pc30.c                    |  12 +-
 drivers/media/i2c/ov7670.c                         |  16 +-
 drivers/media/i2c/ov9650.c                         |  10 +-
 drivers/media/i2c/s5c73m3/s5c73m3.h                |   6 +-
 drivers/media/i2c/s5k4ecgx.c                       |   4 +-
 drivers/media/i2c/s5k5baf.c                        |  14 +-
 drivers/media/i2c/s5k6a3.c                         |   2 +-
 drivers/media/i2c/s5k6aa.c                         |   8 +-
 drivers/media/i2c/saa6752hs.c                      |   6 +-
 drivers/media/i2c/saa7115.c                        |   2 +-
 drivers/media/i2c/saa717x.c                        |   2 +-
 drivers/media/i2c/smiapp/smiapp-core.c             |  34 +--
 drivers/media/i2c/soc_camera/imx074.c              |  10 +-
 drivers/media/i2c/soc_camera/mt9m001.c             |  14 +-
 drivers/media/i2c/soc_camera/mt9m111.c             |  72 ++---
 drivers/media/i2c/soc_camera/mt9t031.c             |  12 +-
 drivers/media/i2c/soc_camera/mt9t112.c             |  24 +-
 drivers/media/i2c/soc_camera/mt9v022.c             |  26 +-
 drivers/media/i2c/soc_camera/ov2640.c              |  56 ++--
 drivers/media/i2c/soc_camera/ov5642.c              |  10 +-
 drivers/media/i2c/soc_camera/ov6650.c              |  60 ++--
 drivers/media/i2c/soc_camera/ov772x.c              |  22 +-
 drivers/media/i2c/soc_camera/ov9640.c              |  42 +--
 drivers/media/i2c/soc_camera/ov9740.c              |  14 +-
 drivers/media/i2c/soc_camera/rj54n1cb0c.c          |  56 ++--
 drivers/media/i2c/soc_camera/tw9910.c              |  12 +-
 drivers/media/i2c/sr030pc30.c                      |  14 +-
 drivers/media/i2c/tvp514x.c                        |  14 +-
 drivers/media/i2c/tvp5150.c                        |   6 +-
 drivers/media/i2c/tvp7002.c                        |  10 +-
 drivers/media/i2c/vs6624.c                         |  18 +-
 drivers/media/pci/cx18/cx18-av-core.c              |   2 +-
 drivers/media/pci/cx18/cx18-controls.c             |   2 +-
 drivers/media/pci/cx18/cx18-ioctl.c                |   2 +-
 drivers/media/pci/cx23885/cx23885-video.c          |   2 +-
 drivers/media/pci/ivtv/ivtv-controls.c             |   2 +-
 drivers/media/pci/ivtv/ivtv-ioctl.c                |   2 +-
 drivers/media/pci/saa7134/saa7134-empress.c        |   4 +-
 drivers/media/platform/blackfin/bfin_capture.c     |  14 +-
 drivers/media/platform/davinci/vpbe.c              |   2 +-
 drivers/media/platform/davinci/vpfe_capture.c      |   4 +-
 drivers/media/platform/exynos-gsc/gsc-core.c       |   8 +-
 drivers/media/platform/exynos-gsc/gsc-core.h       |   2 +-
 drivers/media/platform/exynos4-is/fimc-capture.c   |   2 +-
 drivers/media/platform/exynos4-is/fimc-core.c      |  14 +-
 drivers/media/platform/exynos4-is/fimc-core.h      |   4 +-
 drivers/media/platform/exynos4-is/fimc-isp.c       |  16 +-
 drivers/media/platform/exynos4-is/fimc-lite-reg.c  |  26 +-
 drivers/media/platform/exynos4-is/fimc-lite.c      |  14 +-
 drivers/media/platform/exynos4-is/fimc-reg.c       |  14 +-
 drivers/media/platform/exynos4-is/mipi-csis.c      |  14 +-
 drivers/media/platform/marvell-ccic/mcam-core.c    |  22 +-
 drivers/media/platform/marvell-ccic/mcam-core.h    |   2 +-
 drivers/media/platform/omap3isp/ispccdc.c          | 112 ++++----
 drivers/media/platform/omap3isp/ispccp2.c          |  18 +-
 drivers/media/platform/omap3isp/ispcsi2.c          |  44 +--
 drivers/media/platform/omap3isp/isppreview.c       |  58 ++--
 drivers/media/platform/omap3isp/ispresizer.c       |  18 +-
 drivers/media/platform/omap3isp/ispvideo.c         |  94 +++----
 drivers/media/platform/omap3isp/ispvideo.h         |  12 +-
 drivers/media/platform/s3c-camif/camif-capture.c   |  10 +-
 drivers/media/platform/s3c-camif/camif-regs.c      |   8 +-
 drivers/media/platform/s5p-tv/hdmi_drv.c           |   2 +-
 drivers/media/platform/s5p-tv/sdo_drv.c            |   2 +-
 drivers/media/platform/sh_vou.c                    |   8 +-
 drivers/media/platform/soc_camera/atmel-isi.c      |  22 +-
 drivers/media/platform/soc_camera/mx2_camera.c     |  24 +-
 drivers/media/platform/soc_camera/mx3_camera.c     |   6 +-
 drivers/media/platform/soc_camera/omap1_camera.c   |  36 +--
 drivers/media/platform/soc_camera/pxa_camera.c     |  16 +-
 drivers/media/platform/soc_camera/rcar_vin.c       |  14 +-
 .../platform/soc_camera/sh_mobile_ceu_camera.c     |  20 +-
 drivers/media/platform/soc_camera/sh_mobile_csi2.c |  38 +--
 drivers/media/platform/soc_camera/soc_camera.c     |   2 +-
 .../platform/soc_camera/soc_camera_platform.c      |   2 +-
 drivers/media/platform/soc_camera/soc_mediabus.c   |  78 +++---
 drivers/media/platform/via-camera.c                |   8 +-
 drivers/media/platform/vsp1/vsp1_bru.c             |  14 +-
 drivers/media/platform/vsp1/vsp1_hsit.c            |  12 +-
 drivers/media/platform/vsp1/vsp1_lif.c             |  10 +-
 drivers/media/platform/vsp1/vsp1_lut.c             |  14 +-
 drivers/media/platform/vsp1/vsp1_rwpf.c            |  10 +-
 drivers/media/platform/vsp1/vsp1_sru.c             |  12 +-
 drivers/media/platform/vsp1/vsp1_uds.c             |  10 +-
 drivers/media/platform/vsp1/vsp1_video.c           |  44 +--
 drivers/media/usb/cx231xx/cx231xx-417.c            |   2 +-
 drivers/media/usb/cx231xx/cx231xx-video.c          |   4 +-
 drivers/media/usb/em28xx/em28xx-camera.c           |   2 +-
 drivers/media/usb/go7007/go7007-v4l2.c             |   2 +-
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c            |   2 +-
 drivers/staging/media/davinci_vpfe/dm365_ipipe.c   |  18 +-
 .../staging/media/davinci_vpfe/dm365_ipipe_hw.c    |  26 +-
 drivers/staging/media/davinci_vpfe/dm365_ipipeif.c | 100 +++----
 drivers/staging/media/davinci_vpfe/dm365_isif.c    |  90 +++---
 drivers/staging/media/davinci_vpfe/dm365_resizer.c |  96 +++----
 .../staging/media/davinci_vpfe/vpfe_mc_capture.c   |  18 +-
 drivers/staging/media/omap4iss/iss_csi2.c          |  64 ++---
 drivers/staging/media/omap4iss/iss_ipipe.c         |  16 +-
 drivers/staging/media/omap4iss/iss_ipipeif.c       |  28 +-
 drivers/staging/media/omap4iss/iss_resizer.c       |  26 +-
 drivers/staging/media/omap4iss/iss_video.c         |  78 +++---
 drivers/staging/media/omap4iss/iss_video.h         |  12 +-
 include/media/davinci/vpbe.h                       |   2 +-
 include/media/davinci/vpbe_venc.h                  |   4 +-
 include/media/exynos-fimc.h                        |   2 +-
 include/media/soc_camera.h                         |   2 +-
 include/media/soc_mediabus.h                       |   8 +-
 include/media/v4l2-mediabus.h                      |   4 +-
 include/media/v4l2-subdev.h                        |   2 +-
 include/uapi/linux/Kbuild                          |   2 +
 include/uapi/linux/media-bus-format.h              | 126 +++++++++
 include/uapi/linux/v4l2-mbus.h                     |  35 +++
 include/uapi/linux/v4l2-mediabus.h                 | 208 ++++++--------
 include/uapi/linux/v4l2-subdev.h                   |   8 +-
 139 files changed, 1632 insertions(+), 1509 deletions(-)
 create mode 100644 include/uapi/linux/media-bus-format.h
 create mode 100644 include/uapi/linux/v4l2-mbus.h

-- 
1.9.1

