Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:44838 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932818AbcITMbI (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Sep 2016 08:31:08 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: sre@kernel.org
Subject: [PATCH v1.1 5/5] smiapp: Implement support for autosuspend
Date: Tue, 20 Sep 2016 15:29:58 +0300
Message-Id: <1474374598-32451-1-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1473938961-16067-6-git-send-email-sakari.ailus@linux.intel.com>
References: <1473938961-16067-6-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Delay suspending the device by 1000 ms by default.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---

since v1:

- Increment usage count before register write using
  pm_runtime_get_noresume(), and decrement it before returning. This
  avoids a serialisation problem with autosuspend.

 drivers/media/i2c/smiapp/smiapp-core.c | 10 +++++++---
 drivers/media/i2c/smiapp/smiapp-regs.c | 21 +++++++++++++++------
 2 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index f1c95bf..77c0a26 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -1556,7 +1556,8 @@ static int smiapp_set_stream(struct v4l2_subdev *subdev, int enable)
 		rval = smiapp_stop_streaming(sensor);
 		sensor->streaming = false;
 
-		pm_runtime_put(&client->dev);
+		pm_runtime_mark_last_busy(&client->dev);
+		pm_runtime_put_autosuspend(&client->dev);
 	}
 
 	return rval;
@@ -2324,7 +2325,8 @@ smiapp_sysfs_nvm_read(struct device *dev, struct device_attribute *attr,
 			dev_err(&client->dev, "nvm read failed\n");
 			return -ENODEV;
 		}
-		pm_runtime_put(&client->dev);
+		pm_runtime_mark_last_busy(&client->dev);
+		pm_runtime_put_autosuspend(&client->dev);
 	}
 	/*
 	 * NVM is still way below a PAGE_SIZE, so we can safely
@@ -3052,7 +3054,9 @@ static int smiapp_probe(struct i2c_client *client,
 	if (rval < 0)
 		goto out_media_entity_cleanup;
 
-	pm_runtime_put(&client->dev);
+	pm_runtime_set_autosuspend_delay(&client->dev, 1000);
+	pm_runtime_use_autosuspend(&client->dev);
+	pm_runtime_put_autosuspend(&client->dev);
 
 	return 0;
 
diff --git a/drivers/media/i2c/smiapp/smiapp-regs.c b/drivers/media/i2c/smiapp/smiapp-regs.c
index a9c7baf..ef15478 100644
--- a/drivers/media/i2c/smiapp/smiapp-regs.c
+++ b/drivers/media/i2c/smiapp/smiapp-regs.c
@@ -290,16 +290,25 @@ int smiapp_write_no_quirk(struct smiapp_sensor *sensor, u32 reg, u32 val)
 int smiapp_write(struct smiapp_sensor *sensor, u32 reg, u32 val)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(&sensor->src->sd);
-	int rval;
+	int rval = 0;
+
+	pm_runtime_get_noresume(&client->dev);
 
 	if (pm_runtime_suspended(&client->dev))
-		return 0;
+		goto out;
 
 	rval = smiapp_call_quirk(sensor, reg_access, true, &reg, &val);
-	if (rval == -ENOIOCTLCMD)
-		return 0;
+	if (rval == -ENOIOCTLCMD) {
+		rval = 0;
+		goto out;
+	}
 	if (rval < 0)
-		return rval;
+		goto out;
+
+	rval = smiapp_write_no_quirk(sensor, reg, val);
+
+out:
+	pm_runtime_put_autosuspend(&client->dev);
 
-	return smiapp_write_no_quirk(sensor, reg, val);
+	return rval;
 }
-- 
2.7.4

