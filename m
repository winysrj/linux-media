Return-Path: <SRS0=mDsK=O7=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D618FC43387
	for <linux-media@archiver.kernel.org>; Sat, 22 Dec 2018 17:13:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 955AB21A48
	for <linux-media@archiver.kernel.org>; Sat, 22 Dec 2018 17:13:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AQNWtoGB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391062AbeLVRNX (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 22 Dec 2018 12:13:23 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:47099 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388743AbeLVRNX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 22 Dec 2018 12:13:23 -0500
Received: by mail-pg1-f196.google.com with SMTP id w7so3892185pgp.13;
        Sat, 22 Dec 2018 09:13:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=WzjyvpgI/0C3cgEv0rR/qqBgCA7uDyu98oGTGsbnyeY=;
        b=AQNWtoGBpYfzTD/vXzs04UpBFdPFT/wYP8BseLHBCTxTgMfymVmTLqmt0u0PsOORNK
         euUfnWi0ZuVJl4jDpV0rDGy7MY7IAuhBrBX7XGtZjYBX27Co3afmdYqwe34YyJLraoRQ
         7c2tzicVNs5GT1tojQ/9LejpH9fWeJm3ZqdTuI0j8l1ydL/TOaVE5pXf0MHHDxmjIr6d
         i595yP7Cbt3RWToY59SkiSOWe7oSSk22AjFqlUp/59axLvy5VZ4Fc0cAIcwunsLrWSBc
         xIHMArdk1uiY2VEdiBHrXMGpGjYbbdEEmm6ahk0Qez6lzVcj2TICGQi7zpNYZLpi3+cG
         zEWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=WzjyvpgI/0C3cgEv0rR/qqBgCA7uDyu98oGTGsbnyeY=;
        b=M3VN+Z5KhY3MzogXwilTRDiUQoRKjYvJd/U4kYFWbOyGMqrWMURlKeiXbhCi+Xv8I8
         hBeXBbP1jvX+m3JWj3HTYVkJg8NQr0kSONhUdE8s1NfRpRkl2g2yf4gTAnnuQEmtikUu
         ooAZJ0MdpijM117kITqhR2XMJu6AvDkwEmPtgPnEGCuFW5akrqlXzzbo3nlZt1Vf2tDx
         NLKGEINMRwZ1tuOmV7TgfQSIxZCAMgurrpt9RLk8m+uvJlaNqkOcVbRy6TQQyllp30Rx
         MQgqPLDn9kQFYP7ig/XaLAQEXf1UBU3wDkzk87Wc1tnAlWU+7GSHo0WONlpXdyuzaa0G
         MrjQ==
X-Gm-Message-State: AJcUukcjzKqqQHDTDbJnMeeT/PNsREVWNpCenkNwUQDi4VwolDb9hu+B
        JCwyEjuvE66Jv7uIw8MQrBJ++5eQmpU=
X-Google-Smtp-Source: ALg8bN4aXgrmSB724kEp0cwYhcB+qFEnJy9qTyEJ648cEonqqkmroLzGK4l4fQKXhK35d81aELrgsw==
X-Received: by 2002:a63:d949:: with SMTP id e9mr6806422pgj.24.1545498801622;
        Sat, 22 Dec 2018 09:13:21 -0800 (PST)
Received: from localhost.localdomain ([240f:34:212d:1:966:8499:7122:52f6])
        by smtp.gmail.com with ESMTPSA id w11sm33322025pgk.16.2018.12.22.09.13.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sat, 22 Dec 2018 09:13:21 -0800 (PST)
From:   Akinobu Mita <akinobu.mita@gmail.com>
To:     linux-media@vger.kernel.org, devicetree@vger.kernel.org
Cc:     Akinobu Mita <akinobu.mita@gmail.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH 07/12] media: mt9m001: remove remaining soc_camera specific code
Date:   Sun, 23 Dec 2018 02:12:49 +0900
Message-Id: <1545498774-11754-8-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1545498774-11754-1-git-send-email-akinobu.mita@gmail.com>
References: <1545498774-11754-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Remove remaining soc_camera specific code and drop soc_camera dependency
from this driver.

Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 drivers/media/i2c/Kconfig   |  2 +-
 drivers/media/i2c/mt9m001.c | 84 ++++++++-------------------------------------
 2 files changed, 15 insertions(+), 71 deletions(-)

diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index 0efc038..4bdf043 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -845,7 +845,7 @@ config VIDEO_VS6624
 
 config VIDEO_MT9M001
 	tristate "mt9m001 support"
-	depends on SOC_CAMERA && I2C
+	depends on I2C && VIDEO_V4L2
 	help
 	  This driver supports MT9M001 cameras from Micron, monochrome
 	  and colour models.
diff --git a/drivers/media/i2c/mt9m001.c b/drivers/media/i2c/mt9m001.c
index f20188a..eb5c4ed 100644
--- a/drivers/media/i2c/mt9m001.c
+++ b/drivers/media/i2c/mt9m001.c
@@ -15,15 +15,12 @@
 #include <linux/log2.h>
 #include <linux/module.h>
 
-#include <media/soc_camera.h>
-#include <media/drv-intf/soc_mediabus.h>
 #include <media/v4l2-subdev.h>
 #include <media/v4l2-ctrls.h>
+#include <media/v4l2-device.h>
 
 /*
  * mt9m001 i2c address 0x5d
- * The platform has to define struct i2c_board_info objects and link to them
- * from struct soc_camera_host_desc
  */
 
 /* mt9m001 selected register addresses */
@@ -278,11 +275,15 @@ static int mt9m001_set_selection(struct v4l2_subdev *sd,
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
@@ -561,12 +562,10 @@ static int mt9m001_s_ctrl(struct v4l2_ctrl *ctrl)
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
@@ -581,9 +580,11 @@ static int mt9m001_video_probe(struct soc_camera_subdev_desc *ssdd,
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
@@ -592,26 +593,6 @@ static int mt9m001_video_probe(struct soc_camera_subdev_desc *ssdd,
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
@@ -630,12 +611,6 @@ static int mt9m001_video_probe(struct soc_camera_subdev_desc *ssdd,
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
@@ -675,41 +650,18 @@ static int mt9m001_enum_mbus_code(struct v4l2_subdev *sd,
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
@@ -736,21 +688,15 @@ static int mt9m001_probe(struct i2c_client *client,
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
 
@@ -808,7 +754,7 @@ static int mt9m001_probe(struct i2c_client *client,
 	pm_runtime_set_active(&client->dev);
 	pm_runtime_enable(&client->dev);
 
-	ret = mt9m001_video_probe(ssdd, client);
+	ret = mt9m001_video_probe(client);
 	if (ret)
 		goto error_power_off;
 
@@ -831,7 +777,6 @@ static int mt9m001_probe(struct i2c_client *client,
 static int mt9m001_remove(struct i2c_client *client)
 {
 	struct mt9m001 *mt9m001 = to_mt9m001(client);
-	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
 
 	v4l2_device_unregister_subdev(&mt9m001->subdev);
 	pm_runtime_get_sync(&client->dev);
@@ -842,7 +787,6 @@ static int mt9m001_remove(struct i2c_client *client)
 	mt9m001_power_off(mt9m001);
 
 	v4l2_ctrl_handler_free(&mt9m001->hdl);
-	mt9m001_video_remove(ssdd);
 	mutex_destroy(&mt9m001->mutex);
 
 	return 0;
-- 
2.7.4

