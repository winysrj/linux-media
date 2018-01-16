Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:52584 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752020AbeAPLCu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 16 Jan 2018 06:02:50 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 1/2] imx074: deprecate, move to staging
Date: Tue, 16 Jan 2018 12:02:44 +0100
Message-Id: <20180116110245.9456-2-hverkuil@xs4all.nl>
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
 drivers/media/i2c/soc_camera/Kconfig                            | 6 ------
 drivers/media/i2c/soc_camera/Makefile                           | 1 -
 drivers/staging/media/Kconfig                                   | 2 ++
 drivers/staging/media/Makefile                                  | 1 +
 drivers/staging/media/imx074/Kconfig                            | 5 +++++
 drivers/staging/media/imx074/Makefile                           | 1 +
 drivers/staging/media/imx074/TODO                               | 5 +++++
 drivers/{media/i2c/soc_camera => staging/media/imx074}/imx074.c | 0
 8 files changed, 14 insertions(+), 7 deletions(-)
 create mode 100644 drivers/staging/media/imx074/Kconfig
 create mode 100644 drivers/staging/media/imx074/Makefile
 create mode 100644 drivers/staging/media/imx074/TODO
 rename drivers/{media/i2c/soc_camera => staging/media/imx074}/imx074.c (100%)

diff --git a/drivers/media/i2c/soc_camera/Kconfig b/drivers/media/i2c/soc_camera/Kconfig
index 72b369895b37..d7136f2c2b20 100644
--- a/drivers/media/i2c/soc_camera/Kconfig
+++ b/drivers/media/i2c/soc_camera/Kconfig
@@ -1,11 +1,5 @@
 comment "soc_camera sensor drivers"
 
-config SOC_CAMERA_IMX074
-	tristate "imx074 support"
-	depends on SOC_CAMERA && I2C
-	help
-	  This driver supports IMX074 cameras from Sony
-
 config SOC_CAMERA_MT9M001
 	tristate "mt9m001 support"
 	depends on SOC_CAMERA && I2C
diff --git a/drivers/media/i2c/soc_camera/Makefile b/drivers/media/i2c/soc_camera/Makefile
index faa2df8901d2..a489b00e43b5 100644
--- a/drivers/media/i2c/soc_camera/Makefile
+++ b/drivers/media/i2c/soc_camera/Makefile
@@ -1,5 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0
-obj-$(CONFIG_SOC_CAMERA_IMX074)		+= imx074.o
 obj-$(CONFIG_SOC_CAMERA_MT9M001)	+= mt9m001.o
 obj-$(CONFIG_SOC_CAMERA_MT9T031)	+= mt9t031.o
 obj-$(CONFIG_SOC_CAMERA_MT9T112)	+= mt9t112.o
diff --git a/drivers/staging/media/Kconfig b/drivers/staging/media/Kconfig
index e68e1d343d53..9afdb2e279cc 100644
--- a/drivers/staging/media/Kconfig
+++ b/drivers/staging/media/Kconfig
@@ -29,6 +29,8 @@ source "drivers/staging/media/davinci_vpfe/Kconfig"
 
 source "drivers/staging/media/imx/Kconfig"
 
+source "drivers/staging/media/imx074/Kconfig"
+
 source "drivers/staging/media/omap4iss/Kconfig"
 
 source "drivers/staging/media/tegra-vde/Kconfig"
diff --git a/drivers/staging/media/Makefile b/drivers/staging/media/Makefile
index 59a47f69884f..9958466524ed 100644
--- a/drivers/staging/media/Makefile
+++ b/drivers/staging/media/Makefile
@@ -2,6 +2,7 @@
 obj-$(CONFIG_I2C_BCM2048)	+= bcm2048/
 obj-$(CONFIG_DVB_CXD2099)	+= cxd2099/
 obj-$(CONFIG_VIDEO_IMX_MEDIA)	+= imx/
+obj-$(CONFIG_SOC_CAMERA_IMX074)	+= imx074/
 obj-$(CONFIG_VIDEO_DM365_VPFE)	+= davinci_vpfe/
 obj-$(CONFIG_VIDEO_OMAP4)	+= omap4iss/
 obj-$(CONFIG_INTEL_ATOMISP)     += atomisp/
diff --git a/drivers/staging/media/imx074/Kconfig b/drivers/staging/media/imx074/Kconfig
new file mode 100644
index 000000000000..229cbeea580b
--- /dev/null
+++ b/drivers/staging/media/imx074/Kconfig
@@ -0,0 +1,5 @@
+config SOC_CAMERA_IMX074
+	tristate "imx074 support (DEPRECATED)"
+	depends on SOC_CAMERA && I2C
+	help
+	  This driver supports IMX074 cameras from Sony
diff --git a/drivers/staging/media/imx074/Makefile b/drivers/staging/media/imx074/Makefile
new file mode 100644
index 000000000000..7d183574aa84
--- /dev/null
+++ b/drivers/staging/media/imx074/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_SOC_CAMERA_IMX074)		+= imx074.o
diff --git a/drivers/staging/media/imx074/TODO b/drivers/staging/media/imx074/TODO
new file mode 100644
index 000000000000..15580a4f950c
--- /dev/null
+++ b/drivers/staging/media/imx074/TODO
@@ -0,0 +1,5 @@
+This sensor driver needs to be converted to a regular
+v4l2 subdev driver. The soc_camera framework is deprecated and
+will be removed in the future. Unless someone does this work this
+sensor driver will be deleted when the soc_camera framework is
+deleted.
diff --git a/drivers/media/i2c/soc_camera/imx074.c b/drivers/staging/media/imx074/imx074.c
similarity index 100%
rename from drivers/media/i2c/soc_camera/imx074.c
rename to drivers/staging/media/imx074/imx074.c
-- 
2.15.1
