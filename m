Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:54318 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2387810AbeGWLvS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Jul 2018 07:51:18 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: devicetree@vger.kernel.org, robh@kernel.org,
        alanx.chiang@intel.com, andy.yeh@intel.com
Subject: [PATCH 2/2] dw9807-vcm: Recognise this is just the VCM bit of the device
Date: Mon, 23 Jul 2018 13:50:39 +0300
Message-Id: <20180723105039.20110-3-sakari.ailus@linux.intel.com>
In-Reply-To: <20180723105039.20110-1-sakari.ailus@linux.intel.com>
References: <20180723105039.20110-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The dw9807 contains a voice coil lens driver as well as an EEPROM. This
driver is just for the VCM. Reflect this in the driver's name --- this is
already the case for the compatible string, for instance.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/Kconfig                    | 2 +-
 drivers/media/i2c/Makefile                   | 2 +-
 drivers/media/i2c/{dw9807.c => dw9807-vcm.c} | 0
 3 files changed, 2 insertions(+), 2 deletions(-)
 rename drivers/media/i2c/{dw9807.c => dw9807-vcm.c} (100%)

diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index 79bbb39f5b0d..20d53c9aa709 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -346,7 +346,7 @@ config VIDEO_DW9714
 	  capability. This is designed for linear control of
 	  voice coil motors, controlled via I2C serial interface.
 
-config VIDEO_DW9807
+config VIDEO_DW9807_VCM
 	tristate "DW9807 lens voice coil support"
 	depends on I2C && VIDEO_V4L2 && MEDIA_CONTROLLER
 	depends on VIDEO_V4L2_SUBDEV_API
diff --git a/drivers/media/i2c/Makefile b/drivers/media/i2c/Makefile
index aa2d793b80cc..39ad6883e0a9 100644
--- a/drivers/media/i2c/Makefile
+++ b/drivers/media/i2c/Makefile
@@ -25,7 +25,7 @@ obj-$(CONFIG_VIDEO_SAA6752HS) += saa6752hs.o
 obj-$(CONFIG_VIDEO_AD5820)  += ad5820.o
 obj-$(CONFIG_VIDEO_AK7375)  += ak7375.o
 obj-$(CONFIG_VIDEO_DW9714)  += dw9714.o
-obj-$(CONFIG_VIDEO_DW9807)  += dw9807.o
+obj-$(CONFIG_VIDEO_DW9807_VCM)  += dw9807-vcm.o
 obj-$(CONFIG_VIDEO_ADV7170) += adv7170.o
 obj-$(CONFIG_VIDEO_ADV7175) += adv7175.o
 obj-$(CONFIG_VIDEO_ADV7180) += adv7180.o
diff --git a/drivers/media/i2c/dw9807.c b/drivers/media/i2c/dw9807-vcm.c
similarity index 100%
rename from drivers/media/i2c/dw9807.c
rename to drivers/media/i2c/dw9807-vcm.c
-- 
2.11.0
