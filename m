Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:43179 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751280AbdGQKzR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Jul 2017 06:55:17 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH] [media] platform: video-mux: convert to multiplexer framework
Date: Mon, 17 Jul 2017 12:55:14 +0200
Message-Id: <20170717105514.18426-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that the multiplexer framework is merged, drop the temporary
mmio-mux implementation from the video-mux driver and convert it to use
the multiplexer API.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/video-mux.c | 53 +++++---------------------------------
 1 file changed, 7 insertions(+), 46 deletions(-)

diff --git a/drivers/media/platform/video-mux.c b/drivers/media/platform/video-mux.c
index 665744716f73b..ee89ad76bee23 100644
--- a/drivers/media/platform/video-mux.c
+++ b/drivers/media/platform/video-mux.c
@@ -17,8 +17,7 @@
 #include <linux/err.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
-#include <linux/regmap.h>
-#include <linux/mfd/syscon.h>
+#include <linux/mux/consumer.h>
 #include <linux/of.h>
 #include <linux/of_graph.h>
 #include <linux/platform_device.h>
@@ -30,7 +29,7 @@ struct video_mux {
 	struct v4l2_subdev subdev;
 	struct media_pad *pads;
 	struct v4l2_mbus_framefmt *format_mbus;
-	struct regmap_field *field;
+	struct mux_control *mux;
 	struct mutex lock;
 	int active;
 };
@@ -71,7 +70,7 @@ static int video_mux_link_setup(struct media_entity *entity,
 		}
 
 		dev_dbg(sd->dev, "setting %d active\n", local->index);
-		ret = regmap_field_write(vmux->field, local->index);
+		ret = mux_control_try_select(vmux->mux, local->index);
 		if (ret < 0)
 			goto out;
 		vmux->active = local->index;
@@ -80,6 +79,7 @@ static int video_mux_link_setup(struct media_entity *entity,
 			goto out;
 
 		dev_dbg(sd->dev, "going inactive\n");
+		mux_control_deselect(vmux->mux);
 		vmux->active = -1;
 	}
 
@@ -193,46 +193,6 @@ static const struct v4l2_subdev_ops video_mux_subdev_ops = {
 	.video = &video_mux_subdev_video_ops,
 };
 
-static int video_mux_probe_mmio_mux(struct video_mux *vmux)
-{
-	struct device *dev = vmux->subdev.dev;
-	struct of_phandle_args args;
-	struct reg_field field;
-	struct regmap *regmap;
-	u32 reg, mask;
-	int ret;
-
-	ret = of_parse_phandle_with_args(dev->of_node, "mux-controls",
-					 "#mux-control-cells", 0, &args);
-	if (ret)
-		return ret;
-
-	if (!of_device_is_compatible(args.np, "mmio-mux"))
-		return -EINVAL;
-
-	regmap = syscon_node_to_regmap(args.np->parent);
-	if (IS_ERR(regmap))
-		return PTR_ERR(regmap);
-
-	ret = of_property_read_u32_index(args.np, "mux-reg-masks",
-					 2 * args.args[0], &reg);
-	if (!ret)
-		ret = of_property_read_u32_index(args.np, "mux-reg-masks",
-						 2 * args.args[0] + 1, &mask);
-	if (ret < 0)
-		return ret;
-
-	field.reg = reg;
-	field.msb = fls(mask) - 1;
-	field.lsb = ffs(mask) - 1;
-
-	vmux->field = devm_regmap_field_alloc(dev, regmap, field);
-	if (IS_ERR(vmux->field))
-		return PTR_ERR(vmux->field);
-
-	return 0;
-}
-
 static int video_mux_probe(struct platform_device *pdev)
 {
 	struct device_node *np = pdev->dev.of_node;
@@ -270,8 +230,9 @@ static int video_mux_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	ret = video_mux_probe_mmio_mux(vmux);
-	if (ret) {
+	vmux->mux = devm_mux_control_get(dev, NULL);
+	if (IS_ERR(vmux->mux)) {
+		ret = PTR_ERR(vmux->mux);
 		if (ret != -EPROBE_DEFER)
 			dev_err(dev, "Failed to get mux: %d\n", ret);
 		return ret;
-- 
2.11.0
