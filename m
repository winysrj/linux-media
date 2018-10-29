Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:54202 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729783AbeJ3IMc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 30 Oct 2018 04:12:32 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, mchehab@kernel.org
Subject: [PATCH 3/4] SoC camera: Remove the framework and the drivers
Date: Tue, 30 Oct 2018 01:21:34 +0200
Message-Id: <20181029232134.25831-1-sakari.ailus@linux.intel.com>
In-Reply-To: <20181029230029.14630-1-sakari.ailus@linux.intel.com>
References: <20181029230029.14630-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The SoC camera framework has been obsolete for some time and it is no
longer functional. A few drivers have been converted to the V4L2
sub-device API but for the rest the conversion has not taken place yet.

In order to keep the tree clean and to avoid keep maintaining
non-functional and obsolete code, remove the SoC camera framework as well
as the drivers that depend on it.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
Resending, this time with git format-patch -D .

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
 35 files changed, 16177 deletions(-)
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

diff --git a/MAINTAINERS b/MAINTAINERS
index 23021e0df5d7..788de30125c1 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13422,14 +13422,6 @@ L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/ethernet/smsc/smsc9420.*
 
-SOC-CAMERA V4L2 SUBSYSTEM
-L:	linux-media@vger.kernel.org
-T:	git git://linuxtv.org/media_tree.git
-S:	Orphan
-F:	include/media/soc*
-F:	drivers/media/i2c/soc_camera/
-F:	drivers/media/platform/soc_camera/
-
 SOCIONEXT SYNQUACER I2C DRIVER
 M:	Ard Biesheuvel <ard.biesheuvel@linaro.org>
 L:	linux-i2c@vger.kernel.org
diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index 704af210e270..c7683ac5a3d8 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -1091,12 +1091,4 @@ config VIDEO_I2C
 
 endmenu
 
-menu "Sensors used on soc_camera driver"
-
-if SOC_CAMERA
-	source "drivers/media/i2c/soc_camera/Kconfig"
-endif
-
-endmenu
-
 endif
diff --git a/drivers/media/i2c/Makefile b/drivers/media/i2c/Makefile
index 260d4d9ec2a1..d83d1f2a08ee 100644
--- a/drivers/media/i2c/Makefile
+++ b/drivers/media/i2c/Makefile
@@ -6,7 +6,6 @@ obj-$(CONFIG_VIDEO_SMIAPP)	+= smiapp/
 obj-$(CONFIG_VIDEO_ET8EK8)	+= et8ek8/
 obj-$(CONFIG_VIDEO_CX25840) += cx25840/
 obj-$(CONFIG_VIDEO_M5MOLS)	+= m5mols/
-obj-y				+= soc_camera/
 
 obj-$(CONFIG_VIDEO_APTINA_PLL) += aptina-pll.o
 obj-$(CONFIG_VIDEO_TVAUDIO) += tvaudio.o
diff --git a/drivers/media/i2c/soc_camera/Kconfig b/drivers/media/i2c/soc_camera/Kconfig
deleted file mode 100644
index 7c2aabc8a3f6..000000000000
diff --git a/drivers/media/i2c/soc_camera/Makefile b/drivers/media/i2c/soc_camera/Makefile
deleted file mode 100644
index 09ae483b96ef..000000000000
diff --git a/drivers/media/i2c/soc_camera/ov9640.h b/drivers/media/i2c/soc_camera/ov9640.h
deleted file mode 100644
index 65d13ff17536..000000000000
diff --git a/drivers/media/i2c/soc_camera/soc_mt9m001.c b/drivers/media/i2c/soc_camera/soc_mt9m001.c
deleted file mode 100644
index a1a85ff838c5..000000000000
diff --git a/drivers/media/i2c/soc_camera/soc_mt9t112.c b/drivers/media/i2c/soc_camera/soc_mt9t112.c
deleted file mode 100644
index ea1ff270bc2d..000000000000
diff --git a/drivers/media/i2c/soc_camera/soc_mt9v022.c b/drivers/media/i2c/soc_camera/soc_mt9v022.c
deleted file mode 100644
index 6d922b17ea94..000000000000
diff --git a/drivers/media/i2c/soc_camera/soc_ov5642.c b/drivers/media/i2c/soc_camera/soc_ov5642.c
deleted file mode 100644
index 0931898c79dd..000000000000
diff --git a/drivers/media/i2c/soc_camera/soc_ov772x.c b/drivers/media/i2c/soc_camera/soc_ov772x.c
deleted file mode 100644
index fafd372527b2..000000000000
diff --git a/drivers/media/i2c/soc_camera/soc_ov9640.c b/drivers/media/i2c/soc_camera/soc_ov9640.c
deleted file mode 100644
index eb91b8240083..000000000000
diff --git a/drivers/media/i2c/soc_camera/soc_ov9740.c b/drivers/media/i2c/soc_camera/soc_ov9740.c
deleted file mode 100644
index a07d3145d1b4..000000000000
diff --git a/drivers/media/i2c/soc_camera/soc_rj54n1cb0c.c b/drivers/media/i2c/soc_camera/soc_rj54n1cb0c.c
deleted file mode 100644
index f0cb49a6167b..000000000000
diff --git a/drivers/media/i2c/soc_camera/soc_tw9910.c b/drivers/media/i2c/soc_camera/soc_tw9910.c
deleted file mode 100644
index bdb5e0a431e9..000000000000
diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index 0edacfb01f3a..87bca0fe37a4 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -132,7 +132,6 @@ config VIDEO_RENESAS_CEU
 	---help---
 	  This is a v4l2 driver for the Renesas CEU Interface
 
-source "drivers/media/platform/soc_camera/Kconfig"
 source "drivers/media/platform/exynos4-is/Kconfig"
 source "drivers/media/platform/am437x/Kconfig"
 source "drivers/media/platform/xilinx/Kconfig"
diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
index 6ab6200dd9c9..ad1d47c1a3b1 100644
--- a/drivers/media/platform/Makefile
+++ b/drivers/media/platform/Makefile
@@ -59,8 +59,6 @@ obj-y					+= davinci/
 
 obj-$(CONFIG_VIDEO_SH_VOU)		+= sh_vou.o
 
-obj-$(CONFIG_SOC_CAMERA)		+= soc_camera/
-
 obj-$(CONFIG_VIDEO_RCAR_DRIF)		+= rcar_drif.o
 obj-$(CONFIG_VIDEO_RENESAS_CEU)		+= renesas-ceu.o
 obj-$(CONFIG_VIDEO_RENESAS_FCP)		+= rcar-fcp.o
diff --git a/drivers/media/platform/soc_camera/Kconfig b/drivers/media/platform/soc_camera/Kconfig
deleted file mode 100644
index 669d116b8f09..000000000000
diff --git a/drivers/media/platform/soc_camera/Makefile b/drivers/media/platform/soc_camera/Makefile
deleted file mode 100644
index 07a451e8b228..000000000000
diff --git a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
deleted file mode 100644
index 6803f744e307..000000000000
diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
deleted file mode 100644
index 0a70fb67c401..000000000000
diff --git a/drivers/media/platform/soc_camera/soc_camera_platform.c b/drivers/media/platform/soc_camera/soc_camera_platform.c
deleted file mode 100644
index 79fbe1fea95f..000000000000
diff --git a/drivers/media/platform/soc_camera/soc_mediabus.c b/drivers/media/platform/soc_camera/soc_mediabus.c
deleted file mode 100644
index be74008ec0ca..000000000000
diff --git a/drivers/media/platform/soc_camera/soc_scale_crop.c b/drivers/media/platform/soc_camera/soc_scale_crop.c
deleted file mode 100644
index 8d25ca0490f7..000000000000
diff --git a/drivers/media/platform/soc_camera/soc_scale_crop.h b/drivers/media/platform/soc_camera/soc_scale_crop.h
deleted file mode 100644
index 9ca469312a1f..000000000000
diff --git a/drivers/staging/media/Kconfig b/drivers/staging/media/Kconfig
index db5cf67047ad..ad0de8a22313 100644
--- a/drivers/staging/media/Kconfig
+++ b/drivers/staging/media/Kconfig
@@ -25,10 +25,6 @@ source "drivers/staging/media/davinci_vpfe/Kconfig"
 
 source "drivers/staging/media/imx/Kconfig"
 
-source "drivers/staging/media/imx074/Kconfig"
-
-source "drivers/staging/media/mt9t031/Kconfig"
-
 source "drivers/staging/media/omap4iss/Kconfig"
 
 source "drivers/staging/media/tegra-vde/Kconfig"
diff --git a/drivers/staging/media/Makefile b/drivers/staging/media/Makefile
index 503fbe47fa58..2d268d3905e5 100644
--- a/drivers/staging/media/Makefile
+++ b/drivers/staging/media/Makefile
@@ -1,8 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 obj-$(CONFIG_I2C_BCM2048)	+= bcm2048/
 obj-$(CONFIG_VIDEO_IMX_MEDIA)	+= imx/
-obj-$(CONFIG_SOC_CAMERA_IMX074)	+= imx074/
-obj-$(CONFIG_SOC_CAMERA_MT9T031)	+= mt9t031/
 obj-$(CONFIG_VIDEO_DM365_VPFE)	+= davinci_vpfe/
 obj-$(CONFIG_VIDEO_OMAP4)	+= omap4iss/
 obj-$(CONFIG_TEGRA_VDE)		+= tegra-vde/
diff --git a/drivers/staging/media/imx074/Kconfig b/drivers/staging/media/imx074/Kconfig
deleted file mode 100644
index 229cbeea580b..000000000000
diff --git a/drivers/staging/media/imx074/Makefile b/drivers/staging/media/imx074/Makefile
deleted file mode 100644
index 7d183574aa84..000000000000
diff --git a/drivers/staging/media/imx074/TODO b/drivers/staging/media/imx074/TODO
deleted file mode 100644
index 15580a4f950c..000000000000
diff --git a/drivers/staging/media/imx074/imx074.c b/drivers/staging/media/imx074/imx074.c
deleted file mode 100644
index 1676c166dc83..000000000000
diff --git a/drivers/staging/media/mt9t031/Kconfig b/drivers/staging/media/mt9t031/Kconfig
deleted file mode 100644
index 9a58aaf72edd..000000000000
diff --git a/drivers/staging/media/mt9t031/Makefile b/drivers/staging/media/mt9t031/Makefile
deleted file mode 100644
index bfd24c442b33..000000000000
diff --git a/drivers/staging/media/mt9t031/TODO b/drivers/staging/media/mt9t031/TODO
deleted file mode 100644
index 15580a4f950c..000000000000
diff --git a/drivers/staging/media/mt9t031/mt9t031.c b/drivers/staging/media/mt9t031/mt9t031.c
deleted file mode 100644
index 4ff179302b4f..000000000000
-- 
2.11.0
