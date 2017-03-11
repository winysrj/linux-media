Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:52910 "EHLO
        lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755399AbdCKLXe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 11 Mar 2017 06:23:34 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>,
        Songjun Wu <songjun.wu@microchip.com>,
        Sakari Ailus <sakari.ailus@iki.fi>, devicetree@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv5 04/16] ov7670: get xclk
Date: Sat, 11 Mar 2017 12:23:16 +0100
Message-Id: <20170311112328.11802-5-hverkuil@xs4all.nl>
In-Reply-To: <20170311112328.11802-1-hverkuil@xs4all.nl>
References: <20170311112328.11802-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Get the clock for this sensor.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/ov7670.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/ov7670.c b/drivers/media/i2c/ov7670.c
index 50e4466a2b37..912ff09c6100 100644
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
@@ -227,6 +228,7 @@ struct ov7670_info {
 		struct v4l2_ctrl *hue;
 	};
 	struct ov7670_format_struct *fmt;  /* Current format */
+	struct clk *clk;
 	int min_width;			/* Filter out smaller sizes */
 	int min_height;			/* Filter out smaller sizes */
 	int clock_speed;		/* External clock speed (MHz) */
@@ -1587,13 +1589,24 @@ static int ov7670_probe(struct i2c_client *client,
 			info->pclk_hb_disable = true;
 	}
 
+	info->clk = devm_clk_get(&client->dev, "xclk");
+	if (IS_ERR(info->clk))
+		return -EPROBE_DEFER;
+	clk_prepare_enable(info->clk);
+
+	info->clock_speed = clk_get_rate(info->clk) / 1000000;
+	if (info->clock_speed < 10 || info->clock_speed > 48) {
+		ret = -EINVAL;
+		goto clk_disable;
+	}
+
 	/* Make sure it's an ov7670 */
 	ret = ov7670_detect(sd);
 	if (ret) {
 		v4l_dbg(1, debug, client,
 			"chip found @ 0x%x (%s) is not an ov7670 chip.\n",
 			client->addr << 1, client->adapter->name);
-		return ret;
+		goto clk_disable;
 	}
 	v4l_info(client, "chip found @ 0x%02x (%s)\n",
 			client->addr << 1, client->adapter->name);
@@ -1656,6 +1669,8 @@ static int ov7670_probe(struct i2c_client *client,
 
 hdl_free:
 	v4l2_ctrl_handler_free(&info->hdl);
+clk_disable:
+	clk_disable_unprepare(info->clk);
 	return ret;
 }
 
@@ -1667,6 +1682,7 @@ static int ov7670_remove(struct i2c_client *client)
 
 	v4l2_device_unregister_subdev(sd);
 	v4l2_ctrl_handler_free(&info->hdl);
+	clk_disable_unprepare(info->clk);
 	return 0;
 }
 
-- 
2.11.0
