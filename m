Return-Path: <SRS0=yFxv=OW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,T_MIXED_ES,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 670D4C67839
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 15:39:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2B1B82086D
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 15:39:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ILtLu5mx"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2B1B82086D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729172AbeLMPjJ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 13 Dec 2018 10:39:09 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:41627 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728983AbeLMPjJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Dec 2018 10:39:09 -0500
Received: by mail-lj1-f193.google.com with SMTP id k15-v6so2156991ljc.8
        for <linux-media@vger.kernel.org>; Thu, 13 Dec 2018 07:39:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UR7uJt73LdC9cnsa2muUxsJSkIHi1mCj0tRdDPciJws=;
        b=ILtLu5mxYbsdxI1ImENHlZTyi2IkiiscgkeWNIwu2RSLRRHoYbmLNzi1bG+GHiNNLs
         vjednPB3tURk52UtFanCT6hg9vEl0LJYnV1ys6WRqraoe817nt8Qy6gM+CBzx5zhswJf
         u1HtJq4Tn25BZpuaVRmC2gqgtz/qTwQryvB446CVoatG5Zi6y1Uac0vGrO4P3VME6spZ
         HLMxAaaPA9tTY1j5E8fvwNvnlJa8gpAhLZxoupAchMyeqbt15TmXuDxV85/r1yLJ7Igo
         Ctj0AAoNKWwBdjaulcb6fF4QOc7rHNbiDCgpF404DhodqvCLYlvzwkRmmVR5CdyPbzgl
         eKqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UR7uJt73LdC9cnsa2muUxsJSkIHi1mCj0tRdDPciJws=;
        b=OFYrNeKSlFVlxf+hl+L1/rtM0hnO/GbAqpqPA8WNMlEM/JifzyhAOu0xQqNIv8MXzV
         ZYKDKhCIDp/x96bpZuUBv3JE4MwC0Sq+6184pDbHIQ/HUuboRWiGyB/NkBF3l2Sy/PtH
         /Y6brukpC4MMG2x2chNltxcDJSntGNnbm+V6obe/rXSuPmpvZmrWVyo0EVae/X6vQLJx
         w0jKlbHz9rZoMdUz5FmkxH4UGRxtW1PzitfHJmK8hqw4/nc/Bw3V1oWG1wivuTeQJhF/
         gBpLin1XQ23KxEX3Vwx2YNlSR11I5hyf3Tnkb7l3jDsswBLkRnCkmguULWkdrD3JUFSh
         0RgQ==
X-Gm-Message-State: AA+aEWYKGqQJKVfgW0h04z1ZeLuel8yL9uhkBrpiL9wC4mWgYlVNJROz
        sQj3T4jiBIS1x5wg6dNPzOY=
X-Google-Smtp-Source: AFSGD/X0zUFCPZD4lS/d1hJw1EWau/t9+F1Au8tenC72EzDL/Qbmb6KazZYwrhxCrKfdCqDvPkytxA==
X-Received: by 2002:a2e:5d12:: with SMTP id r18-v6mr16635067ljb.89.1544715546839;
        Thu, 13 Dec 2018 07:39:06 -0800 (PST)
Received: from kontron.lan (2001-1ae9-0ff1-f191-41f2-812a-df1c-0485.ip6.tmcz.cz. [2001:1ae9:ff1:f191:41f2:812a:df1c:485])
        by smtp.gmail.com with ESMTPSA id q67sm412869lfe.19.2018.12.13.07.39.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Dec 2018 07:39:06 -0800 (PST)
From:   petrcvekcz@gmail.com
X-Google-Original-From: petrcvekcz.gmail.com
To:     hans.verkuil@cisco.com, jacopo@jmondi.org, mchehab@kernel.org,
        marek.vasut@gmail.com
Cc:     Petr Cvek <petrcvekcz@gmail.com>, linux-media@vger.kernel.org,
        robert.jarzmik@free.fr, slapin@ossfans.org,
        philipp.zabel@gmail.com, sakari.ailus@iki.fi
Subject: [PATCH v3 2/8] media: i2c: ov9640: drop soc_camera code and switch to v4l2_async
Date:   Thu, 13 Dec 2018 16:39:13 +0100
Message-Id: <c0e60ae3a15bcf09eef19859f337be3835ef12b3.1544713575.git.petrcvekcz@gmail.com>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <cover.1544713575.git.petrcvekcz@gmail.com>
References: <cover.1544713575.git.petrcvekcz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Petr Cvek <petrcvekcz@gmail.com>

This patch removes the dependency on an obsoleted soc_camera from ov9640
driver and changes the code to be a standalone v4l2 async subdevice.
It also adds GPIO allocations for power and reset signals (as they are not
handled by soc_camera now).

The values for waiting on GPIOs (reset and power) settling down were taken
from the datasheet (> 1 ms after HW/SW reset). The upper limit was chosen
as an arbitrary value. Also one occurrence of mdelay() was changed to
msleep(). The delays were successfully tested on a real hardware.

The patch makes ov9640 sensor again compatible with the pxa_camera driver.

Signed-off-by: Petr Cvek <petrcvekcz@gmail.com>
---
 drivers/media/i2c/ov9640.c | 76 ++++++++++++++++++++++++++------------
 drivers/media/i2c/ov9640.h |  2 +
 2 files changed, 55 insertions(+), 23 deletions(-)

diff --git a/drivers/media/i2c/ov9640.c b/drivers/media/i2c/ov9640.c
index eb91b8240083..1f7cf01d037f 100644
--- a/drivers/media/i2c/ov9640.c
+++ b/drivers/media/i2c/ov9640.c
@@ -9,6 +9,7 @@
  * Kuninori Morimoto <morimoto.kuninori@renesas.com>
  *
  * Based on ov7670 and soc_camera_platform driver,
+ * transition from soc_camera to pxa_camera based on mt9m111
  *
  * Copyright 2006-7 Jonathan Corbet <corbet@lwn.net>
  * Copyright (C) 2008 Magnus Damm
@@ -27,10 +28,14 @@
 #include <linux/v4l2-mediabus.h>
 #include <linux/videodev2.h>
 
-#include <media/soc_camera.h>
+#include <media/v4l2-async.h>
 #include <media/v4l2-clk.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-ctrls.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-event.h>
+
+#include <linux/gpio/consumer.h>
 
 #include "ov9640.h"
 
@@ -323,11 +328,23 @@ static int ov9640_set_register(struct v4l2_subdev *sd,
 
 static int ov9640_s_power(struct v4l2_subdev *sd, int on)
 {
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
 	struct ov9640_priv *priv = to_ov9640_sensor(sd);
-
-	return soc_camera_set_power(&client->dev, ssdd, priv->clk, on);
+	int ret = 0;
+
+	if (on) {
+		gpiod_set_value(priv->gpio_power, 1);
+		usleep_range(1000, 2000);
+		ret = v4l2_clk_enable(priv->clk);
+		usleep_range(1000, 2000);
+		gpiod_set_value(priv->gpio_reset, 0);
+	} else {
+		gpiod_set_value(priv->gpio_reset, 1);
+		usleep_range(1000, 2000);
+		v4l2_clk_disable(priv->clk);
+		usleep_range(1000, 2000);
+		gpiod_set_value(priv->gpio_power, 0);
+	}
+	return ret;
 }
 
 /* select nearest higher resolution for capture */
@@ -475,7 +492,7 @@ static int ov9640_prog_dflt(struct i2c_client *client)
 	}
 
 	/* wait for the changes to actually happen, 140ms are not enough yet */
-	mdelay(150);
+	msleep(150);
 
 	return 0;
 }
@@ -630,14 +647,10 @@ static const struct v4l2_subdev_core_ops ov9640_core_ops = {
 static int ov9640_g_mbus_config(struct v4l2_subdev *sd,
 				struct v4l2_mbus_config *cfg)
 {
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
-
 	cfg->flags = V4L2_MBUS_PCLK_SAMPLE_RISING | V4L2_MBUS_MASTER |
 		V4L2_MBUS_VSYNC_ACTIVE_HIGH | V4L2_MBUS_HSYNC_ACTIVE_HIGH |
 		V4L2_MBUS_DATA_ACTIVE_HIGH;
 	cfg->type = V4L2_MBUS_PARALLEL;
-	cfg->flags = soc_camera_apply_board_flags(ssdd, cfg);
 
 	return 0;
 }
@@ -666,18 +679,27 @@ static int ov9640_probe(struct i2c_client *client,
 			const struct i2c_device_id *did)
 {
 	struct ov9640_priv *priv;
-	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
 	int ret;
 
-	if (!ssdd) {
-		dev_err(&client->dev, "Missing platform_data for driver\n");
-		return -EINVAL;
-	}
-
-	priv = devm_kzalloc(&client->dev, sizeof(*priv), GFP_KERNEL);
+	priv = devm_kzalloc(&client->dev, sizeof(*priv),
+			    GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
 
+	priv->gpio_power = devm_gpiod_get(&client->dev, "Camera power",
+					  GPIOD_OUT_LOW);
+	if (IS_ERR_OR_NULL(priv->gpio_power)) {
+		ret = PTR_ERR(priv->gpio_power);
+		return ret;
+	}
+
+	priv->gpio_reset = devm_gpiod_get(&client->dev, "Camera reset",
+					  GPIOD_OUT_HIGH);
+	if (IS_ERR_OR_NULL(priv->gpio_reset)) {
+		ret = PTR_ERR(priv->gpio_reset);
+		return ret;
+	}
+
 	v4l2_i2c_subdev_init(&priv->subdev, client, &ov9640_subdev_ops);
 
 	v4l2_ctrl_handler_init(&priv->hdl, 2);
@@ -696,12 +718,20 @@ static int ov9640_probe(struct i2c_client *client,
 	}
 
 	ret = ov9640_video_probe(client);
-	if (ret) {
-		v4l2_clk_put(priv->clk);
-eclkget:
-		v4l2_ctrl_handler_free(&priv->hdl);
-	}
+	if (ret)
+		goto eprobe;
 
+	priv->subdev.dev = &client->dev;
+	ret = v4l2_async_register_subdev(&priv->subdev);
+	if (ret)
+		goto eprobe;
+
+	return 0;
+
+eprobe:
+	v4l2_clk_put(priv->clk);
+eclkget:
+	v4l2_ctrl_handler_free(&priv->hdl);
 	return ret;
 }
 
@@ -711,7 +741,7 @@ static int ov9640_remove(struct i2c_client *client)
 	struct ov9640_priv *priv = to_ov9640_sensor(sd);
 
 	v4l2_clk_put(priv->clk);
-	v4l2_device_unregister_subdev(&priv->subdev);
+	v4l2_async_unregister_subdev(&priv->subdev);
 	v4l2_ctrl_handler_free(&priv->hdl);
 	return 0;
 }
diff --git a/drivers/media/i2c/ov9640.h b/drivers/media/i2c/ov9640.h
index 65d13ff17536..be5e4b29ac69 100644
--- a/drivers/media/i2c/ov9640.h
+++ b/drivers/media/i2c/ov9640.h
@@ -200,6 +200,8 @@ struct ov9640_priv {
 	struct v4l2_subdev		subdev;
 	struct v4l2_ctrl_handler	hdl;
 	struct v4l2_clk			*clk;
+	struct gpio_desc		*gpio_power;
+	struct gpio_desc		*gpio_reset;
 
 	int				model;
 	int				revision;
-- 
2.20.0

