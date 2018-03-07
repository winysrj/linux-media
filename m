Return-path: <linux-media-owner@vger.kernel.org>
Received: from bin-mail-out-06.binero.net ([195.74.38.229]:31657 "EHLO
        bin-vsp-out-02.atm.binero.net" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754547AbeCGWFc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Mar 2018 17:05:32 -0500
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v12 07/33] rcar-vin: move model information to own struct
Date: Wed,  7 Mar 2018 23:04:45 +0100
Message-Id: <20180307220511.9826-8-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20180307220511.9826-1-niklas.soderlund+renesas@ragnatech.se>
References: <20180307220511.9826-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When Gen3 support is added to the driver more than model ID will be
different for the different SoCs. To avoid a lot of if statements in the
code create a struct rvin_info to store this information.

While we are at it rename the poorly chosen enum which contains the
different model IDs from chip_id to model_id. Also sort the compatible
string entries and make use of of_device_get_match_data() which will
always work as the driver is DT only, so there's always a valid match.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/rcar-vin/rcar-core.c | 56 +++++++++++++++++++++--------
 drivers/media/platform/rcar-vin/rcar-v4l2.c |  3 +-
 drivers/media/platform/rcar-vin/rcar-vin.h  | 14 ++++++--
 3 files changed, 55 insertions(+), 18 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index 663309ca9c04f208..d2b27ccff690cede 100644
--- a/drivers/media/platform/rcar-vin/rcar-core.c
+++ b/drivers/media/platform/rcar-vin/rcar-core.c
@@ -241,21 +241,53 @@ static int rvin_digital_graph_init(struct rvin_dev *vin)
  * Platform Device Driver
  */
 
+static const struct rvin_info rcar_info_h1 = {
+	.model = RCAR_H1,
+};
+
+static const struct rvin_info rcar_info_m1 = {
+	.model = RCAR_M1,
+};
+
+static const struct rvin_info rcar_info_gen2 = {
+	.model = RCAR_GEN2,
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
-	{ },
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
+	{ /* Sentinel */ },
 };
 MODULE_DEVICE_TABLE(of, rvin_of_id_table);
 
 static int rcar_vin_probe(struct platform_device *pdev)
 {
-	const struct of_device_id *match;
 	struct rvin_dev *vin;
 	struct resource *mem;
 	int irq, ret;
@@ -264,12 +296,8 @@ static int rcar_vin_probe(struct platform_device *pdev)
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
index 4a0610a6b4503501..0a035667c0b0e93f 100644
--- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
+++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
@@ -266,7 +266,8 @@ static int __rvin_try_format(struct rvin_dev *vin,
 	pix->sizeimage = max_t(u32, pix->sizeimage,
 			       rvin_format_sizeimage(pix));
 
-	if (vin->chip == RCAR_M1 && pix->pixelformat == V4L2_PIX_FMT_XBGR32) {
+	if (vin->info->model == RCAR_M1 &&
+	    pix->pixelformat == V4L2_PIX_FMT_XBGR32) {
 		vin_err(vin, "pixel format XBGR32 not supported on M1\n");
 		return -EINVAL;
 	}
diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h b/drivers/media/platform/rcar-vin/rcar-vin.h
index 85cb7ec53d2b08b5..3f49d2f2d6b88471 100644
--- a/drivers/media/platform/rcar-vin/rcar-vin.h
+++ b/drivers/media/platform/rcar-vin/rcar-vin.h
@@ -29,7 +29,7 @@
 /* Address alignment mask for HW buffers */
 #define HW_BUFFER_MASK 0x7f
 
-enum chip_id {
+enum model_id {
 	RCAR_H1,
 	RCAR_M1,
 	RCAR_GEN2,
@@ -88,11 +88,19 @@ struct rvin_graph_entity {
 	unsigned int sink_pad;
 };
 
+/**
+ * struct rvin_info - Information about the particular VIN implementation
+ * @model:		VIN model
+ */
+struct rvin_info {
+	enum model_id model;
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
2.16.2
