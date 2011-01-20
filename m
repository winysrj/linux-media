Return-path: <mchehab@pedra>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:53100 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753369Ab1ATBoY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Jan 2011 20:44:24 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from spt2.w1.samsung.com ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LFA004R5STYL890@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 20 Jan 2011 01:44:22 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LFA00858STX02@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 20 Jan 2011 01:44:22 +0000 (GMT)
Date: Thu, 20 Jan 2011 02:44:02 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 3/3] sr030pc30: Add regulator framework support
In-reply-to: <1295487842-23410-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, m.szyprowski@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Message-id: <1295487842-23410-4-git-send-email-s.nawrocki@samsung.com>
References: <1295487842-23410-1-git-send-email-s.nawrocki@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Use the regulator API instead of the set_power callback.
Handle RESET and STANDBY gpio in the driver when needed.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/sr030pc30.c |  193 ++++++++++++++++++++++++++++++---------
 include/media/sr030pc30.h       |   14 ++-
 2 files changed, 162 insertions(+), 45 deletions(-)

diff --git a/drivers/media/video/sr030pc30.c b/drivers/media/video/sr030pc30.c
index 1a195f0..940ac37 100644
--- a/drivers/media/video/sr030pc30.c
+++ b/drivers/media/video/sr030pc30.c
@@ -18,6 +18,8 @@
 
 #include <linux/i2c.h>
 #include <linux/delay.h>
+#include <linux/gpio.h>
+#include <linux/regulator/consumer.h>
 #include <linux/slab.h>
 #include <media/v4l2-chip-ident.h>
 #include <media/v4l2-ctrls.h>
@@ -141,6 +143,12 @@ module_param(debug, int, 0644);
 #define EXPOS_MIN_MS		1
 #define EXPOS_MAX_MS		125
 
+static const char * const sr030pc30_supply_name[] = {
+	"vdd_core", "vddio", "vdda"
+};
+
+#define SR030PC30_NUM_SUPPLIES ARRAY_SIZE(sr030pc30_supply_name)
+
 struct sr030pc30_info {
 	struct v4l2_subdev sd;
 	struct v4l2_ctrl_handler hdl;
@@ -160,7 +168,11 @@ struct sr030pc30_info {
 	const struct sr030pc30_platform_data *pdata;
 	const struct sr030pc30_format *curr_fmt;
 	const struct sr030pc30_frmsize *curr_win;
+	unsigned int power:1;
 	unsigned int sleep:1;
+	struct regulator_bulk_data supply[SR030PC30_NUM_SUPPLIES];
+	u32 gpio_nreset;
+	u32 gpio_nstby;
 	u8 i2c_reg_page;
 };
 
@@ -473,7 +485,7 @@ static int sr030pc30_s_ctrl(struct v4l2_ctrl *ctrl)
 
 	switch (ctrl->id) {
 	case V4L2_CID_AUTO_WHITE_BALANCE:
-		if (!ctrl->has_new)
+		if (!ctrl->is_new)
 			ctrl->val = 0;
 
 		ret = sr030pc30_enable_autowhitebalance(sd, ctrl->val);
@@ -487,7 +499,7 @@ static int sr030pc30_s_ctrl(struct v4l2_ctrl *ctrl)
 		return ret;
 
 	case V4L2_CID_EXPOSURE_AUTO:
-		if (!ctrl->has_new)
+		if (!ctrl->is_new)
 			ctrl->val = V4L2_EXPOSURE_MANUAL;
 
 		if (ctrl->val == V4L2_EXPOSURE_MANUAL)
@@ -622,9 +634,66 @@ static int sr030pc30_base_config(struct v4l2_subdev *sd)
 	return v4l2_ctrl_handler_setup(&info->hdl);
 }
 
+static int sr030pc30_power_enable(struct sr030pc30_info *info)
+{
+	int ret;
+
+	if (info->power)
+		return 0;
+
+	if (gpio_is_valid(info->gpio_nstby))
+		gpio_set_value(info->gpio_nstby, 0);
+
+	if (gpio_is_valid(info->gpio_nreset))
+		gpio_set_value(info->gpio_nreset, 0);
+
+	ret = regulator_bulk_enable(SR030PC30_NUM_SUPPLIES, info->supply);
+	if (ret)
+		return ret;
+
+	if (gpio_is_valid(info->gpio_nreset)) {
+		msleep(50);
+		gpio_set_value(info->gpio_nreset, 1);
+	}
+	if (gpio_is_valid(info->gpio_nstby)) {
+		udelay(1000);
+		gpio_set_value(info->gpio_nstby, 1);
+	}
+	if (gpio_is_valid(info->gpio_nreset)) {
+		udelay(1000);
+		gpio_set_value(info->gpio_nreset, 0);
+		msleep(100);
+		gpio_set_value(info->gpio_nreset, 1);
+		msleep(20);
+	}
+
+	info->power = 1;
+	return 0;
+}
+
+static int sr030pc30_power_disable(struct sr030pc30_info *info)
+{
+	int ret;
+
+	if (!info->power)
+		return 0;
+
+	ret = regulator_bulk_disable(SR030PC30_NUM_SUPPLIES, info->supply);
+	if (ret)
+		return ret;
+
+	if (gpio_is_valid(info->gpio_nstby))
+		gpio_set_value(info->gpio_nstby, 0);
+
+	if (gpio_is_valid(info->gpio_nreset))
+		gpio_set_value(info->gpio_nreset, 0);
+
+	info->power = 0;
+	return 0;
+}
+
 static int sr030pc30_s_power(struct v4l2_subdev *sd, int on)
 {
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct sr030pc30_info *info = to_sr030pc30(sd);
 	const struct sr030pc30_platform_data *pdata = info->pdata;
 	int ret;
@@ -632,23 +701,15 @@ static int sr030pc30_s_power(struct v4l2_subdev *sd, int on)
 	if (WARN(pdata == NULL, "No platform data!\n"))
 		return -ENOMEM;
 
-	/*
-	 * Put sensor into power sleep mode before switching off
-	 * power and disabling MCLK.
-	 */
-	if (!on)
-		sr030pc30_pwr_ctrl(sd, false, true);
-
-	/* set_power controls sensor's power and clock */
-	if (pdata->set_power) {
-		ret = pdata->set_power(&client->dev, on);
+	/* Put sensor into power sleep mode before switching supply off. */
+	if (on) {
+		ret = sr030pc30_power_enable(info);
 		if (ret)
 			return ret;
-	}
-
-	if (on) {
 		ret = sr030pc30_base_config(sd);
 	} else {
+		sr030pc30_pwr_ctrl(sd, false, true);
+		ret = sr030pc30_power_disable(info);
 		info->curr_win = NULL;
 		info->curr_fmt = NULL;
 	}
@@ -696,30 +757,40 @@ static const struct v4l2_subdev_ops sr030pc30_ops = {
  * Detect sensor type. Return 0 if SR030PC30 was detected
  * or -ENODEV otherwise.
  */
-static int sr030pc30_detect(struct i2c_client *client)
+static int sr030pc30_detect(struct i2c_client *client, struct sr030pc30_info *info)
 {
-	const struct sr030pc30_platform_data *pdata
-		= client->dev.platform_data;
 	int ret;
 
-	/* Enable sensor's power and clock */
-	if (pdata->set_power) {
-		ret = pdata->set_power(&client->dev, 1);
-		if (ret)
-			return ret;
-	}
+	ret = sr030pc30_power_enable(info);
+	if (ret)
+		return ret;
 
 	ret = i2c_smbus_read_byte_data(client, DEVICE_ID_REG);
+	if (ret < 0)
+		dev_err(&client->dev, "%s: I2C read failed\n", __func__);
 
-	if (pdata->set_power)
-		pdata->set_power(&client->dev, 0);
+	sr030pc30_power_disable(info);
 
-	if (ret < 0) {
-		dev_err(&client->dev, "%s: I2C read failed\n", __func__);
+	return ret == SR030PC30_ID ? 0 : -ENODEV;
+}
+
+static int sr030pc30_configure_gpio(struct v4l2_subdev *sd,
+				    int nr, const char *name)
+{
+	int ret = 0;
+
+	if (!gpio_is_valid(nr))
 		return ret;
-	}
 
-	return ret == SR030PC30_ID ? 0 : -ENODEV;
+	ret = gpio_request(nr, name);
+	if (!ret)
+		ret = gpio_direction_output(nr, 0);
+	if (!ret)
+		ret = gpio_export(nr, 0);
+	if (ret)
+		v4l2_err(sd, "gpio configuration error: %d\n", ret);
+
+	return ret;
 }
 
 static int sr030pc30_probe(struct i2c_client *client,
@@ -729,17 +800,13 @@ static int sr030pc30_probe(struct i2c_client *client,
 	struct v4l2_subdev *sd;
 	const struct sr030pc30_platform_data *pdata
 		= client->dev.platform_data;
-	int ret;
+	int i, ret;
 
 	if (!pdata) {
 		dev_err(&client->dev, "No platform data!\n");
 		return -EIO;
 	}
 
-	ret = sr030pc30_detect(client);
-	if (ret)
-		return ret;
-
 	info = kzalloc(sizeof(*info), GFP_KERNEL);
 	if (!info)
 		return -ENOMEM;
@@ -774,16 +841,49 @@ static int sr030pc30_probe(struct i2c_client *client,
 				1, 0, V4L2_EXPOSURE_AUTO);
 
 	sd->ctrl_handler = &info->hdl;
+	ret = info->hdl.error;
 
-	if (info->hdl.error) {
-		v4l2_ctrl_handler_free(&info->hdl);
-		kfree(info);
-		return info->hdl.error;
-	}
+	if (ret)
+		goto sp_err;
 
 	v4l2_ctrl_cluster(2, &info->autoexposure);
 	v4l2_ctrl_cluster(3, &info->autowb);
-	return 0;
+
+	ret = sr030pc30_configure_gpio(sd, pdata->gpio_nreset,
+				       "SR030PC30_NRST");
+	if (ret)
+		goto sp_err;
+	info->gpio_nreset = pdata->gpio_nreset;
+
+	ret = sr030pc30_configure_gpio(sd, pdata->gpio_nstby,
+				       "SR030PC30_NSTBY");
+	if (ret)
+		goto sp_gpio_err;
+	info->gpio_nstby = pdata->gpio_nstby;
+
+	for (i = 0; i < SR030PC30_NUM_SUPPLIES; i++)
+		info->supply[i].supply = sr030pc30_supply_name[i];
+
+	ret = regulator_bulk_get(&client->dev, SR030PC30_NUM_SUPPLIES,
+				 info->supply);
+	if (ret)
+		goto sp_reg_err;
+
+	ret = sr030pc30_detect(client, info);
+	if (!ret)
+		return 0;
+
+	regulator_bulk_free(SR030PC30_NUM_SUPPLIES, info->supply);
+sp_reg_err:
+	if (gpio_is_valid(info->gpio_nstby))
+		gpio_free(info->gpio_nstby);
+sp_gpio_err:
+	if (gpio_is_valid(info->gpio_nreset))
+		gpio_free(info->gpio_nreset);
+sp_err:
+	v4l2_ctrl_handler_free(&info->hdl);
+	kfree(info);
+	return ret;
 }
 
 static int sr030pc30_remove(struct i2c_client *client)
@@ -793,6 +893,15 @@ static int sr030pc30_remove(struct i2c_client *client)
 
 	v4l2_device_unregister_subdev(sd);
 	v4l2_ctrl_handler_free(&info->hdl);
+
+	regulator_bulk_free(SR030PC30_NUM_SUPPLIES, info->supply);
+
+	if (gpio_is_valid(info->gpio_nreset))
+		gpio_free(info->gpio_nreset);
+
+	if (gpio_is_valid(info->gpio_nstby))
+		gpio_free(info->gpio_nstby);
+
 	kfree(info);
 	return 0;
 }
diff --git a/include/media/sr030pc30.h b/include/media/sr030pc30.h
index 6f901a6..3689769 100644
--- a/include/media/sr030pc30.h
+++ b/include/media/sr030pc30.h
@@ -13,9 +13,17 @@
 #ifndef SR030PC30_H
 #define SR030PC30_H
 
+/**
+ * @clk_rate: the sensor's master clock frequency in Hz
+ * @gpio_nreset: GPIO driving nRESET pin
+ * @gpio_nstby: GPIO driving nSTBY pin
+ *
+ * When the gpio pins are not used gpio_nreset
+ * and gpio_nstby must be set to -EINVAL.
+ */
 struct sr030pc30_platform_data {
-	unsigned long clk_rate;	/* master clock frequency in Hz */
-	int (*set_power)(struct device *dev, int on);
+	unsigned long clk_rate;
+	int gpio_nreset;
+	int gpio_nstby;
 };
-
 #endif /* SR030PC30_H */
-- 
1.7.0.4

