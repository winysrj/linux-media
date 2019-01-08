Return-Path: <SRS0=gjtM=PQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 242FCC43387
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 14:52:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DC9492171F
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 14:52:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F1WblJ1P"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728636AbfAHOwd (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 8 Jan 2019 09:52:33 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:41664 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727656AbfAHOwc (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 8 Jan 2019 09:52:32 -0500
Received: by mail-pf1-f194.google.com with SMTP id b7so2037192pfi.8;
        Tue, 08 Jan 2019 06:52:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=UUZV6+pF+C6XNExtUvUnD090iD0oqSfuL+xB06Mguss=;
        b=F1WblJ1PXRzhbiwE2VDPDaTimf9MKGVhokP8IkOT7IJi7qPCKKa/q2E8FgtFxThrg1
         CmaDqhdxe0RCyDC0/5/UqJ20iX8kknwDifZrZ9ZiIlvNAaJMUDIgBa/th7nqfYdqPaW8
         XKCOl7ceg7idTofVjlmW/rXViE39uKRn0C6uWLCT4eQWlU8Pky0NemHJLvawnOY/KS7f
         6RGTd2ozR1n6Dn/eLFqWM8Bq+SwUpn5I2GmpjLN35IJJeFznlQqapbkpTfKt04elCmio
         4br/PHRQZXEE/cqod7urPdJnh9sUKJik1lHrNAAh11AfpSYsk/N+3nd8GFiO6qWzkef0
         i07A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=UUZV6+pF+C6XNExtUvUnD090iD0oqSfuL+xB06Mguss=;
        b=Rh5dhgBu9aDRAklqokqCjmPeficQ79CknyDOexn+ccHo9M/wEqbqgmb/ACQ0WeQlbF
         KR+/FylSgSg0B+U0U9yz9h+33JaVWUrTFi4ZrWicwP0bLfcgiCfLZlTE2CC2dY/IKHc9
         cnHqtFwko/rE6R1ZP0E8fPsseVAHcPianmSz0YSRU+BJCMkMommWOy6LSHC5UduhyjQb
         VoX1QzGmp4k63qT1X8tggYAwRA97582fVIexkuwlg3KtGtVYF26f8X0TS+ami1Xg/LgF
         X24stpAiAMkv0ZmJANzrAcAg9b5HdwpO1LyT78CE0Xf/DuYKMhAJHwhM7zmcIDqAVdDT
         ej6A==
X-Gm-Message-State: AJcUukeKnMXlR93J6RpSd87tMFu9YUfEF2YnX79EL1ydC5WI4wd0UZTZ
        7kJO3VYXt6Srmt9FcEuqRej3sOxF
X-Google-Smtp-Source: ALg8bN56GXCjxsZhy9nCNSnypB2CIUTMxQnUDx4hqfsmYVP3tp7zosNKSprc+S89Tnh4/eg8iVRv+w==
X-Received: by 2002:a62:f907:: with SMTP id o7mr2004831pfh.244.1546959151375;
        Tue, 08 Jan 2019 06:52:31 -0800 (PST)
Received: from localhost.localdomain ([240f:34:212d:1:5cb2:2bb:ff67:c70d])
        by smtp.gmail.com with ESMTPSA id n78sm53546990pfk.19.2019.01.08.06.52.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 08 Jan 2019 06:52:30 -0800 (PST)
From:   Akinobu Mita <akinobu.mita@gmail.com>
To:     linux-media@vger.kernel.org, devicetree@vger.kernel.org
Cc:     Akinobu Mita <akinobu.mita@gmail.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH v2 07/13] media: mt9m001: switch s_power callback to runtime PM
Date:   Tue,  8 Jan 2019 23:51:44 +0900
Message-Id: <1546959110-19445-8-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1546959110-19445-1-git-send-email-akinobu.mita@gmail.com>
References: <1546959110-19445-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Switch s_power() callback to runtime PM framework.  This also removes
soc_camera specific power management code and introduces reset and standby
gpios instead.

Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
* v2
- Add new label for error handling in s_stream() callback.
- Replace pm_runtime_get_noresume() + pm_runtime_put_sync() with a
  single pm_runtime_idle() call in probe() function.
- Change the argument of mt9m001_power_o{n,ff} to struct device, and
  use them for runtime PM callbacks directly.

 drivers/media/i2c/mt9m001.c | 222 +++++++++++++++++++++++++++++++-------------
 1 file changed, 160 insertions(+), 62 deletions(-)

diff --git a/drivers/media/i2c/mt9m001.c b/drivers/media/i2c/mt9m001.c
index 7ba11a8..1619c8c 100644
--- a/drivers/media/i2c/mt9m001.c
+++ b/drivers/media/i2c/mt9m001.c
@@ -5,15 +5,18 @@
  * Copyright (C) 2008, Guennadi Liakhovetski <kernel@pengutronix.de>
  */
 
+#include <linux/clk.h>
+#include <linux/delay.h>
+#include <linux/gpio/consumer.h>
 #include <linux/i2c.h>
 #include <linux/log2.h>
 #include <linux/module.h>
+#include <linux/pm_runtime.h>
 #include <linux/slab.h>
 #include <linux/videodev2.h>
 
 #include <media/drv-intf/soc_mediabus.h>
 #include <media/soc_camera.h>
-#include <media/v4l2-clk.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-subdev.h>
 
@@ -92,8 +95,12 @@ struct mt9m001 {
 		struct v4l2_ctrl *autoexposure;
 		struct v4l2_ctrl *exposure;
 	};
+	bool streaming;
+	struct mutex mutex;
 	struct v4l2_rect rect;	/* Sensor window */
-	struct v4l2_clk *clk;
+	struct clk *clk;
+	struct gpio_desc *standby_gpio;
+	struct gpio_desc *reset_gpio;
 	const struct mt9m001_datafmt *fmt;
 	const struct mt9m001_datafmt *fmts;
 	int num_fmts;
@@ -177,8 +184,7 @@ static int mt9m001_init(struct i2c_client *client)
 	return multi_reg_write(client, init_regs, ARRAY_SIZE(init_regs));
 }
 
-static int mt9m001_apply_selection(struct v4l2_subdev *sd,
-				    struct v4l2_rect *rect)
+static int mt9m001_apply_selection(struct v4l2_subdev *sd)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct mt9m001 *mt9m001 = to_mt9m001(client);
@@ -190,11 +196,11 @@ static int mt9m001_apply_selection(struct v4l2_subdev *sd,
 		 * The caller provides a supported format, as verified per
 		 * call to .set_fmt(FORMAT_TRY).
 		 */
-		{ MT9M001_COLUMN_START, rect->left },
-		{ MT9M001_ROW_START, rect->top },
-		{ MT9M001_WINDOW_WIDTH, rect->width - 1 },
+		{ MT9M001_COLUMN_START, mt9m001->rect.left },
+		{ MT9M001_ROW_START, mt9m001->rect.top },
+		{ MT9M001_WINDOW_WIDTH, mt9m001->rect.width - 1 },
 		{ MT9M001_WINDOW_HEIGHT,
-			rect->height + mt9m001->y_skip_top - 1 },
+			mt9m001->rect.height + mt9m001->y_skip_top - 1 },
 	};
 
 	return multi_reg_write(client, regs, ARRAY_SIZE(regs));
@@ -203,11 +209,48 @@ static int mt9m001_apply_selection(struct v4l2_subdev *sd,
 static int mt9m001_s_stream(struct v4l2_subdev *sd, int enable)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct mt9m001 *mt9m001 = to_mt9m001(client);
+	int ret = 0;
+
+	mutex_lock(&mt9m001->mutex);
+
+	if (mt9m001->streaming == enable)
+		goto done;
+
+	if (enable) {
+		ret = pm_runtime_get_sync(&client->dev);
+		if (ret < 0)
+			goto put_unlock;
+
+		ret = mt9m001_apply_selection(sd);
+		if (ret)
+			goto put_unlock;
+
+		ret = __v4l2_ctrl_handler_setup(&mt9m001->hdl);
+		if (ret)
+			goto put_unlock;
+
+		/* Switch to master "normal" mode */
+		ret = reg_write(client, MT9M001_OUTPUT_CONTROL, 2);
+		if (ret < 0)
+			goto put_unlock;
+	} else {
+		/* Switch to master stop sensor readout */
+		reg_write(client, MT9M001_OUTPUT_CONTROL, 0);
+		pm_runtime_put(&client->dev);
+	}
+
+	mt9m001->streaming = enable;
+done:
+	mutex_unlock(&mt9m001->mutex);
 
-	/* Switch to master "normal" mode or stop sensor readout */
-	if (reg_write(client, MT9M001_OUTPUT_CONTROL, enable ? 2 : 0) < 0)
-		return -EIO;
 	return 0;
+
+put_unlock:
+	pm_runtime_put(&client->dev);
+	mutex_unlock(&mt9m001->mutex);
+
+	return ret;
 }
 
 static int mt9m001_set_selection(struct v4l2_subdev *sd,
@@ -217,7 +260,6 @@ static int mt9m001_set_selection(struct v4l2_subdev *sd,
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct mt9m001 *mt9m001 = to_mt9m001(client);
 	struct v4l2_rect rect = sel->r;
-	int ret;
 
 	if (sel->which != V4L2_SUBDEV_FORMAT_ACTIVE ||
 	    sel->target != V4L2_SEL_TGT_CROP)
@@ -243,15 +285,9 @@ static int mt9m001_set_selection(struct v4l2_subdev *sd,
 	mt9m001->total_h = rect.height + mt9m001->y_skip_top +
 			   MT9M001_DEFAULT_VBLANK;
 
+	mt9m001->rect = rect;
 
-	ret = mt9m001_apply_selection(sd, &rect);
-	if (!ret && v4l2_ctrl_g_ctrl(mt9m001->autoexposure) == V4L2_EXPOSURE_AUTO)
-		ret = reg_write(client, MT9M001_SHUTTER_WIDTH, mt9m001->total_h);
-
-	if (!ret)
-		mt9m001->rect = rect;
-
-	return ret;
+	return 0;
 }
 
 static int mt9m001_get_selection(struct v4l2_subdev *sd,
@@ -395,13 +431,40 @@ static int mt9m001_s_register(struct v4l2_subdev *sd,
 }
 #endif
 
-static int mt9m001_s_power(struct v4l2_subdev *sd, int on)
+static int mt9m001_power_on(struct device *dev)
 {
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
+	struct i2c_client *client = to_i2c_client(dev);
 	struct mt9m001 *mt9m001 = to_mt9m001(client);
+	int ret;
+
+	ret = clk_prepare_enable(mt9m001->clk);
+	if (ret)
+		return ret;
+
+	if (mt9m001->standby_gpio) {
+		gpiod_set_value_cansleep(mt9m001->standby_gpio, 0);
+		usleep_range(1000, 2000);
+	}
 
-	return soc_camera_set_power(&client->dev, ssdd, mt9m001->clk, on);
+	if (mt9m001->reset_gpio) {
+		gpiod_set_value_cansleep(mt9m001->reset_gpio, 1);
+		usleep_range(1000, 2000);
+		gpiod_set_value_cansleep(mt9m001->reset_gpio, 0);
+		usleep_range(1000, 2000);
+	}
+
+	return 0;
+}
+
+static int mt9m001_power_off(struct device *dev)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct mt9m001 *mt9m001 = to_mt9m001(client);
+
+	gpiod_set_value_cansleep(mt9m001->standby_gpio, 1);
+	clk_disable_unprepare(mt9m001->clk);
+
+	return 0;
 }
 
 static int mt9m001_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
@@ -429,16 +492,18 @@ static int mt9m001_s_ctrl(struct v4l2_ctrl *ctrl)
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct v4l2_ctrl *exp = mt9m001->exposure;
 	int data;
+	int ret;
+
+	if (!pm_runtime_get_if_in_use(&client->dev))
+		return 0;
 
 	switch (ctrl->id) {
 	case V4L2_CID_VFLIP:
 		if (ctrl->val)
-			data = reg_set(client, MT9M001_READ_OPTIONS2, 0x8000);
+			ret = reg_set(client, MT9M001_READ_OPTIONS2, 0x8000);
 		else
-			data = reg_clear(client, MT9M001_READ_OPTIONS2, 0x8000);
-		if (data < 0)
-			return -EIO;
-		return 0;
+			ret = reg_clear(client, MT9M001_READ_OPTIONS2, 0x8000);
+		break;
 
 	case V4L2_CID_GAIN:
 		/* See Datasheet Table 7, Gain settings. */
@@ -448,9 +513,7 @@ static int mt9m001_s_ctrl(struct v4l2_ctrl *ctrl)
 			data = ((ctrl->val - (s32)ctrl->minimum) * 8 + range / 2) / range;
 
 			dev_dbg(&client->dev, "Setting gain %d\n", data);
-			data = reg_write(client, MT9M001_GLOBAL_GAIN, data);
-			if (data < 0)
-				return -EIO;
+			ret = reg_write(client, MT9M001_GLOBAL_GAIN, data);
 		} else {
 			/* Pack it into 1.125..15 variable step, register values 9..67 */
 			/* We assume qctrl->maximum - qctrl->default_value - 1 > 0 */
@@ -467,11 +530,9 @@ static int mt9m001_s_ctrl(struct v4l2_ctrl *ctrl)
 
 			dev_dbg(&client->dev, "Setting gain from %d to %d\n",
 				 reg_read(client, MT9M001_GLOBAL_GAIN), data);
-			data = reg_write(client, MT9M001_GLOBAL_GAIN, data);
-			if (data < 0)
-				return -EIO;
+			ret = reg_write(client, MT9M001_GLOBAL_GAIN, data);
 		}
-		return 0;
+		break;
 
 	case V4L2_CID_EXPOSURE_AUTO:
 		if (ctrl->val == V4L2_EXPOSURE_MANUAL) {
@@ -482,19 +543,22 @@ static int mt9m001_s_ctrl(struct v4l2_ctrl *ctrl)
 			dev_dbg(&client->dev,
 				"Setting shutter width from %d to %lu\n",
 				reg_read(client, MT9M001_SHUTTER_WIDTH), shutter);
-			if (reg_write(client, MT9M001_SHUTTER_WIDTH, shutter) < 0)
-				return -EIO;
+			ret = reg_write(client, MT9M001_SHUTTER_WIDTH, shutter);
 		} else {
-			const u16 vblank = 25;
-
 			mt9m001->total_h = mt9m001->rect.height +
-				mt9m001->y_skip_top + vblank;
-			if (reg_write(client, MT9M001_SHUTTER_WIDTH, mt9m001->total_h) < 0)
-				return -EIO;
+				mt9m001->y_skip_top + MT9M001_DEFAULT_VBLANK;
+			ret = reg_write(client, MT9M001_SHUTTER_WIDTH,
+					mt9m001->total_h);
 		}
-		return 0;
+		break;
+	default:
+		ret = -EINVAL;
+		break;
 	}
-	return -EINVAL;
+
+	pm_runtime_put(&client->dev);
+
+	return ret;
 }
 
 /*
@@ -509,10 +573,6 @@ static int mt9m001_video_probe(struct soc_camera_subdev_desc *ssdd,
 	unsigned long flags;
 	int ret;
 
-	ret = mt9m001_s_power(&mt9m001->subdev, 1);
-	if (ret < 0)
-		return ret;
-
 	/* Enable the chip */
 	data = reg_write(client, MT9M001_CHIP_ENABLE, 1);
 	dev_dbg(&client->dev, "write: %d\n", data);
@@ -571,7 +631,6 @@ static int mt9m001_video_probe(struct soc_camera_subdev_desc *ssdd,
 	ret = v4l2_ctrl_handler_setup(&mt9m001->hdl);
 
 done:
-	mt9m001_s_power(&mt9m001->subdev, 0);
 	return ret;
 }
 
@@ -601,7 +660,6 @@ static const struct v4l2_subdev_core_ops mt9m001_subdev_core_ops = {
 	.g_register	= mt9m001_g_register,
 	.s_register	= mt9m001_s_register,
 #endif
-	.s_power	= mt9m001_s_power,
 };
 
 static int mt9m001_enum_mbus_code(struct v4l2_subdev *sd,
@@ -700,6 +758,20 @@ static int mt9m001_probe(struct i2c_client *client,
 	if (!mt9m001)
 		return -ENOMEM;
 
+	mt9m001->clk = devm_clk_get(&client->dev, NULL);
+	if (IS_ERR(mt9m001->clk))
+		return PTR_ERR(mt9m001->clk);
+
+	mt9m001->standby_gpio = devm_gpiod_get_optional(&client->dev, "standby",
+							GPIOD_OUT_LOW);
+	if (IS_ERR(mt9m001->standby_gpio))
+		return PTR_ERR(mt9m001->standby_gpio);
+
+	mt9m001->reset_gpio = devm_gpiod_get_optional(&client->dev, "reset",
+						      GPIOD_OUT_LOW);
+	if (IS_ERR(mt9m001->reset_gpio))
+		return PTR_ERR(mt9m001->reset_gpio);
+
 	v4l2_i2c_subdev_init(&mt9m001->subdev, client, &mt9m001_subdev_ops);
 	v4l2_ctrl_handler_init(&mt9m001->hdl, 4);
 	v4l2_ctrl_new_std(&mt9m001->hdl, &mt9m001_ctrl_ops,
@@ -722,6 +794,9 @@ static int mt9m001_probe(struct i2c_client *client,
 	v4l2_ctrl_auto_cluster(2, &mt9m001->autoexposure,
 					V4L2_EXPOSURE_MANUAL, true);
 
+	mutex_init(&mt9m001->mutex);
+	mt9m001->hdl.lock = &mt9m001->mutex;
+
 	/* Second stage probe - when a capture adapter is there */
 	mt9m001->y_skip_top	= 0;
 	mt9m001->rect.left	= MT9M001_COLUMN_SKIP;
@@ -729,18 +804,29 @@ static int mt9m001_probe(struct i2c_client *client,
 	mt9m001->rect.width	= MT9M001_MAX_WIDTH;
 	mt9m001->rect.height	= MT9M001_MAX_HEIGHT;
 
-	mt9m001->clk = v4l2_clk_get(&client->dev, "mclk");
-	if (IS_ERR(mt9m001->clk)) {
-		ret = PTR_ERR(mt9m001->clk);
-		goto eclkget;
-	}
+	ret = mt9m001_power_on(&client->dev);
+	if (ret)
+		goto error_hdl_free;
+
+	pm_runtime_set_active(&client->dev);
+	pm_runtime_enable(&client->dev);
 
 	ret = mt9m001_video_probe(ssdd, client);
-	if (ret) {
-		v4l2_clk_put(mt9m001->clk);
-eclkget:
-		v4l2_ctrl_handler_free(&mt9m001->hdl);
-	}
+	if (ret)
+		goto error_power_off;
+
+	pm_runtime_idle(&client->dev);
+
+	return 0;
+
+error_power_off:
+	pm_runtime_disable(&client->dev);
+	pm_runtime_set_suspended(&client->dev);
+	mt9m001_power_off(&client->dev);
+
+error_hdl_free:
+	v4l2_ctrl_handler_free(&mt9m001->hdl);
+	mutex_destroy(&mt9m001->mutex);
 
 	return ret;
 }
@@ -750,10 +836,17 @@ static int mt9m001_remove(struct i2c_client *client)
 	struct mt9m001 *mt9m001 = to_mt9m001(client);
 	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
 
-	v4l2_clk_put(mt9m001->clk);
 	v4l2_device_unregister_subdev(&mt9m001->subdev);
+	pm_runtime_get_sync(&client->dev);
+
+	pm_runtime_disable(&client->dev);
+	pm_runtime_set_suspended(&client->dev);
+	pm_runtime_put_noidle(&client->dev);
+	mt9m001_power_off(&client->dev);
+
 	v4l2_ctrl_handler_free(&mt9m001->hdl);
 	mt9m001_video_remove(ssdd);
+	mutex_destroy(&mt9m001->mutex);
 
 	return 0;
 }
@@ -764,6 +857,10 @@ static const struct i2c_device_id mt9m001_id[] = {
 };
 MODULE_DEVICE_TABLE(i2c, mt9m001_id);
 
+static const struct dev_pm_ops mt9m001_pm_ops = {
+	SET_RUNTIME_PM_OPS(mt9m001_power_off, mt9m001_power_on, NULL)
+};
+
 static const struct of_device_id mt9m001_of_match[] = {
 	{ .compatible = "onnn,mt9m001", },
 	{ /* sentinel */ },
@@ -773,6 +870,7 @@ MODULE_DEVICE_TABLE(of, mt9m001_of_match);
 static struct i2c_driver mt9m001_i2c_driver = {
 	.driver = {
 		.name = "mt9m001",
+		.pm = &mt9m001_pm_ops,
 		.of_match_table = mt9m001_of_match,
 	},
 	.probe		= mt9m001_probe,
-- 
2.7.4

