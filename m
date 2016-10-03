Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:50244 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751365AbcJCI5F (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 3 Oct 2016 04:57:05 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: sre@kernel.org
Subject: [PATCH v1.2 5/5] smiapp: Implement support for autosuspend
Date: Mon,  3 Oct 2016 11:57:02 +0300
Message-Id: <1475485022-20484-1-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1474374598-32451-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1474374598-32451-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Delay suspending the device by 1000 ms by default. This is done on
explicit power off through s_power() callback, through releasing the
file descriptor, NVM read or when the probe finishes.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
since v1.1:

- More or less just rebased. The previous patch changed quite a bit so
  this one did as well.

 drivers/media/i2c/smiapp/smiapp-core.c | 29 +++++++++++++++++++----------
 1 file changed, 19 insertions(+), 10 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index 68adc1b..44e32cf 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -1380,17 +1380,22 @@ static int smiapp_power_off(struct device *dev)
 
 static int smiapp_set_power(struct v4l2_subdev *subdev, int on)
 {
-	int rval = 0;
+	int rval;
 
-	if (on) {
-		rval = pm_runtime_get_sync(subdev->dev);
-		if (rval >= 0)
-			return 0;
+	if (!on) {
+		pm_runtime_mark_last_busy(subdev->dev);
+		pm_runtime_put_autosuspend(subdev->dev);
 
-		if (rval != -EBUSY && rval != -EAGAIN)
-			pm_runtime_set_active(subdev->dev);
+		return 0;
 	}
 
+	rval = pm_runtime_get_sync(subdev->dev);
+	if (rval >= 0)
+		return 0;
+
+	if (rval != -EBUSY && rval != -EAGAIN)
+		pm_runtime_set_active(subdev->dev);
+
 	pm_runtime_put(subdev->dev);
 
 	return rval;
@@ -2340,7 +2345,8 @@ smiapp_sysfs_nvm_read(struct device *dev, struct device_attribute *attr,
 			return -ENODEV;
 		}
 
-		pm_runtime_put(&client->dev);
+		pm_runtime_mark_last_busy(&client->dev);
+		pm_runtime_put_autosuspend(&client->dev);
 	}
 	/*
 	 * NVM is still way below a PAGE_SIZE, so we can safely
@@ -2681,7 +2687,8 @@ static int smiapp_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
 
 static int smiapp_close(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
 {
-	pm_runtime_put(sd->dev);
+	pm_runtime_mark_last_busy(&client->dev);
+	pm_runtime_put_autosuspend(&client->dev);
 
 	return 0;
 }
@@ -3093,7 +3100,9 @@ static int smiapp_probe(struct i2c_client *client,
 	if (rval < 0)
 		goto out_media_entity_cleanup;
 
-	pm_runtime_put(&client->dev);
+	pm_runtime_set_autosuspend_delay(&client->dev, 1000);
+	pm_runtime_use_autosuspend(&client->dev);
+	pm_runtime_put_autosuspend(&client->dev);
 
 	return 0;
 
-- 
2.1.4

