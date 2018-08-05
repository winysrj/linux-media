Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:49773 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726100AbeHEMiI (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 5 Aug 2018 08:38:08 -0400
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: m.chehab@samsung.com, hverkuil@xs4all.nl,
        sakari.ailus@linux.intel.com
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org
Subject: [PATCH] media: i2c: mt9v111: Add VIDEO_V4L2_SUBDEV_API dependency
Date: Sun,  5 Aug 2018 12:33:52 +0200
Message-Id: <1533465232-4067-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix build error caused by the VIDEO_V4L2_SUBDEV_API symbol not being enabled
in Kconfig option by making the driver depend on it.

Builds configured without the VIDEO_V4L2_SUBDEV_API symbol fail with:
drivers/media/i2c/mt9v111.c:801:10: error: implicit declaration of function
'v4l2_subdev_get_try_format';

Fixes: aab7ed1c ("media: i2c: Add driver for Aptina MT9V111")
Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
 drivers/media/i2c/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index 82af974..422c586 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -876,7 +876,7 @@ config VIDEO_MT9V032
 config VIDEO_MT9V111
 	tristate "Aptina MT9V111 sensor support"
 	depends on I2C && VIDEO_V4L2
-	depends on MEDIA_CAMERA_SUPPORT
+	depends on MEDIA_CAMERA_SUPPORT && VIDEO_V4L2_SUBDEV_API
 	help
 	  This is a Video4Linux2 sensor driver for the Aptina/Micron
 	  MT9V111 sensor.
--
2.7.4
