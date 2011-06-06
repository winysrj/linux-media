Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.186]:56398 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756426Ab1FFRUv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Jun 2011 13:20:51 -0400
Date: Mon, 6 Jun 2011 19:20:47 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: =?ISO-8859-15?Q?Teresa_G=E1mez?= <t.gamez@phytec.de>,
	Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [PATCH 2/2] V4L: mt9m111: switch to v4l2-subdev .s_power() method
In-Reply-To: <Pine.LNX.4.64.1106061918010.11169@axis700.grange>
Message-ID: <Pine.LNX.4.64.1106061918590.11169@axis700.grange>
References: <Pine.LNX.4.64.1106061918010.11169@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Eliminate soc-camera specific .suspend() and .restore() methods in favour
of the standard v4l2-subdev .s_power() method

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

Please, test both these mt9m111 patches.

 drivers/media/video/mt9m111.c |   51 +++++++++++++++++++++++++++++++---------
 1 files changed, 39 insertions(+), 12 deletions(-)

diff --git a/drivers/media/video/mt9m111.c b/drivers/media/video/mt9m111.c
index 872c99c..828112b 100644
--- a/drivers/media/video/mt9m111.c
+++ b/drivers/media/video/mt9m111.c
@@ -169,6 +169,8 @@ struct mt9m111 {
 			 * from v4l2-chip-ident.h */
 	enum mt9m111_context context;
 	struct v4l2_rect rect;
+	struct mutex power_lock; /* lock to protect power_count */
+	int power_count;
 	const struct mt9m111_datafmt *fmt;
 	unsigned int gain;
 	unsigned char autoexposure;
@@ -723,12 +725,7 @@ static const struct v4l2_queryctrl mt9m111_controls[] = {
 	}
 };
 
-static int mt9m111_resume(struct soc_camera_device *icd);
-static int mt9m111_suspend(struct soc_camera_device *icd, pm_message_t state);
-
 static struct soc_camera_ops mt9m111_ops = {
-	.suspend		= mt9m111_suspend,
-	.resume			= mt9m111_resume,
 	.query_bus_param	= mt9m111_query_bus_param,
 	.set_bus_param		= mt9m111_set_bus_param,
 	.controls		= mt9m111_controls,
@@ -898,11 +895,8 @@ static int mt9m111_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
 	return ret;
 }
 
-static int mt9m111_suspend(struct soc_camera_device *icd, pm_message_t state)
+static int mt9m111_suspend(struct mt9m111 *mt9m111)
 {
-	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
-	struct mt9m111 *mt9m111 = to_mt9m111(client);
-
 	mt9m111->gain = mt9m111_get_global_gain(mt9m111);
 
 	return 0;
@@ -920,10 +914,8 @@ static void mt9m111_restore_state(struct mt9m111 *mt9m111)
 	mt9m111_set_autowhitebalance(mt9m111, mt9m111->autowhitebalance);
 }
 
-static int mt9m111_resume(struct soc_camera_device *icd)
+static int mt9m111_resume(struct mt9m111 *mt9m111)
 {
-	struct i2c_client *client = to_i2c_client(to_soc_camera_control(icd));
-	struct mt9m111 *mt9m111 = to_mt9m111(client);
 	int ret = 0;
 
 	if (mt9m111->powered) {
@@ -1005,10 +997,45 @@ ei2c:
 	return ret;
 }
 
+static int mt9m111_s_power(struct v4l2_subdev *sd, int on)
+{
+	struct mt9m111 *mt9m111 = container_of(sd, struct mt9m111, subdev);
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	int ret = 0;
+
+	mutex_lock(&mt9m111->power_lock);
+
+	/*
+	 * If the power count is modified from 0 to != 0 or from != 0 to 0,
+	 * update the power state.
+	 */
+	if (mt9m111->power_count == !on) {
+		if (on) {
+			ret = mt9m111_resume(mt9m111);
+			if (ret) {
+				dev_err(&client->dev,
+					"Failed to resume the sensor: %d\n", ret);
+				goto out;
+			}
+		} else {
+			mt9m111_suspend(mt9m111);
+		}
+	}
+
+	/* Update the power count. */
+	mt9m111->power_count += on ? 1 : -1;
+	WARN_ON(mt9m111->power_count < 0);
+
+out:
+	mutex_unlock(&mt9m111->power_lock);
+	return ret;
+}
+
 static struct v4l2_subdev_core_ops mt9m111_subdev_core_ops = {
 	.g_ctrl		= mt9m111_g_ctrl,
 	.s_ctrl		= mt9m111_s_ctrl,
 	.g_chip_ident	= mt9m111_g_chip_ident,
+	.s_power	= mt9m111_s_power,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.g_register	= mt9m111_g_register,
 	.s_register	= mt9m111_s_register,
-- 
1.7.2.5

