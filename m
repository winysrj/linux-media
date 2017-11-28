Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.73]:60782 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932324AbdK1Ki4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 28 Nov 2017 05:38:56 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] media: ov13858: select V4L2_FWNODE
Date: Tue, 28 Nov 2017 11:38:00 +0100
Message-Id: <20171128103841.490119-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

v4l2_async_register_subdev_sensor_common() is only provided when
CONFIG_V4L2_FWNODE is enabled, otherwise we get a link failure:

drivers/media/i2c/ov13858.o: In function `ov13858_probe':
ov13858.c:(.text+0xf74): undefined reference to `v4l2_async_register_subdev_sensor_common'

This adds a Kconfig 'select' statement like all the other users of
this interface have.

Fixes: 2e8a9fbb7950 ("media: ov13858: Add support for flash and lens devices")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
This is the same patch I submitted for et8ek8 earlier. Both
are needed for 4.15.
---
 drivers/media/i2c/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index 3c6d6428f525..cb5d7ff82915 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -676,6 +676,7 @@ config VIDEO_OV13858
 	tristate "OmniVision OV13858 sensor support"
 	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
 	depends on MEDIA_CAMERA_SUPPORT
+	select V4L2_FWNODE
 	---help---
 	  This is a Video4Linux2 sensor-level driver for the OmniVision
 	  OV13858 camera.
-- 
2.9.0
