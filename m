Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:27281 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751387AbeABLNJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 2 Jan 2018 06:13:09 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: rajmohan.mani@intel.com
Subject: [RESEND PATCH 2/2] dw9714: Remove client field in driver's struct
Date: Tue,  2 Jan 2018 13:12:12 +0200
Message-Id: <1514891532-19348-3-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1514891532-19348-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1514891532-19348-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The client field in driver's struct is redundant. Remove it.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/dw9714.c | 19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

diff --git a/drivers/media/i2c/dw9714.c b/drivers/media/i2c/dw9714.c
index 7832210..57460da 100644
--- a/drivers/media/i2c/dw9714.c
+++ b/drivers/media/i2c/dw9714.c
@@ -42,7 +42,6 @@
 
 /* dw9714 device structure */
 struct dw9714_device {
-	struct i2c_client *client;
 	struct v4l2_ctrl_handler ctrls_vcm;
 	struct v4l2_subdev sd;
 	u16 current_val;
@@ -73,7 +72,7 @@ static int dw9714_i2c_write(struct i2c_client *client, u16 data)
 
 static int dw9714_t_focus_vcm(struct dw9714_device *dw9714_dev, u16 val)
 {
-	struct i2c_client *client = dw9714_dev->client;
+	struct i2c_client *client = v4l2_get_subdevdata(&dw9714_dev->sd);
 
 	dw9714_dev->current_val = val;
 
@@ -96,13 +95,11 @@ static const struct v4l2_ctrl_ops dw9714_vcm_ctrl_ops = {
 
 static int dw9714_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
 {
-	struct dw9714_device *dw9714_dev = sd_to_dw9714_vcm(sd);
-	struct device *dev = &dw9714_dev->client->dev;
 	int rval;
 
-	rval = pm_runtime_get_sync(dev);
+	rval = pm_runtime_get_sync(sd->dev);
 	if (rval < 0) {
-		pm_runtime_put_noidle(dev);
+		pm_runtime_put_noidle(sd->dev);
 		return rval;
 	}
 
@@ -111,10 +108,7 @@ static int dw9714_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
 
 static int dw9714_close(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
 {
-	struct dw9714_device *dw9714_dev = sd_to_dw9714_vcm(sd);
-	struct device *dev = &dw9714_dev->client->dev;
-
-	pm_runtime_put(dev);
+	pm_runtime_put(sd->dev);
 
 	return 0;
 }
@@ -137,7 +131,6 @@ static int dw9714_init_controls(struct dw9714_device *dev_vcm)
 {
 	struct v4l2_ctrl_handler *hdl = &dev_vcm->ctrls_vcm;
 	const struct v4l2_ctrl_ops *ops = &dw9714_vcm_ctrl_ops;
-	struct i2c_client *client = dev_vcm->client;
 
 	v4l2_ctrl_handler_init(hdl, 1);
 
@@ -145,7 +138,7 @@ static int dw9714_init_controls(struct dw9714_device *dev_vcm)
 			  0, DW9714_MAX_FOCUS_POS, DW9714_FOCUS_STEPS, 0);
 
 	if (hdl->error)
-		dev_err(&client->dev, "%s fail error: 0x%x\n",
+		dev_err(dev_vcm->sd.dev, "%s fail error: 0x%x\n",
 			__func__, hdl->error);
 	dev_vcm->sd.ctrl_handler = hdl;
 	return hdl->error;
@@ -161,8 +154,6 @@ static int dw9714_probe(struct i2c_client *client)
 	if (dw9714_dev == NULL)
 		return -ENOMEM;
 
-	dw9714_dev->client = client;
-
 	v4l2_i2c_subdev_init(&dw9714_dev->sd, client, &dw9714_ops);
 	dw9714_dev->sd.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
 	dw9714_dev->sd.internal_ops = &dw9714_int_ops;
-- 
2.7.4
