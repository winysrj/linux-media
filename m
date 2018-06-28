Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:58701 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934577AbeF1QVa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 28 Jun 2018 12:21:30 -0400
From: Marco Felsch <m.felsch@pengutronix.de>
To: mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com
Cc: p.zabel@pengutronix.de, afshin.nasser@gmail.com,
        javierm@redhat.com, sakari.ailus@linux.intel.com,
        laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, kernel@pengutronix.de
Subject: [PATCH 19/22] [media] tvp5150: add input source selection of_graph support
Date: Thu, 28 Jun 2018 18:20:51 +0200
Message-Id: <20180628162054.25613-20-m.felsch@pengutronix.de>
In-Reply-To: <20180628162054.25613-1-m.felsch@pengutronix.de>
References: <20180628162054.25613-1-m.felsch@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The currrent driver layout had the following layout:
               +----------------+
 +-------+     |    TVP5150     |
 | Comp0 +--+  |                |
 +-------+  |  |          +-----+
 +-------+  |  +------+   | Src |
 | Comp1 +--+--|Sink  |   +-----+
 +-------+  |  +------+   +-----+
+--------+  |  |          | Src |
| SVideo +--+  |          +-----+
+--------+     +----------------+

Since the device tree abstracts the real hardware this layout is not
correct, because the TVP5150 has 3 physical ports (2 input, 1 output).
Furthermore this layout assumes that there is an additional external mux
in front of the TVP5150. This is not correct because the TVP5150 does
the muxing work. The corresponding of_graph layout will look like:
	tvp5150 {
		....
		port {
			reg = <0>;
			endpoint@0 {...};
			endpoint@1 {...};
			endpoint@2 {...};
		};

	};

This patch change the layout to:
             +----------------+
             |    TVP5150     |
 +-------+   +------+         |
 | Comp0 +---+ Sink |         |
 +-------+   +------+         |
 +-------+   +------+   +-----+
 | Comp1 +---+ Sink |   | Src |
 +-------+   +------+   +-----+
+--------+   +------+         |
| SVideo +---+ Sink |         |
+--------+   +------+         |
             +----------------+

To keep things easy an additional 'virtual' S-Video port is added. More
information about the port mapping can be found in the device tree
binding documentation. The connector entities Comp0/1, SVideo are created
only if they are connected to the correct port. If more than one connector
is available the media_entity_operations.link_setup() callback ensures that
only one connector is active. To change the input src the link between
the TVP5150 pad and the connector must be disabled, then a new link can
be enabled.

The patch tries to reduce the '#ifdef CONFIG_MEDIA_CONTROLLER' usage to
a minimum.

Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
---
 drivers/media/i2c/tvp5150.c | 322 ++++++++++++++++++++++++++++++++----
 1 file changed, 287 insertions(+), 35 deletions(-)

diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
index a6fec569a610..6ac29c62d99b 100644
--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -44,10 +44,30 @@ MODULE_PARM_DESC(debug, "Debug level (0-2)");
 
 #define dprintk0(__dev, __arg...) dev_dbg_lvl(__dev, 0, 0, __arg)
 
+enum tvp5150_ports {
+	TVP5150_PORT_AIP1A = TVP5150_COMPOSITE0,
+	TVP5150_PORT_AIP1B,
+	/* s-video port is a virtual port */
+	TVP5150_PORT_SVIDEO,
+	TVP5150_PORT_YOUT,
+	TVP5150_PORT_NUM,
+};
+
+#ifdef CONFIG_MEDIA_CONTROLLER
+struct tvp5150_connector {
+	struct media_entity con;
+	struct media_pad pad;
+	unsigned int port_num;
+};
+#endif
+
 struct tvp5150 {
 	struct v4l2_subdev sd;
+	struct device_node *endpoints[TVP5150_PORT_NUM];
 #ifdef CONFIG_MEDIA_CONTROLLER
-	struct media_pad pads[DEMOD_NUM_PADS];
+	struct media_pad pads[TVP5150_PORT_NUM];
+	struct tvp5150_connector *connectors;
+	int active;
 #endif
 	struct v4l2_ctrl_handler hdl;
 	struct v4l2_rect rect;
@@ -990,7 +1010,7 @@ static int tvp5150_fill_fmt(struct v4l2_subdev *sd,
 	struct v4l2_rect *__crop;
 	struct tvp5150 *decoder = to_tvp5150(sd);
 
-	if (!format || (format->pad != DEMOD_PAD_VID_OUT))
+	if (!format || (format->pad != TVP5150_PORT_YOUT))
 		return -EINVAL;
 
 	f = &format->format;
@@ -1189,6 +1209,62 @@ static int tvp5150_enum_frame_size(struct v4l2_subdev *sd,
 	return 0;
 }
 
+/****************************************************************************
+ *			Media entity ops
+ ****************************************************************************/
+#ifdef CONFIG_MEDIA_CONTROLLER
+static int tvp5150_s_routing(struct v4l2_subdev *sd, u32 input, u32 output,
+			     u32 config);
+static int tvp5150_link_setup(struct media_entity *entity,
+			      const struct media_pad *local,
+			      const struct media_pad *remote, u32 flags)
+{
+	struct v4l2_subdev *sd = media_entity_to_v4l2_subdev(entity);
+	struct tvp5150 *decoder = to_tvp5150(sd);
+	int ret = 0;
+
+	/*
+	 * The tvp state is determined by the enabled sink pad link.
+	 * Enabling or disabling the source pad link has no effect.
+	 */
+	if (local->flags & MEDIA_PAD_FL_SOURCE)
+		return 0;
+
+	dev_dbg(sd->dev, "link setup '%s':%d->'%s':%d[%d]",
+		remote->entity->name, remote->index, local->entity->name,
+		local->index, flags & MEDIA_LNK_FL_ENABLED);
+
+	if (flags & MEDIA_LNK_FL_ENABLED) {
+		if (decoder->active == local->index)
+			goto out;
+		if (decoder->active >= 0) {
+			ret = -EBUSY;
+			goto out;
+		}
+
+		dev_dbg(sd->dev, "Setting %d active\n", local->index);
+		decoder->active = local->index;
+		tvp5150_s_routing(sd, local->index, TVP5150_NORMAL, 0);
+	} else {
+		if (decoder->active != local->index)
+			goto out;
+
+		dev_dbg(sd->dev, "going inactive\n");
+		decoder->active = -1;
+		/*
+		 * Output black screen for deselected input if TVP5150 variant
+		 * supports this.
+		 */
+		tvp5150_s_routing(sd, local->index, TVP5150_BLACK_SCREEN, 0);
+	}
+out:
+	return ret;
+}
+
+static const struct media_entity_operations tvp5150_sd_media_ops = {
+	.link_setup = tvp5150_link_setup,
+};
+#endif
 /****************************************************************************
 			I2C Command
  ****************************************************************************/
@@ -1333,6 +1409,50 @@ static int tvp5150_g_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *vt)
 	return 0;
 }
 
+static int tvp5150_get_con_num(struct tvp5150 *decoder)
+{
+	unsigned int i, num = 0;
+
+	for (i = 0; i < TVP5150_PORT_NUM - 1; i++)
+		if (decoder->endpoints[i])
+			num++;
+	return num;
+}
+
+static int tvp5150_registered(struct v4l2_subdev *sd)
+{
+#ifdef CONFIG_MEDIA_CONTROLLER
+	struct tvp5150 *decoder = to_tvp5150(sd);
+	unsigned int i, con_num;
+	int ret;
+
+	con_num = tvp5150_get_con_num(decoder);
+	for (i = 0; i < con_num; i++) {
+		struct media_entity *con = &decoder->connectors[i].con;
+		struct media_pad *pad = &decoder->connectors[i].pad;
+		unsigned int port = decoder->connectors[i].port_num;
+
+		pad->flags = MEDIA_PAD_FL_SOURCE;
+		ret = media_entity_pads_init(con, 1, pad);
+		if (ret < 0)
+			return ret;
+
+		ret = media_device_register_entity(sd->v4l2_dev->mdev, con);
+		if (ret < 0)
+			return ret;
+
+		ret = media_create_pad_link(con, 0, &sd->entity, port, 0);
+		if (ret < 0) {
+			media_device_unregister_entity(con);
+			return ret;
+		}
+
+	}
+#endif
+	return 0;
+}
+
+
 /* ----------------------------------------------------------------------- */
 
 static const struct v4l2_ctrl_ops tvp5150_ctrl_ops = {
@@ -1386,6 +1506,10 @@ static const struct v4l2_subdev_ops tvp5150_ops = {
 	.pad = &tvp5150_pad_ops,
 };
 
+static const struct v4l2_subdev_internal_ops tvp5150_internal_ops = {
+	.registered = tvp5150_registered,
+};
+
 /****************************************************************************
 			I2C Client & Driver
  ****************************************************************************/
@@ -1534,38 +1658,171 @@ static int tvp5150_init(struct i2c_client *c)
 	return 0;
 }
 
+static int tvp5150_mc_init(struct v4l2_subdev *sd)
+{
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	struct tvp5150 *decoder = to_tvp5150(sd);
+	struct device *dev = decoder->sd.dev;
+	struct device_node *rp;
+	unsigned int con_num = 0;
+	unsigned int i, j;
+	int ret;
+
+	sd->entity.ops = &tvp5150_sd_media_ops;
+	sd->entity.function = MEDIA_ENT_F_ATV_DECODER;
+
+	/* Initialize all TVP5150 pads */
+	for (i = 0; i < TVP5150_PORT_NUM; i++)
+		decoder->pads[i].flags = (i < TVP5150_PORT_NUM - 1) ?
+							MEDIA_PAD_FL_SINK :
+							MEDIA_PAD_FL_SOURCE;
+	ret = media_entity_pads_init(&sd->entity, TVP5150_PORT_NUM,
+				     decoder->pads);
+	if (ret < 0)
+		return ret;
+
+	/* Allocate and initialize all available input connectors */
+	con_num = tvp5150_get_con_num(decoder);
+	if (!con_num)
+		return 0;
+	decoder->connectors = devm_kcalloc(dev, con_num,
+					   sizeof(*decoder->connectors),
+					   GFP_KERNEL);
+	if (!decoder->connectors)
+		return -ENOMEM;
+
+	for (i = 0, j = 0; i < TVP5150_PORT_NUM - 1; i++) {
+		if (!decoder->endpoints[i])
+			continue;
+
+		switch (i) {
+		case TVP5150_PORT_AIP1A:
+		case TVP5150_PORT_AIP1B:
+			decoder->connectors[j].con.function =
+						MEDIA_ENT_F_CONN_COMPOSITE;
+			break;
+		case TVP5150_PORT_SVIDEO:
+			decoder->connectors[j].con.function =
+						MEDIA_ENT_F_CONN_SVIDEO;
+			break;
+		}
+
+		decoder->connectors[j].con.flags = MEDIA_ENT_FL_CONNECTOR;
+		rp = of_graph_get_remote_port_parent(decoder->endpoints[i]);
+		ret = of_property_read_string(rp, "label",
+					      &decoder->connectors[j].con.name);
+		if (ret < 0)
+			return ret;
+		decoder->connectors[j].port_num = i;
+
+		j++;
+	}
+#endif
+	return 0;
+}
+
+static bool tvp5150_valid_input(struct device_node *endpoint,
+				unsigned int port)
+{
+	struct device_node *rp = of_graph_get_remote_port_parent(endpoint);
+	const char *input;
+	int ret;
+
+	switch (port) {
+	case TVP5150_PORT_AIP1A:
+	case TVP5150_PORT_AIP1B:
+		ret = of_device_is_compatible(rp, "composite-video-connector");
+		if (!ret)
+			return false;
+		break;
+	case TVP5150_PORT_SVIDEO:
+		ret = of_device_is_compatible(rp, "svideo-connector");
+		if (!ret)
+			return false;
+	}
+
+	ret = of_property_read_string(rp, "label", &input);
+	if (ret < 0)
+		return false;
+
+	return true;
+}
+
 static int tvp5150_parse_dt(struct tvp5150 *decoder, struct device_node *np)
 {
+	struct device *dev = decoder->sd.dev;
 	struct v4l2_fwnode_endpoint bus_cfg;
-	struct device_node *ep;
+	struct device_node *ep_np;
 	unsigned int flags;
-	int ret = 0;
+	int ret;
+	bool found = false;
 
-	ep = of_graph_get_next_endpoint(np, NULL);
-	if (!ep)
-		return -EINVAL;
+	for_each_endpoint_of_node(np, ep_np) {
+		struct of_endpoint ep;
 
-	ret = v4l2_fwnode_endpoint_parse(of_fwnode_handle(ep), &bus_cfg);
-	if (ret)
-		goto err;
-
-	flags = bus_cfg.bus.parallel.flags;
+		of_graph_parse_endpoint(ep_np, &ep);
+		if (decoder->endpoints[ep.port]) {
+			dev_warn(dev,
+				 "Multiple port endpoints are not supported\n");
+			continue;
+		}
 
-	if (bus_cfg.bus_type == V4L2_MBUS_PARALLEL &&
-	    !(flags & V4L2_MBUS_HSYNC_ACTIVE_HIGH &&
-	      flags & V4L2_MBUS_VSYNC_ACTIVE_HIGH &&
-	      flags & V4L2_MBUS_FIELD_EVEN_LOW)) {
-		ret = -EINVAL;
-		goto err;
-	}
+		switch (ep.port) {
+		     /* Use common tvp5150_valid_input() for all inputs */
+		case TVP5150_PORT_AIP1A:
+		case TVP5150_PORT_AIP1B:
+		case TVP5150_PORT_SVIDEO:
+			if (!tvp5150_valid_input(ep_np, ep.port)) {
+				dev_err(dev,
+					"Invalid endpoint %pOF on port %d\n",
+					ep.local_node, ep.port);
+				ret = -EINVAL;
+				goto err;
+			}
+			break;
+		case TVP5150_PORT_YOUT:
+			ret = v4l2_fwnode_endpoint_parse(of_fwnode_handle(ep_np),
+							 &bus_cfg);
+			if (ret)
+				goto err;
+
+			flags = bus_cfg.bus.parallel.flags;
+
+			if (bus_cfg.bus_type == V4L2_MBUS_PARALLEL &&
+			    !(flags & V4L2_MBUS_HSYNC_ACTIVE_HIGH &&
+			      flags & V4L2_MBUS_VSYNC_ACTIVE_HIGH &&
+			      flags & V4L2_MBUS_FIELD_EVEN_LOW)) {
+				ret = -EINVAL;
+				goto err;
+			}
+
+			decoder->mbus_type = bus_cfg.bus_type;
+			break;
+		default:
+			dev_err(dev, "Invalid port %d for endpoint %pOF\n",
+				ep.port, ep.local_node);
+			ret = -EINVAL;
+			goto err;
+		}
 
-	decoder->mbus_type = bus_cfg.bus_type;
+		of_node_get(ep_np);
+		decoder->endpoints[ep.port] = ep_np;
 
+		found = true;
+	}
+	return found ? 0 : -ENODEV;
 err:
-	of_node_put(ep);
 	return ret;
 }
 
+static void tvp5150_dt_cleanup(struct tvp5150 *decoder)
+{
+	unsigned int i;
+
+	for (i = 0; i < TVP5150_PORT_NUM; i++)
+		of_node_put(decoder->endpoints[i]);
+}
+
 static const char * const tvp5150_test_patterns[2] = {
 	"Disabled",
 	"Black screen"
@@ -1604,7 +1861,7 @@ static int tvp5150_probe(struct i2c_client *c,
 		res = tvp5150_parse_dt(core, np);
 		if (res) {
 			dev_err(sd->dev, "DT parsing error: %d\n", res);
-			return res;
+			goto err_cleanup_dt;
 		}
 	} else {
 		/* Default to BT.656 embedded sync */
@@ -1612,24 +1869,16 @@ static int tvp5150_probe(struct i2c_client *c,
 	}
 
 	v4l2_i2c_subdev_init(sd, c, &tvp5150_ops);
+	sd->internal_ops = &tvp5150_internal_ops;
 	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
 
-#if defined(CONFIG_MEDIA_CONTROLLER)
-	core->pads[DEMOD_PAD_IF_INPUT].flags = MEDIA_PAD_FL_SINK;
-	core->pads[DEMOD_PAD_VID_OUT].flags = MEDIA_PAD_FL_SOURCE;
-	core->pads[DEMOD_PAD_VBI_OUT].flags = MEDIA_PAD_FL_SOURCE;
-
-	sd->entity.function = MEDIA_ENT_F_ATV_DECODER;
-
-	res = media_entity_pads_init(&sd->entity, DEMOD_NUM_PADS, core->pads);
-	if (res < 0)
-		return res;
-
-#endif
+	res = tvp5150_mc_init(sd);
+	if (res)
+		goto err_cleanup_dt;
 
 	res = tvp5150_detect_version(core);
 	if (res < 0)
-		return res;
+		goto err_cleanup_dt;
 
 	core->norm = V4L2_STD_ALL;	/* Default is autodetect */
 	core->detected_norm = V4L2_STD_UNKNOWN;
@@ -1683,6 +1932,9 @@ static int tvp5150_probe(struct i2c_client *c,
 err:
 	v4l2_ctrl_handler_free(&core->hdl);
 	return res;
+err_cleanup_dt:
+	tvp5150_dt_cleanup(core);
+	return res;
 }
 
 static int tvp5150_remove(struct i2c_client *c)
-- 
2.17.1
