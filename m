Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:10952 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755063AbdIRNrZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Sep 2017 09:47:25 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: d.filoni@ubuntu.com
Subject: [PATCH 1/1] staging: atomisp: Add driver prefix to Kconfig option and module names
Date: Mon, 18 Sep 2017 16:44:37 +0300
Message-Id: <1505742277-30633-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

By adding the "atomisp-" prefix to module names (and "ATOMISP_" to Kconfig
options), the staging drivers for e.g. sensors are labelled as being
specific to atomisp, which they effectively are.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/staging/media/atomisp/i2c/Kconfig            | 18 +++++++++---------
 drivers/staging/media/atomisp/i2c/Makefile           | 20 ++++++++++----------
 .../media/atomisp/i2c/{ap1302.c => atomisp-ap1302.c} |  0
 .../media/atomisp/i2c/{gc0310.c => atomisp-gc0310.c} |  0
 .../media/atomisp/i2c/{gc2235.c => atomisp-gc2235.c} |  0
 ...libmsrlisthelper.c => atomisp-libmsrlisthelper.c} |  0
 .../media/atomisp/i2c/{lm3554.c => atomisp-lm3554.c} |  0
 .../atomisp/i2c/{mt9m114.c => atomisp-mt9m114.c}     |  0
 .../media/atomisp/i2c/{ov2680.c => atomisp-ov2680.c} |  0
 .../media/atomisp/i2c/{ov2722.c => atomisp-ov2722.c} |  0
 drivers/staging/media/atomisp/i2c/imx/Kconfig        |  4 ++--
 drivers/staging/media/atomisp/i2c/imx/Makefile       |  8 ++++----
 drivers/staging/media/atomisp/i2c/ov5693/Kconfig     |  2 +-
 drivers/staging/media/atomisp/i2c/ov5693/Makefile    |  2 +-
 .../i2c/ov5693/{ov5693.c => atomisp-ov5693.c}        |  0
 15 files changed, 27 insertions(+), 27 deletions(-)
 rename drivers/staging/media/atomisp/i2c/{ap1302.c => atomisp-ap1302.c} (100%)
 rename drivers/staging/media/atomisp/i2c/{gc0310.c => atomisp-gc0310.c} (100%)
 rename drivers/staging/media/atomisp/i2c/{gc2235.c => atomisp-gc2235.c} (100%)
 rename drivers/staging/media/atomisp/i2c/{libmsrlisthelper.c => atomisp-libmsrlisthelper.c} (100%)
 rename drivers/staging/media/atomisp/i2c/{lm3554.c => atomisp-lm3554.c} (100%)
 rename drivers/staging/media/atomisp/i2c/{mt9m114.c => atomisp-mt9m114.c} (100%)
 rename drivers/staging/media/atomisp/i2c/{ov2680.c => atomisp-ov2680.c} (100%)
 rename drivers/staging/media/atomisp/i2c/{ov2722.c => atomisp-ov2722.c} (100%)
 rename drivers/staging/media/atomisp/i2c/ov5693/{ov5693.c => atomisp-ov5693.c} (100%)

diff --git a/drivers/staging/media/atomisp/i2c/Kconfig b/drivers/staging/media/atomisp/i2c/Kconfig
index 57505b7..09b1a97 100644
--- a/drivers/staging/media/atomisp/i2c/Kconfig
+++ b/drivers/staging/media/atomisp/i2c/Kconfig
@@ -5,7 +5,7 @@
 source "drivers/staging/media/atomisp/i2c/ov5693/Kconfig"
 source "drivers/staging/media/atomisp/i2c/imx/Kconfig"
 
-config VIDEO_OV2722
+config VIDEO_ATOMISP_OV2722
        tristate "OVT ov2722 sensor support"
        depends on I2C && VIDEO_V4L2
        ---help---
@@ -16,7 +16,7 @@ config VIDEO_OV2722
 
 	 It currently only works with the atomisp driver.
 
-config VIDEO_GC2235
+config VIDEO_ATOMISP_GC2235
        tristate "Galaxy gc2235 sensor support"
        depends on I2C && VIDEO_V4L2
        ---help---
@@ -27,7 +27,7 @@ config VIDEO_GC2235
 
 	 It currently only works with the atomisp driver.
 
-config VIDEO_OV8858
+config VIDEO_ATOMISP_OV8858
        tristate "Omnivision ov8858 sensor support"
        depends on I2C && VIDEO_V4L2 && VIDEO_ATOMISP
        ---help---
@@ -38,7 +38,7 @@ config VIDEO_OV8858
 
 	 It currently only works with the atomisp driver.
 
-config VIDEO_MSRLIST_HELPER
+config VIDEO_ATOMISP_MSRLIST_HELPER
        tristate "Helper library to load, parse and apply large register lists."
        depends on I2C
        ---help---
@@ -48,7 +48,7 @@ config VIDEO_MSRLIST_HELPER
 	 To compile this driver as a module, choose M here: the
 	 module will be called libmsrlisthelper.
 
-config VIDEO_MT9M114
+config VIDEO_ATOMISP_MT9M114
        tristate "Aptina mt9m114 sensor support"
        depends on I2C && VIDEO_V4L2
        ---help---
@@ -59,7 +59,7 @@ config VIDEO_MT9M114
 
 	 It currently only works with the atomisp driver.
 
-config VIDEO_AP1302
+config VIDEO_ATOMISP_AP1302
        tristate "AP1302 external ISP support"
        depends on I2C && VIDEO_V4L2
        select REGMAP_I2C
@@ -71,14 +71,14 @@ config VIDEO_AP1302
 
 	 It currently only works with the atomisp driver.
 
-config VIDEO_GC0310
+config VIDEO_ATOMISP_GC0310
 	tristate "GC0310 sensor support"
 	depends on I2C && VIDEO_V4L2
 	---help---
 	  This is a Video4Linux2 sensor-level driver for the Galaxycore
 	  GC0310 0.3MP sensor.
 	 
-config VIDEO_OV2680
+config VIDEO_ATOMISP_OV2680
        tristate "Omnivision OV2680 sensor support"
        depends on I2C && VIDEO_V4L2
        ---help---
@@ -93,7 +93,7 @@ config VIDEO_OV2680
 # Kconfig for flash drivers
 #
 
-config VIDEO_LM3554
+config VIDEO_ATOMISP_LM3554
        tristate "LM3554 flash light driver"
        depends on VIDEO_V4L2 && I2C
        ---help---
diff --git a/drivers/staging/media/atomisp/i2c/Makefile b/drivers/staging/media/atomisp/i2c/Makefile
index be13fab..3d27c75 100644
--- a/drivers/staging/media/atomisp/i2c/Makefile
+++ b/drivers/staging/media/atomisp/i2c/Makefile
@@ -2,22 +2,22 @@
 # Makefile for sensor drivers
 #
 
-obj-$(CONFIG_VIDEO_IMX)        += imx/
-obj-$(CONFIG_VIDEO_OV5693)     += ov5693/
-obj-$(CONFIG_VIDEO_MT9M114)    += mt9m114.o
-obj-$(CONFIG_VIDEO_GC2235)     += gc2235.o
-obj-$(CONFIG_VIDEO_OV2722)     += ov2722.o
-obj-$(CONFIG_VIDEO_OV2680)     += ov2680.o
-obj-$(CONFIG_VIDEO_GC0310)     += gc0310.o
+obj-$(CONFIG_VIDEO_ATOMISP_IMX)        += imx/
+obj-$(CONFIG_VIDEO_ATOMISP_OV5693)     += ov5693/
+obj-$(CONFIG_VIDEO_ATOMISP_MT9M114)    += atomisp-mt9m114.o
+obj-$(CONFIG_VIDEO_ATOMISP_GC2235)     += atomisp-gc2235.o
+obj-$(CONFIG_VIDEO_ATOMISP_OV2722)     += atomisp-ov2722.o
+obj-$(CONFIG_VIDEO_ATOMISP_OV2680)     += atomisp-ov2680.o
+obj-$(CONFIG_VIDEO_ATOMISP_GC0310)     += atomisp-gc0310.o
 
-obj-$(CONFIG_VIDEO_MSRLIST_HELPER) += libmsrlisthelper.o
+obj-$(CONFIG_VIDEO_ATOMISP_MSRLIST_HELPER) += atomisp-libmsrlisthelper.o
 
-obj-$(CONFIG_VIDEO_AP1302)     += ap1302.o
+obj-$(CONFIG_VIDEO_ATOMISP_AP1302)     += atomisp-ap1302.o
 
 # Makefile for flash drivers
 #
 
-obj-$(CONFIG_VIDEO_LM3554) += lm3554.o
+obj-$(CONFIG_VIDEO_ATOMISP_LM3554) += atomisp-lm3554.o
 
 # HACK! While this driver is in bad shape, don't enable several warnings
 #       that would be otherwise enabled with W=1
diff --git a/drivers/staging/media/atomisp/i2c/ap1302.c b/drivers/staging/media/atomisp/i2c/atomisp-ap1302.c
similarity index 100%
rename from drivers/staging/media/atomisp/i2c/ap1302.c
rename to drivers/staging/media/atomisp/i2c/atomisp-ap1302.c
diff --git a/drivers/staging/media/atomisp/i2c/gc0310.c b/drivers/staging/media/atomisp/i2c/atomisp-gc0310.c
similarity index 100%
rename from drivers/staging/media/atomisp/i2c/gc0310.c
rename to drivers/staging/media/atomisp/i2c/atomisp-gc0310.c
diff --git a/drivers/staging/media/atomisp/i2c/gc2235.c b/drivers/staging/media/atomisp/i2c/atomisp-gc2235.c
similarity index 100%
rename from drivers/staging/media/atomisp/i2c/gc2235.c
rename to drivers/staging/media/atomisp/i2c/atomisp-gc2235.c
diff --git a/drivers/staging/media/atomisp/i2c/libmsrlisthelper.c b/drivers/staging/media/atomisp/i2c/atomisp-libmsrlisthelper.c
similarity index 100%
rename from drivers/staging/media/atomisp/i2c/libmsrlisthelper.c
rename to drivers/staging/media/atomisp/i2c/atomisp-libmsrlisthelper.c
diff --git a/drivers/staging/media/atomisp/i2c/lm3554.c b/drivers/staging/media/atomisp/i2c/atomisp-lm3554.c
similarity index 100%
rename from drivers/staging/media/atomisp/i2c/lm3554.c
rename to drivers/staging/media/atomisp/i2c/atomisp-lm3554.c
diff --git a/drivers/staging/media/atomisp/i2c/mt9m114.c b/drivers/staging/media/atomisp/i2c/atomisp-mt9m114.c
similarity index 100%
rename from drivers/staging/media/atomisp/i2c/mt9m114.c
rename to drivers/staging/media/atomisp/i2c/atomisp-mt9m114.c
diff --git a/drivers/staging/media/atomisp/i2c/ov2680.c b/drivers/staging/media/atomisp/i2c/atomisp-ov2680.c
similarity index 100%
rename from drivers/staging/media/atomisp/i2c/ov2680.c
rename to drivers/staging/media/atomisp/i2c/atomisp-ov2680.c
diff --git a/drivers/staging/media/atomisp/i2c/ov2722.c b/drivers/staging/media/atomisp/i2c/atomisp-ov2722.c
similarity index 100%
rename from drivers/staging/media/atomisp/i2c/ov2722.c
rename to drivers/staging/media/atomisp/i2c/atomisp-ov2722.c
diff --git a/drivers/staging/media/atomisp/i2c/imx/Kconfig b/drivers/staging/media/atomisp/i2c/imx/Kconfig
index a39eeb3..c4356c1 100644
--- a/drivers/staging/media/atomisp/i2c/imx/Kconfig
+++ b/drivers/staging/media/atomisp/i2c/imx/Kconfig
@@ -1,6 +1,6 @@
-config VIDEO_IMX
+config VIDEO_ATOMISP_IMX
 	tristate "sony imx sensor support"
-	depends on I2C && VIDEO_V4L2 && VIDEO_MSRLIST_HELPER && m
+	depends on I2C && VIDEO_V4L2 && VIDEO_ATOMISP_MSRLIST_HELPER && m
 	---help---
 	  This is a Video4Linux2 sensor-level driver for the Sony
 	  IMX RAW sensor.
diff --git a/drivers/staging/media/atomisp/i2c/imx/Makefile b/drivers/staging/media/atomisp/i2c/imx/Makefile
index b6578f0..f3e2891 100644
--- a/drivers/staging/media/atomisp/i2c/imx/Makefile
+++ b/drivers/staging/media/atomisp/i2c/imx/Makefile
@@ -1,9 +1,9 @@
-obj-$(CONFIG_VIDEO_IMX) += imx1x5.o
+obj-$(CONFIG_VIDEO_ATOMISP_IMX) += atomisp-imx1x5.o
 
-imx1x5-objs := imx.o drv201.o ad5816g.o dw9714.o dw9719.o dw9718.o vcm.o otp.o otp_imx.o otp_brcc064_e2prom.o otp_e2prom.o
+atomisp-imx1x5-objs := imx.o drv201.o ad5816g.o dw9714.o dw9719.o dw9718.o vcm.o otp.o otp_imx.o otp_brcc064_e2prom.o otp_e2prom.o
 
-ov8858_driver-objs := ../ov8858.o dw9718.o vcm.o
-obj-$(CONFIG_VIDEO_OV8858)     += ov8858_driver.o
+atomisp-ov8858-objs := ../ov8858.o dw9718.o vcm.o
+obj-$(CONFIG_VIDEO_ATOMISP_OV8858)     += atomisp-ov8858.o
 
 # HACK! While this driver is in bad shape, don't enable several warnings
 #       that would be otherwise enabled with W=1
diff --git a/drivers/staging/media/atomisp/i2c/ov5693/Kconfig b/drivers/staging/media/atomisp/i2c/ov5693/Kconfig
index 9e8d325..5fe4113 100644
--- a/drivers/staging/media/atomisp/i2c/ov5693/Kconfig
+++ b/drivers/staging/media/atomisp/i2c/ov5693/Kconfig
@@ -1,4 +1,4 @@
-config VIDEO_OV5693
+config VIDEO_ATOMISP_OV5693
        tristate "Omnivision ov5693 sensor support"
        depends on I2C && VIDEO_V4L2
        ---help---
diff --git a/drivers/staging/media/atomisp/i2c/ov5693/Makefile b/drivers/staging/media/atomisp/i2c/ov5693/Makefile
index 4e3833a..2de7000 100644
--- a/drivers/staging/media/atomisp/i2c/ov5693/Makefile
+++ b/drivers/staging/media/atomisp/i2c/ov5693/Makefile
@@ -1,4 +1,4 @@
-obj-$(CONFIG_VIDEO_OV5693) += ov5693.o
+obj-$(CONFIG_VIDEO_ATOMISP_OV5693) += atomisp-ov5693.o
 
 # HACK! While this driver is in bad shape, don't enable several warnings
 #       that would be otherwise enabled with W=1
diff --git a/drivers/staging/media/atomisp/i2c/ov5693/ov5693.c b/drivers/staging/media/atomisp/i2c/ov5693/atomisp-ov5693.c
similarity index 100%
rename from drivers/staging/media/atomisp/i2c/ov5693/ov5693.c
rename to drivers/staging/media/atomisp/i2c/ov5693/atomisp-ov5693.c
-- 
2.7.4
