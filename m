Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:34431 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727595AbeH1FoL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 28 Aug 2018 01:44:11 -0400
From: Rob Herring <robh@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Benoit Parrot <bparrot@ti.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Hyun Kwon <hyun.kwon@xilinx.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Michal Simek <michal.simek@xilinx.com>,
        linux-media@vger.kernel.org
Subject: [PATCH] media: Convert to using %pOFn instead of device_node.name
Date: Mon, 27 Aug 2018 20:52:29 -0500
Message-Id: <20180828015252.28511-28-robh@kernel.org>
In-Reply-To: <20180828015252.28511-1-robh@kernel.org>
References: <20180828015252.28511-1-robh@kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In preparation to remove the node name pointer from struct device_node,
convert printf users to use the %pOFn format specifier.

Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Cc: Benoit Parrot <bparrot@ti.com>
Cc: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Hyun Kwon <hyun.kwon@xilinx.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Michal Simek <michal.simek@xilinx.com>
Cc: linux-media@vger.kernel.org
Signed-off-by: Rob Herring <robh@kernel.org>
---
 drivers/media/i2c/tvp5150.c                   | 8 ++++----
 drivers/media/platform/davinci/vpif_capture.c | 3 +--
 drivers/media/platform/ti-vpe/cal.c           | 8 ++++----
 drivers/media/platform/video-mux.c            | 2 +-
 drivers/media/platform/xilinx/xilinx-dma.c    | 8 ++++----
 5 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
index 76e6bed5a1da..f337e523821b 100644
--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -1403,8 +1403,8 @@ static int tvp5150_parse_dt(struct tvp5150 *decoder, struct device_node *np)
 		ret = of_property_read_u32(child, "input", &input_type);
 		if (ret) {
 			dev_err(decoder->sd.dev,
-				 "missing type property in node %s\n",
-				 child->name);
+				 "missing type property in node %pOFn\n",
+				 child);
 			goto err_connector;
 		}
 
@@ -1439,8 +1439,8 @@ static int tvp5150_parse_dt(struct tvp5150 *decoder, struct device_node *np)
 		ret = of_property_read_string(child, "label", &name);
 		if (ret < 0) {
 			dev_err(decoder->sd.dev,
-				 "missing label property in node %s\n",
-				 child->name);
+				 "missing label property in node %pOFn\n",
+				 child);
 			goto err_connector;
 		}
 
diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
index a96f53ce8088..35fc69591d54 100644
--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -1583,8 +1583,7 @@ vpif_capture_get_pdata(struct platform_device *pdev)
 			goto done;
 		}
 
-		dev_dbg(&pdev->dev, "Remote device %s, %pOF found\n",
-			rem->name, rem);
+		dev_dbg(&pdev->dev, "Remote device %pOF found\n", rem);
 		sdinfo->name = rem->full_name;
 
 		pdata->asd[i] = devm_kzalloc(&pdev->dev,
diff --git a/drivers/media/platform/ti-vpe/cal.c b/drivers/media/platform/ti-vpe/cal.c
index d1febe5baa6d..77d755020e78 100644
--- a/drivers/media/platform/ti-vpe/cal.c
+++ b/drivers/media/platform/ti-vpe/cal.c
@@ -1712,8 +1712,8 @@ static int of_cal_create_instance(struct cal_ctx *ctx, int inst)
 	v4l2_fwnode_endpoint_parse(of_fwnode_handle(remote_ep), endpoint);
 
 	if (endpoint->bus_type != V4L2_MBUS_CSI2) {
-		ctx_err(ctx, "Port:%d sub-device %s is not a CSI2 device\n",
-			inst, sensor_node->name);
+		ctx_err(ctx, "Port:%d sub-device %pOFn is not a CSI2 device\n",
+			inst, sensor_node);
 		goto cleanup_exit;
 	}
 
@@ -1732,8 +1732,8 @@ static int of_cal_create_instance(struct cal_ctx *ctx, int inst)
 			endpoint->bus.mipi_csi2.data_lanes[lane]);
 	ctx_dbg(3, ctx, "\t>\n");
 
-	ctx_dbg(1, ctx, "Port: %d found sub-device %s\n",
-		inst, sensor_node->name);
+	ctx_dbg(1, ctx, "Port: %d found sub-device %pOFn\n",
+		inst, sensor_node);
 
 	ctx->asd_list[0] = asd;
 	ctx->notifier.subdevs = ctx->asd_list;
diff --git a/drivers/media/platform/video-mux.c b/drivers/media/platform/video-mux.c
index c01e1592ad0a..61a9bf716a05 100644
--- a/drivers/media/platform/video-mux.c
+++ b/drivers/media/platform/video-mux.c
@@ -333,7 +333,7 @@ static int video_mux_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, vmux);
 
 	v4l2_subdev_init(&vmux->subdev, &video_mux_subdev_ops);
-	snprintf(vmux->subdev.name, sizeof(vmux->subdev.name), "%s", np->name);
+	snprintf(vmux->subdev.name, sizeof(vmux->subdev.name), "%pOFn", np);
 	vmux->subdev.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
 	vmux->subdev.dev = dev;
 
diff --git a/drivers/media/platform/xilinx/xilinx-dma.c b/drivers/media/platform/xilinx/xilinx-dma.c
index d041f94be832..3c8fcf951c63 100644
--- a/drivers/media/platform/xilinx/xilinx-dma.c
+++ b/drivers/media/platform/xilinx/xilinx-dma.c
@@ -506,8 +506,8 @@ xvip_dma_querycap(struct file *file, void *fh, struct v4l2_capability *cap)
 
 	strlcpy(cap->driver, "xilinx-vipp", sizeof(cap->driver));
 	strlcpy(cap->card, dma->video.name, sizeof(cap->card));
-	snprintf(cap->bus_info, sizeof(cap->bus_info), "platform:%s:%u",
-		 dma->xdev->dev->of_node->name, dma->port);
+	snprintf(cap->bus_info, sizeof(cap->bus_info), "platform:%pOFn:%u",
+		 dma->xdev->dev->of_node, dma->port);
 
 	return 0;
 }
@@ -693,8 +693,8 @@ int xvip_dma_init(struct xvip_composite_device *xdev, struct xvip_dma *dma,
 	dma->video.fops = &xvip_dma_fops;
 	dma->video.v4l2_dev = &xdev->v4l2_dev;
 	dma->video.queue = &dma->queue;
-	snprintf(dma->video.name, sizeof(dma->video.name), "%s %s %u",
-		 xdev->dev->of_node->name,
+	snprintf(dma->video.name, sizeof(dma->video.name), "%pOFn %s %u",
+		 xdev->dev->of_node,
 		 type == V4L2_BUF_TYPE_VIDEO_CAPTURE ? "output" : "input",
 		 port);
 	dma->video.vfl_type = VFL_TYPE_GRABBER;
-- 
2.17.1
