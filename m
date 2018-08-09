Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr1-f66.google.com ([209.85.221.66]:39723 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725757AbeHIECE (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 9 Aug 2018 00:02:04 -0400
Received: by mail-wr1-f66.google.com with SMTP id h10-v6so3652480wre.6
        for <linux-media@vger.kernel.org>; Wed, 08 Aug 2018 18:39:46 -0700 (PDT)
From: petrcvekcz@gmail.com
To: marek.vasut@gmail.com, mchehab@kernel.org
Cc: Petr Cvek <petrcvekcz@gmail.com>, linux-media@vger.kernel.org,
        robert.jarzmik@free.fr, slapin@ossfans.org, philipp.zabel@gmail.com
Subject: [PATCH v1 3/5] [media] i2c: add ov9640 config option as a standalone v4l2 sensor
Date: Thu,  9 Aug 2018 03:39:47 +0200
Message-Id: <fc84f29c549d67a39e51cd0b35f6a33fe3c57b6c.1533774451.git.petrcvekcz@gmail.com>
In-Reply-To: <cover.1533774451.git.petrcvekcz@gmail.com>
References: <cover.1533774451.git.petrcvekcz@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Petr Cvek <petrcvekcz@gmail.com>

Add ov9640 config option VIDEO_OV9640 to the build files in media/i2c
directory.

Signed-off-by: Petr Cvek <petrcvekcz@gmail.com>
---
 drivers/media/i2c/Kconfig  | 7 +++++++
 drivers/media/i2c/Makefile | 1 +
 2 files changed, 8 insertions(+)

diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index 439f6be08b95..c948b163a567 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -771,6 +771,13 @@ config VIDEO_OV7740
 	  This is a Video4Linux2 sensor driver for the OmniVision
 	  OV7740 VGA camera sensor.
 
+config VIDEO_OV9640
+	tristate "OmniVision OV9640 sensor support"
+	depends on I2C && VIDEO_V4L2
+	help
+	  This is a Video4Linux2 sensor driver for the OmniVision
+	  OV9640 camera sensor.
+
 config VIDEO_OV9650
 	tristate "OmniVision OV9650/OV9652 sensor support"
 	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
diff --git a/drivers/media/i2c/Makefile b/drivers/media/i2c/Makefile
index 837c428339df..9cc951f9c041 100644
--- a/drivers/media/i2c/Makefile
+++ b/drivers/media/i2c/Makefile
@@ -77,6 +77,7 @@ obj-$(CONFIG_VIDEO_OV7640) += ov7640.o
 obj-$(CONFIG_VIDEO_OV7670) += ov7670.o
 obj-$(CONFIG_VIDEO_OV772X) += ov772x.o
 obj-$(CONFIG_VIDEO_OV7740) += ov7740.o
+obj-$(CONFIG_VIDEO_OV9640) += ov9640.o
 obj-$(CONFIG_VIDEO_OV9650) += ov9650.o
 obj-$(CONFIG_VIDEO_OV13858) += ov13858.o
 obj-$(CONFIG_VIDEO_MT9M032) += mt9m032.o
-- 
2.18.0
