Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:48651 "EHLO
        lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752425AbcLLPzY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Dec 2016 10:55:24 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>,
        Songjun Wu <songjun.wu@microchip.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 04/15] ov7670: get xclk
Date: Mon, 12 Dec 2016 16:55:09 +0100
Message-Id: <20161212155520.41375-5-hverkuil@xs4all.nl>
In-Reply-To: <20161212155520.41375-1-hverkuil@xs4all.nl>
References: <20161212155520.41375-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Get the clock for this sensor.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/ov7670.c | 35 ++++++++++++++++++++++++++++-------
 1 file changed, 28 insertions(+), 7 deletions(-)

diff --git a/drivers/media/i2c/ov7670.c b/drivers/media/i2c/ov7670.c
index 35b09d2..d2c0e23 100644
--- a/drivers/media/i2c/ov7670.c
+++ b/drivers/media/i2c/ov7670.c
@@ -10,6 +10,7 @@
  * This file may be distributed under the terms of the GNU General
  * Public License, version 2.
  */
+#include <linux/clk.h>
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/slab.h>
@@ -230,6 +231,7 @@ struct ov7670_info {
 		struct v4l2_ctrl *hue;
 	};
 	struct ov7670_format_struct *fmt;  /* Current format */
+	struct clk *clk;
 	int min_width;			/* Filter out smaller sizes */
 	int min_height;			/* Filter out smaller sizes */
 	int clock_speed;		/* External clock speed (MHz) */
@@ -1590,13 +1592,28 @@ static int ov7670_probe(struct i2c_client *client,
 			info->pclk_hb_disable = true;
 	}
 
+	info->clk = clk_get(&client->dev, "xclk");
+	if (IS_ERR(info->clk))
+		return -EPROBE_DEFER;
+	clk_prepare_enable(info->clk);
+
+	ret = ov7670_probe_dt(client, info);
+	if (ret)
+		goto clk_put;
+
+	info->clock_speed = clk_get_rate(info->clk) / 1000000;
+	if (info->clock_speed < 12 || info->clock_speed > 48) {
+		ret = -EINVAL;
+		goto clk_put;
+	}
+
 	/* Make sure it's an ov7670 */
 	ret = ov7670_detect(sd);
 	if (ret) {
 		v4l_dbg(1, debug, client,
 			"chip found @ 0x%x (%s) is not an ov7670 chip.\n",
 			client->addr << 1, client->adapter->name);
-		return ret;
+		goto clk_put;
 	}
 	v4l_info(client, "chip found @ 0x%02x (%s)\n",
 			client->addr << 1, client->adapter->name);
@@ -1637,9 +1654,8 @@ static int ov7670_probe(struct i2c_client *client,
 			V4L2_EXPOSURE_AUTO);
 	sd->ctrl_handler = &info->hdl;
 	if (info->hdl.error) {
-		int err = info->hdl.error;
-
-		goto fail;
+		ret = info->hdl.error;
+		goto hdl_free;
 	}
 
 #if defined(CONFIG_MEDIA_CONTROLLER)
@@ -1647,7 +1663,7 @@ static int ov7670_probe(struct i2c_client *client,
 	info->sd.entity.function = MEDIA_ENT_F_CAM_SENSOR;
 	ret = media_entity_pads_init(&info->sd.entity, 1, &info->pad);
 	if (ret < 0)
-		goto fail;
+		goto hdl_free;
 #endif
 	/*
 	 * We have checked empirically that hw allows to read back the gain
@@ -1664,13 +1680,16 @@ static int ov7670_probe(struct i2c_client *client,
 #if defined(CONFIG_MEDIA_CONTROLLER)
 		media_entity_cleanup(&info->sd.entity);
 #endif
-		goto fail;
+		goto hdl_free;
 	}
 
 	return 0;
 
-fail:
+hdl_free:
 	v4l2_ctrl_handler_free(&info->hdl);
+clk_put:
+	clk_disable_unprepare(info->clk);
+	clk_put(info->clk);
 	return ret;
 }
 
@@ -1685,6 +1704,8 @@ static int ov7670_remove(struct i2c_client *client)
 #if defined(CONFIG_MEDIA_CONTROLLER)
 	media_entity_cleanup(&sd->entity);
 #endif
+	clk_disable_unprepare(info->clk);
+	clk_put(info->clk);
 	return 0;
 }
 
-- 
2.10.2

