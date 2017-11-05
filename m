Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:33306 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750817AbdKEXCg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 5 Nov 2017 18:02:36 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: pavel@ucw.cz
Subject: [PATCH 1/1] et8ek8: Select V4L2_FWNODE
Date: Mon,  6 Nov 2017 01:02:34 +0200
Message-Id: <20171105230234.24919-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The et8ek8 driver depends on the V4L2 fwnode, thus add that to Kconfig.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
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
2.11.0
