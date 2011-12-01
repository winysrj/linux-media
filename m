Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:54061 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752462Ab1LAAPP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Nov 2011 19:15:15 -0500
From: Sergio Aguirre <saaguirre@ti.com>
To: <linux-media@vger.kernel.org>
CC: <linux-omap@vger.kernel.org>, <laurent.pinchart@ideasonboard.com>,
	<sakari.ailus@iki.fi>, Sergio Aguirre <saaguirre@ti.com>
Subject: [PATCH v2 00/11] v4l2: OMAP4 ISS driver + Sensor + Board support
Date: Wed, 30 Nov 2011 18:14:49 -0600
Message-ID: <1322698500-29924-1-git-send-email-saaguirre@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everyone,

This is the second version of the OMAP4 ISS driver,
now ported to the Media Controller framework AND supporting
videobuf2 framework.

This patchset should apply cleanly on top of v3.2-rc3 kernel tag.

This driver attempts to provide an fully open source solution to
control the OMAP4 Imaging SubSystem (a.k.a. ISS).

Starts with just CSI2-A interface support, and pretends to be
ready for expansion to add support to the many ISS block modules
as possible.

Please see newly added documentation for more details:

Documentation/video4linux/omap4_camera.txt

Any comments/complaints are welcome. :)

Changes since v1:
- Simplification of auxclk handling in board files. (Pointed out by: Roger Quadros)
- Cleanup of Camera support enablement for 4430sdp & panda. (Pointed out by: Roger Quadros)
- Use of HWMOD declaration for assisted platform_device creation. (Pointed out by: Felipe Balbi)
- Videobuf2 migration (Removal of custom iss_queue buffer handling driver)
- Proper GPO3 handling for CAM_SEL in 4430sdp.

Sergio Aguirre (10):
  TWL6030: Add mapping for auxiliary regs
  mfd: twl6040: Fix wrong TWL6040_GPO3 bitfield value
  OMAP4: hwmod: Include CSI2A and CSIPHY1 memory sections
  OMAP4: Add base addresses for ISS
  v4l: Add support for omap4iss driver
  v4l: Add support for ov5640 sensor
  v4l: Add support for ov5650 sensor
  arm: omap4430sdp: Add support for omap4iss camera
  arm: omap4panda: Add support for omap4iss camera
  arm: Add support for CMA for omap4iss driver

Stanimir Varbanov (1):
  v4l: Introduce sensor operation for getting interface configuration

 Documentation/video4linux/omap4_camera.txt    |   60 ++
 arch/arm/mach-omap2/Kconfig                   |   54 +
 arch/arm/mach-omap2/Makefile                  |    3 +
 arch/arm/mach-omap2/board-4430sdp-camera.c    |  221 ++++
 arch/arm/mach-omap2/board-omap4panda-camera.c |  198 ++++
 arch/arm/mach-omap2/devices.c                 |   40 +
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c    |   16 +-
 arch/arm/plat-omap/include/plat/omap4-iss.h   |   42 +
 arch/arm/plat-omap/include/plat/omap44xx.h    |    9 +
 drivers/media/video/Kconfig                   |   25 +
 drivers/media/video/Makefile                  |    3 +
 drivers/media/video/omap4iss/Makefile         |    6 +
 drivers/media/video/omap4iss/iss.c            | 1179 ++++++++++++++++++++++
 drivers/media/video/omap4iss/iss.h            |  133 +++
 drivers/media/video/omap4iss/iss_csi2.c       | 1324 +++++++++++++++++++++++++
 drivers/media/video/omap4iss/iss_csi2.h       |  166 +++
 drivers/media/video/omap4iss/iss_csiphy.c     |  215 ++++
 drivers/media/video/omap4iss/iss_csiphy.h     |   69 ++
 drivers/media/video/omap4iss/iss_regs.h       |  238 +++++
 drivers/media/video/omap4iss/iss_video.c      | 1192 ++++++++++++++++++++++
 drivers/media/video/omap4iss/iss_video.h      |  205 ++++
 drivers/media/video/ov5640.c                  |  972 ++++++++++++++++++
 drivers/media/video/ov5650.c                  |  524 ++++++++++
 drivers/mfd/twl-core.c                        |    2 +-
 include/linux/mfd/twl6040.h                   |    2 +-
 include/media/ov5640.h                        |   10 +
 include/media/ov5650.h                        |   10 +
 include/media/v4l2-chip-ident.h               |    2 +
 include/media/v4l2-subdev.h                   |   42 +
 29 files changed, 6957 insertions(+), 5 deletions(-)
 create mode 100644 Documentation/video4linux/omap4_camera.txt
 create mode 100644 arch/arm/mach-omap2/board-4430sdp-camera.c
 create mode 100644 arch/arm/mach-omap2/board-omap4panda-camera.c
 create mode 100644 arch/arm/plat-omap/include/plat/omap4-iss.h
 create mode 100644 drivers/media/video/omap4iss/Makefile
 create mode 100644 drivers/media/video/omap4iss/iss.c
 create mode 100644 drivers/media/video/omap4iss/iss.h
 create mode 100644 drivers/media/video/omap4iss/iss_csi2.c
 create mode 100644 drivers/media/video/omap4iss/iss_csi2.h
 create mode 100644 drivers/media/video/omap4iss/iss_csiphy.c
 create mode 100644 drivers/media/video/omap4iss/iss_csiphy.h
 create mode 100644 drivers/media/video/omap4iss/iss_regs.h
 create mode 100644 drivers/media/video/omap4iss/iss_video.c
 create mode 100644 drivers/media/video/omap4iss/iss_video.h
 create mode 100644 drivers/media/video/ov5640.c
 create mode 100644 drivers/media/video/ov5650.c
 create mode 100644 include/media/ov5640.h
 create mode 100644 include/media/ov5650.h

-- 
1.7.7.4

