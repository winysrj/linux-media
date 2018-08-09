Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:35686 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725757AbeHIECB (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 9 Aug 2018 00:02:01 -0400
Received: by mail-wm0-f65.google.com with SMTP id o18-v6so4710016wmc.0
        for <linux-media@vger.kernel.org>; Wed, 08 Aug 2018 18:39:42 -0700 (PDT)
From: petrcvekcz@gmail.com
To: marek.vasut@gmail.com, mchehab@kernel.org
Cc: Petr Cvek <petrcvekcz@gmail.com>, linux-media@vger.kernel.org,
        robert.jarzmik@free.fr, slapin@ossfans.org, philipp.zabel@gmail.com
Subject: [PATCH v1 2/5] [media] i2c: soc_camera: remove ov9640 Kconfig and Makefile options
Date: Thu,  9 Aug 2018 03:39:46 +0200
Message-Id: <af81f4356fd02b807c62434a7f91993f93c29e08.1533774451.git.petrcvekcz@gmail.com>
In-Reply-To: <cover.1533774451.git.petrcvekcz@gmail.com>
References: <cover.1533774451.git.petrcvekcz@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Petr Cvek <petrcvekcz@gmail.com>

Remove ov9640 config options from soc_camera build files

Signed-off-by: Petr Cvek <petrcvekcz@gmail.com>
---
 drivers/media/i2c/soc_camera/Kconfig  | 6 ------
 drivers/media/i2c/soc_camera/Makefile | 1 -
 2 files changed, 7 deletions(-)

diff --git a/drivers/media/i2c/soc_camera/Kconfig b/drivers/media/i2c/soc_camera/Kconfig
index 7c2aabc8a3f6..f67499187bda 100644
--- a/drivers/media/i2c/soc_camera/Kconfig
+++ b/drivers/media/i2c/soc_camera/Kconfig
@@ -41,12 +41,6 @@ config SOC_CAMERA_OV772X
 	help
 	  This is a ov772x camera driver
 
-config SOC_CAMERA_OV9640
-	tristate "ov9640 camera support"
-	depends on SOC_CAMERA && I2C
-	help
-	  This is a ov9640 camera driver
-
 config SOC_CAMERA_OV9740
 	tristate "ov9740 camera support"
 	depends on SOC_CAMERA && I2C
diff --git a/drivers/media/i2c/soc_camera/Makefile b/drivers/media/i2c/soc_camera/Makefile
index 8c7770f62997..758810abc480 100644
--- a/drivers/media/i2c/soc_camera/Makefile
+++ b/drivers/media/i2c/soc_camera/Makefile
@@ -4,7 +4,6 @@ obj-$(CONFIG_SOC_CAMERA_MT9T112)	+= mt9t112.o
 obj-$(CONFIG_SOC_CAMERA_MT9V022)	+= mt9v022.o
 obj-$(CONFIG_SOC_CAMERA_OV5642)		+= ov5642.o
 obj-$(CONFIG_SOC_CAMERA_OV772X)		+= ov772x.o
-obj-$(CONFIG_SOC_CAMERA_OV9640)		+= ov9640.o
 obj-$(CONFIG_SOC_CAMERA_OV9740)		+= ov9740.o
 obj-$(CONFIG_SOC_CAMERA_RJ54N1)		+= rj54n1cb0c.o
 obj-$(CONFIG_SOC_CAMERA_TW9910)		+= tw9910.o
-- 
2.18.0
