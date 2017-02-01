Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:52922 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750851AbdBAMsO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 1 Feb 2017 07:48:14 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: pavel@ucw.cz, mchehab@s-opensource.com,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH 1/1] et8ek8: Fix compiler / Coccinelle warnings
Date: Wed,  1 Feb 2017 14:48:06 +0200
Message-Id: <1485953286-19161-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix a compiler warning due to an unused but assigned variable. Also remove
an extra semicolon found by Coccinelle script
scripts/coccinelle/misc/semicolon.cocci.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/et8ek8/et8ek8_driver.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/media/i2c/et8ek8/et8ek8_driver.c b/drivers/media/i2c/et8ek8/et8ek8_driver.c
index 2df3ff4..bec4a56 100644
--- a/drivers/media/i2c/et8ek8/et8ek8_driver.c
+++ b/drivers/media/i2c/et8ek8/et8ek8_driver.c
@@ -1109,7 +1109,7 @@ static int et8ek8_g_priv_mem(struct v4l2_subdev *subdev)
 			if (!(status & 0x08))
 				break;
 			usleep_range(1000, 2000);
-		};
+		}
 
 		if (i == 1000)
 			return -EIO;
@@ -1259,7 +1259,6 @@ et8ek8_registered(struct v4l2_subdev *subdev)
 {
 	struct et8ek8_sensor *sensor = to_et8ek8_sensor(subdev);
 	struct i2c_client *client = v4l2_get_subdevdata(subdev);
-	struct v4l2_mbus_framefmt *format;
 	int rval;
 
 	dev_dbg(&client->dev, "registered!");
@@ -1280,8 +1279,8 @@ et8ek8_registered(struct v4l2_subdev *subdev)
 		goto err_file;
 	}
 
-	format = __et8ek8_get_pad_format(sensor, NULL, 0,
-					 V4L2_SUBDEV_FORMAT_ACTIVE);
+	__et8ek8_get_pad_format(sensor, NULL, 0, V4L2_SUBDEV_FORMAT_ACTIVE);
+
 	return 0;
 
 err_file:
-- 
2.1.4

