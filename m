Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:44921 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755235AbaGOBJt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Jul 2014 21:09:49 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 09/18] Kconfig: add SDR support
Date: Tue, 15 Jul 2014 04:09:12 +0300
Message-Id: <1405386561-30450-9-git-send-email-crope@iki.fi>
In-Reply-To: <1405386561-30450-1-git-send-email-crope@iki.fi>
References: <1405386561-30450-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add software defined radio device support for media Kconfig.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/Kconfig     | 11 +++++++++--
 drivers/media/usb/Kconfig |  4 ++++
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
index 1d0758a..3c89fcb 100644
--- a/drivers/media/Kconfig
+++ b/drivers/media/Kconfig
@@ -59,6 +59,13 @@ config MEDIA_RADIO_SUPPORT
 		support radio reception. Disabling this option will
 		disable support for them.
 
+config MEDIA_SDR_SUPPORT
+	bool "Software defined radio support"
+	---help---
+	  Enable software defined radio support.
+
+	  Say Y when you have a software defined radio device.
+
 config MEDIA_RC_SUPPORT
 	bool "Remote Controller support"
 	depends on INPUT
@@ -95,7 +102,7 @@ config MEDIA_CONTROLLER
 config VIDEO_DEV
 	tristate
 	depends on MEDIA_SUPPORT
-	depends on MEDIA_CAMERA_SUPPORT || MEDIA_ANALOG_TV_SUPPORT || MEDIA_RADIO_SUPPORT
+	depends on MEDIA_CAMERA_SUPPORT || MEDIA_ANALOG_TV_SUPPORT || MEDIA_RADIO_SUPPORT || MEDIA_SDR_SUPPORT
 	default y
 
 config VIDEO_V4L2_SUBDEV_API
@@ -171,7 +178,7 @@ comment "Media ancillary drivers (tuners, sensors, i2c, frontends)"
 
 config MEDIA_SUBDRV_AUTOSELECT
 	bool "Autoselect ancillary drivers (tuners, sensors, i2c, frontends)"
-	depends on MEDIA_ANALOG_TV_SUPPORT || MEDIA_DIGITAL_TV_SUPPORT || MEDIA_CAMERA_SUPPORT
+	depends on MEDIA_ANALOG_TV_SUPPORT || MEDIA_DIGITAL_TV_SUPPORT || MEDIA_CAMERA_SUPPORT || MEDIA_SDR_SUPPORT
 	depends on HAS_IOMEM
 	select I2C
 	select I2C_MUX
diff --git a/drivers/media/usb/Kconfig b/drivers/media/usb/Kconfig
index 39d824e..f8c1099 100644
--- a/drivers/media/usb/Kconfig
+++ b/drivers/media/usb/Kconfig
@@ -52,5 +52,9 @@ if (MEDIA_CAMERA_SUPPORT || MEDIA_ANALOG_TV_SUPPORT || MEDIA_DIGITAL_TV_SUPPORT)
 source "drivers/media/usb/em28xx/Kconfig"
 endif
 
+if MEDIA_SDR_SUPPORT
+	comment "Software defined radio USB devices"
+endif
+
 endif #MEDIA_USB_SUPPORT
 endif #USB
-- 
1.9.3

