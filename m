Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40340 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751347AbdJDVu6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 4 Oct 2017 17:50:58 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: niklas.soderlund@ragnatech.se, maxime.ripard@free-electrons.com,
        hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
        pavel@ucw.cz, sre@kernel.org
Subject: [PATCH v15 10/32] rcar-vin: Use generic parser for parsing fwnode endpoints
Date: Thu,  5 Oct 2017 00:50:29 +0300
Message-Id: <20171004215051.13385-11-sakari.ailus@linux.intel.com>
In-Reply-To: <20171004215051.13385-1-sakari.ailus@linux.intel.com>
References: <20171004215051.13385-1-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of using a custom driver implementation, use
v4l2_async_notifier_parse_fwnode_endpoints() to parse the fwnode endpoints
of the device.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-core.c | 107 +++++++++-------------------
 drivers/media/platform/rcar-vin/rcar-dma.c  |  10 +--
 drivers/media/platform/rcar-vin/rcar-v4l2.c |  14 ++--
 drivers/media/platform/rcar-vin/rcar-vin.h  |   4 +-
 4 files changed, 46 insertions(+), 89 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index 142de447aaaa..380288658601 100644
--- a/drivers/media/platform/rcar-vin/rcar-core.c
+++ b/drivers/media/platform/rcar-vin/rcar-core.c
@@ -21,6 +21,7 @@
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
 
+#include <media/v4l2-async.h>
 #include <media/v4l2-fwnode.h>
 
 #include "rcar-vin.h"
@@ -77,14 +78,14 @@ static int rvin_digital_notify_complete(struct v4l2_async_notifier *notifier)
 	int ret;
 
 	/* Verify subdevices mbus format */
-	if (!rvin_mbus_supported(&vin->digital)) {
+	if (!rvin_mbus_supported(vin->digital)) {
 		vin_err(vin, "Unsupported media bus format for %s\n",
-			vin->digital.subdev->name);
+			vin->digital->subdev->name);
 		return -EINVAL;
 	}
 
 	vin_dbg(vin, "Found media bus format for %s: %d\n",
-		vin->digital.subdev->name, vin->digital.code);
+		vin->digital->subdev->name, vin->digital->code);
 
 	ret = v4l2_device_register_subdev_nodes(&vin->v4l2_dev);
 	if (ret < 0) {
@@ -103,7 +104,7 @@ static void rvin_digital_notify_unbind(struct v4l2_async_notifier *notifier,
 
 	vin_dbg(vin, "unbind digital subdev %s\n", subdev->name);
 	rvin_v4l2_remove(vin);
-	vin->digital.subdev = NULL;
+	vin->digital->subdev = NULL;
 }
 
 static int rvin_digital_notify_bound(struct v4l2_async_notifier *notifier,
@@ -120,117 +121,71 @@ static int rvin_digital_notify_bound(struct v4l2_async_notifier *notifier,
 	ret = rvin_find_pad(subdev, MEDIA_PAD_FL_SOURCE);
 	if (ret < 0)
 		return ret;
-	vin->digital.source_pad = ret;
+	vin->digital->source_pad = ret;
 
 	ret = rvin_find_pad(subdev, MEDIA_PAD_FL_SINK);
-	vin->digital.sink_pad = ret < 0 ? 0 : ret;
+	vin->digital->sink_pad = ret < 0 ? 0 : ret;
 
-	vin->digital.subdev = subdev;
+	vin->digital->subdev = subdev;
 
 	vin_dbg(vin, "bound subdev %s source pad: %u sink pad: %u\n",
-		subdev->name, vin->digital.source_pad,
-		vin->digital.sink_pad);
+		subdev->name, vin->digital->source_pad,
+		vin->digital->sink_pad);
 
 	return 0;
 }
 
-static int rvin_digitial_parse_v4l2(struct rvin_dev *vin,
-				    struct device_node *ep,
-				    struct v4l2_mbus_config *mbus_cfg)
+static int rvin_digital_parse_v4l2(struct device *dev,
+				   struct v4l2_fwnode_endpoint *vep,
+				   struct v4l2_async_subdev *asd)
 {
-	struct v4l2_fwnode_endpoint v4l2_ep;
-	int ret;
+	struct rvin_dev *vin = dev_get_drvdata(dev);
+	struct rvin_graph_entity *rvge =
+		container_of(asd, struct rvin_graph_entity, asd);
 
-	ret = v4l2_fwnode_endpoint_parse(of_fwnode_handle(ep), &v4l2_ep);
-	if (ret) {
-		vin_err(vin, "Could not parse v4l2 endpoint\n");
-		return -EINVAL;
-	}
+	if (vep->base.port || vep->base.id)
+		return -ENOTCONN;
 
-	mbus_cfg->type = v4l2_ep.bus_type;
+	rvge->mbus_cfg.type = vep->bus_type;
 
-	switch (mbus_cfg->type) {
+	switch (rvge->mbus_cfg.type) {
 	case V4L2_MBUS_PARALLEL:
 		vin_dbg(vin, "Found PARALLEL media bus\n");
-		mbus_cfg->flags = v4l2_ep.bus.parallel.flags;
+		rvge->mbus_cfg.flags = vep->bus.parallel.flags;
 		break;
 	case V4L2_MBUS_BT656:
 		vin_dbg(vin, "Found BT656 media bus\n");
-		mbus_cfg->flags = 0;
+		rvge->mbus_cfg.flags = 0;
 		break;
 	default:
 		vin_err(vin, "Unknown media bus type\n");
 		return -EINVAL;
 	}
 
-	return 0;
-}
-
-static int rvin_digital_graph_parse(struct rvin_dev *vin)
-{
-	struct device_node *ep, *np;
-	int ret;
-
-	vin->digital.asd.match.fwnode.fwnode = NULL;
-	vin->digital.subdev = NULL;
-
-	/*
-	 * Port 0 id 0 is local digital input, try to get it.
-	 * Not all instances can or will have this, that is OK
-	 */
-	ep = of_graph_get_endpoint_by_regs(vin->dev->of_node, 0, 0);
-	if (!ep)
-		return 0;
-
-	np = of_graph_get_remote_port_parent(ep);
-	if (!np) {
-		vin_err(vin, "No remote parent for digital input\n");
-		of_node_put(ep);
-		return -EINVAL;
-	}
-	of_node_put(np);
-
-	ret = rvin_digitial_parse_v4l2(vin, ep, &vin->digital.mbus_cfg);
-	of_node_put(ep);
-	if (ret)
-		return ret;
-
-	vin->digital.asd.match.fwnode.fwnode = of_fwnode_handle(np);
-	vin->digital.asd.match_type = V4L2_ASYNC_MATCH_FWNODE;
+	vin->digital = rvge;
 
 	return 0;
 }
 
 static int rvin_digital_graph_init(struct rvin_dev *vin)
 {
-	struct v4l2_async_subdev **subdevs = NULL;
 	int ret;
 
-	ret = rvin_digital_graph_parse(vin);
+	ret = v4l2_async_notifier_parse_fwnode_endpoints(
+		vin->dev, &vin->notifier,
+		sizeof(struct rvin_graph_entity), rvin_digital_parse_v4l2);
 	if (ret)
 		return ret;
 
-	if (!vin->digital.asd.match.fwnode.fwnode) {
-		vin_dbg(vin, "No digital subdevice found\n");
+	if (!vin->digital)
 		return -ENODEV;
-	}
-
-	/* Register the subdevices notifier. */
-	subdevs = devm_kzalloc(vin->dev, sizeof(*subdevs), GFP_KERNEL);
-	if (subdevs == NULL)
-		return -ENOMEM;
-
-	subdevs[0] = &vin->digital.asd;
 
 	vin_dbg(vin, "Found digital subdevice %pOF\n",
-		to_of_node(subdevs[0]->match.fwnode.fwnode));
+		to_of_node(vin->digital->asd.match.fwnode.fwnode));
 
-	vin->notifier.num_subdevs = 1;
-	vin->notifier.subdevs = subdevs;
 	vin->notifier.bound = rvin_digital_notify_bound;
 	vin->notifier.unbind = rvin_digital_notify_unbind;
 	vin->notifier.complete = rvin_digital_notify_complete;
-
 	ret = v4l2_async_notifier_register(&vin->v4l2_dev, &vin->notifier);
 	if (ret < 0) {
 		vin_err(vin, "Notifier registration failed\n");
@@ -290,6 +245,8 @@ static int rcar_vin_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
+	platform_set_drvdata(pdev, vin);
+
 	ret = rvin_digital_graph_init(vin);
 	if (ret < 0)
 		goto error;
@@ -297,11 +254,10 @@ static int rcar_vin_probe(struct platform_device *pdev)
 	pm_suspend_ignore_children(&pdev->dev, true);
 	pm_runtime_enable(&pdev->dev);
 
-	platform_set_drvdata(pdev, vin);
-
 	return 0;
 error:
 	rvin_dma_remove(vin);
+	v4l2_async_notifier_cleanup(&vin->notifier);
 
 	return ret;
 }
@@ -313,6 +269,7 @@ static int rcar_vin_remove(struct platform_device *pdev)
 	pm_runtime_disable(&pdev->dev);
 
 	v4l2_async_notifier_unregister(&vin->notifier);
+	v4l2_async_notifier_cleanup(&vin->notifier);
 
 	rvin_dma_remove(vin);
 
diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c b/drivers/media/platform/rcar-vin/rcar-dma.c
index b136844499f6..23fdff7a7370 100644
--- a/drivers/media/platform/rcar-vin/rcar-dma.c
+++ b/drivers/media/platform/rcar-vin/rcar-dma.c
@@ -183,7 +183,7 @@ static int rvin_setup(struct rvin_dev *vin)
 	/*
 	 * Input interface
 	 */
-	switch (vin->digital.code) {
+	switch (vin->digital->code) {
 	case MEDIA_BUS_FMT_YUYV8_1X16:
 		/* BT.601/BT.1358 16bit YCbCr422 */
 		vnmc |= VNMC_INF_YUV16;
@@ -191,7 +191,7 @@ static int rvin_setup(struct rvin_dev *vin)
 		break;
 	case MEDIA_BUS_FMT_UYVY8_2X8:
 		/* BT.656 8bit YCbCr422 or BT.601 8bit YCbCr422 */
-		vnmc |= vin->digital.mbus_cfg.type == V4L2_MBUS_BT656 ?
+		vnmc |= vin->digital->mbus_cfg.type == V4L2_MBUS_BT656 ?
 			VNMC_INF_YUV8_BT656 : VNMC_INF_YUV8_BT601;
 		input_is_yuv = true;
 		break;
@@ -200,7 +200,7 @@ static int rvin_setup(struct rvin_dev *vin)
 		break;
 	case MEDIA_BUS_FMT_UYVY10_2X10:
 		/* BT.656 10bit YCbCr422 or BT.601 10bit YCbCr422 */
-		vnmc |= vin->digital.mbus_cfg.type == V4L2_MBUS_BT656 ?
+		vnmc |= vin->digital->mbus_cfg.type == V4L2_MBUS_BT656 ?
 			VNMC_INF_YUV10_BT656 : VNMC_INF_YUV10_BT601;
 		input_is_yuv = true;
 		break;
@@ -212,11 +212,11 @@ static int rvin_setup(struct rvin_dev *vin)
 	dmr2 = VNDMR2_FTEV | VNDMR2_VLV(1);
 
 	/* Hsync Signal Polarity Select */
-	if (!(vin->digital.mbus_cfg.flags & V4L2_MBUS_HSYNC_ACTIVE_LOW))
+	if (!(vin->digital->mbus_cfg.flags & V4L2_MBUS_HSYNC_ACTIVE_LOW))
 		dmr2 |= VNDMR2_HPS;
 
 	/* Vsync Signal Polarity Select */
-	if (!(vin->digital.mbus_cfg.flags & V4L2_MBUS_VSYNC_ACTIVE_LOW))
+	if (!(vin->digital->mbus_cfg.flags & V4L2_MBUS_VSYNC_ACTIVE_LOW))
 		dmr2 |= VNDMR2_VPS;
 
 	/*
diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
index dd37ea811680..b479b882da12 100644
--- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
+++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
@@ -111,7 +111,7 @@ static int rvin_reset_format(struct rvin_dev *vin)
 	struct v4l2_mbus_framefmt *mf = &fmt.format;
 	int ret;
 
-	fmt.pad = vin->digital.source_pad;
+	fmt.pad = vin->digital->source_pad;
 
 	ret = v4l2_subdev_call(vin_to_source(vin), pad, get_fmt, NULL, &fmt);
 	if (ret)
@@ -172,13 +172,13 @@ static int __rvin_try_format_source(struct rvin_dev *vin,
 
 	sd = vin_to_source(vin);
 
-	v4l2_fill_mbus_format(&format.format, pix, vin->digital.code);
+	v4l2_fill_mbus_format(&format.format, pix, vin->digital->code);
 
 	pad_cfg = v4l2_subdev_alloc_pad_config(sd);
 	if (pad_cfg == NULL)
 		return -ENOMEM;
 
-	format.pad = vin->digital.source_pad;
+	format.pad = vin->digital->source_pad;
 
 	field = pix->field;
 
@@ -555,7 +555,7 @@ static int rvin_enum_dv_timings(struct file *file, void *priv_fh,
 	if (timings->pad)
 		return -EINVAL;
 
-	timings->pad = vin->digital.sink_pad;
+	timings->pad = vin->digital->sink_pad;
 
 	ret = v4l2_subdev_call(sd, pad, enum_dv_timings, timings);
 
@@ -607,7 +607,7 @@ static int rvin_dv_timings_cap(struct file *file, void *priv_fh,
 	if (cap->pad)
 		return -EINVAL;
 
-	cap->pad = vin->digital.sink_pad;
+	cap->pad = vin->digital->sink_pad;
 
 	ret = v4l2_subdev_call(sd, pad, dv_timings_cap, cap);
 
@@ -625,7 +625,7 @@ static int rvin_g_edid(struct file *file, void *fh, struct v4l2_edid *edid)
 	if (edid->pad)
 		return -EINVAL;
 
-	edid->pad = vin->digital.sink_pad;
+	edid->pad = vin->digital->sink_pad;
 
 	ret = v4l2_subdev_call(sd, pad, get_edid, edid);
 
@@ -643,7 +643,7 @@ static int rvin_s_edid(struct file *file, void *fh, struct v4l2_edid *edid)
 	if (edid->pad)
 		return -EINVAL;
 
-	edid->pad = vin->digital.sink_pad;
+	edid->pad = vin->digital->sink_pad;
 
 	ret = v4l2_subdev_call(sd, pad, set_edid, edid);
 
diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h b/drivers/media/platform/rcar-vin/rcar-vin.h
index 9bfb5a7c4dc4..5382078143fb 100644
--- a/drivers/media/platform/rcar-vin/rcar-vin.h
+++ b/drivers/media/platform/rcar-vin/rcar-vin.h
@@ -126,7 +126,7 @@ struct rvin_dev {
 	struct v4l2_device v4l2_dev;
 	struct v4l2_ctrl_handler ctrl_handler;
 	struct v4l2_async_notifier notifier;
-	struct rvin_graph_entity digital;
+	struct rvin_graph_entity *digital;
 
 	struct mutex lock;
 	struct vb2_queue queue;
@@ -145,7 +145,7 @@ struct rvin_dev {
 	struct v4l2_rect compose;
 };
 
-#define vin_to_source(vin)		vin->digital.subdev
+#define vin_to_source(vin)		((vin)->digital->subdev)
 
 /* Debug */
 #define vin_dbg(d, fmt, arg...)		dev_dbg(d->dev, fmt, ##arg)
-- 
2.11.0
