Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:49344 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756877AbcDLWng (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Apr 2016 18:43:36 -0400
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org,
	Javier Martinez Canillas <javier@osg.samsung.com>
Subject: [RFC PATCH v2 2/2] [media] tvp5150: Replace connector support according to DT binding
Date: Tue, 12 Apr 2016 18:42:53 -0400
Message-Id: <1460500973-9066-3-git-send-email-javier@osg.samsung.com>
In-Reply-To: <1460500973-9066-1-git-send-email-javier@osg.samsung.com>
References: <1460500973-9066-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The tvp5150 and tvp5151 decoders support different video input source
connections to their AIP1A and AIP1B pins. Either two Composite or a
S-Video input signals are supported.

The input connector support was added before to the device DT binding
with commit 82c2ffeb217a ("[media] tvp5150: document input connectors
DT bindings"), but the binding was found to be wrong so was reverted.

A new binding documentation was added that uses OF graph endpoint and
ports for the input connectors, so this patch replaces the old logic
to be aligned to what is described in the latest tvp5150 binding doc.

The DT binding only describes the type of the input connectors and not
how the signals are routed to the chip, that information is inferred
by the driver that knows what are the possible input configurations.

Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>

---

Changes in v2:
- Use a single sink pad for the demod and map the connectors as entities
  so the mux is made via links. Suggested by Mauro and Hans.

 drivers/media/i2c/tvp5150.c | 155 +++++++++++++++++++++++++++++++-------------
 1 file changed, 111 insertions(+), 44 deletions(-)

diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
index ff18444e19e4..e5003d94f262 100644
--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -1338,15 +1338,112 @@ static int tvp5150_init(struct i2c_client *c)
 	return 0;
 }
 
+#ifdef CONFIG_MEDIA_CONTROLLER
+static int tvp5150_parse_connector_node(struct tvp5150 *decoder,
+					struct device_node *port)
+{
+	struct v4l2_of_endpoint endpoint;
+	struct media_entity *input;
+	struct device_node *ep, *rp;
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
+	rp = of_graph_get_remote_port_parent(ep);
+	if (!rp) {
+		v4l2_err(&decoder->sd, "Port %s remote parent not found\n",
+			 ep->full_name);
+		ret = -EINVAL;
+		goto err_ep;
+	}
+
+	switch (input_type) {
+	case TVP5150_COMPOSITE0:
+	case TVP5150_COMPOSITE1:
+		if (!of_device_is_compatible(rp, "composite-video-connector")) {
+			v4l2_err(&decoder->sd, "Wrong compatible for port %s\n",
+				 rp->full_name);
+			ret = -EINVAL;
+			goto err_rp;
+		}
+
+		input->function = MEDIA_ENT_F_CONN_COMPOSITE;
+		break;
+	case TVP5150_SVIDEO:
+		if (!of_device_is_compatible(rp, "svideo-connector")) {
+			v4l2_err(&decoder->sd, "Wrong compatible for port %s\n",
+				 rp->full_name);
+			ret = -EINVAL;
+			goto err_rp;
+		}
+
+		input->function = MEDIA_ENT_F_CONN_SVIDEO;
+		break;
+	}
+
+	input->flags = MEDIA_ENT_FL_CONNECTOR;
+
+	ret = of_property_read_string(rp, "label", &name);
+	if (ret < 0) {
+		v4l2_err(&decoder->sd,
+			 "Missing label property in port %s\n",
+			 rp->full_name);
+		goto err_rp;
+	}
+
+	input->name = name;
+
+err_rp:
+	of_node_put(rp);
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
@@ -1377,52 +1474,22 @@ static int tvp5150_parse_dt(struct tvp5150 *decoder, struct device_node *np)
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
-- 
2.5.5

