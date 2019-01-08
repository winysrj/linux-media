Return-Path: <SRS0=gjtM=PQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E42BC43387
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 14:52:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5194820883
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 14:52:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SB0hfJco"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728706AbfAHOwg (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 8 Jan 2019 09:52:36 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:42582 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727656AbfAHOwf (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 8 Jan 2019 09:52:35 -0500
Received: by mail-pg1-f193.google.com with SMTP id d72so1828393pga.9;
        Tue, 08 Jan 2019 06:52:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=q7M9lBdr7+tgIVvHryQoi/WJMPR0c8927AYMRo8Rop8=;
        b=SB0hfJcozHWCLkhi0WOBoLhnX+KrKqaL33SNwRfJ3W7LigtjhvkYojxGwUpJyO/izb
         WUJl31NMHaTPQOYSZ4Z2A49wpIXQse5M1j+t6JhPKu8CjH8c5X4oQrItSDdpDoPBs9xL
         YEY6zXvl18m7+I4uvpjWgMnCCP22v4GQfBQHXdWl1QTTYx+sQ7n/b2KUFS0Pw8ZqpaIr
         uLD8i3A9BLdFIPFNcVQhSym5lRfs9Ipcvc18wkryLtC3oI0Pnu9YWUjyDT82WK26kmCr
         xTpZ3s1058y7HFYfIPrGNXGx3+OIzxl6Hu6tpWzOg/4T2ZZFO8Z8T4SpKHS+IZtcgLVe
         anzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=q7M9lBdr7+tgIVvHryQoi/WJMPR0c8927AYMRo8Rop8=;
        b=gZp8yjLENSvZw5qjJZj0LUKmYeE17zffYCcHJ6N17jcfXUVka5pyXBYcdfWQU2CEmG
         LjlgM89tC4kWthxC+0ZRduLfjL9l1Plhs5/jpgTRGW/uDWwISepDV/OrLzRvLSyQ7iHd
         oGnll+qaQQOblAsb1keOeG0a4lfFhFNQQhdCWAynL9lcXOl8bN2Iz65/jBmvJyltod+Q
         JBFRrZmNzsFW13U6LowK0SvwCvt77WB2Lm3cfNk3P4MpRFpujmux2Pcg4z2zqpC+PIuB
         6adMi2aJakTWFVkYPDVQAxiRbFUYnPrEK4WEyTTUe0EUv4LUfHGkviOccLdJk2Qt/NG1
         TlGg==
X-Gm-Message-State: AJcUuke1VVRwBwkADUunb6+/OGpgGykH6E/KiWUXJfQ5xc3GhUwy7Lul
        vnvo7M55fQv+8JfPDGIX9UsHEbTE
X-Google-Smtp-Source: ALg8bN647pJ/slEVp8q4xpY8cvpNQhph1Q5R06ddH/vSkAYOoTK9t2Oy85ZK3QPXsYy+YSNBSAApxQ==
X-Received: by 2002:a62:345:: with SMTP id 66mr2010686pfd.189.1546959153856;
        Tue, 08 Jan 2019 06:52:33 -0800 (PST)
Received: from localhost.localdomain ([240f:34:212d:1:5cb2:2bb:ff67:c70d])
        by smtp.gmail.com with ESMTPSA id n78sm53546990pfk.19.2019.01.08.06.52.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 08 Jan 2019 06:52:33 -0800 (PST)
From:   Akinobu Mita <akinobu.mita@gmail.com>
To:     linux-media@vger.kernel.org, devicetree@vger.kernel.org
Cc:     Akinobu Mita <akinobu.mita@gmail.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH v2 08/13] media: mt9m001: remove remaining soc_camera specific code
Date:   Tue,  8 Jan 2019 23:51:45 +0900
Message-Id: <1546959110-19445-9-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1546959110-19445-1-git-send-email-akinobu.mita@gmail.com>
References: <1546959110-19445-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Remove remaining soc_camera specific code and drop soc_camera dependency
from this driver.

Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
* No changes from v1

 drivers/media/i2c/Kconfig   |  2 +-
 drivers/media/i2c/mt9m001.c | 84 ++++++++-------------------------------------
 2 files changed, 15 insertions(+), 71 deletions(-)

diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index ee3ef1b..bc248d9 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -859,7 +859,7 @@ config VIDEO_VS6624
 
 config VIDEO_MT9M001
 	tristate "mt9m001 support"
-	depends on SOC_CAMERA && I2C
+	depends on I2C && VIDEO_V4L2
 	help
 	  This driver supports MT9M001 cameras from Micron, monochrome
 	  and colour models.
diff --git a/drivers/media/i2c/mt9m001.c b/drivers/media/i2c/mt9m001.c
index 1619c8c..0f5e3f9 100644
--- a/drivers/media/i2c/mt9m001.c
+++ b/drivers/media/i2c/mt9m001.c
@@ -15,15 +15,12 @@
 #include <linux/slab.h>
 #include <linux/videodev2.h>
 
-#include <media/drv-intf/soc_mediabus.h>
-#include <media/soc_camera.h>
 #include <media/v4l2-ctrls.h>
+#include <media/v4l2-device.h>
 #include <media/v4l2-subdev.h>
 
 /*
  * mt9m001 i2c address 0x5d
- * The platform has to define struct i2c_board_info objects and link to them
- * from struct soc_camera_host_desc
  */
 
 /* mt9m001 selected register addresses */
@@ -276,11 +273,15 @@ static int mt9m001_set_selection(struct v4l2_subdev *sd,
 	rect.width = ALIGN(rect.width, 2);
 	rect.left = ALIGN(rect.left, 2);
 
-	soc_camera_limit_side(&rect.left, &rect.width,
-		     MT9M001_COLUMN_SKIP, MT9M001_MIN_WIDTH, MT9M001_MAX_WIDTH);
+	rect.width = clamp_t(u32, rect.width, MT9M001_MIN_WIDTH,
+			MT9M001_MAX_WIDTH);
+	rect.left = clamp_t(u32, rect.left, MT9M001_COLUMN_SKIP,
+			MT9M001_COLUMN_SKIP + MT9M001_MAX_WIDTH - rect.width);
 
-	soc_camera_limit_side(&rect.top, &rect.height,
-		     MT9M001_ROW_SKIP, MT9M001_MIN_HEIGHT, MT9M001_MAX_HEIGHT);
+	rect.height = clamp_t(u32, rect.height, MT9M001_MIN_HEIGHT,
+			MT9M001_MAX_HEIGHT);
+	rect.top = clamp_t(u32, rect.top, MT9M001_ROW_SKIP,
+			MT9M001_ROW_SKIP + MT9M001_MAX_HEIGHT - rect.width);
 
 	mt9m001->total_h = rect.height + mt9m001->y_skip_top +
 			   MT9M001_DEFAULT_VBLANK;
@@ -565,12 +566,10 @@ static int mt9m001_s_ctrl(struct v4l2_ctrl *ctrl)
  * Interface active, can use i2c. If it fails, it can indeed mean, that
  * this wasn't our capture interface, so, we wait for the right one
  */
-static int mt9m001_video_probe(struct soc_camera_subdev_desc *ssdd,
-			       struct i2c_client *client)
+static int mt9m001_video_probe(struct i2c_client *client)
 {
 	struct mt9m001 *mt9m001 = to_mt9m001(client);
 	s32 data;
-	unsigned long flags;
 	int ret;
 
 	/* Enable the chip */
@@ -585,9 +584,11 @@ static int mt9m001_video_probe(struct soc_camera_subdev_desc *ssdd,
 	case 0x8411:
 	case 0x8421:
 		mt9m001->fmts = mt9m001_colour_fmts;
+		mt9m001->num_fmts = ARRAY_SIZE(mt9m001_colour_fmts);
 		break;
 	case 0x8431:
 		mt9m001->fmts = mt9m001_monochrome_fmts;
+		mt9m001->num_fmts = ARRAY_SIZE(mt9m001_monochrome_fmts);
 		break;
 	default:
 		dev_err(&client->dev,
@@ -596,26 +597,6 @@ static int mt9m001_video_probe(struct soc_camera_subdev_desc *ssdd,
 		goto done;
 	}
 
-	mt9m001->num_fmts = 0;
-
-	/*
-	 * This is a 10bit sensor, so by default we only allow 10bit.
-	 * The platform may support different bus widths due to
-	 * different routing of the data lines.
-	 */
-	if (ssdd->query_bus_param)
-		flags = ssdd->query_bus_param(ssdd);
-	else
-		flags = SOCAM_DATAWIDTH_10;
-
-	if (flags & SOCAM_DATAWIDTH_10)
-		mt9m001->num_fmts++;
-	else
-		mt9m001->fmts++;
-
-	if (flags & SOCAM_DATAWIDTH_8)
-		mt9m001->num_fmts++;
-
 	mt9m001->fmt = &mt9m001->fmts[0];
 
 	dev_info(&client->dev, "Detected a MT9M001 chip ID %x (%s)\n", data,
@@ -634,12 +615,6 @@ static int mt9m001_video_probe(struct soc_camera_subdev_desc *ssdd,
 	return ret;
 }
 
-static void mt9m001_video_remove(struct soc_camera_subdev_desc *ssdd)
-{
-	if (ssdd->free_bus)
-		ssdd->free_bus(ssdd);
-}
-
 static int mt9m001_g_skip_top_lines(struct v4l2_subdev *sd, u32 *lines)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
@@ -679,41 +654,18 @@ static int mt9m001_enum_mbus_code(struct v4l2_subdev *sd,
 static int mt9m001_g_mbus_config(struct v4l2_subdev *sd,
 				struct v4l2_mbus_config *cfg)
 {
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
-
 	/* MT9M001 has all capture_format parameters fixed */
 	cfg->flags = V4L2_MBUS_PCLK_SAMPLE_FALLING |
 		V4L2_MBUS_HSYNC_ACTIVE_HIGH | V4L2_MBUS_VSYNC_ACTIVE_HIGH |
 		V4L2_MBUS_DATA_ACTIVE_HIGH | V4L2_MBUS_MASTER;
 	cfg->type = V4L2_MBUS_PARALLEL;
-	cfg->flags = soc_camera_apply_board_flags(ssdd, cfg);
 
 	return 0;
 }
 
-static int mt9m001_s_mbus_config(struct v4l2_subdev *sd,
-				const struct v4l2_mbus_config *cfg)
-{
-	const struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
-	struct mt9m001 *mt9m001 = to_mt9m001(client);
-	unsigned int bps = soc_mbus_get_fmtdesc(mt9m001->fmt->code)->bits_per_sample;
-
-	if (ssdd->set_bus_param)
-		return ssdd->set_bus_param(ssdd, 1 << (bps - 1));
-
-	/*
-	 * Without board specific bus width settings we only support the
-	 * sensors native bus width
-	 */
-	return bps == 10 ? 0 : -EINVAL;
-}
-
 static const struct v4l2_subdev_video_ops mt9m001_subdev_video_ops = {
 	.s_stream	= mt9m001_s_stream,
 	.g_mbus_config	= mt9m001_g_mbus_config,
-	.s_mbus_config	= mt9m001_s_mbus_config,
 };
 
 static const struct v4l2_subdev_sensor_ops mt9m001_subdev_sensor_ops = {
@@ -740,21 +692,15 @@ static int mt9m001_probe(struct i2c_client *client,
 {
 	struct mt9m001 *mt9m001;
 	struct i2c_adapter *adapter = to_i2c_adapter(client->dev.parent);
-	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
 	int ret;
 
-	if (!ssdd) {
-		dev_err(&client->dev, "MT9M001 driver needs platform data\n");
-		return -EINVAL;
-	}
-
 	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_WORD_DATA)) {
 		dev_warn(&adapter->dev,
 			 "I2C-Adapter doesn't support I2C_FUNC_SMBUS_WORD\n");
 		return -EIO;
 	}
 
-	mt9m001 = devm_kzalloc(&client->dev, sizeof(struct mt9m001), GFP_KERNEL);
+	mt9m001 = devm_kzalloc(&client->dev, sizeof(*mt9m001), GFP_KERNEL);
 	if (!mt9m001)
 		return -ENOMEM;
 
@@ -811,7 +757,7 @@ static int mt9m001_probe(struct i2c_client *client,
 	pm_runtime_set_active(&client->dev);
 	pm_runtime_enable(&client->dev);
 
-	ret = mt9m001_video_probe(ssdd, client);
+	ret = mt9m001_video_probe(client);
 	if (ret)
 		goto error_power_off;
 
@@ -834,7 +780,6 @@ static int mt9m001_probe(struct i2c_client *client,
 static int mt9m001_remove(struct i2c_client *client)
 {
 	struct mt9m001 *mt9m001 = to_mt9m001(client);
-	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
 
 	v4l2_device_unregister_subdev(&mt9m001->subdev);
 	pm_runtime_get_sync(&client->dev);
@@ -845,7 +790,6 @@ static int mt9m001_remove(struct i2c_client *client)
 	mt9m001_power_off(&client->dev);
 
 	v4l2_ctrl_handler_free(&mt9m001->hdl);
-	mt9m001_video_remove(ssdd);
 	mutex_destroy(&mt9m001->mutex);
 
 	return 0;
-- 
2.7.4

