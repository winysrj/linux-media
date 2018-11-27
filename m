Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:43525 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730439AbeK0VAr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Nov 2018 16:00:47 -0500
From: Marco Felsch <m.felsch@pengutronix.de>
To: mchehab@kernel.org, sakari.ailus@linux.intel.com,
        robh+dt@kernel.org, mark.rutland@arm.com
Cc: enrico.scholz@sigma-chemnitz.de, devicetree@vger.kernel.org,
        akinobu.mita@gmail.com, linux-media@vger.kernel.org,
        graphics@pengutronix.de,
        Michael Grzeschik <m.grzeschik@pengutronix.de>
Subject: [PATCH v3 6/6] media: mt9m111: allow to setup pixclk polarity
Date: Tue, 27 Nov 2018 11:02:53 +0100
Message-Id: <20181127100253.30845-7-m.felsch@pengutronix.de>
In-Reply-To: <20181127100253.30845-1-m.felsch@pengutronix.de>
References: <20181127100253.30845-1-m.felsch@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Enrico Scholz <enrico.scholz@sigma-chemnitz.de>

The chip can be configured to output data transitions on the
rising or falling edge of PIXCLK (Datasheet R58:1[9]), default is on the
falling edge.

Parsing the fw-node is made in a subfunction to bundle all (future)
dt-parsing / fw-parsing stuff.

Signed-off-by: Enrico Scholz <enrico.scholz@sigma-chemnitz.de>
(m.grzeschik@pengutronix.de: Fix inverting clock. INV_PIX_CLOCK bit is set
per default. Set bit to 0 (enable mask bit without value) to enable
falling edge sampling.)
Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
(m.felsch@pengutronix.de: use fwnode helpers)
(m.felsch@pengutronix.de: mv fw parsing into own function)
(m.felsch@pengutronix.de: adapt commit msg)
Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>

---
Changelog:

v3:
- call mt9m111_probe_fw() before v4l2_clk_get() to avoid error handling

v2:
- make use of fwnode_*() to drop OF dependency and ifdef's
- mt9m111_g_mbus_config: fix pclk_sample logic which I made due the
  conversion from Enrico's patch.
---
 drivers/media/i2c/mt9m111.c | 46 ++++++++++++++++++++++++++++++++++++-
 1 file changed, 45 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/mt9m111.c b/drivers/media/i2c/mt9m111.c
index f97fd32181ed..2ef332b9b914 100644
--- a/drivers/media/i2c/mt9m111.c
+++ b/drivers/media/i2c/mt9m111.c
@@ -15,6 +15,7 @@
 #include <linux/delay.h>
 #include <linux/v4l2-mediabus.h>
 #include <linux/module.h>
+#include <linux/property.h>
 
 #include <media/v4l2-async.h>
 #include <media/v4l2-clk.h>
@@ -22,6 +23,7 @@
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-event.h>
+#include <media/v4l2-fwnode.h>
 
 /*
  * MT9M111, MT9M112 and MT9M131:
@@ -242,6 +244,8 @@ struct mt9m111 {
 	const struct mt9m111_datafmt *fmt;
 	int lastpage;	/* PageMap cache value */
 	bool is_streaming;
+	/* user point of view - 0: falling 1: rising edge */
+	unsigned int pclk_sample:1;
 #ifdef CONFIG_MEDIA_CONTROLLER
 	struct media_pad pad;
 #endif
@@ -594,6 +598,10 @@ static int mt9m111_set_pixfmt(struct mt9m111 *mt9m111,
 		return -EINVAL;
 	}
 
+	/* receiver samples on falling edge, chip-hw default is rising */
+	if (mt9m111->pclk_sample == 0)
+		mask_outfmt2 |= MT9M111_OUTFMT_INV_PIX_CLOCK;
+
 	ret = mt9m111_reg_mask(client, context_a.output_fmt_ctrl2,
 			       data_outfmt2, mask_outfmt2);
 	if (!ret)
@@ -1084,9 +1092,15 @@ static int mt9m111_s_stream(struct v4l2_subdev *sd, int enable)
 static int mt9m111_g_mbus_config(struct v4l2_subdev *sd,
 				struct v4l2_mbus_config *cfg)
 {
-	cfg->flags = V4L2_MBUS_MASTER | V4L2_MBUS_PCLK_SAMPLE_RISING |
+	struct mt9m111 *mt9m111 = container_of(sd, struct mt9m111, subdev);
+
+	cfg->flags = V4L2_MBUS_MASTER |
 		V4L2_MBUS_HSYNC_ACTIVE_HIGH | V4L2_MBUS_VSYNC_ACTIVE_HIGH |
 		V4L2_MBUS_DATA_ACTIVE_HIGH;
+
+	cfg->flags |= mt9m111->pclk_sample ? V4L2_MBUS_PCLK_SAMPLE_RISING :
+		V4L2_MBUS_PCLK_SAMPLE_FALLING;
+
 	cfg->type = V4L2_MBUS_PARALLEL;
 
 	return 0;
@@ -1156,6 +1170,32 @@ static int mt9m111_video_probe(struct i2c_client *client)
 	return ret;
 }
 
+static int mt9m111_probe_fw(struct i2c_client *client, struct mt9m111 *mt9m111)
+{
+	struct v4l2_fwnode_endpoint *bus_cfg;
+	struct fwnode_handle *np;
+	int ret = 0;
+
+	np = fwnode_graph_get_next_endpoint(dev_fwnode(&client->dev), NULL);
+	if (!np)
+		return -EINVAL;
+
+	bus_cfg = v4l2_fwnode_endpoint_alloc_parse(np);
+	if (IS_ERR(bus_cfg)) {
+		ret = PTR_ERR(bus_cfg);
+		goto out_put_fw;
+	}
+
+	mt9m111->pclk_sample = !!(bus_cfg->bus.parallel.flags &
+				  V4L2_MBUS_PCLK_SAMPLE_RISING);
+
+	v4l2_fwnode_endpoint_free(bus_cfg);
+
+out_put_fw:
+	fwnode_handle_put(np);
+	return ret;
+}
+
 static int mt9m111_probe(struct i2c_client *client,
 			 const struct i2c_device_id *did)
 {
@@ -1173,6 +1213,10 @@ static int mt9m111_probe(struct i2c_client *client,
 	if (!mt9m111)
 		return -ENOMEM;
 
+	ret = mt9m111_probe_fw(client, mt9m111);
+	if (ret)
+		return ret;
+
 	mt9m111->clk = v4l2_clk_get(&client->dev, "mclk");
 	if (IS_ERR(mt9m111->clk))
 		return PTR_ERR(mt9m111->clk);
-- 
2.19.1
