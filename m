Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:54088 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730750AbeJ3HvV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 30 Oct 2018 03:51:21 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, mchehab@kernel.org
Subject: [PATCH 0/4] SoC camera removal
Date: Tue, 30 Oct 2018 01:00:25 +0200
Message-Id: <20181029230029.14630-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everyone,

There's been some discussion on SoC camera removal and the idea has been
to keep it around as long as the board code refers to it, to keep it
compiling.

The references to SoC camera in the board code are effectively references
to a single struct, struct soc_camera_link plus a few macros. The rest of
the SoC camera framework is not really needed.

These patches remove the SoC camera framework and leave just the struct
definition in place so the board files continue to compile. The references
can then be removed later on, while the need to maintain over 16000 lines
of non-working code will be gone immediately.

There are currently four instances of SoC camera references in the board
files:

	arch/arm/mach-imx/mach-imx27_visstrim_m10.c
	arch/arm/mach-omap1/board-ams-delta.c
	arch/arm/mach-pxa/palmz72.c
	arch/arm/mach-pxa/pcm990-baseboard.c

I've compile tested them with the patchset for the affected machines.

If there's a need to revive old drivers, they can always be found in the
git history. There's no need to put them to the staging branch.

Sakari Ailus (4):
  tw9910: Unregister async subdev at device unbind
  tw9910: No SoC camera dependency
  SoC camera: Remove the framework and the drivers
  SoC camera: Tidy the header

 MAINTAINERS                                        |    8 -
 drivers/media/i2c/Kconfig                          |    8 -
 drivers/media/i2c/Makefile                         |    1 -
 drivers/media/i2c/soc_camera/Kconfig               |   66 -
 drivers/media/i2c/soc_camera/Makefile              |   10 -
 drivers/media/i2c/soc_camera/ov9640.h              |  208 --
 drivers/media/i2c/soc_camera/soc_mt9m001.c         |  757 -------
 drivers/media/i2c/soc_camera/soc_mt9t112.c         | 1157 -----------
 drivers/media/i2c/soc_camera/soc_mt9v022.c         | 1012 ---------
 drivers/media/i2c/soc_camera/soc_ov5642.c          | 1087 ----------
 drivers/media/i2c/soc_camera/soc_ov772x.c          | 1123 ----------
 drivers/media/i2c/soc_camera/soc_ov9640.c          |  738 -------
 drivers/media/i2c/soc_camera/soc_ov9740.c          |  996 ---------
 drivers/media/i2c/soc_camera/soc_rj54n1cb0c.c      | 1415 -------------
 drivers/media/i2c/soc_camera/soc_tw9910.c          |  999 ---------
 drivers/media/i2c/tw9910.c                         |    4 +-
 drivers/media/platform/Kconfig                     |    1 -
 drivers/media/platform/Makefile                    |    2 -
 drivers/media/platform/soc_camera/Kconfig          |   26 -
 drivers/media/platform/soc_camera/Makefile         |    9 -
 .../platform/soc_camera/sh_mobile_ceu_camera.c     | 1810 ----------------
 drivers/media/platform/soc_camera/soc_camera.c     | 2169 --------------------
 .../platform/soc_camera/soc_camera_platform.c      |  188 --
 drivers/media/platform/soc_camera/soc_mediabus.c   |  533 -----
 drivers/media/platform/soc_camera/soc_scale_crop.c |  426 ----
 drivers/media/platform/soc_camera/soc_scale_crop.h |   47 -
 drivers/staging/media/Kconfig                      |    4 -
 drivers/staging/media/Makefile                     |    2 -
 drivers/staging/media/imx074/Kconfig               |    5 -
 drivers/staging/media/imx074/Makefile              |    1 -
 drivers/staging/media/imx074/TODO                  |    5 -
 drivers/staging/media/imx074/imx074.c              |  496 -----
 drivers/staging/media/mt9t031/Kconfig              |    5 -
 drivers/staging/media/mt9t031/Makefile             |    1 -
 drivers/staging/media/mt9t031/TODO                 |    5 -
 drivers/staging/media/mt9t031/mt9t031.c            |  857 --------
 include/media/i2c/tw9910.h                         |    2 -
 include/media/soc_camera.h                         |  335 ---
 38 files changed, 3 insertions(+), 16515 deletions(-)
 delete mode 100644 drivers/media/i2c/soc_camera/Kconfig
 delete mode 100644 drivers/media/i2c/soc_camera/Makefile
 delete mode 100644 drivers/media/i2c/soc_camera/ov9640.h
 delete mode 100644 drivers/media/i2c/soc_camera/soc_mt9m001.c
 delete mode 100644 drivers/media/i2c/soc_camera/soc_mt9t112.c
 delete mode 100644 drivers/media/i2c/soc_camera/soc_mt9v022.c
 delete mode 100644 drivers/media/i2c/soc_camera/soc_ov5642.c
 delete mode 100644 drivers/media/i2c/soc_camera/soc_ov772x.c
 delete mode 100644 drivers/media/i2c/soc_camera/soc_ov9640.c
 delete mode 100644 drivers/media/i2c/soc_camera/soc_ov9740.c
 delete mode 100644 drivers/media/i2c/soc_camera/soc_rj54n1cb0c.c
 delete mode 100644 drivers/media/i2c/soc_camera/soc_tw9910.c
 delete mode 100644 drivers/media/platform/soc_camera/Kconfig
 delete mode 100644 drivers/media/platform/soc_camera/Makefile
 delete mode 100644 drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
 delete mode 100644 drivers/media/platform/soc_camera/soc_camera.c
 delete mode 100644 drivers/media/platform/soc_camera/soc_camera_platform.c
 delete mode 100644 drivers/media/platform/soc_camera/soc_mediabus.c
 delete mode 100644 drivers/media/platform/soc_camera/soc_scale_crop.c
 delete mode 100644 drivers/media/platform/soc_camera/soc_scale_crop.h
 delete mode 100644 drivers/staging/media/imx074/Kconfig
 delete mode 100644 drivers/staging/media/imx074/Makefile
 delete mode 100644 drivers/staging/media/imx074/TODO
 delete mode 100644 drivers/staging/media/imx074/imx074.c
 delete mode 100644 drivers/staging/media/mt9t031/Kconfig
 delete mode 100644 drivers/staging/media/mt9t031/Makefile
 delete mode 100644 drivers/staging/media/mt9t031/TODO
 delete mode 100644 drivers/staging/media/mt9t031/mt9t031.c

-- 
2.11.0
