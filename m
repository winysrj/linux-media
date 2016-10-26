Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.74]:51086 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753446AbcJZUjG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 26 Oct 2016 16:39:06 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Sakari Ailus <sakari.ailus@iki.fi>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Sebastian Reichel <sre@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [media] smiapp: make PM functions as __maybe_unused
Date: Wed, 26 Oct 2016 22:38:01 +0200
Message-Id: <20161026203814.1904690-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The rework of the PM support has caused two functions to
be orphaned when CONFIG_PM is disabled:

media/i2c/smiapp/smiapp-core.c:1352:12: error: 'smiapp_power_off' defined but not used [-Werror=unused-function]
media/i2c/smiapp/smiapp-core.c:1206:12: error: 'smiapp_power_on' defined but not used [-Werror=unused-function]

This changes all four PM entry points to __maybe_unused and
removes the #ifdef markers for consistency. This avoids the
warnings even when something changes again.

Fixes: cbba45d43631 ("[media] smiapp: Use runtime PM")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/i2c/smiapp/smiapp-core.c | 17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index 59872b31f832..fc0142838834 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -1203,7 +1203,7 @@ static int smiapp_setup_flash_strobe(struct smiapp_sensor *sensor)
  * Power management
  */
 
-static int smiapp_power_on(struct device *dev)
+static int __maybe_unused smiapp_power_on(struct device *dev)
 {
 	struct i2c_client *client = to_i2c_client(dev);
 	struct v4l2_subdev *subdev = i2c_get_clientdata(client);
@@ -1349,7 +1349,7 @@ static int smiapp_power_on(struct device *dev)
 	return rval;
 }
 
-static int smiapp_power_off(struct device *dev)
+static int __maybe_unused smiapp_power_off(struct device *dev)
 {
 	struct i2c_client *client = to_i2c_client(dev);
 	struct v4l2_subdev *subdev = i2c_get_clientdata(client);
@@ -2741,9 +2741,7 @@ static const struct v4l2_subdev_internal_ops smiapp_internal_ops = {
  * I2C Driver
  */
 
-#ifdef CONFIG_PM
-
-static int smiapp_suspend(struct device *dev)
+static int __maybe_unused smiapp_suspend(struct device *dev)
 {
 	struct i2c_client *client = to_i2c_client(dev);
 	struct v4l2_subdev *subdev = i2c_get_clientdata(client);
@@ -2768,7 +2766,7 @@ static int smiapp_suspend(struct device *dev)
 	return 0;
 }
 
-static int smiapp_resume(struct device *dev)
+static int __maybe_unused smiapp_resume(struct device *dev)
 {
 	struct i2c_client *client = to_i2c_client(dev);
 	struct v4l2_subdev *subdev = i2c_get_clientdata(client);
@@ -2783,13 +2781,6 @@ static int smiapp_resume(struct device *dev)
 	return rval;
 }
 
-#else
-
-#define smiapp_suspend	NULL
-#define smiapp_resume	NULL
-
-#endif /* CONFIG_PM */
-
 static struct smiapp_hwconfig *smiapp_get_hwconfig(struct device *dev)
 {
 	struct smiapp_hwconfig *hwcfg;
-- 
2.9.0

