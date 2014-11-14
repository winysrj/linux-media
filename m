Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:51846 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754631AbaKNJDc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Nov 2014 04:03:32 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 23DA42A0091
	for <linux-media@vger.kernel.org>; Fri, 14 Nov 2014 10:03:21 +0100 (CET)
Message-ID: <5465C558.3020904@xs4all.nl>
Date: Fri, 14 Nov 2014 10:03:20 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.19] Move mediabus format definition to a more standard
 place
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit dd0a6fe2bc3055cd61e369f97982c88183b1f0a0:

  [media] dvb-usb-dvbsky: fix i2c adapter for sp2 device (2014-11-11 12:55:32 -0200)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v3.19h

for you to fetch changes up to 7de21705a75d97f84dd5f1ef0295f79edca8b0f2:

  v4l: Forbid usage of V4L2_MBUS_FMT definitions inside the kernel (2014-11-14 09:56:58 +0100)

----------------------------------------------------------------
Boris BREZILLON (10):
      Move mediabus format definition to a more standard place
      v4l: Update subdev-formats doc with new MEDIA_BUS_FMT values
      Make use of the new media_bus_format definitions
      i2c: Make use of media_bus_format enum
      pci: Make use of MEDIA_BUS_FMT definitions
      platform: Make use of media_bus_format enum
      usb: Make use of media_bus_format enum
      staging: media: Make use of MEDIA_BUS_FMT_ definitions
      gpu: ipu-v3: Make use of media_bus_format enum
      v4l: Forbid usage of V4L2_MBUS_FMT definitions inside the kernel

 Documentation/DocBook/media/v4l/subdev-formats.xml       | 308 +++++++++++++++++++++++++++++++++----------------------------------
 Documentation/video4linux/soc-camera.txt                 |   2 +-
 arch/arm/mach-davinci/board-dm355-evm.c                  |   2 +-
 arch/arm/mach-davinci/board-dm365-evm.c                  |   4 +-
 arch/arm/mach-davinci/dm355.c                            |   7 +-
 arch/arm/mach-davinci/dm365.c                            |   7 +-
 arch/arm/mach-shmobile/board-mackerel.c                  |   2 +-
 arch/sh/boards/mach-ap325rxa/setup.c                     |   2 +-
 drivers/gpu/ipu-v3/ipu-csi.c                             |  66 +++++++--------
 drivers/media/i2c/adv7170.c                              |  16 ++--
 drivers/media/i2c/adv7175.c                              |  16 ++--
 drivers/media/i2c/adv7180.c                              |   6 +-
 drivers/media/i2c/adv7183.c                              |   6 +-
 drivers/media/i2c/adv7604.c                              |  72 ++++++++--------
 drivers/media/i2c/adv7842.c                              |   6 +-
 drivers/media/i2c/ak881x.c                               |   8 +-
 drivers/media/i2c/cx25840/cx25840-core.c                 |   2 +-
 drivers/media/i2c/m5mols/m5mols_core.c                   |   6 +-
 drivers/media/i2c/ml86v7667.c                            |   6 +-
 drivers/media/i2c/mt9m032.c                              |   6 +-
 drivers/media/i2c/mt9p031.c                              |   8 +-
 drivers/media/i2c/mt9t001.c                              |   8 +-
 drivers/media/i2c/mt9v011.c                              |   6 +-
 drivers/media/i2c/mt9v032.c                              |  12 +--
 drivers/media/i2c/noon010pc30.c                          |  12 +--
 drivers/media/i2c/ov7670.c                               |  16 ++--
 drivers/media/i2c/ov9650.c                               |  10 +--
 drivers/media/i2c/s5c73m3/s5c73m3.h                      |   6 +-
 drivers/media/i2c/s5k4ecgx.c                             |   4 +-
 drivers/media/i2c/s5k5baf.c                              |  14 ++--
 drivers/media/i2c/s5k6a3.c                               |   2 +-
 drivers/media/i2c/s5k6aa.c                               |   8 +-
 drivers/media/i2c/saa6752hs.c                            |   6 +-
 drivers/media/i2c/saa7115.c                              |   2 +-
 drivers/media/i2c/saa717x.c                              |   2 +-
 drivers/media/i2c/smiapp/smiapp-core.c                   |  32 +++----
 drivers/media/i2c/soc_camera/imx074.c                    |   8 +-
 drivers/media/i2c/soc_camera/mt9m001.c                   |  14 ++--
 drivers/media/i2c/soc_camera/mt9m111.c                   |  70 ++++++++--------
 drivers/media/i2c/soc_camera/mt9t031.c                   |  10 +--
 drivers/media/i2c/soc_camera/mt9t112.c                   |  22 ++---
 drivers/media/i2c/soc_camera/mt9v022.c                   |  26 +++---
 drivers/media/i2c/soc_camera/ov2640.c                    |  54 ++++++------
 drivers/media/i2c/soc_camera/ov5642.c                    |   8 +-
 drivers/media/i2c/soc_camera/ov6650.c                    |  58 ++++++-------
 drivers/media/i2c/soc_camera/ov772x.c                    |  20 ++---
 drivers/media/i2c/soc_camera/ov9640.c                    |  40 ++++-----
 drivers/media/i2c/soc_camera/ov9740.c                    |  12 +--
 drivers/media/i2c/soc_camera/rj54n1cb0c.c                |  54 ++++++------
 drivers/media/i2c/soc_camera/tw9910.c                    |  10 +--
 drivers/media/i2c/sr030pc30.c                            |  14 ++--
 drivers/media/i2c/tvp514x.c                              |  12 +--
 drivers/media/i2c/tvp5150.c                              |   6 +-
 drivers/media/i2c/tvp7002.c                              |  10 +--
 drivers/media/i2c/vs6624.c                               |  18 ++--
 drivers/media/pci/cx18/cx18-av-core.c                    |   2 +-
 drivers/media/pci/cx18/cx18-controls.c                   |   2 +-
 drivers/media/pci/cx18/cx18-ioctl.c                      |   2 +-
 drivers/media/pci/cx23885/cx23885-video.c                |   2 +-
 drivers/media/pci/ivtv/ivtv-controls.c                   |   2 +-
 drivers/media/pci/ivtv/ivtv-ioctl.c                      |   2 +-
 drivers/media/pci/saa7134/saa7134-empress.c              |   4 +-
 drivers/media/platform/blackfin/bfin_capture.c           |  14 ++--
 drivers/media/platform/davinci/vpbe.c                    |   2 +-
 drivers/media/platform/davinci/vpfe_capture.c            |   4 +-
 drivers/media/platform/exynos-gsc/gsc-core.c             |   8 +-
 drivers/media/platform/exynos-gsc/gsc-core.h             |   2 +-
 drivers/media/platform/exynos4-is/fimc-capture.c         |   2 +-
 drivers/media/platform/exynos4-is/fimc-core.c            |  14 ++--
 drivers/media/platform/exynos4-is/fimc-core.h            |   4 +-
 drivers/media/platform/exynos4-is/fimc-isp.c             |  16 ++--
 drivers/media/platform/exynos4-is/fimc-lite-reg.c        |  26 +++---
 drivers/media/platform/exynos4-is/fimc-lite.c            |  14 ++--
 drivers/media/platform/exynos4-is/fimc-reg.c             |  14 ++--
 drivers/media/platform/exynos4-is/mipi-csis.c            |  14 ++--
 drivers/media/platform/marvell-ccic/mcam-core.c          |  21 +++--
 drivers/media/platform/marvell-ccic/mcam-core.h          |   2 +-
 drivers/media/platform/omap3isp/ispccdc.c                | 112 ++++++++++++-------------
 drivers/media/platform/omap3isp/ispccp2.c                |  18 ++--
 drivers/media/platform/omap3isp/ispcsi2.c                |  42 +++++-----
 drivers/media/platform/omap3isp/isppreview.c             |  60 +++++++------
 drivers/media/platform/omap3isp/ispresizer.c             |  19 ++---
 drivers/media/platform/omap3isp/ispvideo.c               |  95 +++++++++++----------
 drivers/media/platform/omap3isp/ispvideo.h               |  10 +--
 drivers/media/platform/s3c-camif/camif-capture.c         |  10 +--
 drivers/media/platform/s3c-camif/camif-regs.c            |   8 +-
 drivers/media/platform/s5p-tv/hdmi_drv.c                 |   2 +-
 drivers/media/platform/s5p-tv/sdo_drv.c                  |   2 +-
 drivers/media/platform/sh_vou.c                          |   8 +-
 drivers/media/platform/soc_camera/atmel-isi.c            |  22 ++---
 drivers/media/platform/soc_camera/mx2_camera.c           |  26 +++---
 drivers/media/platform/soc_camera/mx3_camera.c           |   6 +-
 drivers/media/platform/soc_camera/omap1_camera.c         |  36 ++++----
 drivers/media/platform/soc_camera/pxa_camera.c           |  16 ++--
 drivers/media/platform/soc_camera/rcar_vin.c             |  14 ++--
 drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c |  20 ++---
 drivers/media/platform/soc_camera/sh_mobile_csi2.c       |  38 ++++-----
 drivers/media/platform/soc_camera/soc_camera.c           |   2 +-
 drivers/media/platform/soc_camera/soc_camera_platform.c  |   2 +-
 drivers/media/platform/soc_camera/soc_mediabus.c         |  78 ++++++++---------
 drivers/media/platform/via-camera.c                      |   8 +-
 drivers/media/platform/vsp1/vsp1_bru.c                   |  14 ++--
 drivers/media/platform/vsp1/vsp1_hsit.c                  |  12 +--
 drivers/media/platform/vsp1/vsp1_lif.c                   |  10 +--
 drivers/media/platform/vsp1/vsp1_lut.c                   |  14 ++--
 drivers/media/platform/vsp1/vsp1_rwpf.c                  |  10 +--
 drivers/media/platform/vsp1/vsp1_sru.c                   |  12 +--
 drivers/media/platform/vsp1/vsp1_uds.c                   |  10 +--
 drivers/media/platform/vsp1/vsp1_video.c                 |  42 +++++-----
 drivers/media/usb/cx231xx/cx231xx-417.c                  |   2 +-
 drivers/media/usb/cx231xx/cx231xx-video.c                |   4 +-
 drivers/media/usb/em28xx/em28xx-camera.c                 |   2 +-
 drivers/media/usb/go7007/go7007-v4l2.c                   |   2 +-
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c                  |   2 +-
 drivers/staging/media/davinci_vpfe/dm365_ipipe.c         |  18 ++--
 drivers/staging/media/davinci_vpfe/dm365_ipipe_hw.c      |  26 +++---
 drivers/staging/media/davinci_vpfe/dm365_ipipeif.c       | 100 +++++++++++-----------
 drivers/staging/media/davinci_vpfe/dm365_isif.c          |  90 ++++++++++----------
 drivers/staging/media/davinci_vpfe/dm365_resizer.c       |  98 +++++++++++-----------
 drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c     |  18 ++--
 drivers/staging/media/omap4iss/iss_csi2.c                |  62 +++++++-------
 drivers/staging/media/omap4iss/iss_ipipe.c               |  16 ++--
 drivers/staging/media/omap4iss/iss_ipipeif.c             |  28 +++----
 drivers/staging/media/omap4iss/iss_resizer.c             |  26 +++---
 drivers/staging/media/omap4iss/iss_video.c               |  78 ++++++++---------
 drivers/staging/media/omap4iss/iss_video.h               |  10 +--
 include/media/davinci/vpbe.h                             |   2 +-
 include/media/davinci/vpbe_venc.h                        |   5 +-
 include/media/exynos-fimc.h                              |   2 +-
 include/media/soc_camera.h                               |   2 +-
 include/media/soc_mediabus.h                             |   6 +-
 include/media/v4l2-mediabus.h                            |   2 +-
 include/media/v4l2-subdev.h                              |   2 +-
 include/uapi/linux/Kbuild                                |   1 +
 include/uapi/linux/media-bus-format.h                    | 125 +++++++++++++++++++++++++++
 include/uapi/linux/v4l2-mediabus.h                       | 213 ++++++++++++++++++++++------------------------
 include/uapi/linux/v4l2-subdev.h                         |   6 +-
 137 files changed, 1582 insertions(+), 1481 deletions(-)
 create mode 100644 include/uapi/linux/media-bus-format.h
