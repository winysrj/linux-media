Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.134]:55728 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752756AbdKMN5P (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Nov 2017 08:57:15 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Pavel Machek <pavel@ucw.cz>, Sakari Ailus <sakari.ailus@iki.fi>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] media: et8ek8: select V4L2_FWNODE
Date: Mon, 13 Nov 2017 14:56:45 +0100
Message-Id: <20171113135658.3208951-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

v4l2_async_register_subdev_sensor_common() is only provided when
CONFIG_V4L2_FWNODE is enabled, otherwise we get a link failure:

drivers/media/i2c/et8ek8/et8ek8_driver.o: In function `et8ek8_probe':
et8ek8_driver.c:(.text+0x884): undefined reference to `v4l2_async_register_subdev_sensor_common'

This adds a Kconfig 'select' statement like all the other users of
this interface have.

Fixes: d8932f38c10f ("media: et8ek8: Add support for flash and lens devices")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/i2c/et8ek8/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/i2c/et8ek8/Kconfig b/drivers/media/i2c/et8ek8/Kconfig
index 14399365ad7f..9fe409e95666 100644
--- a/drivers/media/i2c/et8ek8/Kconfig
+++ b/drivers/media/i2c/et8ek8/Kconfig
@@ -1,6 +1,7 @@
 config VIDEO_ET8EK8
 	tristate "ET8EK8 camera sensor support"
 	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
+	select V4L2_FWNODE
 	---help---
 	  This is a driver for the Toshiba ET8EK8 5 MP camera sensor.
 	  It is used for example in Nokia N900 (RX-51).
-- 
2.9.0
