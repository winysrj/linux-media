Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:44870 "EHLO
        smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752150AbdLHBI7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 7 Dec 2017 20:08:59 -0500
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v9 05/28] rcar-vin: move chip information to own struct
Date: Fri,  8 Dec 2017 02:08:19 +0100
Message-Id: <20171208010842.20047-6-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20171208010842.20047-1-niklas.soderlund+renesas@ragnatech.se>
References: <20171208010842.20047-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When Gen3 support is added to the driver more than chip ID will be
different for the different SoCs. To avoid a lot of if statements in the
code create a struct chip_info to store this information.

And while we are at it sort the compatible string entries and make use
of of_device_get_match_data() which will always work as the driver is DT
only, so there's always a valid match.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/rcar-vin/rcar-core.c | 54 ++++++++++++++++++++++-------
 drivers/media/platform/rcar-vin/rcar-v4l2.c |  3 +-
 drivers/media/platform/rcar-vin/rcar-vin.h  | 12 +++++--
 3 files changed, 53 insertions(+), 16 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index 6ab51acd676641ec..73c1700a409bfd35 100644
--- a/drivers/media/platform/rcar-vin/rcar-core.c
+++ b/drivers/media/platform/rcar-vin/rcar-core.c
@@ -230,21 +230,53 @@ static int rvin_digital_graph_init(struct rvin_dev *vin)
  * Platform Device Driver
  */
 
+static const struct rvin_info rcar_info_h1 = {
+	.chip = RCAR_H1,
+};
+
+static const struct rvin_info rcar_info_m1 = {
+	.chip = RCAR_M1,
+};
+
+static const struct rvin_info rcar_info_gen2 = {
+	.chip = RCAR_GEN2,
+};
+
 static const struct of_device_id rvin_of_id_table[] = {
-	{ .compatible = "renesas,vin-r8a7794", .data = (void *)RCAR_GEN2 },
-	{ .compatible = "renesas,vin-r8a7793", .data = (void *)RCAR_GEN2 },
-	{ .compatible = "renesas,vin-r8a7791", .data = (void *)RCAR_GEN2 },
-	{ .compatible = "renesas,vin-r8a7790", .data = (void *)RCAR_GEN2 },
-	{ .compatible = "renesas,vin-r8a7779", .data = (void *)RCAR_H1 },
-	{ .compatible = "renesas,vin-r8a7778", .data = (void *)RCAR_M1 },
-	{ .compatible = "renesas,rcar-gen2-vin", .data = (void *)RCAR_GEN2 },
+	{
+		.compatible = "renesas,vin-r8a7778",
+		.data = &rcar_info_m1,
+	},
+	{
+		.compatible = "renesas,vin-r8a7779",
+		.data = &rcar_info_h1,
+	},
+	{
+		.compatible = "renesas,vin-r8a7790",
+		.data = &rcar_info_gen2,
+	},
+	{
+		.compatible = "renesas,vin-r8a7791",
+		.data = &rcar_info_gen2,
+	},
+	{
+		.compatible = "renesas,vin-r8a7793",
+		.data = &rcar_info_gen2,
+	},
+	{
+		.compatible = "renesas,vin-r8a7794",
+		.data = &rcar_info_gen2,
+	},
+	{
+		.compatible = "renesas,rcar-gen2-vin",
+		.data = &rcar_info_gen2,
+	},
 	{ },
 };
 MODULE_DEVICE_TABLE(of, rvin_of_id_table);
 
 static int rcar_vin_probe(struct platform_device *pdev)
 {
-	const struct of_device_id *match;
 	struct rvin_dev *vin;
 	struct resource *mem;
 	int irq, ret;
@@ -253,12 +285,8 @@ static int rcar_vin_probe(struct platform_device *pdev)
 	if (!vin)
 		return -ENOMEM;
 
-	match = of_match_device(of_match_ptr(rvin_of_id_table), &pdev->dev);
-	if (!match)
-		return -ENODEV;
-
 	vin->dev = &pdev->dev;
-	vin->chip = (enum chip_id)match->data;
+	vin->info = of_device_get_match_data(&pdev->dev);
 
 	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (mem == NULL)
diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
index 4a0610a6b4503501..b1caa04921aa23bb 100644
--- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
+++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
@@ -266,7 +266,8 @@ static int __rvin_try_format(struct rvin_dev *vin,
 	pix->sizeimage = max_t(u32, pix->sizeimage,
 			       rvin_format_sizeimage(pix));
 
-	if (vin->chip == RCAR_M1 && pix->pixelformat == V4L2_PIX_FMT_XBGR32) {
+	if (vin->info->chip == RCAR_M1 &&
+	    pix->pixelformat == V4L2_PIX_FMT_XBGR32) {
 		vin_err(vin, "pixel format XBGR32 not supported on M1\n");
 		return -EINVAL;
 	}
diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h b/drivers/media/platform/rcar-vin/rcar-vin.h
index 85cb7ec53d2b08b5..0d3949c8c08c8f63 100644
--- a/drivers/media/platform/rcar-vin/rcar-vin.h
+++ b/drivers/media/platform/rcar-vin/rcar-vin.h
@@ -88,11 +88,19 @@ struct rvin_graph_entity {
 	unsigned int sink_pad;
 };
 
+/**
+ * struct rvin_info - Information about the particular VIN implementation
+ * @chip:		type of VIN chip
+ */
+struct rvin_info {
+	enum chip_id chip;
+};
+
 /**
  * struct rvin_dev - Renesas VIN device structure
  * @dev:		(OF) device
  * @base:		device I/O register space remapped to virtual memory
- * @chip:		type of VIN chip
+ * @info:		info about VIN instance
  *
  * @vdev:		V4L2 video device associated with VIN
  * @v4l2_dev:		V4L2 device
@@ -120,7 +128,7 @@ struct rvin_graph_entity {
 struct rvin_dev {
 	struct device *dev;
 	void __iomem *base;
-	enum chip_id chip;
+	const struct rvin_info *info;
 
 	struct video_device vdev;
 	struct v4l2_device v4l2_dev;
-- 
2.15.0
