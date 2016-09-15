Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:55488 "EHLO
        lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754147AbcIOPSU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Sep 2016 11:18:20 -0400
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Cc: Charles-Antoine Couret <charles-antoine.couret@nexvision.fr>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] media Kconfig: improve the spi integration
Message-ID: <e793397c-d545-cd60-6510-98682ceca2b4@xs4all.nl>
Date: Thu, 15 Sep 2016 17:18:14 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The SPI driver looked a bit lonely in the config menu, and it didn't
support the autoselect. Shift things around a bit so it looks more logical.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
Note: this patch sits on top of the gs1662 patch series.
---
 drivers/media/Kconfig     | 8 ++++----
 drivers/media/i2c/Kconfig | 2 +-
 drivers/media/spi/Kconfig | 5 +++++
 3 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
index 6600e59..7b85402 100644
--- a/drivers/media/Kconfig
+++ b/drivers/media/Kconfig
@@ -180,14 +180,14 @@ source "drivers/media/firewire/Kconfig"
 # Common driver options
 source "drivers/media/common/Kconfig"

-comment "Media ancillary drivers (tuners, sensors, i2c, frontends)"
+comment "Media ancillary drivers (tuners, sensors, i2c, spi, frontends)"

 #
-# Ancillary drivers (tuners, i2c, frontends)
+# Ancillary drivers (tuners, i2c, spi, frontends)
 #

 config MEDIA_SUBDRV_AUTOSELECT
-	bool "Autoselect ancillary drivers (tuners, sensors, i2c, frontends)"
+	bool "Autoselect ancillary drivers (tuners, sensors, i2c, spi, frontends)"
 	depends on MEDIA_ANALOG_TV_SUPPORT || MEDIA_DIGITAL_TV_SUPPORT || MEDIA_CAMERA_SUPPORT || MEDIA_SDR_SUPPORT
 	depends on HAS_IOMEM
 	select I2C
@@ -216,8 +216,8 @@ config MEDIA_ATTACH
 	default MODULES

 source "drivers/media/i2c/Kconfig"
+source "drivers/media/spi/Kconfig"
 source "drivers/media/tuners/Kconfig"
 source "drivers/media/dvb-frontends/Kconfig"
-source "drivers/media/spi/Kconfig"

 endif # MEDIA_SUPPORT
diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index 7f92933..2669b4b 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -21,7 +21,7 @@ config VIDEO_IR_I2C
 # Encoder / Decoder module configuration
 #

-menu "Encoders, decoders, sensors and other helper chips"
+menu "I2C Encoders, decoders, sensors and other helper chips"
 	visible if !MEDIA_SUBDRV_AUTOSELECT || COMPILE_TEST

 comment "Audio decoders, processors and mixers"
diff --git a/drivers/media/spi/Kconfig b/drivers/media/spi/Kconfig
index fa47c90..a21f5a3 100644
--- a/drivers/media/spi/Kconfig
+++ b/drivers/media/spi/Kconfig
@@ -1,9 +1,14 @@
 if VIDEO_V4L2

+menu "SPI helper chips"
+	visible if !MEDIA_SUBDRV_AUTOSELECT || COMPILE_TEST
+
 config VIDEO_GS1662
 	tristate "Gennum Serializers video"
 	depends on SPI && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
 	---help---
 	  Enable the GS1662 driver which serializes video streams.

+endmenu
+
 endif
-- 
2.8.1


