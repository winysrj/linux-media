Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:55300 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756030AbcBETKl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Feb 2016 14:10:41 -0500
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org,
	Javier Martinez Canillas <javier@osg.samsung.com>
Subject: [PATCH 8/8] [media] tvp5150: add HW input connectors support
Date: Fri,  5 Feb 2016 16:09:58 -0300
Message-Id: <1454699398-8581-9-git-send-email-javier@osg.samsung.com>
In-Reply-To: <1454699398-8581-1-git-send-email-javier@osg.samsung.com>
References: <1454699398-8581-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The tvp5150 decoder has different input connectors. The actual list of
HW inputs depends on the device version but all have at least these 3:

1) Composite0
2) Composite1
3) S-Video

and some variants have a 4th possible input connector:

4) Signal generator

The driver currently uses the .s_routing callback to switch the input
connector but since these are separate HW blocks, it's better to use
media entities to represent the input connectors and their source pads
linked with the decoder's sink pad.

This allows user-space to use the MEDIA_IOC_SETUP_LINK ioctl to choose
the input connector. For example using the media-ctl user-space tool:

$ media-ctl -r -l '"Composite0":0->"tvp5150 1-005c":0[1]'

Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>

---

 drivers/media/i2c/tvp5150.c         | 150 ++++++++++++++++++++++++++++++++++++
 include/dt-bindings/media/tvp5150.h |   2 +
 2 files changed, 152 insertions(+)

diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
index 3a32fd1df805..b8976028fc82 100644
--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -40,6 +40,8 @@ struct tvp5150 {
 	struct v4l2_subdev sd;
 #ifdef CONFIG_MEDIA_CONTROLLER
 	struct media_pad pads[DEMOD_NUM_PADS];
+	struct media_entity input_ent[TVP5150_INPUT_NUM];
+	struct media_pad input_pad[TVP5150_INPUT_NUM];
 #endif
 	struct v4l2_ctrl_handler hdl;
 	struct v4l2_rect rect;
@@ -997,6 +999,49 @@ static int tvp5150_enum_frame_size(struct v4l2_subdev *sd,
 }
 
 /****************************************************************************
+			Media entity ops
+ ****************************************************************************/
+
+static int tvp5150_link_setup(struct media_entity *entity,
+			      const struct media_pad *local,
+			      const struct media_pad *remote, u32 flags)
+{
+#ifdef CONFIG_MEDIA_CONTROLLER
+	struct v4l2_subdev *sd = media_entity_to_v4l2_subdev(entity);
+	struct tvp5150 *decoder = to_tvp5150(sd);
+	int i;
+
+	for (i = 0; i < TVP5150_INPUT_NUM; i++) {
+		if (remote->entity == &decoder->input_ent[i])
+			break;
+	}
+
+	/* Do nothing for entities that are not input connectors */
+	if (i == TVP5150_INPUT_NUM)
+		return 0;
+
+	decoder->input = i;
+
+	/* Only tvp5150am1 and tvp5151 have signal generator support */
+	if ((decoder->dev_id == 0x5150 && decoder->rom_ver == 0x0400) ||
+	    (decoder->dev_id == 0x5151 && decoder->rom_ver == 0x0100)) {
+		decoder->output = (i == TVP5150_GENERATOR ?
+				   TVP5150_BLACK_SCREEN : TVP5150_NORMAL);
+	} else {
+		decoder->output = TVP5150_NORMAL;
+	}
+
+	tvp5150_selmux(sd);
+#endif
+
+	return 0;
+}
+
+static const struct media_entity_operations tvp5150_sd_media_ops = {
+	.link_setup = tvp5150_link_setup,
+};
+
+/****************************************************************************
 			I2C Command
  ****************************************************************************/
 
@@ -1122,6 +1167,42 @@ static int tvp5150_g_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *vt)
 	return 0;
 }
 
+static int tvp5150_registered_async(struct v4l2_subdev *sd)
+{
+#ifdef CONFIG_MEDIA_CONTROLLER
+	struct tvp5150 *decoder = to_tvp5150(sd);
+	int ret = 0;
+	int i;
+
+	for (i = 0; i < TVP5150_INPUT_NUM; i++) {
+		struct media_entity *input = &decoder->input_ent[i];
+		struct media_pad *pad = &decoder->input_pad[i];
+
+		if (!input->name)
+			continue;
+
+		decoder->input_pad[i].flags = MEDIA_PAD_FL_SOURCE;
+
+		ret = media_entity_pads_init(input, 1, pad);
+		if (ret < 0)
+			return ret;
+
+		ret = media_device_register_entity(sd->v4l2_dev->mdev, input);
+		if (ret < 0)
+			return ret;
+
+		ret = media_create_pad_link(input, 0, &sd->entity,
+					    DEMOD_PAD_IF_INPUT, 0);
+		if (ret < 0) {
+			media_device_unregister_entity(input);
+			return ret;
+		}
+	}
+#endif
+
+	return 0;
+}
+
 /* ----------------------------------------------------------------------- */
 
 static const struct v4l2_ctrl_ops tvp5150_ctrl_ops = {
@@ -1135,6 +1216,7 @@ static const struct v4l2_subdev_core_ops tvp5150_core_ops = {
 	.g_register = tvp5150_g_register,
 	.s_register = tvp5150_s_register,
 #endif
+	.registered_async = tvp5150_registered_async,
 };
 
 static const struct v4l2_subdev_tuner_ops tvp5150_tuner_ops = {
@@ -1255,6 +1337,12 @@ static int tvp5150_parse_dt(struct tvp5150 *decoder, struct device_node *np)
 {
 	struct v4l2_of_endpoint bus_cfg;
 	struct device_node *ep;
+#ifdef CONFIG_MEDIA_CONTROLLER
+	struct device_node *connectors, *child;
+	struct media_entity *input;
+	const char *name;
+	u32 input_type;
+#endif
 	unsigned int flags;
 	int ret = 0;
 
@@ -1278,6 +1366,66 @@ static int tvp5150_parse_dt(struct tvp5150 *decoder, struct device_node *np)
 
 	decoder->mbus_type = bus_cfg.bus_type;
 
+#ifdef CONFIG_MEDIA_CONTROLLER
+	connectors = of_get_child_by_name(np, "connectors");
+
+	if (!connectors)
+		goto err;
+
+	for_each_available_child_of_node(connectors, child) {
+		ret = of_property_read_u32(child, "input", &input_type);
+		if (ret) {
+			v4l2_err(&decoder->sd,
+				 "missing type property in node %s\n",
+				 child->name);
+			goto err_connector;
+		}
+
+		if (input_type > TVP5150_INPUT_NUM) {
+			ret = -EINVAL;
+			goto err_connector;
+		}
+
+		input = &decoder->input_ent[input_type];
+
+		/* Each input connector can only be defined once */
+		if (input->name) {
+			v4l2_err(&decoder->sd,
+				 "input %s with same type already exists\n",
+				 input->name);
+			ret = -EINVAL;
+			goto err_connector;
+		}
+
+		switch (input_type) {
+		case TVP5150_COMPOSITE0:
+		case TVP5150_COMPOSITE1:
+			input->function = MEDIA_ENT_F_CONN_COMPOSITE;
+			break;
+		case TVP5150_SVIDEO:
+			input->function = MEDIA_ENT_F_CONN_SVIDEO;
+			break;
+		case TVP5150_GENERATOR:
+			input->function = MEDIA_ENT_F_CONN_TEST;
+			break;
+		}
+
+		input->flags = MEDIA_ENT_FL_CONNECTOR;
+
+		ret = of_property_read_string(child, "label", &name);
+		if (ret < 0) {
+			v4l2_err(&decoder->sd,
+				 "missing label property in node %s\n",
+				 child->name);
+			goto err_connector;
+		}
+
+		input->name = name;
+	}
+
+err_connector:
+	of_node_put(connectors);
+#endif
 err:
 	of_node_put(ep);
 	return ret;
@@ -1330,6 +1478,8 @@ static int tvp5150_probe(struct i2c_client *c,
 	res = media_entity_pads_init(&sd->entity, DEMOD_NUM_PADS, core->pads);
 	if (res < 0)
 		return res;
+
+	sd->entity.ops = &tvp5150_sd_media_ops;
 #endif
 
 	res = tvp5150_detect_version(core);
diff --git a/include/dt-bindings/media/tvp5150.h b/include/dt-bindings/media/tvp5150.h
index dc347569854f..d30865222082 100644
--- a/include/dt-bindings/media/tvp5150.h
+++ b/include/dt-bindings/media/tvp5150.h
@@ -27,6 +27,8 @@
 #define TVP5150_SVIDEO     2
 #define TVP5150_GENERATOR  3
 
+#define TVP5150_INPUT_NUM  4
+
 /* TVP5150 HW outputs */
 #define TVP5150_NORMAL       0
 #define TVP5150_BLACK_SCREEN 1
-- 
2.5.0

