Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:47578 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752174AbcKRNuW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Nov 2016 08:50:22 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: arnd@arndb.de
Subject: [PATCH 1/1] smiapp: Implement power-on and power-off sequences without runtime PM
Date: Fri, 18 Nov 2016 15:50:16 +0200
Message-Id: <1479477016-28450-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Power on the sensor when the module is loaded and power it off when it is
removed.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
Hi Arnd and others,

The patch is tested with CONFIG_PM set, as the system does I was testing
on did not boot with CONFIG_PM disabled. I'm not really too worried about
this though, the patch is very simple.

Kind regards,
Sakari

 drivers/media/i2c/smiapp/smiapp-core.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index 59872b3..8624dc4 100644
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
@@ -2915,7 +2906,11 @@ static int smiapp_probe(struct i2c_client *client,
 
 	pm_runtime_enable(&client->dev);
 
+#ifdef CONFIG_PM
 	rval = pm_runtime_get_sync(&client->dev);
+#else
+	rval = smiapp_power_on(&client->dev);
+#endif
 	if (rval < 0) {
 		rval = -ENODEV;
 		goto out_power_off;
@@ -3113,7 +3108,11 @@ static int smiapp_probe(struct i2c_client *client,
 	smiapp_cleanup(sensor);
 
 out_power_off:
+#ifdef CONFIG_PM
 	pm_runtime_put(&client->dev);
+#else
+	smiapp_power_off(&client->dev);
+#endif
 	pm_runtime_disable(&client->dev);
 
 	return rval;
@@ -3127,7 +3126,11 @@ static int smiapp_remove(struct i2c_client *client)
 
 	v4l2_async_unregister_subdev(subdev);
 
+#ifdef CONFIG_PM
 	pm_runtime_suspend(&client->dev);
+#else
+	smiapp_power_off(&client->dev);
+#endif
 	pm_runtime_disable(&client->dev);
 
 	for (i = 0; i < sensor->ssds_used; i++) {
-- 
2.1.4

