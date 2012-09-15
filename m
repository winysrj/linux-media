Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:43528 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753847Ab2IOVmJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Sep 2012 17:42:09 -0400
Received: from localhost.localdomain (salottisipuli.retiisi.org.uk [IPv6:2001:1bc8:102:6d9a::83:2])
	by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 4D2BB6009C
	for <linux-media@vger.kernel.org>; Sun, 16 Sep 2012 00:42:07 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [PATCH 2/2] smiapp: Provide module identification information through sysfs
Date: Sun, 16 Sep 2012 00:43:29 +0300
Message-Id: <1347745409-21003-2-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <5054F66C.1050400@iki.fi>
References: <5054F66C.1050400@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@iki.if>

Provide module ident information through sysfs.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.if>
---
 drivers/media/i2c/smiapp/smiapp-core.c |   28 ++++++++++++++++++++++++++--
 1 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index 02bfa44..e08e588 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -2211,6 +2211,21 @@ smiapp_sysfs_nvm_read(struct device *dev, struct device_attribute *attr,
 }
 static DEVICE_ATTR(nvm, S_IRUGO, smiapp_sysfs_nvm_read, NULL);
 
+static ssize_t
+smiapp_sysfs_ident_read(struct device *dev, struct device_attribute *attr,
+			char *buf)
+{
+	struct v4l2_subdev *subdev = i2c_get_clientdata(to_i2c_client(dev));
+	struct smiapp_sensor *sensor = to_smiapp_sensor(subdev);
+	struct smiapp_module_info *minfo = &sensor->minfo;
+
+	return snprintf(buf, PAGE_SIZE, "%2.2x%4.4x%2.2x\n",
+			minfo->manufacturer_id, minfo->model_id,
+			minfo->revision_number_major) + 1;
+}
+
+static DEVICE_ATTR(ident, S_IRUGO, smiapp_sysfs_ident_read, NULL);
+
 /* -----------------------------------------------------------------------------
  * V4L2 subdev core operations
  */
@@ -2467,6 +2482,11 @@ static int smiapp_registered(struct v4l2_subdev *subdev)
 	sensor->binning_horizontal = 1;
 	sensor->binning_vertical = 1;
 
+	if (device_create_file(&client->dev, &dev_attr_ident) != 0) {
+		dev_err(&client->dev, "sysfs ident entry creation failed\n");
+		rval = -ENOENT;
+		goto out_power_off;
+	}
 	/* SMIA++ NVM initialization - it will be read from the sensor
 	 * when it is first requested by userspace.
 	 */
@@ -2476,13 +2496,13 @@ static int smiapp_registered(struct v4l2_subdev *subdev)
 		if (sensor->nvm == NULL) {
 			dev_err(&client->dev, "nvm buf allocation failed\n");
 			rval = -ENOMEM;
-			goto out_power_off;
+			goto out_ident_release;
 		}
 
 		if (device_create_file(&client->dev, &dev_attr_nvm) != 0) {
 			dev_err(&client->dev, "sysfs nvm entry failed\n");
 			rval = -EBUSY;
-			goto out_power_off;
+			goto out_ident_release;
 		}
 	}
 
@@ -2637,6 +2657,9 @@ static int smiapp_registered(struct v4l2_subdev *subdev)
 out_nvm_release:
 	device_remove_file(&client->dev, &dev_attr_nvm);
 
+out_ident_release:
+	device_remove_file(&client->dev, &dev_attr_ident);
+
 out_power_off:
 	smiapp_power_off(sensor);
 
@@ -2832,6 +2855,7 @@ static int __exit smiapp_remove(struct i2c_client *client)
 		sensor->power_count = 0;
 	}
 
+	device_remove_file(&client->dev, &dev_attr_ident);
 	if (sensor->nvm)
 		device_remove_file(&client->dev, &dev_attr_nvm);
 
-- 
1.7.2.5

