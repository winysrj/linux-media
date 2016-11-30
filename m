Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40766 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1758181AbcK3QLm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 Nov 2016 11:11:42 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: stern@rowland.harvard.edu
Cc: laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: [PATCH v2.2 1/2] smiapp: Implement power-on and power-off sequences without runtime PM
Date: Wed, 30 Nov 2016 18:11:36 +0200
Message-Id: <1480522296-24006-1-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1480440533-32685-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1480440533-32685-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Power on the sensor when the module is loaded and power it off when it is
removed.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
since v2.1:

- Power off conditionally, i.e. only if the device was powered.
  pm_runtime_status_suspended() returns false if CONFIG_PM is not set.

 drivers/media/i2c/smiapp/smiapp-core.c | 29 ++++++++++-------------------
 1 file changed, 10 insertions(+), 19 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index 59872b3..620f8ce 100644
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
@@ -2913,13 +2904,9 @@ static int smiapp_probe(struct i2c_client *client,
 	if (IS_ERR(sensor->xshutdown))
 		return PTR_ERR(sensor->xshutdown);
 
-	pm_runtime_enable(&client->dev);
-
-	rval = pm_runtime_get_sync(&client->dev);
-	if (rval < 0) {
-		rval = -ENODEV;
-		goto out_power_off;
-	}
+	rval = smiapp_power_on(&client->dev);
+	if (rval < 0)
+		return rval;
 
 	rval = smiapp_identify_module(sensor);
 	if (rval) {
@@ -3100,6 +3087,9 @@ static int smiapp_probe(struct i2c_client *client,
 	if (rval < 0)
 		goto out_media_entity_cleanup;
 
+	pm_runtime_set_active(&client->dev);
+	pm_runtime_get_noresume(&client->dev);
+	pm_runtime_enable(&client->dev);
 	pm_runtime_set_autosuspend_delay(&client->dev, 1000);
 	pm_runtime_use_autosuspend(&client->dev);
 	pm_runtime_put_autosuspend(&client->dev);
@@ -3113,8 +3103,7 @@ static int smiapp_probe(struct i2c_client *client,
 	smiapp_cleanup(sensor);
 
 out_power_off:
-	pm_runtime_put(&client->dev);
-	pm_runtime_disable(&client->dev);
+	smiapp_power_off(&client->dev);
 
 	return rval;
 }
@@ -3127,8 +3116,10 @@ static int smiapp_remove(struct i2c_client *client)
 
 	v4l2_async_unregister_subdev(subdev);
 
-	pm_runtime_suspend(&client->dev);
 	pm_runtime_disable(&client->dev);
+	if (!pm_runtime_status_suspended(&client->dev))
+		smiapp_power_off(&client->dev);
+	pm_runtime_set_suspended(&client->dev);
 
 	for (i = 0; i < sensor->ssds_used; i++) {
 		v4l2_device_unregister_subdev(&sensor->ssds[i].sd);
-- 
2.1.4

