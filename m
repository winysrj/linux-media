Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:47881 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752025AbeAPLCv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 16 Jan 2018 06:02:51 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 2/2] mt9t031: deprecate, move to staging
Date: Tue, 16 Jan 2018 12:02:45 +0100
Message-Id: <20180116110245.9456-3-hverkuil@xs4all.nl>
In-Reply-To: <20180116110245.9456-1-hverkuil@xs4all.nl>
References: <20180116110245.9456-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This driver is unused and depends on the deprecated soc-camera framework.
Move it to staging in preparation for being removed unless someone does
the work to convert it to a proper V4L2 subdev driver.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/soc_camera/Kconfig                          |  6 ------
 drivers/media/i2c/soc_camera/Makefile                         |  1 -
 drivers/staging/media/Kconfig                                 |  2 ++
 drivers/staging/media/Makefile                                |  1 +
 drivers/staging/media/mt9t031/Kconfig                         | 11 +++++++++++
 drivers/staging/media/mt9t031/Makefile                        |  1 +
 drivers/staging/media/mt9t031/TODO                            |  5 +++++
 .../{media/i2c/soc_camera => staging/media/mt9t031}/mt9t031.c |  0
 8 files changed, 20 insertions(+), 7 deletions(-)
 create mode 100644 drivers/staging/media/mt9t031/Kconfig
 create mode 100644 drivers/staging/media/mt9t031/Makefile
 create mode 100644 drivers/staging/media/mt9t031/TODO
 rename drivers/{media/i2c/soc_camera => staging/media/mt9t031}/mt9t031.c (100%)

diff --git a/drivers/media/i2c/soc_camera/Kconfig b/drivers/media/i2c/soc_camera/Kconfig
index d7136f2c2b20..7c2aabc8a3f6 100644
--- a/drivers/media/i2c/soc_camera/Kconfig
+++ b/drivers/media/i2c/soc_camera/Kconfig
@@ -17,12 +17,6 @@ config SOC_CAMERA_MT9M111
 	  This is the legacy configuration which shouldn't be used anymore,
 	  while VIDEO_MT9M111 should be used instead.
 
-config SOC_CAMERA_MT9T031
-	tristate "mt9t031 support"
-	depends on SOC_CAMERA && I2C
-	help
-	  This driver supports MT9T031 cameras from Micron.
-
 config SOC_CAMERA_MT9T112
 	tristate "mt9t112 support"
 	depends on SOC_CAMERA && I2C
diff --git a/drivers/media/i2c/soc_camera/Makefile b/drivers/media/i2c/soc_camera/Makefile
index a489b00e43b5..8c7770f62997 100644
--- a/drivers/media/i2c/soc_camera/Makefile
+++ b/drivers/media/i2c/soc_camera/Makefile
@@ -1,6 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
 obj-$(CONFIG_SOC_CAMERA_MT9M001)	+= mt9m001.o
-obj-$(CONFIG_SOC_CAMERA_MT9T031)	+= mt9t031.o
 obj-$(CONFIG_SOC_CAMERA_MT9T112)	+= mt9t112.o
 obj-$(CONFIG_SOC_CAMERA_MT9V022)	+= mt9v022.o
 obj-$(CONFIG_SOC_CAMERA_OV5642)		+= ov5642.o
diff --git a/drivers/staging/media/Kconfig b/drivers/staging/media/Kconfig
index 9afdb2e279cc..f99287e58402 100644
--- a/drivers/staging/media/Kconfig
+++ b/drivers/staging/media/Kconfig
@@ -31,6 +31,8 @@ source "drivers/staging/media/imx/Kconfig"
 
 source "drivers/staging/media/imx074/Kconfig"
 
+source "drivers/staging/media/mt9t031/Kconfig"
+
 source "drivers/staging/media/omap4iss/Kconfig"
 
 source "drivers/staging/media/tegra-vde/Kconfig"
diff --git a/drivers/staging/media/Makefile b/drivers/staging/media/Makefile
index 9958466524ed..a98efd52a185 100644
--- a/drivers/staging/media/Makefile
+++ b/drivers/staging/media/Makefile
@@ -3,6 +3,7 @@ obj-$(CONFIG_I2C_BCM2048)	+= bcm2048/
 obj-$(CONFIG_DVB_CXD2099)	+= cxd2099/
 obj-$(CONFIG_VIDEO_IMX_MEDIA)	+= imx/
 obj-$(CONFIG_SOC_CAMERA_IMX074)	+= imx074/
+obj-$(CONFIG_SOC_CAMERA_MT9T031)	+= mt9t031/
 obj-$(CONFIG_VIDEO_DM365_VPFE)	+= davinci_vpfe/
 obj-$(CONFIG_VIDEO_OMAP4)	+= omap4iss/
 obj-$(CONFIG_INTEL_ATOMISP)     += atomisp/
diff --git a/drivers/staging/media/mt9t031/Kconfig b/drivers/staging/media/mt9t031/Kconfig
new file mode 100644
index 000000000000..f48e06a03cdb
--- /dev/null
+++ b/drivers/staging/media/mt9t031/Kconfig
@@ -0,0 +1,11 @@
+config SOC_CAMERA_IMX074
+	tristate "imx074 support (DEPRECATED)"
+	depends on SOC_CAMERA && I2C
+	help
+	  This driver supports IMX074 cameras from Sony
+
+config SOC_CAMERA_MT9T031
+	tristate "mt9t031 support (DEPRECATED)"
+	depends on SOC_CAMERA && I2C
+	help
+	  This driver supports MT9T031 cameras from Micron.
diff --git a/drivers/staging/media/mt9t031/Makefile b/drivers/staging/media/mt9t031/Makefile
new file mode 100644
index 000000000000..bfd24c442b33
--- /dev/null
+++ b/drivers/staging/media/mt9t031/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_SOC_CAMERA_MT9T031)		+= mt9t031.o
diff --git a/drivers/staging/media/mt9t031/TODO b/drivers/staging/media/mt9t031/TODO
new file mode 100644
index 000000000000..15580a4f950c
--- /dev/null
+++ b/drivers/staging/media/mt9t031/TODO
@@ -0,0 +1,5 @@
+This sensor driver needs to be converted to a regular
+v4l2 subdev driver. The soc_camera framework is deprecated and
+will be removed in the future. Unless someone does this work this
+sensor driver will be deleted when the soc_camera framework is
+deleted.
diff --git a/drivers/media/i2c/soc_camera/mt9t031.c b/drivers/staging/media/mt9t031/mt9t031.c
similarity index 100%
rename from drivers/media/i2c/soc_camera/mt9t031.c
rename to drivers/staging/media/mt9t031/mt9t031.c
-- 
2.15.1
