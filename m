Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:58602 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936482Ab3DRVf7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Apr 2013 17:35:59 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH 00/24] V4L2: subdevice pad-level API wrapper
Date: Thu, 18 Apr 2013 23:35:21 +0200
Message-Id: <1366320945-21591-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is the first very crude shot at the subdevice pad-level API wrapper.
The actual wrapper is added in patch #21, previous 20 patches are
preparation... They apply on top of the last version of my async / clock
patch series, respectively, on top of the announced branch of my linuxtv
git-tree. Patches 2 and 4 from this series should actually be merged into
respective patches from the async series.

I'm publishing this patch-series now, because I don't know when and how
much time I'll have to improve it... Maybe you don't want to spend too much
time reviewing implementation details, but comments to general concepts
would be appreciated.

Further note, that patches 8-12 aren't really required. We can keep the
deprecated struct soc_camera_link for now, or use a more gentle and slow
way to remove it.

Guennadi Liakhovetski (24):
  V4L2: (cosmetic) remove redundant use of unlikely()
  imx074: fix error handling for failed async subdevice registration
  mt9t031: fix NULL dereference during probe()
  V4L2: fix Oops on rmmod path
  V4L2: allow dummy file-handle initialisation by v4l2_fh_init()
  V4L2: add a common V4L2 subdevice platform data type
  soc-camera: switch to using the new struct v4l2_subdev_platform_data
  ARM: update all soc-camera users to new platform data layout
  SH: update all soc-camera users to new platform data layout
  soc-camera: update soc-camera-platform & its users to a new platform
    data layout
  soc-camera: completely remove struct soc_camera_link
  V4L2: soc-camera: retrieve subdevice platform data from struct
    v4l2_subdev
  ARM: pcm037: convert custom GPIO-based power function to a regulator
  mx3-camera: clean up the use of platform data, add driver owner
  mx3-camera: support asynchronous subdevice registration
  V4L2: mt9p031: add support for V4L2 clock and asynchronous probing
  V4L2: mt9p031: add support for .g_mbus_config() video operation
  V4L2: mt9p031: power down the sensor if no supported device has been
    detected
  V4L2: add struct v4l2_subdev_try_buf
  V4L2: add a subdev pointer to struct v4l2_subdev_fh
  V4L2: add a subdevice-driver pad-operation wrapper
  V4L2: soc-camera: use the pad-operation wrapper
  V4L2: mt9p031: add struct v4l2_subdev_platform_data to platform data
  ARM: pcm037: support mt9p031 / mt9p006 camera sensors

 Documentation/video4linux/soc-camera.txt       |    2 +-
 arch/arm/mach-at91/board-sam9m10g45ek.c        |   19 +-
 arch/arm/mach-imx/mach-imx27_visstrim_m10.c    |   17 +-
 arch/arm/mach-imx/mach-mx27_3ds.c              |   21 +-
 arch/arm/mach-imx/mach-mx31_3ds.c              |   23 +-
 arch/arm/mach-imx/mach-mx35_3ds.c              |   12 +-
 arch/arm/mach-imx/mach-pcm037.c                |  120 +++++++--
 arch/arm/mach-imx/mx31moboard-marxbot.c        |   17 +-
 arch/arm/mach-imx/mx31moboard-smartbot.c       |   17 +-
 arch/arm/mach-omap1/board-ams-delta.c          |   17 +-
 arch/arm/mach-pxa/em-x270.c                    |   15 +-
 arch/arm/mach-pxa/ezx.c                        |   36 ++-
 arch/arm/mach-pxa/mioa701.c                    |   11 +-
 arch/arm/mach-pxa/palmz72.c                    |   21 +-
 arch/arm/mach-pxa/pcm990-baseboard.c           |   44 ++--
 arch/arm/mach-shmobile/board-ap4evb.c          |    5 +-
 arch/arm/mach-shmobile/board-armadillo800eva.c |   17 +-
 arch/arm/mach-shmobile/board-mackerel.c        |   23 +-
 arch/sh/boards/mach-ap325rxa/setup.c           |   43 ++--
 arch/sh/boards/mach-ecovec24/setup.c           |   51 +++--
 arch/sh/boards/mach-kfr2r09/setup.c            |   15 +-
 arch/sh/boards/mach-migor/setup.c              |   30 ++-
 drivers/media/i2c/mt9p031.c                    |   55 ++++-
 drivers/media/i2c/soc_camera/imx074.c          |    5 +-
 drivers/media/i2c/soc_camera/mt9t031.c         |    7 +-
 drivers/media/platform/soc_camera/mx3_camera.c |   29 ++-
 drivers/media/platform/soc_camera/soc_camera.c |   49 +++-
 drivers/media/usb/em28xx/em28xx-camera.c       |   12 +-
 drivers/media/v4l2-core/Makefile               |    3 +
 drivers/media/v4l2-core/v4l2-async.c           |   18 +-
 drivers/media/v4l2-core/v4l2-fh.c              |    8 +-
 drivers/media/v4l2-core/v4l2-pad-wrap.c        |  329 ++++++++++++++++++++++++
 drivers/media/v4l2-core/v4l2-subdev.c          |    1 +
 include/linux/platform_data/camera-mx3.h       |    3 +
 include/media/mt9p031.h                        |    3 +
 include/media/soc_camera.h                     |   53 +----
 include/media/soc_camera_platform.h            |    8 +-
 include/media/v4l2-pad-wrap.h                  |   23 ++
 include/media/v4l2-subdev.h                    |   31 ++-
 39 files changed, 909 insertions(+), 304 deletions(-)
 create mode 100644 drivers/media/v4l2-core/v4l2-pad-wrap.c
 create mode 100644 include/media/v4l2-pad-wrap.h

-- 
1.7.2.5

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
