Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:39658 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S933712AbcIOL3a (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Sep 2016 07:29:30 -0400
Received: from lanttu.localdomain (unknown [192.168.15.166])
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id E8641600A5
        for <linux-media@vger.kernel.org>; Thu, 15 Sep 2016 14:29:25 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 5/5] smiapp: Implement support for autosuspend
Date: Thu, 15 Sep 2016 14:29:21 +0300
Message-Id: <1473938961-16067-6-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1473938961-16067-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1473938961-16067-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Delay suspending the device by 1000 ms by default.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp/smiapp-core.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index ba5ad36..313f037 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -1559,7 +1559,8 @@ static int smiapp_set_stream(struct v4l2_subdev *subdev, int enable)
 		rval = smiapp_stop_streaming(sensor);
 		sensor->streaming = false;
 
-		pm_runtime_put(&client->dev);
+		pm_runtime_mark_last_busy(&client->dev);
+		pm_runtime_put_autosuspend(&client->dev);
 	}
 
 	return rval;
@@ -2327,7 +2328,8 @@ smiapp_sysfs_nvm_read(struct device *dev, struct device_attribute *attr,
 			dev_err(&client->dev, "nvm read failed\n");
 			return -ENODEV;
 		}
-		pm_runtime_put(&client->dev);
+		pm_runtime_mark_last_busy(&client->dev);
+		pm_runtime_put_autosuspend(&client->dev);
 	}
 	/*
 	 * NVM is still way below a PAGE_SIZE, so we can safely
@@ -3038,7 +3040,9 @@ static int smiapp_probe(struct i2c_client *client,
 	if (rval < 0)
 		goto out_media_entity_cleanup;
 
-	pm_runtime_put(&client->dev);
+	pm_runtime_set_autosuspend_delay(&client->dev, 1000);
+	pm_runtime_use_autosuspend(&client->dev);
+	pm_runtime_put_autosuspend(&client->dev);
 
 	return 0;
 
-- 
2.1.4

