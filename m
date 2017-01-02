Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:37988 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1755556AbdABUn5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 2 Jan 2017 15:43:57 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 1/1] smiapp: Use runtime PM for power iff CONFIG_PM is defined
Date: Mon,  2 Jan 2017 22:43:53 +0200
Message-Id: <1483389833-29790-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If CONFIG_PM is defined, always use runtime PM to manage power to the
device. Controlling the power state directly in probe does have the
problem of ignoring the device parent power management. Fix this.

Fixes: commit 9447082ae666 ("[media] smiapp: Implement power-on and power-off sequences without runtime PM")
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
---
 drivers/media/i2c/smiapp/smiapp-core.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index e290601..0ea0303 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -2904,9 +2904,16 @@ static int smiapp_probe(struct i2c_client *client,
 	if (IS_ERR(sensor->xshutdown))
 		return PTR_ERR(sensor->xshutdown);
 
+	pm_runtime_set_suspended(&client->dev);
+	pm_runtime_enable(&client->dev);
+	rval = pm_runtime_get_sync(&client->dev);
+	if (rval < 0)
+		goto out_power_off;
+#ifndef CONFIG_PM
 	rval = smiapp_power_on(&client->dev);
 	if (rval < 0)
 		return rval;
+#endif
 
 	rval = smiapp_identify_module(sensor);
 	if (rval) {
@@ -3087,12 +3094,12 @@ static int smiapp_probe(struct i2c_client *client,
 	if (rval < 0)
 		goto out_media_entity_cleanup;
 
-	pm_runtime_set_active(&client->dev);
-	pm_runtime_get_noresume(&client->dev);
-	pm_runtime_enable(&client->dev);
 	pm_runtime_set_autosuspend_delay(&client->dev, 1000);
 	pm_runtime_use_autosuspend(&client->dev);
 	pm_runtime_put_autosuspend(&client->dev);
+#ifndef CONFIG_PM
+	smiapp_power_off(&client->dev);
+#endif
 
 	return 0;
 
@@ -3103,7 +3110,10 @@ static int smiapp_probe(struct i2c_client *client,
 	smiapp_cleanup(sensor);
 
 out_power_off:
+	pm_runtime_put_sync(&client->dev);
+#ifndef CONFIG_PM
 	smiapp_power_off(&client->dev);
+#endif
 
 	return rval;
 }
@@ -3118,8 +3128,11 @@ static int smiapp_remove(struct i2c_client *client)
 
 	pm_runtime_disable(&client->dev);
 	if (!pm_runtime_status_suspended(&client->dev))
-		smiapp_power_off(&client->dev);
+		pm_runtime_suspend(&client->dev);
 	pm_runtime_set_suspended(&client->dev);
+#ifndef CONFIG_PM
+	smiapp_power_off(&client->dev);
+#endif
 
 	for (i = 0; i < sensor->ssds_used; i++) {
 		v4l2_device_unregister_subdev(&sensor->ssds[i].sd);
-- 
2.1.4

