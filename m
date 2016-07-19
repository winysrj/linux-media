Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:56073 "EHLO
	smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753917AbcGSOXP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jul 2016 10:23:15 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>
To: linux-media@vger.kernel.org, ulrich.hecht@gmail.com,
	hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com
Cc: linux-renesas-soc@vger.kernel.org,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCHv2 09/16] [media] rcar-vin: rework how subdeivce is found and bound
Date: Tue, 19 Jul 2016 16:21:00 +0200
Message-Id: <20160719142107.22358-10-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20160719142107.22358-1-niklas.soderlund+renesas@ragnatech.se>
References: <20160719142107.22358-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The original drivers code to find a subdevice by looking in the DT graph
and how the callbacks to the v4l2 async bind framework where poorly
written. The most obvious example of badness was the duplication of data
in the struct rvin_graph_entity.

This patch removes the data duplication, simplifies the parsing of the
DT graph and add checks to the v4l2 callbacks.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-core.c | 232 +++++++++++++---------------
 drivers/media/platform/rcar-vin/rcar-vin.h  |   8 +-
 2 files changed, 111 insertions(+), 129 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index 6744325..6934940 100644
--- a/drivers/media/platform/rcar-vin/rcar-core.c
+++ b/drivers/media/platform/rcar-vin/rcar-core.c
@@ -31,16 +31,14 @@
 
 #define notifier_to_vin(n) container_of(n, struct rvin_dev, notifier)
 
-static int rvin_mbus_supported(struct rvin_dev *vin)
+static bool rvin_mbus_supported(struct rvin_dev *vin)
 {
-	struct v4l2_subdev *sd;
+	struct v4l2_subdev *sd = vin->digital.subdev;
 	struct v4l2_subdev_mbus_code_enum code = {
 		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
 	};
 	bool found;
 
-	sd = vin_to_source(vin);
-
 	code.index = 0;
 	while (!v4l2_subdev_call(sd, pad, enum_mbus_code, NULL, &code)) {
 		code.index++;
@@ -50,8 +48,6 @@ static int rvin_mbus_supported(struct rvin_dev *vin)
 		case MEDIA_BUS_FMT_UYVY10_2X10:
 		case MEDIA_BUS_FMT_RGB888_1X24:
 			vin->source.code = code.code;
-			vin_dbg(vin, "Found supported media bus format: %d\n",
-				vin->source.code);
 			return true;
 		default:
 			break;
@@ -100,17 +96,22 @@ static int rvin_digital_notify_complete(struct v4l2_async_notifier *notifier)
 	struct rvin_dev *vin = notifier_to_vin(notifier);
 	int ret;
 
+	/* Verify subdevices mbus format */
+	if (!rvin_mbus_supported(vin)) {
+		vin_err(vin, "Unsupported media bus format for %s\n",
+			vin->digital.subdev->name);
+		return -EINVAL;
+	}
+
+	vin_dbg(vin, "Found media bus format for %s: %d\n",
+		vin->digital.subdev->name, vin->source.code);
+
 	ret = v4l2_device_register_subdev_nodes(&vin->v4l2_dev);
 	if (ret < 0) {
 		vin_err(vin, "Failed to register subdev nodes\n");
 		return ret;
 	}
 
-	if (!rvin_mbus_supported(vin)) {
-		vin_err(vin, "No supported mediabus format found\n");
-		return -EINVAL;
-	}
-
 	return rvin_v4l2_probe(vin);
 }
 
@@ -120,7 +121,14 @@ static void rvin_digital_notify_unbind(struct v4l2_async_notifier *notifier,
 {
 	struct rvin_dev *vin = notifier_to_vin(notifier);
 
-	rvin_v4l2_remove(vin);
+	if (vin->digital.subdev == subdev) {
+		vin_dbg(vin, "unbind digital subdev %s\n", subdev->name);
+		rvin_v4l2_remove(vin);
+		vin->digital.subdev = NULL;
+		return;
+	}
+
+	vin_err(vin, "no entity for subdev %s to unbind\n", subdev->name);
 }
 
 static int rvin_digital_notify_bound(struct v4l2_async_notifier *notifier,
@@ -129,89 +137,111 @@ static int rvin_digital_notify_bound(struct v4l2_async_notifier *notifier,
 {
 	struct rvin_dev *vin = notifier_to_vin(notifier);
 
-	vin_dbg(vin, "subdev %s bound\n", subdev->name);
+	v4l2_set_subdev_hostdata(subdev, vin);
 
-	vin->digital.entity = &subdev->entity;
-	vin->digital.subdev = subdev;
+	if (vin->digital.asd.match.of.node == subdev->dev->of_node) {
+		vin_dbg(vin, "bound digital subdev %s\n", subdev->name);
+		vin->digital.subdev = subdev;
+		return 0;
+	}
 
-	return 0;
+	vin_err(vin, "no entity for subdev %s to bind\n", subdev->name);
+	return -EINVAL;
 }
 
-static int rvin_digital_parse(struct rvin_dev *vin,
-			      struct device_node *node)
+static int rvin_digitial_parse_v4l2(struct rvin_dev *vin,
+				    struct device_node *ep,
+				    struct v4l2_mbus_config *mbus_cfg)
 {
-	struct device_node *remote;
-	struct device_node *ep = NULL;
-	struct device_node *next;
-	int ret = 0;
-
-	while (1) {
-		next = of_graph_get_next_endpoint(node, ep);
-		if (!next)
-			break;
+	struct v4l2_of_endpoint v4l2_ep;
+	int ret;
 
-		of_node_put(ep);
-		ep = next;
+	ret = v4l2_of_parse_endpoint(ep, &v4l2_ep);
+	if (ret) {
+		vin_err(vin, "Could not parse v4l2 endpoint\n");
+		return -EINVAL;
+	}
 
-		remote = of_graph_get_remote_port_parent(ep);
-		if (!remote) {
-			ret = -EINVAL;
-			break;
-		}
+	mbus_cfg->type = v4l2_ep.bus_type;
 
-		/* Skip entities that we have already processed. */
-		if (remote == vin->dev->of_node) {
-			of_node_put(remote);
-			continue;
-		}
+	switch (mbus_cfg->type) {
+	case V4L2_MBUS_PARALLEL:
+		vin_dbg(vin, "Found PARALLEL media bus\n");
+		mbus_cfg->flags = v4l2_ep.bus.parallel.flags;
+		break;
+	case V4L2_MBUS_BT656:
+		vin_dbg(vin, "Found BT656 media bus\n");
+		mbus_cfg->flags = 0;
+		break;
+	default:
+		vin_err(vin, "Unknown media bus type\n");
+		return -EINVAL;
+	}
 
-		/* Remote node to connect */
-		if (!vin->digital.node) {
-			vin->digital.node = remote;
-			vin->digital.asd.match_type = V4L2_ASYNC_MATCH_OF;
-			vin->digital.asd.match.of.node = remote;
-			ret++;
-		}
+	return 0;
+}
+
+static int rvin_digital_graph_parse(struct rvin_dev *vin)
+{
+	struct device_node *ep, *np;
+	int ret;
+
+	vin->digital.asd.match.of.node = NULL;
+	vin->digital.subdev = NULL;
+
+	/*
+	 * Port 0 id 0 is local digital input, try to get it.
+	 * Not all instances can or will have this, that is OK
+	 */
+	ep = of_graph_get_endpoint_by_regs(vin->dev->of_node, 0, 0);
+	if (!ep)
+		return 0;
+
+	np = of_graph_get_remote_port_parent(ep);
+	if (!np) {
+		vin_err(vin, "No remote parent for digital input\n");
+		of_node_put(ep);
+		return -EINVAL;
 	}
+	of_node_put(np);
 
+	ret = rvin_digitial_parse_v4l2(vin, ep, &vin->mbus_cfg);
 	of_node_put(ep);
+	if (ret)
+		return ret;
 
-	return ret;
+	vin->digital.asd.match.of.node = np;
+	vin->digital.asd.match_type = V4L2_ASYNC_MATCH_OF;
+
+	return 0;
 }
 
-static int rvin_digital_init(struct rvin_dev *vin)
+static int rvin_digital_graph_init(struct rvin_dev *vin)
 {
 	struct v4l2_async_subdev **subdevs = NULL;
 	int ret;
 
-	/* Parse the graph to extract a list of subdevice DT nodes. */
-	ret = rvin_digital_parse(vin, vin->dev->of_node);
-	if (ret < 0) {
-		vin_err(vin, "Graph parsing failed\n");
-		goto done;
-	}
-
-	if (!ret) {
-		vin_err(vin, "No subdev found in graph\n");
-		goto done;
-	}
+	ret = rvin_digital_graph_parse(vin);
+	if (ret)
+		return ret;
 
-	if (ret != 1) {
-		vin_err(vin, "More then one subdev found in graph\n");
-		goto done;
+	if (!vin->digital.asd.match.of.node) {
+		vin_dbg(vin, "No digital subdevice found\n");
+		return -ENODEV;
 	}
 
 	/* Register the subdevices notifier. */
 	subdevs = devm_kzalloc(vin->dev, sizeof(*subdevs), GFP_KERNEL);
-	if (subdevs == NULL) {
-		ret = -ENOMEM;
-		goto done;
-	}
+	if (subdevs == NULL)
+		return -ENOMEM;
 
 	subdevs[0] = &vin->digital.asd;
 
-	vin->notifier.subdevs = subdevs;
+	vin_dbg(vin, "Found digital subdevice %s\n",
+		of_node_full_name(subdevs[0]->match.of.node));
+
 	vin->notifier.num_subdevs = 1;
+	vin->notifier.subdevs = subdevs;
 	vin->notifier.bound = rvin_digital_notify_bound;
 	vin->notifier.unbind = rvin_digital_notify_unbind;
 	vin->notifier.complete = rvin_digital_notify_complete;
@@ -219,18 +249,10 @@ static int rvin_digital_init(struct rvin_dev *vin)
 	ret = v4l2_async_notifier_register(&vin->v4l2_dev, &vin->notifier);
 	if (ret < 0) {
 		vin_err(vin, "Notifier registration failed\n");
-		goto done;
-	}
-
-	ret = 0;
-
-done:
-	if (ret < 0) {
-		v4l2_async_notifier_unregister(&vin->notifier);
-		of_node_put(vin->digital.node);
+		return ret;
 	}
 
-	return ret;
+	return 0;
 }
 
 /* -----------------------------------------------------------------------------
@@ -248,52 +270,9 @@ static const struct of_device_id rvin_of_id_table[] = {
 };
 MODULE_DEVICE_TABLE(of, rvin_of_id_table);
 
-static int rvin_parse_dt(struct rvin_dev *vin)
-{
-	const struct of_device_id *match;
-	struct v4l2_of_endpoint ep;
-	struct device_node *np;
-	int ret;
-
-	match = of_match_device(of_match_ptr(rvin_of_id_table), vin->dev);
-	if (!match)
-		return -ENODEV;
-
-	vin->chip = (enum chip_id)match->data;
-
-	np = of_graph_get_next_endpoint(vin->dev->of_node, NULL);
-	if (!np) {
-		vin_err(vin, "Could not find endpoint\n");
-		return -EINVAL;
-	}
-
-	ret = v4l2_of_parse_endpoint(np, &ep);
-	if (ret) {
-		vin_err(vin, "Could not parse endpoint\n");
-		return ret;
-	}
-
-	of_node_put(np);
-
-	vin->mbus_cfg.type = ep.bus_type;
-
-	switch (vin->mbus_cfg.type) {
-	case V4L2_MBUS_PARALLEL:
-		vin->mbus_cfg.flags = ep.bus.parallel.flags;
-		break;
-	case V4L2_MBUS_BT656:
-		vin->mbus_cfg.flags = 0;
-		break;
-	default:
-		vin_err(vin, "Unknown media bus type\n");
-		return -EINVAL;
-	}
-
-	return 0;
-}
-
 static int rcar_vin_probe(struct platform_device *pdev)
 {
+	const struct of_device_id *match;
 	struct rvin_dev *vin;
 	struct resource *mem;
 	int irq, ret;
@@ -302,11 +281,12 @@ static int rcar_vin_probe(struct platform_device *pdev)
 	if (!vin)
 		return -ENOMEM;
 
-	vin->dev = &pdev->dev;
+	match = of_match_device(of_match_ptr(rvin_of_id_table), &pdev->dev);
+	if (!match)
+		return -ENODEV;
 
-	ret = rvin_parse_dt(vin);
-	if (ret)
-		return ret;
+	vin->dev = &pdev->dev;
+	vin->chip = (enum chip_id)match->data;
 
 	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (mem == NULL)
@@ -324,7 +304,7 @@ static int rcar_vin_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	ret = rvin_digital_init(vin);
+	ret = rvin_digital_graph_init(vin);
 	if (ret < 0)
 		goto error;
 
diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h b/drivers/media/platform/rcar-vin/rcar-vin.h
index 9488ca3..8f25c4b 100644
--- a/drivers/media/platform/rcar-vin/rcar-vin.h
+++ b/drivers/media/platform/rcar-vin/rcar-vin.h
@@ -70,10 +70,12 @@ struct rvin_video_format {
 	u8 bpp;
 };
 
+/**
+ * struct rvin_graph_entity - Video endpoint from async framework
+ * @asd:	sub-device descriptor for async framework
+ * @subdev:	subdevice matched using async framework
+ */
 struct rvin_graph_entity {
-	struct device_node *node;
-	struct media_entity *entity;
-
 	struct v4l2_async_subdev asd;
 	struct v4l2_subdev *subdev;
 };
-- 
2.9.0

