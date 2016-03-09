Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:40289 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934018AbcCITKL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Mar 2016 14:10:11 -0500
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>
Subject: [RFC PATCH 3/3] [media] tvp5150: Replace connector support according to DT binding
Date: Wed,  9 Mar 2016 16:09:26 -0300
Message-Id: <1457550566-5465-4-git-send-email-javier@osg.samsung.com>
In-Reply-To: <1457550566-5465-1-git-send-email-javier@osg.samsung.com>
References: <1457550566-5465-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The tvp5150 and tvp5151 decoders support different video input source
connections to their AIP1A and AIP1B pins. Either two Composite input
signals or a S-Video signal are supported.

The MC input connector support was added before, but the Device Tree
binding was found to be inadecuate so it was reverted. A new binding
documentation was added so this patch replaces the old logic with a
new one according to what is described in the latest DT binding doc.

There could be different connectors for each possible configuration
or physical connectors (i.e: two RCA) can be multiplexed to support
both the two Composite and a single S-Video input.

The DT binding only describes the type of the input connection and not
how the signals are routed to the chip, that information is inferred
by the driver that knows what are the possible input configurations.

Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>

---

 drivers/media/i2c/tvp5150.c | 190 +++++++++++++++++++++++++++++++++-----------
 1 file changed, 142 insertions(+), 48 deletions(-)

diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
index ff18444e19e4..c6ea5581b7c7 100644
--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -41,7 +41,7 @@ struct tvp5150 {
 #ifdef CONFIG_MEDIA_CONTROLLER
 	struct media_pad pads[DEMOD_NUM_PADS];
 	struct media_entity input_ent[TVP5150_INPUT_NUM];
-	struct media_pad input_pad[TVP5150_INPUT_NUM];
+	struct media_pad input_pad[TVP5150_INPUT_NUM + 1]; /* 2 for S-Video */
 #endif
 	struct v4l2_ctrl_handler hdl;
 	struct v4l2_rect rect;
@@ -1176,6 +1176,8 @@ static int tvp5150_registered_async(struct v4l2_subdev *sd)
 {
 #ifdef CONFIG_MEDIA_CONTROLLER
 	struct tvp5150 *decoder = to_tvp5150(sd);
+	int num_pads;
+	u16 sink_pad;
 	int ret = 0;
 	int i;
 
@@ -1186,9 +1188,25 @@ static int tvp5150_registered_async(struct v4l2_subdev *sd)
 		if (!input->name)
 			continue;
 
+		switch (i) {
+		case TVP5150_COMPOSITE0:
+			sink_pad = DEMOD_PAD_IF_INPUT;
+			num_pads = 1;
+			break;
+		case TVP5150_COMPOSITE1:
+			sink_pad = DEMOD_PAD_C_INPUT;
+			num_pads = 1;
+			break;
+		case TVP5150_SVIDEO:
+			sink_pad = DEMOD_PAD_IF_INPUT;
+			num_pads = 2;
+			decoder->input_pad[i + 1].flags = MEDIA_PAD_FL_SOURCE;
+			break;
+		}
+
 		decoder->input_pad[i].flags = MEDIA_PAD_FL_SOURCE;
 
-		ret = media_entity_pads_init(input, 1, pad);
+		ret = media_entity_pads_init(input, num_pads, pad);
 		if (ret < 0)
 			return ret;
 
@@ -1196,12 +1214,20 @@ static int tvp5150_registered_async(struct v4l2_subdev *sd)
 		if (ret < 0)
 			return ret;
 
-		ret = media_create_pad_link(input, 0, &sd->entity,
-					    DEMOD_PAD_IF_INPUT, 0);
+		ret = media_create_pad_link(input, 0, &sd->entity, sink_pad, 0);
 		if (ret < 0) {
 			media_device_unregister_entity(input);
 			return ret;
 		}
+
+		if (input->function == MEDIA_ENT_F_CONN_SVIDEO) {
+			ret = media_create_pad_link(input, 1, &sd->entity,
+						    DEMOD_PAD_C_INPUT, 0);
+			if (ret < 0) {
+				media_device_unregister_entity(input);
+				return ret;
+			}
+		}
 	}
 #endif
 
@@ -1338,15 +1364,112 @@ static int tvp5150_init(struct i2c_client *c)
 	return 0;
 }
 
+#ifdef CONFIG_MEDIA_CONTROLLER
+static int tvp5150_parse_connector_node(struct tvp5150 *decoder,
+					struct device_node *port)
+{
+	struct v4l2_of_endpoint endpoint;
+	struct media_entity *input;
+	struct device_node *ep, *rem;
+	unsigned int input_type;
+	const char *name;
+	int ret;
+
+	/* tvp5150 connector ports can have only one endpoint. */
+	ep = of_get_next_child(port, NULL);
+	if (!ep) {
+		v4l2_err(&decoder->sd, "Endpoint not found for connector %s\n",
+			 port->full_name);
+		return -EINVAL;
+	}
+
+	ret = v4l2_of_parse_endpoint(ep, &endpoint);
+	if (ret) {
+		v4l2_err(&decoder->sd, "Connector %s parse endpoint failed %d\n",
+			 port->full_name, ret);
+		goto err_ep;
+	}
+
+	input_type = endpoint.base.port;
+
+	if (input_type >= TVP5150_INPUT_NUM) {
+		v4l2_err(&decoder->sd,
+			 "Connector %s port address %u is not a valid one\n",
+			 port->full_name, input_type);
+		ret = -EINVAL;
+		goto err_ep;
+	}
+
+	input = &decoder->input_ent[input_type];
+
+	/* Each input connector can only be defined once */
+	if (input->name) {
+		v4l2_err(&decoder->sd,
+			 "Connector %s with same type already exists\n",
+			 input->name);
+		ret = -EINVAL;
+		goto err_ep;
+	}
+
+	rem = of_graph_get_remote_port_parent(ep);
+	if (!rem) {
+		v4l2_err(&decoder->sd, "Port %s remote parent not found\n",
+			 ep->full_name);
+		ret = -EINVAL;
+		goto err_ep;
+	}
+
+	switch (input_type) {
+	case TVP5150_COMPOSITE0:
+	case TVP5150_COMPOSITE1:
+		if (!of_device_is_compatible(rem, "composite-video-connector")) {
+			v4l2_err(&decoder->sd, "Wrong compatible for port %s\n",
+				 rem->full_name);
+			ret = -EINVAL;
+			goto err_rem;
+		}
+
+		input->function = MEDIA_ENT_F_CONN_COMPOSITE;
+		break;
+	case TVP5150_SVIDEO:
+		if (!of_device_is_compatible(rem, "svideo-connector")) {
+			v4l2_err(&decoder->sd, "Wrong compatible for port %s\n",
+				 rem->full_name);
+			ret = -EINVAL;
+			goto err_rem;
+		}
+
+		input->function = MEDIA_ENT_F_CONN_SVIDEO;
+		break;
+	}
+
+	input->flags = MEDIA_ENT_FL_CONNECTOR;
+
+	ret = of_property_read_string(rem, "label", &name);
+	if (ret < 0) {
+		v4l2_err(&decoder->sd,
+			 "Missing label property in port %s\n",
+			 rem->full_name);
+		goto err_rem;
+	}
+
+	input->name = name;
+
+err_rem:
+	of_node_put(rem);
+err_ep:
+	of_node_put(ep);
+	return ret;
+
+}
+#endif
+
 static int tvp5150_parse_dt(struct tvp5150 *decoder, struct device_node *np)
 {
 	struct v4l2_of_endpoint bus_cfg;
 	struct device_node *ep;
 #ifdef CONFIG_MEDIA_CONTROLLER
 	struct device_node *connectors, *child;
-	struct media_entity *input;
-	const char *name;
-	u32 input_type;
 #endif
 	unsigned int flags;
 	int ret = 0;
@@ -1377,52 +1500,22 @@ static int tvp5150_parse_dt(struct tvp5150 *decoder, struct device_node *np)
 	if (!connectors)
 		goto err;
 
+	if (of_get_child_count(connectors) > TVP5150_INPUT_NUM) {
+		v4l2_err(&decoder->sd,
+			 "Maximum number of connectors is %d\n",
+			 TVP5150_INPUT_NUM);
+		ret = -EINVAL;
+		goto err_connector;
+	}
+
 	for_each_available_child_of_node(connectors, child) {
-		ret = of_property_read_u32(child, "input", &input_type);
+		ret = tvp5150_parse_connector_node(decoder, child);
 		if (ret) {
 			v4l2_err(&decoder->sd,
-				 "missing type property in node %s\n",
-				 child->name);
-			goto err_connector;
-		}
-
-		if (input_type >= TVP5150_INPUT_NUM) {
-			ret = -EINVAL;
+				 "Connector %s parse failed\n", child->name);
+			of_node_put(child);
 			goto err_connector;
 		}
-
-		input = &decoder->input_ent[input_type];
-
-		/* Each input connector can only be defined once */
-		if (input->name) {
-			v4l2_err(&decoder->sd,
-				 "input %s with same type already exists\n",
-				 input->name);
-			ret = -EINVAL;
-			goto err_connector;
-		}
-
-		switch (input_type) {
-		case TVP5150_COMPOSITE0:
-		case TVP5150_COMPOSITE1:
-			input->function = MEDIA_ENT_F_CONN_COMPOSITE;
-			break;
-		case TVP5150_SVIDEO:
-			input->function = MEDIA_ENT_F_CONN_SVIDEO;
-			break;
-		}
-
-		input->flags = MEDIA_ENT_FL_CONNECTOR;
-
-		ret = of_property_read_string(child, "label", &name);
-		if (ret < 0) {
-			v4l2_err(&decoder->sd,
-				 "missing label property in node %s\n",
-				 child->name);
-			goto err_connector;
-		}
-
-		input->name = name;
 	}
 
 err_connector:
@@ -1477,6 +1570,7 @@ static int tvp5150_probe(struct i2c_client *c,
 
 #if defined(CONFIG_MEDIA_CONTROLLER)
 	core->pads[DEMOD_PAD_IF_INPUT].flags = MEDIA_PAD_FL_SINK;
+	core->pads[DEMOD_PAD_C_INPUT].flags = MEDIA_PAD_FL_SINK;
 	core->pads[DEMOD_PAD_VID_OUT].flags = MEDIA_PAD_FL_SOURCE;
 	core->pads[DEMOD_PAD_VBI_OUT].flags = MEDIA_PAD_FL_SOURCE;
 
-- 
2.5.0

