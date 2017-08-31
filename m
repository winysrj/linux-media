Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:31760 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751514AbdHaITn (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 31 Aug 2017 04:19:43 -0400
Received: from nauris.fi.intel.com (nauris.localdomain [192.168.240.2])
        by paasikivi.fi.intel.com (Postfix) with ESMTP id 88A9E2006B
        for <linux-media@vger.kernel.org>; Thu, 31 Aug 2017 11:19:41 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/1] staging: media: atomisp: Use tabs in Kconfig
Date: Thu, 31 Aug 2017 11:17:12 +0300
Message-Id: <1504167432-8723-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use tabs in Kconfig for indentation rather than spaces.

The patch has been created using the following command:

find drivers/staging/media/atomisp/ -name Kconfig| \
	xargs perl -i -pe 's/ {8}/\t/g'

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/staging/media/atomisp/Kconfig            | 10 ++--
 drivers/staging/media/atomisp/i2c/Kconfig        | 70 ++++++++++++------------
 drivers/staging/media/atomisp/i2c/ov5693/Kconfig |  8 +--
 3 files changed, 44 insertions(+), 44 deletions(-)

diff --git a/drivers/staging/media/atomisp/Kconfig b/drivers/staging/media/atomisp/Kconfig
index 8eb13c3..52b86b7 100644
--- a/drivers/staging/media/atomisp/Kconfig
+++ b/drivers/staging/media/atomisp/Kconfig
@@ -1,9 +1,9 @@
 menuconfig INTEL_ATOMISP
-        bool "Enable support to Intel MIPI camera drivers"
-        depends on X86 && EFI && MEDIA_CONTROLLER && PCI && ACPI
-        help
-          Enable support for the Intel ISP2 camera interfaces and MIPI
-          sensor drivers.
+	bool "Enable support to Intel MIPI camera drivers"
+	depends on X86 && EFI && MEDIA_CONTROLLER && PCI && ACPI
+	help
+	  Enable support for the Intel ISP2 camera interfaces and MIPI
+	  sensor drivers.
 
 if INTEL_ATOMISP
 source "drivers/staging/media/atomisp/pci/Kconfig"
diff --git a/drivers/staging/media/atomisp/i2c/Kconfig b/drivers/staging/media/atomisp/i2c/Kconfig
index e628b5c..57505b7 100644
--- a/drivers/staging/media/atomisp/i2c/Kconfig
+++ b/drivers/staging/media/atomisp/i2c/Kconfig
@@ -9,85 +9,85 @@ config VIDEO_OV2722
        tristate "OVT ov2722 sensor support"
        depends on I2C && VIDEO_V4L2
        ---help---
-         This is a Video4Linux2 sensor-level driver for the OVT
-         OV2722 raw camera.
+	 This is a Video4Linux2 sensor-level driver for the OVT
+	 OV2722 raw camera.
 
-         OVT is a 2M raw sensor.
+	 OVT is a 2M raw sensor.
 
-         It currently only works with the atomisp driver.
+	 It currently only works with the atomisp driver.
 
 config VIDEO_GC2235
        tristate "Galaxy gc2235 sensor support"
        depends on I2C && VIDEO_V4L2
        ---help---
-         This is a Video4Linux2 sensor-level driver for the OVT
-         GC2235 raw camera.
+	 This is a Video4Linux2 sensor-level driver for the OVT
+	 GC2235 raw camera.
 
-         GC2235 is a 2M raw sensor.
+	 GC2235 is a 2M raw sensor.
 
-         It currently only works with the atomisp driver.
+	 It currently only works with the atomisp driver.
 
 config VIDEO_OV8858
        tristate "Omnivision ov8858 sensor support"
        depends on I2C && VIDEO_V4L2 && VIDEO_ATOMISP
        ---help---
-         This is a Video4Linux2 sensor-level driver for the Omnivision
-         ov8858 RAW sensor.
+	 This is a Video4Linux2 sensor-level driver for the Omnivision
+	 ov8858 RAW sensor.
 
 	 OV8858 is a 8M raw sensor.
 
-         It currently only works with the atomisp driver.
+	 It currently only works with the atomisp driver.
 
 config VIDEO_MSRLIST_HELPER
        tristate "Helper library to load, parse and apply large register lists."
        depends on I2C
        ---help---
-         This is a helper library to be used from a sensor driver to load, parse
-         and apply large register lists.
+	 This is a helper library to be used from a sensor driver to load, parse
+	 and apply large register lists.
 
-         To compile this driver as a module, choose M here: the
-         module will be called libmsrlisthelper.
+	 To compile this driver as a module, choose M here: the
+	 module will be called libmsrlisthelper.
 
 config VIDEO_MT9M114
        tristate "Aptina mt9m114 sensor support"
        depends on I2C && VIDEO_V4L2
        ---help---
-         This is a Video4Linux2 sensor-level driver for the Micron
-         mt9m114 1.3 Mpixel camera.
+	 This is a Video4Linux2 sensor-level driver for the Micron
+	 mt9m114 1.3 Mpixel camera.
 
-         mt9m114 is video camera sensor.
+	 mt9m114 is video camera sensor.
 
-         It currently only works with the atomisp driver.
+	 It currently only works with the atomisp driver.
 
 config VIDEO_AP1302
        tristate "AP1302 external ISP support"
        depends on I2C && VIDEO_V4L2
        select REGMAP_I2C
        ---help---
-         This is a Video4Linux2 sensor-level driver for the external
-         ISP AP1302.
+	 This is a Video4Linux2 sensor-level driver for the external
+	 ISP AP1302.
 
-         AP1302 is an exteral ISP.
+	 AP1302 is an exteral ISP.
 
-         It currently only works with the atomisp driver.
+	 It currently only works with the atomisp driver.
 
 config VIDEO_GC0310
 	tristate "GC0310 sensor support"
-        depends on I2C && VIDEO_V4L2
-        ---help---
-          This is a Video4Linux2 sensor-level driver for the Galaxycore
-          GC0310 0.3MP sensor.
+	depends on I2C && VIDEO_V4L2
+	---help---
+	  This is a Video4Linux2 sensor-level driver for the Galaxycore
+	  GC0310 0.3MP sensor.
 	 
 config VIDEO_OV2680
        tristate "Omnivision OV2680 sensor support"
        depends on I2C && VIDEO_V4L2
        ---help---
-         This is a Video4Linux2 sensor-level driver for the Omnivision
-         OV2680 raw camera.
+	 This is a Video4Linux2 sensor-level driver for the Omnivision
+	 OV2680 raw camera.
 
-         ov2680 is a 2M raw sensor.
+	 ov2680 is a 2M raw sensor.
 
-         It currently only works with the atomisp driver.
+	 It currently only works with the atomisp driver.
 
 #
 # Kconfig for flash drivers
@@ -97,10 +97,10 @@ config VIDEO_LM3554
        tristate "LM3554 flash light driver"
        depends on VIDEO_V4L2 && I2C
        ---help---
-         This is a Video4Linux2 sub-dev driver for the LM3554
-         flash light driver.
+	 This is a Video4Linux2 sub-dev driver for the LM3554
+	 flash light driver.
 
-         To compile this driver as a module, choose M here: the
-         module will be called lm3554
+	 To compile this driver as a module, choose M here: the
+	 module will be called lm3554
 
 
diff --git a/drivers/staging/media/atomisp/i2c/ov5693/Kconfig b/drivers/staging/media/atomisp/i2c/ov5693/Kconfig
index 9fb1bff..9e8d325 100644
--- a/drivers/staging/media/atomisp/i2c/ov5693/Kconfig
+++ b/drivers/staging/media/atomisp/i2c/ov5693/Kconfig
@@ -2,10 +2,10 @@ config VIDEO_OV5693
        tristate "Omnivision ov5693 sensor support"
        depends on I2C && VIDEO_V4L2
        ---help---
-         This is a Video4Linux2 sensor-level driver for the Micron
-         ov5693 5 Mpixel camera.
+	 This is a Video4Linux2 sensor-level driver for the Micron
+	 ov5693 5 Mpixel camera.
 
-         ov5693 is video camera sensor.
+	 ov5693 is video camera sensor.
 
-         It currently only works with the atomisp driver.
+	 It currently only works with the atomisp driver.
 
-- 
2.7.4
