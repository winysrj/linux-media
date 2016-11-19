Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:44090 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752849AbcKSWYf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 19 Nov 2016 17:24:35 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: arnd@arndb.de
Subject: [PATCH v2 1/2] smiapp: Implement power-on and power-off sequences without runtime PM
Date: Sun, 20 Nov 2016 00:24:25 +0200
Message-Id: <1479594266-3034-2-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1479594266-3034-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1479594266-3034-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Power on the sensor when the module is loaded and power it off when it is
removed.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp/smiapp-core.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index 59872b3..b20886f 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -2741,8 +2741,6 @@ static const struct v4l2_subdev_internal_ops smiapp_internal_ops = {
  * I2C Driver
  */
 
-#ifdef CONFIG_PM
-
 static int smiapp_suspend(struct device *dev)
 {
 	struct i2c_client *client = to_i2c_client(dev);
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
@@ -2915,7 +2906,10 @@ static int smiapp_probe(struct i2c_client *client,
 
 	pm_runtime_enable(&client->dev);
 
-	rval = pm_runtime_get_sync(&client->dev);
+	if (IS_ENABLED(CONFIG_PM))
+		rval = pm_runtime_get_sync(&client->dev);
+	else
+		rval = smiapp_power_on(&client->dev);
 	if (rval < 0) {
 		rval = -ENODEV;
 		goto out_power_off;
@@ -3113,7 +3107,10 @@ static int smiapp_probe(struct i2c_client *client,
 	smiapp_cleanup(sensor);
 
 out_power_off:
-	pm_runtime_put(&client->dev);
+	if (IS_ENABLED(CONFIG_PM))
+		pm_runtime_put(&client->dev);
+	else
+		smiapp_power_off(&client->dev);
 	pm_runtime_disable(&client->dev);
 
 	return rval;
@@ -3127,7 +3124,10 @@ static int smiapp_remove(struct i2c_client *client)
 
 	v4l2_async_unregister_subdev(subdev);
 
-	pm_runtime_suspend(&client->dev);
+	if (IS_ENABLED(CONFIG_PM))
+		pm_runtime_suspend(&client->dev);
+	else
+		smiapp_power_off(&client->dev);
 	pm_runtime_disable(&client->dev);
 
 	for (i = 0; i < sensor->ssds_used; i++) {
-- 
2.1.4

