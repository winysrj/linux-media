Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:44205 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753417AbcAGMrn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 7 Jan 2016 07:47:43 -0500
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: devicetree@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Enrico Butera <ebutera@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Enric Balletbo i Serra <eballetbo@gmail.com>,
	Rob Herring <robh+dt@kernel.org>,
	Eduard Gavin <egavinc@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org,
	Javier Martinez Canillas <javier@osg.samsung.com>
Subject: [PATCH v2 10/10] [media] tvp5150: Configure data interface via DT
Date: Thu,  7 Jan 2016 09:46:50 -0300
Message-Id: <1452170810-32346-11-git-send-email-javier@osg.samsung.com>
In-Reply-To: <1452170810-32346-1-git-send-email-javier@osg.samsung.com>
References: <1452170810-32346-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The video decoder supports either 8-bit 4:2:2 YUV with discrete syncs
or 8-bit ITU-R BT.656 with embedded syncs output format but currently
BT.656 it's always reported. Allow to configure the format to use via
either platform data or a device tree definition.

Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>

---

Changes in v2:
- Embed mbus_type into struct tvp5150. Suggested by Laurent Pinchart.
- Remove platform data support. Suggested by Laurent Pinchart.
- Check if the hsync, vsync and field even active properties are correct.
  Suggested by Laurent Pinchart.

 drivers/media/i2c/tvp5150.c | 66 ++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 63 insertions(+), 3 deletions(-)

diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
index 48df7615eb64..813c7181dca9 100644
--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -15,6 +15,7 @@
 #include <media/v4l2-device.h>
 #include <media/i2c/tvp5150.h>
 #include <media/v4l2-ctrls.h>
+#include <media/v4l2-of.h>
 
 #include "tvp5150_reg.h"
 
@@ -44,6 +45,8 @@ struct tvp5150 {
 	u32 input;
 	u32 output;
 	int enable;
+
+	enum v4l2_mbus_type mbus_type;
 };
 
 static inline struct tvp5150 *to_tvp5150(struct v4l2_subdev *sd)
@@ -774,6 +777,10 @@ static int tvp5150_reset(struct v4l2_subdev *sd, u32 val)
 	v4l2_ctrl_handler_setup(&decoder->hdl);
 
 	tvp5150_set_std(sd, decoder->norm);
+
+	if (decoder->mbus_type == V4L2_MBUS_PARALLEL)
+		tvp5150_write(sd, TVP5150_DATA_RATE_SEL, 0x40);
+
 	return 0;
 };
 
@@ -940,7 +947,9 @@ static int tvp5150_cropcap(struct v4l2_subdev *sd, struct v4l2_cropcap *a)
 static int tvp5150_g_mbus_config(struct v4l2_subdev *sd,
 				 struct v4l2_mbus_config *cfg)
 {
-	cfg->type = V4L2_MBUS_BT656;
+	struct tvp5150 *decoder = to_tvp5150(sd);
+
+	cfg->type = decoder->mbus_type;
 	cfg->flags = V4L2_MBUS_MASTER | V4L2_MBUS_PCLK_SAMPLE_RISING
 		   | V4L2_MBUS_FIELD_EVEN_LOW | V4L2_MBUS_DATA_ACTIVE_HIGH;
 
@@ -986,13 +995,20 @@ static int tvp5150_enum_frame_size(struct v4l2_subdev *sd,
 
 static int tvp5150_s_stream(struct v4l2_subdev *sd, int enable)
 {
+	struct tvp5150 *decoder = to_tvp5150(sd);
+	/* Output format: 8-bit ITU-R BT.656 with embedded syncs */
+	int val = 0x09;
+
+	/* Output format: 8-bit 4:2:2 YUV with discrete sync */
+	if (decoder->mbus_type == V4L2_MBUS_PARALLEL)
+		val = 0x0d;
+
 	/* Initializes TVP5150 to its default values */
 	/* # set PCLK (27MHz) */
 	tvp5150_write(sd, TVP5150_CONF_SHARED_PIN, 0x00);
 
-	/* Output format: 8-bit ITU-R BT.656 with embedded syncs */
 	if (enable)
-		tvp5150_write(sd, TVP5150_MISC_CTL, 0x09);
+		tvp5150_write(sd, TVP5150_MISC_CTL, val);
 	else
 		tvp5150_write(sd, TVP5150_MISC_CTL, 0x00);
 
@@ -1228,11 +1244,42 @@ static int tvp5150_init(struct i2c_client *c)
 	return 0;
 }
 
+static int tvp5150_parse_dt(struct tvp5150 *decoder, struct device_node *np)
+{
+	struct v4l2_of_endpoint bus_cfg;
+	struct device_node *ep;
+	unsigned int flags;
+	int ret = 0;
+
+	ep = of_graph_get_next_endpoint(np, NULL);
+	if (!ep)
+		return -EINVAL;
+
+	ret = v4l2_of_parse_endpoint(ep, &bus_cfg);
+	if (ret)
+		goto err;
+
+	flags = bus_cfg.bus.parallel.flags;
+
+	if (bus_cfg.bus_type == V4L2_MBUS_PARALLEL &&
+	    !(flags & V4L2_MBUS_HSYNC_ACTIVE_HIGH &&
+	      flags & V4L2_MBUS_VSYNC_ACTIVE_HIGH &&
+	      flags & V4L2_MBUS_FIELD_EVEN_LOW))
+		return -EINVAL;
+
+	decoder->mbus_type = bus_cfg.bus_type;
+
+err:
+	of_node_put(ep);
+	return ret;
+}
+
 static int tvp5150_probe(struct i2c_client *c,
 			 const struct i2c_device_id *id)
 {
 	struct tvp5150 *core;
 	struct v4l2_subdev *sd;
+	struct device_node *np = c->dev.of_node;
 	int res;
 
 	/* Check if the adapter supports the needed features */
@@ -1247,7 +1294,20 @@ static int tvp5150_probe(struct i2c_client *c,
 	core = devm_kzalloc(&c->dev, sizeof(*core), GFP_KERNEL);
 	if (!core)
 		return -ENOMEM;
+
 	sd = &core->sd;
+
+	if (IS_ENABLED(CONFIG_OF) && np) {
+		res = tvp5150_parse_dt(core, np);
+		if (res) {
+			v4l2_err(sd, "DT parsing error: %d\n", res);
+			return res;
+		}
+	} else {
+		/* Default to BT.656 embedded sync */
+		core->mbus_type = V4L2_MBUS_BT656;
+	}
+
 	v4l2_i2c_subdev_init(sd, c, &tvp5150_ops);
 	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
 
-- 
2.4.3

