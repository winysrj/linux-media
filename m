Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:35835 "EHLO
	smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929AbcEYTTy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 May 2016 15:19:54 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>
To: linux-media@vger.kernel.org, ulrich.hecht@gmail.com,
	hverkuil@xs4all.nl
Cc: linux-renesas-soc@vger.kernel.org,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH 4/8] [media] rcar-vin: allow subdevices to be bound late
Date: Wed, 25 May 2016 21:10:05 +0200
Message-Id: <1464203409-1279-5-git-send-email-niklas.soderlund@ragnatech.se>
In-Reply-To: <1464203409-1279-1-git-send-email-niklas.soderlund@ragnatech.se>
References: <1464203409-1279-1-git-send-email-niklas.soderlund@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

This is done to prepare for Gen3 support where there are more than one
subdevice and the usage of them are complex. There is a need to be able
to change which subdevices are involved in capturing during runtime (but
not while streaming). Furtherer more the subdevices can be shared by
more then one rcar-vin instance. To be able to facilitate this for Gen3
this patch adds support to select an input (set of subdevices) after the
struct video_device have been registered.

It makes the selection when the first open occurs on the video device,
concurrent opens of the device are stuck with the input which was set by
the first open. A exception to this is if there is only one user of the
video device it is possible to change the input selection using s_input.
If s_input is attempted while there are more then one user of the video
device it will be disallowed with a -EBUSY. If a user tries to open the
video device before it has found a valid input (bound its subdevices) it
will be denied to open the video device with a -EBUSY.

At this point this change is purely academic since the driver in its
current form only supports one subdevice so not much point in trying to
change it. It do however solve the issue of bind/unbind of subdevices
and still remaining operational.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-core.c  | 425 ++++++++++++++++-----------
 drivers/media/platform/rcar-vin/rcar-dma.c   |  36 +--
 drivers/media/platform/rcar-vin/rcar-group.h | 102 +++++++
 drivers/media/platform/rcar-vin/rcar-v4l2.c  | 416 ++++++++++++--------------
 drivers/media/platform/rcar-vin/rcar-vin.h   |  49 ++-
 5 files changed, 587 insertions(+), 441 deletions(-)
 create mode 100644 drivers/media/platform/rcar-vin/rcar-group.h

diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index 341c081..b8dff90 100644
--- a/drivers/media/platform/rcar-vin/rcar-core.c
+++ b/drivers/media/platform/rcar-vin/rcar-core.c
@@ -25,48 +25,127 @@
 
 #include "rcar-vin.h"
 
+static const struct of_device_id rvin_of_id_table[] = {
+	{ .compatible = "renesas,vin-r8a7794", .data = (void *)RCAR_GEN2 },
+	{ .compatible = "renesas,vin-r8a7793", .data = (void *)RCAR_GEN2 },
+	{ .compatible = "renesas,vin-r8a7791", .data = (void *)RCAR_GEN2 },
+	{ .compatible = "renesas,vin-r8a7790", .data = (void *)RCAR_GEN2 },
+	{ .compatible = "renesas,vin-r8a7779", .data = (void *)RCAR_H1 },
+	{ .compatible = "renesas,vin-r8a7778", .data = (void *)RCAR_M1 },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, rvin_of_id_table);
+
 /* -----------------------------------------------------------------------------
- * Async notifier
+ * Subdevice group helpers
  */
 
-#define notifier_to_vin(n) container_of(n, struct rvin_dev, notifier)
-
-static int rvin_mbus_supported(struct rvin_dev *vin)
+int rvin_subdev_get(struct rvin_dev *vin)
 {
-	struct v4l2_subdev *sd;
-	struct v4l2_subdev_mbus_code_enum code = {
-		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
-	};
-
-	sd = vin_to_source(vin);
-
-	code.index = 0;
-	while (!v4l2_subdev_call(sd, pad, enum_mbus_code, NULL, &code)) {
-		code.index++;
-		switch (code.code) {
-		case MEDIA_BUS_FMT_YUYV8_1X16:
-		case MEDIA_BUS_FMT_YUYV8_2X8:
-		case MEDIA_BUS_FMT_YUYV10_2X10:
-		case MEDIA_BUS_FMT_RGB888_1X24:
-			vin->source.code = code.code;
-			vin_dbg(vin, "Found supported media bus format: %d\n",
-				vin->source.code);
-			return true;
-		default:
-			break;
-		}
+	int i, num = 0;
+
+	for (i = 0; i < RVIN_INPUT_MAX; i++) {
+		vin->inputs[i].type = RVIN_INPUT_NONE;
+		vin->inputs[i].hint = false;
+	}
+
+	/* Add local digital input */
+	if (num < RVIN_INPUT_MAX && vin->digital.subdev) {
+		vin->inputs[num].type = RVIN_INPUT_DIGITAL;
+		strncpy(vin->inputs[num].name, "Digital", RVIN_INPUT_NAME_SIZE);
+		vin->inputs[num].sink_idx =
+			sd_to_pad_idx(vin->digital.subdev, MEDIA_PAD_FL_SINK);
+		vin->inputs[num].source_idx =
+			sd_to_pad_idx(vin->digital.subdev, MEDIA_PAD_FL_SOURCE);
+		/* If last input was digital we want it again */
+		if (vin->current_input == RVIN_INPUT_DIGITAL)
+			vin->inputs[num].hint = true;
+	}
+
+	/* Make sure we have at least one input */
+	if (vin->inputs[0].type == RVIN_INPUT_NONE) {
+		vin_err(vin, "No inputs for channel with current selection\n");
+		return -EBUSY;
 	}
+	vin->current_input = 0;
+
+	/* Search for hint and prefer digital over CSI2 run over all elements */
+	for (i = 0; i < RVIN_INPUT_MAX; i++)
+		if (vin->inputs[i].hint)
+			vin->current_input = i;
+
+	return 0;
+}
+
+int rvin_subdev_put(struct rvin_dev *vin)
+{
+	/* Store what type of input we used */
+	vin->current_input = vin->inputs[vin->current_input].type;
+
+	return 0;
+}
+
+int rvin_subdev_set_input(struct rvin_dev *vin, struct rvin_input_item *item)
+{
+	if (vin->digital.subdev)
+		return 0;
+
+	return -EBUSY;
+}
+
+int rvin_subdev_get_code(struct rvin_dev *vin, u32 *code)
+{
+	*code = vin->digital.code;
+	return 0;
+}
+
+int rvin_subdev_get_mbus_cfg(struct rvin_dev *vin,
+			     struct v4l2_mbus_config *mbus_cfg)
+{
+	*mbus_cfg = vin->digital.mbus_cfg;
+	return 0;
+}
+
+struct v4l2_subdev_pad_config*
+rvin_subdev_alloc_pad_config(struct rvin_dev *vin)
+{
+	return v4l2_subdev_alloc_pad_config(vin->digital.subdev);
+}
+
+int rvin_subdev_ctrl_add_handler(struct rvin_dev *vin)
+{
+	int ret;
+
+	v4l2_ctrl_handler_free(&vin->ctrl_handler);
+
+	ret = v4l2_ctrl_handler_init(&vin->ctrl_handler, 16);
+	if (ret < 0)
+		return ret;
 
-	return false;
+	return v4l2_ctrl_add_handler(&vin->ctrl_handler,
+				     vin->digital.subdev->ctrl_handler, NULL);
 }
 
-static int rvin_graph_notify_complete(struct v4l2_async_notifier *notifier)
+/* -----------------------------------------------------------------------------
+ * Async notifier for local Digital
+ */
+
+#define notifier_to_vin(n) container_of(n, struct rvin_dev, notifier)
+
+static int rvin_digital_notify_complete(struct v4l2_async_notifier *notifier)
 {
-	struct v4l2_subdev *sd;
 	struct rvin_dev *vin = notifier_to_vin(notifier);
 	int ret;
 
-	sd = vin_to_source(vin);
+	/* Verify subdevices mbus format */
+	if (!rvin_mbus_supported(&vin->digital)) {
+		vin_err(vin, "Unsupported media bus format for %s\n",
+			vin->digital.subdev->name);
+		return -EINVAL;
+	}
+
+	vin_dbg(vin, "Found media bus format for %s: %d\n",
+		vin->digital.subdev->name, vin->digital.code);
 
 	ret = v4l2_device_register_subdev_nodes(&vin->v4l2_dev);
 	if (ret < 0) {
@@ -74,236 +153,226 @@ static int rvin_graph_notify_complete(struct v4l2_async_notifier *notifier)
 		return ret;
 	}
 
-	if (!rvin_mbus_supported(vin)) {
-		vin_err(vin, "No supported mediabus format found\n");
-		return -EINVAL;
+	return 0;
+}
+
+static void rvin_digital_notify_unbind(struct v4l2_async_notifier *notifier,
+				       struct v4l2_subdev *subdev,
+				       struct v4l2_async_subdev *asd)
+{
+	struct rvin_dev *vin = notifier_to_vin(notifier);
+
+	if (vin->digital.subdev == subdev) {
+		vin_dbg(vin, "unbind digital subdev %s\n", subdev->name);
+		vin->digital.subdev = NULL;
+		return;
 	}
 
-	return rvin_v4l2_probe(vin);
+	vin_err(vin, "no entity for subdev %s to unbind\n", subdev->name);
 }
 
-static void rvin_graph_notify_unbind(struct v4l2_async_notifier *notifier,
-				     struct v4l2_subdev *sd,
+static int rvin_digital_notify_bound(struct v4l2_async_notifier *notifier,
+				     struct v4l2_subdev *subdev,
 				     struct v4l2_async_subdev *asd)
 {
 	struct rvin_dev *vin = notifier_to_vin(notifier);
 
-	rvin_v4l2_remove(vin);
+	v4l2_set_subdev_hostdata(subdev, vin);
+
+	if (vin->digital.asd.match.of.node == subdev->dev->of_node) {
+		vin_dbg(vin, "bound digital subdev %s\n", subdev->name);
+		vin->digital.subdev = subdev;
+		return 0;
+	}
+
+	vin_err(vin, "no entity for subdev %s to bind\n", subdev->name);
+	return -EINVAL;
 }
 
-static int rvin_graph_notify_bound(struct v4l2_async_notifier *notifier,
-				   struct v4l2_subdev *subdev,
-				   struct v4l2_async_subdev *asd)
+static int rvin_digitial_parse_v4l2(struct rvin_dev *vin,
+				    struct device_node *ep,
+				    struct v4l2_mbus_config *mbus_cfg)
 {
-	struct rvin_dev *vin = notifier_to_vin(notifier);
+	struct v4l2_of_endpoint v4l2_ep;
+	int ret;
 
-	vin_dbg(vin, "subdev %s bound\n", subdev->name);
+	ret = v4l2_of_parse_endpoint(ep, &v4l2_ep);
+	if (ret) {
+		vin_err(vin, "Could not parse v4l2 endpoint\n");
+		return -EINVAL;
+	}
+
+	mbus_cfg->type = v4l2_ep.bus_type;
 
-	vin->entity.entity = &subdev->entity;
-	vin->entity.subdev = subdev;
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
 
 	return 0;
 }
 
-static int rvin_graph_parse(struct rvin_dev *vin,
-			    struct device_node *node)
+static int rvin_digital_get(struct rvin_dev *vin)
 {
-	struct device_node *remote;
-	struct device_node *ep = NULL;
-	struct device_node *next;
-	int ret = 0;
+	struct device_node *ep, *np;
+	int ret;
 
-	while (1) {
-		next = of_graph_get_next_endpoint(node, ep);
-		if (!next)
-			break;
+	vin->digital.asd.match.of.node = NULL;
+	vin->digital.subdev = NULL;
 
+	/*
+	 * Port 0 id 0 is local digital input, try to get it.
+	 * Not all instances can or will have this, that is OK
+	 */
+	ep = of_graph_get_endpoint_by_regs(vin->dev->of_node, RVIN_PORT_LOCAL,
+					   0);
+	if (!ep)
+		return 0;
+
+	np = of_graph_get_remote_port_parent(ep);
+	if (!np) {
+		vin_err(vin, "No remote parent for digital input\n");
 		of_node_put(ep);
-		ep = next;
-
-		remote = of_graph_get_remote_port_parent(ep);
-		if (!remote) {
-			ret = -EINVAL;
-			break;
-		}
-
-		/* Skip entities that we have already processed. */
-		if (remote == vin->dev->of_node) {
-			of_node_put(remote);
-			continue;
-		}
-
-		/* Remote node to connect */
-		if (!vin->entity.node) {
-			vin->entity.node = remote;
-			vin->entity.asd.match_type = V4L2_ASYNC_MATCH_OF;
-			vin->entity.asd.match.of.node = remote;
-			ret++;
-		}
+		return -EINVAL;
 	}
+	of_node_put(np);
 
+	ret = rvin_digitial_parse_v4l2(vin, ep, &vin->digital.mbus_cfg);
 	of_node_put(ep);
+	if (ret)
+		return ret;
 
-	return ret;
+	vin->digital.asd.match.of.node = np;
+	vin->digital.asd.match_type = V4L2_ASYNC_MATCH_OF;
+
+	return 0;
 }
 
-static int rvin_graph_init(struct rvin_dev *vin)
+static int rvin_digital_graph_init(struct rvin_dev *vin)
 {
 	struct v4l2_async_subdev **subdevs = NULL;
 	int ret;
 
-	/* Parse the graph to extract a list of subdevice DT nodes. */
-	ret = rvin_graph_parse(vin, vin->dev->of_node);
-	if (ret < 0) {
-		vin_err(vin, "Graph parsing failed\n");
-		goto done;
-	}
-
-	if (!ret) {
-		vin_err(vin, "No subdev found in graph\n");
-		goto done;
-	}
+	ret = rvin_digital_get(vin);
+	if (ret)
+		return ret;
 
-	if (ret != 1) {
-		vin_err(vin, "More then one subdev found in graph\n");
-		goto done;
+	if (!vin->digital.asd.match.of.node) {
+		vin_dbg(vin, "No digital subdevice found\n");
+		return -EINVAL;
 	}
 
 	/* Register the subdevices notifier. */
 	subdevs = devm_kzalloc(vin->dev, sizeof(*subdevs), GFP_KERNEL);
-	if (subdevs == NULL) {
-		ret = -ENOMEM;
-		goto done;
-	}
+	if (subdevs == NULL)
+		return -ENOMEM;
 
-	subdevs[0] = &vin->entity.asd;
+	subdevs[0] =  &vin->digital.asd;
+
+	vin_dbg(vin, "Found digital subdevice %s\n",
+		of_node_full_name(subdevs[0]->match.of.node));
 
-	vin->notifier.subdevs = subdevs;
 	vin->notifier.num_subdevs = 1;
-	vin->notifier.bound = rvin_graph_notify_bound;
-	vin->notifier.unbind = rvin_graph_notify_unbind;
-	vin->notifier.complete = rvin_graph_notify_complete;
+	vin->notifier.subdevs = subdevs;
+	vin->notifier.bound = rvin_digital_notify_bound;
+	vin->notifier.unbind = rvin_digital_notify_unbind;
+	vin->notifier.complete = rvin_digital_notify_complete;
 
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
-		of_node_put(vin->entity.node);
+		return ret;
 	}
 
-	return ret;
+	return 0;
 }
 
 /* -----------------------------------------------------------------------------
  * Platform Device Driver
  */
 
-static const struct of_device_id rvin_of_id_table[] = {
-	{ .compatible = "renesas,vin-r8a7794", .data = (void *)RCAR_GEN2 },
-	{ .compatible = "renesas,vin-r8a7793", .data = (void *)RCAR_GEN2 },
-	{ .compatible = "renesas,vin-r8a7791", .data = (void *)RCAR_GEN2 },
-	{ .compatible = "renesas,vin-r8a7790", .data = (void *)RCAR_GEN2 },
-	{ .compatible = "renesas,vin-r8a7779", .data = (void *)RCAR_H1 },
-	{ .compatible = "renesas,vin-r8a7778", .data = (void *)RCAR_M1 },
-	{ },
-};
-MODULE_DEVICE_TABLE(of, rvin_of_id_table);
-
-static int rvin_parse_dt(struct rvin_dev *vin)
+static int rvin_probe_channel(struct platform_device *pdev,
+			      struct rvin_dev *vin)
 {
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
+	struct resource *mem;
+	int irq, ret;
 
-	np = of_graph_get_next_endpoint(vin->dev->of_node, NULL);
-	if (!np) {
-		vin_err(vin, "Could not find endpoint\n");
+	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (mem == NULL)
 		return -EINVAL;
-	}
 
-	ret = v4l2_of_parse_endpoint(np, &ep);
-	if (ret) {
-		vin_err(vin, "Could not parse endpoint\n");
-		return ret;
-	}
-
-	of_node_put(np);
+	vin->base = devm_ioremap_resource(vin->dev, mem);
+	if (IS_ERR(vin->base))
+		return PTR_ERR(vin->base);
 
-	vin->mbus_cfg.type = ep.bus_type;
+	irq = platform_get_irq(pdev, 0);
+	if (irq <= 0)
+		return irq;
 
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
+	ret = rvin_dma_probe(vin, irq);
+	if (ret)
+		return ret;
 
 	return 0;
 }
 
 static int rcar_vin_probe(struct platform_device *pdev)
 {
+	const struct of_device_id *match;
 	struct rvin_dev *vin;
-	struct resource *mem;
-	int irq, ret;
+	int ret;
 
 	vin = devm_kzalloc(&pdev->dev, sizeof(*vin), GFP_KERNEL);
 	if (!vin)
 		return -ENOMEM;
 
+	match = of_match_device(of_match_ptr(rvin_of_id_table), &pdev->dev);
+	if (!match)
+		return -ENODEV;
+
 	vin->dev = &pdev->dev;
+	vin->chip = (enum chip_id)match->data;
 
-	ret = rvin_parse_dt(vin);
+	/* Prefer digital input */
+	vin->current_input = RVIN_INPUT_DIGITAL;
+
+	/* Initialize the top-level structure */
+	ret = v4l2_device_register(vin->dev, &vin->v4l2_dev);
 	if (ret)
 		return ret;
 
-	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (mem == NULL)
-		return -EINVAL;
-
-	vin->base = devm_ioremap_resource(vin->dev, mem);
-	if (IS_ERR(vin->base))
-		return PTR_ERR(vin->base);
+	ret = rvin_probe_channel(pdev, vin);
+	if (ret)
+		goto err_register;
 
-	irq = platform_get_irq(pdev, 0);
-	if (irq <= 0)
-		return ret;
+	ret = rvin_digital_graph_init(vin);
+	if (ret < 0)
+		goto err_dma;
 
-	ret = rvin_dma_probe(vin, irq);
+	ret = rvin_v4l2_probe(vin);
 	if (ret)
-		return ret;
+		goto err_dma;
 
-	ret = rvin_graph_init(vin);
-	if (ret < 0)
-		goto error;
+	platform_set_drvdata(pdev, vin);
 
 	pm_suspend_ignore_children(&pdev->dev, true);
 	pm_runtime_enable(&pdev->dev);
 
-	platform_set_drvdata(pdev, vin);
-
 	return 0;
-error:
+
+err_dma:
 	rvin_dma_remove(vin);
+err_register:
+	v4l2_device_unregister(&vin->v4l2_dev);
 
 	return ret;
 }
@@ -314,10 +383,14 @@ static int rcar_vin_remove(struct platform_device *pdev)
 
 	pm_runtime_disable(&pdev->dev);
 
+	rvin_v4l2_remove(vin);
+
 	v4l2_async_notifier_unregister(&vin->notifier);
 
 	rvin_dma_remove(vin);
 
+	v4l2_device_unregister(&vin->v4l2_dev);
+
 	return 0;
 }
 
diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c b/drivers/media/platform/rcar-vin/rcar-dma.c
index dad3b03..b3d3c5e 100644
--- a/drivers/media/platform/rcar-vin/rcar-dma.c
+++ b/drivers/media/platform/rcar-vin/rcar-dma.c
@@ -130,9 +130,16 @@ static u32 rvin_read(struct rvin_dev *vin, u32 offset)
 
 static int rvin_setup(struct rvin_dev *vin)
 {
-	u32 vnmc, dmr, dmr2, interrupts;
+	u32 code, vnmc, dmr, dmr2, interrupts;
+	struct v4l2_mbus_config mbus_cfg;
 	bool progressive = false, output_is_yuv = false, input_is_yuv = false;
 
+	if (rvin_subdev_get_mbus_cfg(vin, &mbus_cfg))
+		return -EINVAL;
+
+	if (rvin_subdev_get_code(vin, &code))
+		return -EINVAL;
+
 	switch (vin->format.field) {
 	case V4L2_FIELD_TOP:
 		vnmc = VNMC_IM_ODD;
@@ -163,7 +170,7 @@ static int rvin_setup(struct rvin_dev *vin)
 	/*
 	 * Input interface
 	 */
-	switch (vin->source.code) {
+	switch (code) {
 	case MEDIA_BUS_FMT_YUYV8_1X16:
 		/* BT.601/BT.1358 16bit YCbCr422 */
 		vnmc |= VNMC_INF_YUV16;
@@ -171,7 +178,7 @@ static int rvin_setup(struct rvin_dev *vin)
 		break;
 	case MEDIA_BUS_FMT_YUYV8_2X8:
 		/* BT.656 8bit YCbCr422 or BT.601 8bit YCbCr422 */
-		vnmc |= vin->mbus_cfg.type == V4L2_MBUS_BT656 ?
+		vnmc |= mbus_cfg.type == V4L2_MBUS_BT656 ?
 			VNMC_INF_YUV8_BT656 : VNMC_INF_YUV8_BT601;
 		input_is_yuv = true;
 		break;
@@ -180,7 +187,7 @@ static int rvin_setup(struct rvin_dev *vin)
 		break;
 	case MEDIA_BUS_FMT_YUYV10_2X10:
 		/* BT.656 10bit YCbCr422 or BT.601 10bit YCbCr422 */
-		vnmc |= vin->mbus_cfg.type == V4L2_MBUS_BT656 ?
+		vnmc |= mbus_cfg.type == V4L2_MBUS_BT656 ?
 			VNMC_INF_YUV10_BT656 : VNMC_INF_YUV10_BT601;
 		input_is_yuv = true;
 		break;
@@ -192,11 +199,11 @@ static int rvin_setup(struct rvin_dev *vin)
 	dmr2 = VNDMR2_FTEV | VNDMR2_VLV(1);
 
 	/* Hsync Signal Polarity Select */
-	if (!(vin->mbus_cfg.flags & V4L2_MBUS_HSYNC_ACTIVE_LOW))
+	if (!(mbus_cfg.flags & V4L2_MBUS_HSYNC_ACTIVE_LOW))
 		dmr2 |= VNDMR2_HPS;
 
 	/* Vsync Signal Polarity Select */
-	if (!(vin->mbus_cfg.flags & V4L2_MBUS_VSYNC_ACTIVE_LOW))
+	if (!(mbus_cfg.flags & V4L2_MBUS_VSYNC_ACTIVE_LOW))
 		dmr2 |= VNDMR2_VPS;
 
 	/*
@@ -1030,12 +1037,10 @@ static void rvin_buffer_queue(struct vb2_buffer *vb)
 static int rvin_start_streaming(struct vb2_queue *vq, unsigned int count)
 {
 	struct rvin_dev *vin = vb2_get_drv_priv(vq);
-	struct v4l2_subdev *sd;
 	unsigned long flags;
 	int ret;
 
-	sd = vin_to_source(vin);
-	v4l2_subdev_call(sd, video, s_stream, 1);
+	rvin_subdev_call(vin, video, s_stream, 1);
 
 	spin_lock_irqsave(&vin->qlock, flags);
 
@@ -1060,7 +1065,7 @@ out:
 	/* Return all buffers if something went wrong */
 	if (ret) {
 		return_all_buffers(vin, VB2_BUF_STATE_QUEUED);
-		v4l2_subdev_call(sd, video, s_stream, 0);
+		rvin_subdev_call(vin, video, s_stream, 0);
 	}
 
 	spin_unlock_irqrestore(&vin->qlock, flags);
@@ -1071,7 +1076,6 @@ out:
 static void rvin_stop_streaming(struct vb2_queue *vq)
 {
 	struct rvin_dev *vin = vb2_get_drv_priv(vq);
-	struct v4l2_subdev *sd;
 	unsigned long flags;
 	int retries = 0;
 
@@ -1110,8 +1114,7 @@ static void rvin_stop_streaming(struct vb2_queue *vq)
 
 	spin_unlock_irqrestore(&vin->qlock, flags);
 
-	sd = vin_to_source(vin);
-	v4l2_subdev_call(sd, video, s_stream, 0);
+	rvin_subdev_call(vin, video, s_stream, 0);
 
 	/* disable interrupts */
 	rvin_disable_interrupts(vin);
@@ -1133,8 +1136,6 @@ void rvin_dma_remove(struct rvin_dev *vin)
 		vb2_dma_contig_cleanup_ctx(vin->alloc_ctx);
 
 	mutex_destroy(&vin->lock);
-
-	v4l2_device_unregister(&vin->v4l2_dev);
 }
 
 int rvin_dma_probe(struct rvin_dev *vin, int irq)
@@ -1142,11 +1143,6 @@ int rvin_dma_probe(struct rvin_dev *vin, int irq)
 	struct vb2_queue *q = &vin->queue;
 	int i, ret;
 
-	/* Initialize the top-level structure */
-	ret = v4l2_device_register(vin->dev, &vin->v4l2_dev);
-	if (ret)
-		return ret;
-
 	mutex_init(&vin->lock);
 	INIT_LIST_HEAD(&vin->buf_list);
 
diff --git a/drivers/media/platform/rcar-vin/rcar-group.h b/drivers/media/platform/rcar-vin/rcar-group.h
new file mode 100644
index 0000000..59eae46
--- /dev/null
+++ b/drivers/media/platform/rcar-vin/rcar-group.h
@@ -0,0 +1,102 @@
+/*
+ * Driver for Renesas R-Car VIN
+ *
+ * Copyright (C) 2016 Renesas Electronics Corp.
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+
+#ifndef __RCAR_GROUP__
+#define __RCAR_GROUP__
+
+#include <media/v4l2-dev.h>
+#include <media/v4l2-device.h>
+
+#define RVIN_PORT_LOCAL 0
+
+enum rvin_input_type {
+	RVIN_INPUT_NONE,
+	RVIN_INPUT_DIGITAL,
+};
+
+/* Max number of inputs supported */
+#define RVIN_INPUT_MAX 1
+#define RVIN_INPUT_NAME_SIZE 32
+
+/**
+ * struct rvin_input_item - One possible input for the channel
+ * @name:	User-friendly name of the input
+ * @type:	Type of the input or RVIN_INPUT_NONE if not available
+ * @chsel:	The chsel value needed to select this input
+ * @sink_idx:	Sink pad number from the subdevice associated with the input
+ * @source_idx:	Source pad number from the subdevice associated with the input
+ */
+struct rvin_input_item {
+	char name[RVIN_INPUT_NAME_SIZE];
+	enum rvin_input_type type;
+	int chsel;
+	bool hint;
+	int sink_idx;
+	int source_idx;
+};
+
+/**
+ * struct rvin_graph_entity - Video endpoint from async framework
+ * @asd:	sub-device descriptor for async framework
+ * @subdev:	subdevice matched using async framework
+ * @code:	Media bus format from source
+ * @mbus_cfg:	Media bus format from DT
+ */
+struct rvin_graph_entity {
+	struct v4l2_async_subdev asd;
+	struct v4l2_subdev *subdev;
+
+	u32 code;
+	struct v4l2_mbus_config mbus_cfg;
+};
+
+static inline int rvin_mbus_supported(struct rvin_graph_entity *entity)
+{
+	struct v4l2_subdev *sd = entity->subdev;
+	struct v4l2_subdev_mbus_code_enum code = {
+		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+	};
+
+	code.index = 0;
+	while (!v4l2_subdev_call(sd, pad, enum_mbus_code, NULL, &code)) {
+		code.index++;
+		switch (code.code) {
+		case MEDIA_BUS_FMT_YUYV8_1X16:
+		case MEDIA_BUS_FMT_YUYV8_2X8:
+		case MEDIA_BUS_FMT_YUYV10_2X10:
+		case MEDIA_BUS_FMT_RGB888_1X24:
+			entity->code = code.code;
+			return true;
+		default:
+			break;
+		}
+	}
+
+	return false;
+}
+
+static inline int sd_to_pad_idx(struct v4l2_subdev *sd, int flag)
+{
+	int pad_idx;
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	for (pad_idx = 0; pad_idx < sd->entity.num_pads; pad_idx++)
+		if (sd->entity.pads[pad_idx].flags == flag)
+			break;
+
+	if (pad_idx >= sd->entity.num_pads)
+		pad_idx = 0;
+#else
+	pad_idx = 0;
+#endif
+	return pad_idx;
+}
+
+#endif
diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
index 10a5c10..2307f5b 100644
--- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
+++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
@@ -93,30 +93,31 @@ static u32 rvin_format_sizeimage(struct v4l2_pix_format *pix)
  */
 
 static int __rvin_try_format_source(struct rvin_dev *vin,
-					u32 which,
-					struct v4l2_pix_format *pix,
-					struct rvin_source_fmt *source)
+				    u32 which,
+				    struct v4l2_pix_format *pix,
+				    struct rvin_source_fmt *source)
 {
-	struct v4l2_subdev *sd;
 	struct v4l2_subdev_pad_config *pad_cfg;
 	struct v4l2_subdev_format format = {
 		.which = which,
 	};
+	u32 code;
 	int ret;
 
-	sd = vin_to_source(vin);
+	ret = rvin_subdev_get_code(vin, &code);
+	if (ret)
+		return -EINVAL;
 
-	v4l2_fill_mbus_format(&format.format, pix, vin->source.code);
+	v4l2_fill_mbus_format(&format.format, pix, code);
 
-	pad_cfg = v4l2_subdev_alloc_pad_config(sd);
+	pad_cfg = rvin_subdev_alloc_pad_config(vin);
 	if (pad_cfg == NULL)
 		return -ENOMEM;
 
-	format.pad = vin->src_pad_idx;
+	format.pad = vin->inputs[vin->current_input].source_idx;
 
-	ret = v4l2_device_call_until_err(sd->v4l2_dev, 0, pad, set_fmt,
-					 pad_cfg, &format);
-	if (ret < 0)
+	ret = rvin_subdev_call(vin, pad, set_fmt, pad_cfg, &format);
+	if (ret < 0 && ret != -ENOIOCTLCMD)
 		goto cleanup;
 
 	v4l2_fill_pix_format(pix, &format.format);
@@ -129,13 +130,13 @@ static int __rvin_try_format_source(struct rvin_dev *vin,
 
 cleanup:
 	v4l2_subdev_free_pad_config(pad_cfg);
-	return 0;
+	return ret;
 }
 
 static int __rvin_try_format(struct rvin_dev *vin,
-				 u32 which,
-				 struct v4l2_pix_format *pix,
-				 struct rvin_source_fmt *source)
+			     u32 which,
+			     struct v4l2_pix_format *pix,
+			     struct rvin_source_fmt *source)
 {
 	const struct rvin_video_format *info;
 	u32 rwidth, rheight, walign;
@@ -219,13 +220,11 @@ static int rvin_try_fmt_vid_cap(struct file *file, void *priv,
 	struct rvin_source_fmt source;
 
 	return __rvin_try_format(vin, V4L2_SUBDEV_FORMAT_TRY, &f->fmt.pix,
-				     &source);
+				 &source);
 }
 
-static int rvin_s_fmt_vid_cap(struct file *file, void *priv,
-			      struct v4l2_format *f)
+static int __rvin_s_fmt_vid_cap(struct rvin_dev *vin, struct v4l2_format *f)
 {
-	struct rvin_dev *vin = video_drvdata(file);
 	struct rvin_source_fmt source;
 	int ret;
 
@@ -233,7 +232,7 @@ static int rvin_s_fmt_vid_cap(struct file *file, void *priv,
 		return -EBUSY;
 
 	ret = __rvin_try_format(vin, V4L2_SUBDEV_FORMAT_ACTIVE, &f->fmt.pix,
-				    &source);
+				&source);
 	if (ret)
 		return ret;
 
@@ -245,6 +244,14 @@ static int rvin_s_fmt_vid_cap(struct file *file, void *priv,
 	return 0;
 }
 
+static int rvin_s_fmt_vid_cap(struct file *file, void *priv,
+			      struct v4l2_format *f)
+{
+	struct rvin_dev *vin = video_drvdata(file);
+
+	return __rvin_s_fmt_vid_cap(vin, f);
+}
+
 static int rvin_g_fmt_vid_cap(struct file *file, void *priv,
 			      struct v4l2_format *f)
 {
@@ -334,8 +341,8 @@ static int rvin_s_selection(struct file *file, void *fh,
 		vin->crop = s->r = r;
 
 		vin_dbg(vin, "Cropped %dx%d@%d:%d of %dx%d\n",
-			 r.width, r.height, r.left, r.top,
-			 vin->source.width, vin->source.height);
+			r.width, r.height, r.left, r.top,
+			vin->source.width, vin->source.height);
 		break;
 	case V4L2_SEL_TGT_COMPOSE:
 		/* Make sure compose rect fits inside output format */
@@ -359,8 +366,8 @@ static int rvin_s_selection(struct file *file, void *fh,
 		vin->compose = s->r = r;
 
 		vin_dbg(vin, "Compose %dx%d@%d:%d in %dx%d\n",
-			 r.width, r.height, r.left, r.top,
-			 vin->format.width, vin->format.height);
+			r.width, r.height, r.left, r.top,
+			vin->format.width, vin->format.height);
 		break;
 	default:
 		return -EINVAL;
@@ -376,75 +383,167 @@ static int rvin_cropcap(struct file *file, void *priv,
 			struct v4l2_cropcap *crop)
 {
 	struct rvin_dev *vin = video_drvdata(file);
-	struct v4l2_subdev *sd = vin_to_source(vin);
 
 	if (crop->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
 
-	return v4l2_subdev_call(sd, video, cropcap, crop);
+	return rvin_subdev_call(vin, video, cropcap, crop);
+}
+
+static int rvin_attach_subdevices(struct rvin_dev *vin)
+{
+	struct v4l2_subdev_format fmt = {
+		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+	};
+	struct v4l2_mbus_framefmt *mf = &fmt.format;
+	struct v4l2_format f;
+	int ret;
+
+	ret = rvin_subdev_set_input(vin, &vin->inputs[vin->current_input]);
+	if (ret)
+		return ret;
+
+	ret = rvin_subdev_call(vin, core, s_power, 1);
+	if (ret < 0 && ret != -ENOIOCTLCMD && ret != -ENODEV)
+		return ret;
+
+	vin->vdev.tvnorms = 0;
+	ret = rvin_subdev_call(vin, video, g_tvnorms, &vin->vdev.tvnorms);
+	if (ret < 0 && ret != -ENOIOCTLCMD && ret != -ENODEV)
+		goto error;
+
+	/* Add controlls */
+	ret = rvin_subdev_ctrl_add_handler(vin);
+	if (ret < 0)
+		goto error;
+
+	v4l2_ctrl_handler_setup(&vin->ctrl_handler);
+
+	fmt.pad = vin->inputs[vin->current_input].source_idx;
+
+	/* Try to improve our guess of a reasonable window format */
+	ret = rvin_subdev_call(vin, pad, get_fmt, NULL, &fmt);
+	if (ret)
+		goto error;
+
+	/* Set default format */
+	vin->format.width	= mf->width;
+	vin->format.height	= mf->height;
+	vin->format.colorspace	= mf->colorspace;
+	vin->format.field	= mf->field;
+	vin->format.pixelformat	= RVIN_DEFAULT_FORMAT;
+
+	/* Set initial crop and compose */
+	vin->crop.top = vin->crop.left = 0;
+	vin->crop.width = mf->width;
+	vin->crop.height = mf->height;
+
+	vin->compose.top = vin->compose.left = 0;
+	vin->compose.width = mf->width;
+	vin->compose.height = mf->height;
+
+	f.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	f.fmt.pix = vin->format;
+	ret = __rvin_s_fmt_vid_cap(vin, &f);
+	if (ret)
+		goto error;
+
+	return 0;
+error:
+	rvin_subdev_call(vin, core, s_power, 0);
+	return ret;
+}
+
+static void rvin_detach_subdevices(struct rvin_dev *vin)
+{
+	rvin_subdev_call(vin, core, s_power, 0);
 }
 
 static int rvin_enum_input(struct file *file, void *priv,
 			   struct v4l2_input *i)
 {
 	struct rvin_dev *vin = video_drvdata(file);
-	struct v4l2_subdev *sd = vin_to_source(vin);
+	struct rvin_input_item *item;
 	int ret;
 
-	if (i->index != 0)
+	if (i->index > RVIN_INPUT_MAX ||
+	    vin->inputs[i->index].type == RVIN_INPUT_NONE)
 		return -EINVAL;
 
-	ret = v4l2_subdev_call(sd, video, g_input_status, &i->status);
+	item = &vin->inputs[i->index];
+
+	ret = rvin_subdev_call_input(vin, i->index, video,
+				     g_input_status, &i->status);
+
 	if (ret < 0 && ret != -ENOIOCTLCMD && ret != -ENODEV)
 		return ret;
 
 	i->type = V4L2_INPUT_TYPE_CAMERA;
-	i->std = vin->vdev.tvnorms;
+	strlcpy(i->name, item->name, sizeof(i->name));
 
-	if (v4l2_subdev_has_op(sd, pad, dv_timings_cap))
+	if (rvin_subdev_has_op(vin, pad, dv_timings_cap)) {
 		i->capabilities = V4L2_IN_CAP_DV_TIMINGS;
-
-	strlcpy(i->name, "Camera", sizeof(i->name));
+		i->std = 0;
+	} else {
+		i->capabilities = V4L2_IN_CAP_STD;
+		ret = rvin_subdev_call_input(vin,
+					     vin->current_input,
+					     video, g_tvnorms, &i->std);
+		if (ret < 0 && ret != -ENOIOCTLCMD && ret != -ENODEV)
+			return ret;
+	}
 
 	return 0;
 }
 
 static int rvin_g_input(struct file *file, void *priv, unsigned int *i)
 {
-	*i = 0;
+	struct rvin_dev *vin = video_drvdata(file);
+
+	*i = vin->current_input;
 	return 0;
 }
 
 static int rvin_s_input(struct file *file, void *priv, unsigned int i)
 {
-	if (i > 0)
+	struct rvin_dev *vin = video_drvdata(file);
+	int ret;
+
+	if (i > RVIN_INPUT_MAX || vin->inputs[i].type == RVIN_INPUT_NONE)
 		return -EINVAL;
-	return 0;
+
+	rvin_detach_subdevices(vin);
+
+	ret = rvin_subdev_set_input(vin, &vin->inputs[i]);
+	if (!ret)
+		vin->current_input = i;
+
+	/* Power on new subdevice */
+	return rvin_attach_subdevices(vin);
 }
 
 static int rvin_querystd(struct file *file, void *priv, v4l2_std_id *a)
 {
 	struct rvin_dev *vin = video_drvdata(file);
-	struct v4l2_subdev *sd = vin_to_source(vin);
 
-	return v4l2_subdev_call(sd, video, querystd, a);
+	return rvin_subdev_call(vin, video, querystd, a);
 }
 
 static int rvin_s_std(struct file *file, void *priv, v4l2_std_id a)
 {
 	struct rvin_dev *vin = video_drvdata(file);
-	struct v4l2_subdev *sd = vin_to_source(vin);
 	struct v4l2_subdev_format fmt = {
 		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
 	};
 	struct v4l2_mbus_framefmt *mf = &fmt.format;
-	int ret = v4l2_subdev_call(sd, video, s_std, a);
+	int ret;
 
+	ret = rvin_subdev_call(vin, video, s_std, a);
 	if (ret < 0)
 		return ret;
 
 	/* Changing the standard will change the width/height */
-	ret = v4l2_subdev_call(sd, pad, get_fmt, NULL, &fmt);
+	ret = rvin_subdev_call(vin, pad, get_fmt, NULL, &fmt);
 	if (ret) {
 		vin_err(vin, "Failed to get initial format\n");
 		return ret;
@@ -467,9 +566,8 @@ static int rvin_s_std(struct file *file, void *priv, v4l2_std_id a)
 static int rvin_g_std(struct file *file, void *priv, v4l2_std_id *a)
 {
 	struct rvin_dev *vin = video_drvdata(file);
-	struct v4l2_subdev *sd = vin_to_source(vin);
 
-	return v4l2_subdev_call(sd, video, g_std, a);
+	return rvin_subdev_call(vin, video, g_std, a);
 }
 
 static int rvin_subscribe_event(struct v4l2_fh *fh,
@@ -483,31 +581,29 @@ static int rvin_subscribe_event(struct v4l2_fh *fh,
 }
 
 static int rvin_enum_dv_timings(struct file *file, void *priv_fh,
-				    struct v4l2_enum_dv_timings *timings)
+				struct v4l2_enum_dv_timings *timings)
 {
 	struct rvin_dev *vin = video_drvdata(file);
-	struct v4l2_subdev *sd = vin_to_source(vin);
-	int pad, ret;
+	int input, ret;
+
+	input = timings->pad;
 
-	pad = timings->pad;
-	timings->pad = vin->src_pad_idx;
+	timings->pad = vin->inputs[input].sink_idx;
 
-	ret = v4l2_subdev_call(sd, pad, enum_dv_timings, timings);
+	ret = rvin_subdev_call_input(vin, input, pad, enum_dv_timings, timings);
 
-	timings->pad = pad;
+	timings->pad = input;
 
 	return ret;
 }
 
 static int rvin_s_dv_timings(struct file *file, void *priv_fh,
-				    struct v4l2_dv_timings *timings)
+			     struct v4l2_dv_timings *timings)
 {
 	struct rvin_dev *vin = video_drvdata(file);
-	struct v4l2_subdev *sd = vin_to_source(vin);
 	int err;
 
-	err = v4l2_subdev_call(sd,
-			video, s_dv_timings, timings);
+	err = rvin_subdev_call(vin, video, s_dv_timings, timings);
 	if (!err) {
 		vin->source.width = timings->bt.width;
 		vin->source.height = timings->bt.height;
@@ -518,38 +614,35 @@ static int rvin_s_dv_timings(struct file *file, void *priv_fh,
 }
 
 static int rvin_g_dv_timings(struct file *file, void *priv_fh,
-				    struct v4l2_dv_timings *timings)
+			     struct v4l2_dv_timings *timings)
 {
 	struct rvin_dev *vin = video_drvdata(file);
-	struct v4l2_subdev *sd = vin_to_source(vin);
 
-	return v4l2_subdev_call(sd,
-			video, g_dv_timings, timings);
+	return rvin_subdev_call(vin, video, g_dv_timings, timings);
 }
 
 static int rvin_query_dv_timings(struct file *file, void *priv_fh,
-				    struct v4l2_dv_timings *timings)
+				 struct v4l2_dv_timings *timings)
 {
 	struct rvin_dev *vin = video_drvdata(file);
-	struct v4l2_subdev *sd = vin_to_source(vin);
 
-	return v4l2_subdev_call(sd,
-			video, query_dv_timings, timings);
+	return rvin_subdev_call(vin, video, query_dv_timings, timings);
 }
 
 static int rvin_dv_timings_cap(struct file *file, void *priv_fh,
-				    struct v4l2_dv_timings_cap *cap)
+			       struct v4l2_dv_timings_cap *cap)
 {
 	struct rvin_dev *vin = video_drvdata(file);
-	struct v4l2_subdev *sd = vin_to_source(vin);
-	int pad, ret;
+	int input, ret;
 
-	pad = cap->pad;
-	cap->pad = vin->src_pad_idx;
+	input = cap->pad;
 
-	ret = v4l2_subdev_call(sd, pad, dv_timings_cap, cap);
+	cap->pad = vin->inputs[input].sink_idx;
 
-	cap->pad = pad;
+	ret = rvin_subdev_call_input(vin, input, pad,
+				     dv_timings_cap, cap);
+
+	cap->pad = input;
 
 	return ret;
 }
@@ -599,80 +692,6 @@ static const struct v4l2_ioctl_ops rvin_ioctl_ops = {
  * File Operations
  */
 
-static int rvin_power_on(struct rvin_dev *vin)
-{
-	int ret;
-	struct v4l2_subdev *sd = vin_to_source(vin);
-
-	pm_runtime_get_sync(vin->v4l2_dev.dev);
-
-	ret = v4l2_subdev_call(sd, core, s_power, 1);
-	if (ret < 0 && ret != -ENOIOCTLCMD && ret != -ENODEV)
-		return ret;
-	return 0;
-}
-
-static int rvin_power_off(struct rvin_dev *vin)
-{
-	int ret;
-	struct v4l2_subdev *sd = vin_to_source(vin);
-
-	ret = v4l2_subdev_call(sd, core, s_power, 0);
-
-	pm_runtime_put(vin->v4l2_dev.dev);
-
-	if (ret < 0 && ret != -ENOIOCTLCMD && ret != -ENODEV)
-		return ret;
-
-	return 0;
-}
-
-static int rvin_initialize_device(struct file *file)
-{
-	struct rvin_dev *vin = video_drvdata(file);
-	int ret;
-
-	struct v4l2_format f = {
-		.type = V4L2_BUF_TYPE_VIDEO_CAPTURE,
-		.fmt.pix = {
-			.width		= vin->format.width,
-			.height		= vin->format.height,
-			.field		= vin->format.field,
-			.colorspace	= vin->format.colorspace,
-			.pixelformat	= vin->format.pixelformat,
-		},
-	};
-
-	ret = rvin_power_on(vin);
-	if (ret < 0)
-		return ret;
-
-	pm_runtime_enable(&vin->vdev.dev);
-	ret = pm_runtime_resume(&vin->vdev.dev);
-	if (ret < 0 && ret != -ENOSYS)
-		goto eresume;
-
-	/*
-	 * Try to configure with default parameters. Notice: this is the
-	 * very first open, so, we cannot race against other calls,
-	 * apart from someone else calling open() simultaneously, but
-	 * .host_lock is protecting us against it.
-	 */
-	ret = rvin_s_fmt_vid_cap(file, NULL, &f);
-	if (ret < 0)
-		goto esfmt;
-
-	v4l2_ctrl_handler_setup(&vin->ctrl_handler);
-
-	return 0;
-esfmt:
-	pm_runtime_disable(&vin->vdev.dev);
-eresume:
-	rvin_power_off(vin);
-
-	return ret;
-}
-
 static int rvin_open(struct file *file)
 {
 	struct rvin_dev *vin = video_drvdata(file);
@@ -684,17 +703,30 @@ static int rvin_open(struct file *file)
 
 	ret = v4l2_fh_open(file);
 	if (ret)
-		goto unlock;
-
-	if (!v4l2_fh_is_singular_file(file))
-		goto unlock;
+		goto err_out;
 
-	if (rvin_initialize_device(file)) {
-		v4l2_fh_release(file);
-		ret = -ENODEV;
+	ret = rvin_subdev_get(vin);
+	if (ret)
+		goto err_open;
+
+	if (v4l2_fh_is_singular_file(file)) {
+		pm_runtime_get_sync(vin->dev);
+		ret = rvin_attach_subdevices(vin);
+		if (ret) {
+			vin_err(vin, "Error attaching subdevices\n");
+			goto err_get;
+		}
 	}
 
-unlock:
+	mutex_unlock(&vin->lock);
+
+	return 0;
+err_get:
+	pm_runtime_put(vin->dev);
+	rvin_subdev_put(vin);
+err_open:
+	v4l2_fh_release(file);
+err_out:
 	mutex_unlock(&vin->lock);
 	return ret;
 }
@@ -718,11 +750,12 @@ static int rvin_release(struct file *file)
 	 * Then de-initialize hw module.
 	 */
 	if (fh_singular) {
-		pm_runtime_suspend(&vin->vdev.dev);
-		pm_runtime_disable(&vin->vdev.dev);
-		rvin_power_off(vin);
+		rvin_detach_subdevices(vin);
+		pm_runtime_put(vin->dev);
 	}
 
+	rvin_subdev_put(vin);
+
 	mutex_unlock(&vin->lock);
 
 	return ret;
@@ -767,49 +800,11 @@ static void rvin_notify(struct v4l2_subdev *sd,
 
 int rvin_v4l2_probe(struct rvin_dev *vin)
 {
-	struct v4l2_subdev_format fmt = {
-		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
-	};
-	struct v4l2_mbus_framefmt *mf = &fmt.format;
 	struct video_device *vdev = &vin->vdev;
-	struct v4l2_subdev *sd = vin_to_source(vin);
-#if defined(CONFIG_MEDIA_CONTROLLER)
-	int pad_idx;
-#endif
 	int ret;
 
-	v4l2_set_subdev_hostdata(sd, vin);
-
 	vin->v4l2_dev.notify = rvin_notify;
 
-	ret = v4l2_subdev_call(sd, video, g_tvnorms, &vin->vdev.tvnorms);
-	if (ret < 0 && ret != -ENOIOCTLCMD && ret != -ENODEV)
-		return ret;
-
-	if (vin->vdev.tvnorms == 0) {
-		/* Disable the STD API if there are no tvnorms defined */
-		v4l2_disable_ioctl(&vin->vdev, VIDIOC_G_STD);
-		v4l2_disable_ioctl(&vin->vdev, VIDIOC_S_STD);
-		v4l2_disable_ioctl(&vin->vdev, VIDIOC_QUERYSTD);
-		v4l2_disable_ioctl(&vin->vdev, VIDIOC_ENUMSTD);
-	}
-
-	/* Add the controls */
-	/*
-	 * Currently the subdev with the largest number of controls (13) is
-	 * ov6550. So let's pick 16 as a hint for the control handler. Note
-	 * that this is a hint only: too large and you waste some memory, too
-	 * small and there is a (very) small performance hit when looking up
-	 * controls in the internal hash.
-	 */
-	ret = v4l2_ctrl_handler_init(&vin->ctrl_handler, 16);
-	if (ret < 0)
-		return ret;
-
-	ret = v4l2_ctrl_add_handler(&vin->ctrl_handler, sd->ctrl_handler, NULL);
-	if (ret < 0)
-		return ret;
-
 	/* video node */
 	vdev->fops = &rvin_fops;
 	vdev->v4l2_dev = &vin->v4l2_dev;
@@ -822,43 +817,6 @@ int rvin_v4l2_probe(struct rvin_dev *vin)
 	vdev->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING |
 		V4L2_CAP_READWRITE;
 
-	vin->src_pad_idx = 0;
-#if defined(CONFIG_MEDIA_CONTROLLER)
-	for (pad_idx = 0; pad_idx < sd->entity.num_pads; pad_idx++)
-		if (sd->entity.pads[pad_idx].flags
-				== MEDIA_PAD_FL_SOURCE)
-			break;
-	if (pad_idx >= sd->entity.num_pads)
-		return -EINVAL;
-
-	vin->src_pad_idx = pad_idx;
-#endif
-	fmt.pad = vin->src_pad_idx;
-
-	/* Try to improve our guess of a reasonable window format */
-	ret = v4l2_subdev_call(sd, pad, get_fmt, NULL, &fmt);
-	if (ret) {
-		vin_err(vin, "Failed to get initial format\n");
-		return ret;
-	}
-
-	/* Set default format */
-	vin->format.width	= mf->width;
-	vin->format.height	= mf->height;
-	vin->format.colorspace	= mf->colorspace;
-	vin->format.field	= mf->field;
-	vin->format.pixelformat	= RVIN_DEFAULT_FORMAT;
-
-
-	/* Set initial crop and compose */
-	vin->crop.top = vin->crop.left = 0;
-	vin->crop.width = mf->width;
-	vin->crop.height = mf->height;
-
-	vin->compose.top = vin->compose.left = 0;
-	vin->compose.width = mf->width;
-	vin->compose.height = mf->height;
-
 	ret = video_register_device(&vin->vdev, VFL_TYPE_GRABBER, -1);
 	if (ret) {
 		vin_err(vin, "Failed to register video device\n");
diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h b/drivers/media/platform/rcar-vin/rcar-vin.h
index a6dd6db..81780f1 100644
--- a/drivers/media/platform/rcar-vin/rcar-vin.h
+++ b/drivers/media/platform/rcar-vin/rcar-vin.h
@@ -23,6 +23,8 @@
 #include <media/v4l2-device.h>
 #include <media/videobuf2-v4l2.h>
 
+#include "rcar-group.h"
+
 /* Number of HW buffers */
 #define HW_BUFFER_NUM 3
 
@@ -50,12 +52,10 @@ enum rvin_dma_state {
 
 /**
  * struct rvin_source_fmt - Source information
- * @code:	Media bus format from source
  * @width:	Width from source
  * @height:	Height from source
  */
 struct rvin_source_fmt {
-	u32 code;
 	u32 width;
 	u32 height;
 };
@@ -70,27 +70,18 @@ struct rvin_video_format {
 	u8 bpp;
 };
 
-struct rvin_graph_entity {
-	struct device_node *node;
-	struct media_entity *entity;
-
-	struct v4l2_async_subdev asd;
-	struct v4l2_subdev *subdev;
-};
-
 /**
  * struct rvin_dev - Renesas VIN device structure
  * @dev:		(OF) device
  * @base:		device I/O register space remapped to virtual memory
  * @chip:		type of VIN chip
- * @mbus_cfg		media bus configuration
  *
  * @vdev:		V4L2 video device associated with VIN
  * @v4l2_dev:		V4L2 device
  * @src_pad_idx:	source pad index for media controller drivers
  * @ctrl_handler:	V4L2 control handler
  * @notifier:		V4L2 asynchronous subdevs notifier
- * @entity:		entity in the DT for subdevice
+ * @digital:		entity in the DT for local digital subdevice
  *
  * @lock:		protects @queue
  * @queue:		vb2 buffers queue
@@ -109,19 +100,21 @@ struct rvin_graph_entity {
  *
  * @crop:		active cropping
  * @compose:		active composing
+ *
+ * @current_input:	currently used input in @inputs
+ * @inputs:		list of valid inputs sources
  */
 struct rvin_dev {
 	struct device *dev;
 	void __iomem *base;
 	enum chip_id chip;
-	struct v4l2_mbus_config mbus_cfg;
 
 	struct video_device vdev;
 	struct v4l2_device v4l2_dev;
 	int src_pad_idx;
 	struct v4l2_ctrl_handler ctrl_handler;
 	struct v4l2_async_notifier notifier;
-	struct rvin_graph_entity entity;
+	struct rvin_graph_entity digital;
 
 	struct mutex lock;
 	struct vb2_queue queue;
@@ -139,9 +132,10 @@ struct rvin_dev {
 
 	struct v4l2_rect crop;
 	struct v4l2_rect compose;
-};
 
-#define vin_to_source(vin)		vin->entity.subdev
+	int current_input;
+	struct rvin_input_item inputs[RVIN_INPUT_MAX];
+};
 
 /* Debug */
 #define vin_dbg(d, fmt, arg...)		dev_dbg(d->dev, fmt, ##arg)
@@ -162,4 +156,27 @@ void rvin_scale_try(struct rvin_dev *vin, struct v4l2_pix_format *pix,
 		    u32 width, u32 height);
 void rvin_crop_scale_comp(struct rvin_dev *vin);
 
+/* Subdevice group helpers */
+#define rvin_subdev_call(v, o, f, args...)				\
+	(v->digital.subdev ?						\
+	 v4l2_subdev_call(v->digital.subdev, o, f, ##args) : -ENODEV)
+#define rvin_subdev_call_input(v, i, o, f, args...)			\
+	(v->digital.subdev ?						\
+	 v4l2_subdev_call(v->digital.subdev, o, f, ##args) : -ENODEV)
+
+#define rvin_subdev_has_op(v, o, f)					\
+	(v->digital.subdev ?						\
+	v4l2_subdev_has_op(v->digital.subdev, o, f) : -ENODEV)
+
+int rvin_subdev_get(struct rvin_dev *vin);
+int rvin_subdev_put(struct rvin_dev *vin);
+int rvin_subdev_set_input(struct rvin_dev *vin, struct rvin_input_item *item);
+
+int rvin_subdev_get_code(struct rvin_dev *vin, u32 *code);
+int rvin_subdev_get_mbus_cfg(struct rvin_dev *vin,
+			     struct v4l2_mbus_config *mbus_cfg);
+
+int rvin_subdev_ctrl_add_handler(struct rvin_dev *vin);
+struct v4l2_subdev_pad_config *rvin_subdev_alloc_pad_config(struct rvin_dev
+							    *vin);
 #endif
-- 
2.8.2


