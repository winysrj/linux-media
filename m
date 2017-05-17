Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:37335 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753518AbdEQPPR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 17 May 2017 11:15:17 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: devicetree@vger.kernel.org,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Peter Rosin <peda@axentia.se>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Pavel Machek <pavel@ucw.cz>, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>,
        Sebastian Reichel <sebastian.reichel@collabora.co.uk>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v5 3/3] [media] platform: video-mux: include temporary mmio-mux support
Date: Wed, 17 May 2017 17:15:07 +0200
Message-Id: <1495034107-21407-3-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1495034107-21407-1-git-send-email-p.zabel@pengutronix.de>
References: <1495034107-21407-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As long as the mux framework is not merged, add temporary mmio-mux
support to the video-mux driver itself. This patch is to be reverted
once the "mux: minimal mux subsystem" and "mux: mmio-based syscon mux
controller" patches are merged.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
This patch allows the video-mux driver to be built and used on i.MX6 before
the mux framework [1][2] is merged. It can be dropped after that happened,
but until then, it should help to avoid a dependency of the i.MX6 capture
drivers on the mux framework, so that the two can be merged independently.

[1] https://patchwork.kernel.org/patch/9725911/
[2] https://patchwork.kernel.org/patch/9725893/
---
 drivers/media/platform/Kconfig     |  2 +-
 drivers/media/platform/video-mux.c | 62 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 63 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index 259c0ff780937..fea1dc05ea7b7 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -76,7 +76,7 @@ config VIDEO_M32R_AR_M64278
 
 config VIDEO_MUX
 	tristate "Video Multiplexer"
-	depends on OF && VIDEO_V4L2_SUBDEV_API && MEDIA_CONTROLLER && MULTIPLEXER
+	depends on OF && VIDEO_V4L2_SUBDEV_API && MEDIA_CONTROLLER
 	help
 	  This driver provides support for N:1 video bus multiplexers.
 
diff --git a/drivers/media/platform/video-mux.c b/drivers/media/platform/video-mux.c
index e35ffa18126f3..b997ff881ad24 100644
--- a/drivers/media/platform/video-mux.c
+++ b/drivers/media/platform/video-mux.c
@@ -17,7 +17,12 @@
 #include <linux/err.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
+#ifdef CONFIG_MULTIPLEXER
 #include <linux/mux/consumer.h>
+#else
+#include <linux/regmap.h>
+#include <linux/mfd/syscon.h>
+#endif
 #include <linux/of.h>
 #include <linux/of_graph.h>
 #include <linux/platform_device.h>
@@ -29,7 +34,11 @@ struct video_mux {
 	struct v4l2_subdev subdev;
 	struct media_pad *pads;
 	struct v4l2_mbus_framefmt *format_mbus;
+#ifdef CONFIG_MULTIPLEXER
 	struct mux_control *mux;
+#else
+	struct regmap_field *field;
+#endif
 	struct mutex lock;
 	int active;
 };
@@ -70,7 +79,11 @@ static int video_mux_link_setup(struct media_entity *entity,
 		}
 
 		dev_dbg(sd->dev, "setting %d active\n", local->index);
+#ifdef CONFIG_MULTIPLEXER
 		ret = mux_control_try_select(vmux->mux, local->index);
+#else
+		ret = regmap_field_write(vmux->field, local->index);
+#endif
 		if (ret < 0)
 			goto out;
 		vmux->active = local->index;
@@ -79,7 +92,9 @@ static int video_mux_link_setup(struct media_entity *entity,
 			goto out;
 
 		dev_dbg(sd->dev, "going inactive\n");
+#ifdef CONFIG_MULTIPLEXER
 		mux_control_deselect(vmux->mux);
+#endif
 		vmux->active = -1;
 	}
 
@@ -193,6 +208,48 @@ static const struct v4l2_subdev_ops video_mux_subdev_ops = {
 	.video = &video_mux_subdev_video_ops,
 };
 
+#ifndef CONFIG_MULTIPLEXER
+static int video_mux_probe_mmio_mux(struct video_mux *vmux)
+{
+	struct device *dev = vmux->subdev.dev;
+	struct of_phandle_args args;
+	struct reg_field field;
+	struct regmap *regmap;
+	u32 reg, mask;
+	int ret;
+
+	ret = of_parse_phandle_with_args(dev->of_node, "mux-controls",
+					 "#mux-control-cells", 0, &args);
+	if (ret)
+		return ret;
+
+	if (!of_device_is_compatible(args.np, "mmio-mux"))
+		return -EINVAL;
+
+	regmap = syscon_node_to_regmap(args.np->parent);
+	if (IS_ERR(regmap))
+		return PTR_ERR(regmap);
+
+	ret = of_property_read_u32_index(args.np, "mux-reg-masks",
+					 2 * args.args[0], &reg);
+	if (!ret)
+		ret = of_property_read_u32_index(args.np, "mux-reg-masks",
+						 2 * args.args[0] + 1, &mask);
+	if (ret < 0)
+		return ret;
+
+	field.reg = reg;
+	field.msb = fls(mask) - 1;
+	field.lsb = ffs(mask) - 1;
+
+	vmux->field = devm_regmap_field_alloc(dev, regmap, field);
+	if (IS_ERR(vmux->field))
+		return PTR_ERR(vmux->field);
+
+	return 0;
+}
+#endif
+
 static int video_mux_probe(struct platform_device *pdev)
 {
 	struct device_node *np = pdev->dev.of_node;
@@ -230,9 +287,14 @@ static int video_mux_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
+#ifdef CONFIG_MULTIPLEXER
 	vmux->mux = devm_mux_control_get(dev, NULL);
 	if (IS_ERR(vmux->mux)) {
 		ret = PTR_ERR(vmux->mux);
+#else
+	ret = video_mux_probe_mmio_mux(vmux);
+	if (ret) {
+#endif
 		if (ret != -EPROBE_DEFER)
 			dev_err(dev, "Failed to get mux: %d\n", ret);
 		return ret;
-- 
2.11.0
