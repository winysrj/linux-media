Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.13]:62684 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934192AbcILPdl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Sep 2016 11:33:41 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>,
        Pavel Machek <pavel@ucw.cz>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] [media] ad5820: use __maybe_unused for PM functions
Date: Mon, 12 Sep 2016 17:32:57 +0200
Message-Id: <20160912153322.3098750-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The new ad5820 driver uses #ifdef to hide the suspend/resume functions,
but gets it wrong when CONFIG_PM_SLEEP is disabled:

drivers/media/i2c/ad5820.c:286:12: error: 'ad5820_resume' defined but not used [-Werror=unused-function]
drivers/media/i2c/ad5820.c:274:12: error: 'ad5820_suspend' defined but not used [-Werror=unused-function]

This replaces the #ifdef with a __maybe_unused annotation that is
simpler and harder to get wrong, avoiding the warning.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Fixes: bee3d5115611 ("[media] ad5820: Add driver for auto-focus coil")
---
 drivers/media/i2c/ad5820.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/media/i2c/ad5820.c b/drivers/media/i2c/ad5820.c
index fd4c5f67163d..beab2f381b81 100644
--- a/drivers/media/i2c/ad5820.c
+++ b/drivers/media/i2c/ad5820.c
@@ -269,9 +269,7 @@ static const struct v4l2_subdev_internal_ops ad5820_internal_ops = {
 /*
  * I2C driver
  */
-#ifdef CONFIG_PM
-
-static int ad5820_suspend(struct device *dev)
+static int __maybe_unused ad5820_suspend(struct device *dev)
 {
 	struct i2c_client *client = container_of(dev, struct i2c_client, dev);
 	struct v4l2_subdev *subdev = i2c_get_clientdata(client);
@@ -283,7 +281,7 @@ static int ad5820_suspend(struct device *dev)
 	return ad5820_power_off(coil, false);
 }
 
-static int ad5820_resume(struct device *dev)
+static int __maybe_unused ad5820_resume(struct device *dev)
 {
 	struct i2c_client *client = container_of(dev, struct i2c_client, dev);
 	struct v4l2_subdev *subdev = i2c_get_clientdata(client);
@@ -295,13 +293,6 @@ static int ad5820_resume(struct device *dev)
 	return ad5820_power_on(coil, true);
 }
 
-#else
-
-#define ad5820_suspend	NULL
-#define ad5820_resume	NULL
-
-#endif /* CONFIG_PM */
-
 static int ad5820_probe(struct i2c_client *client,
 			const struct i2c_device_id *devid)
 {
-- 
2.9.0

