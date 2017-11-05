Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:33280 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750920AbdKEW6v (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 5 Nov 2017 17:58:51 -0500
Received: from lanttu.localdomain (lanttu-e.localdomain [192.168.1.64])
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 5869B600C9
        for <linux-media@vger.kernel.org>; Mon,  6 Nov 2017 00:58:49 +0200 (EET)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/1] ov13858: Select V4L2_FWNODE
Date: Mon,  6 Nov 2017 00:58:49 +0200
Message-Id: <20171105225849.24614-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The ov13858 driver depends on the V4L2 fwnode, thus add that to Kconfig.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
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
2.11.0
