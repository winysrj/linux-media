Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:54010 "EHLO
        lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753657AbdCFO6v (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 6 Mar 2017 09:58:51 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>,
        Songjun Wu <songjun.wu@microchip.com>,
        Sakari Ailus <sakari.ailus@iki.fi>, devicetree@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv3 04/15] ov7670: get xclk
Date: Mon,  6 Mar 2017 15:56:05 +0100
Message-Id: <20170306145616.38485-5-hverkuil@xs4all.nl>
In-Reply-To: <20170306145616.38485-1-hverkuil@xs4all.nl>
References: <20170306145616.38485-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Get the clock for this sensor.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/ov7670.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/media/i2c/ov7670.c b/drivers/media/i2c/ov7670.c
index 50e4466a2b37..da0843617a49 100644
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
@@ -1587,6 +1589,15 @@ static int ov7670_probe(struct i2c_client *client,
 			info->pclk_hb_disable = true;
 	}
 
+	info->clk = devm_clk_get(&client->dev, "xclk");
+	if (IS_ERR(info->clk))
+		return -EPROBE_DEFER;
+	clk_prepare_enable(info->clk);
+
+	info->clock_speed = clk_get_rate(info->clk) / 1000000;
+	if (info->clock_speed < 10 || info->clock_speed > 48)
+		return -EINVAL;
+
 	/* Make sure it's an ov7670 */
 	ret = ov7670_detect(sd);
 	if (ret) {
@@ -1667,6 +1678,7 @@ static int ov7670_remove(struct i2c_client *client)
 
 	v4l2_device_unregister_subdev(sd);
 	v4l2_ctrl_handler_free(&info->hdl);
+	clk_disable_unprepare(info->clk);
 	return 0;
 }
 
-- 
2.11.0
