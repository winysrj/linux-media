Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:37396 "EHLO
        smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751386AbdCNTGg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Mar 2017 15:06:36 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        tomoharu.fukawa.eb@renesas.com,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v3 05/27] rcar-vin: move chip information to own struct
Date: Tue, 14 Mar 2017 20:02:46 +0100
Message-Id: <20170314190308.25790-6-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20170314190308.25790-1-niklas.soderlund+renesas@ragnatech.se>
References: <20170314190308.25790-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When Gen3 support is added to the driver more then chip id will be
different for the different Soc. To avoid a lot of if statements in the
code create a struct chip_info to contain this information.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-core.c | 49 ++++++++++++++++++++++++-----
 drivers/media/platform/rcar-vin/rcar-v4l2.c |  3 +-
 drivers/media/platform/rcar-vin/rcar-vin.h  | 12 +++++--
 3 files changed, 53 insertions(+), 11 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index c4d4f112da0c9d45..ec1eb723d401fda2 100644
--- a/drivers/media/platform/rcar-vin/rcar-core.c
+++ b/drivers/media/platform/rcar-vin/rcar-core.c
@@ -255,14 +255,47 @@ static int rvin_digital_graph_init(struct rvin_dev *vin)
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
+		.compatible = "renesas,vin-r8a7794",
+		.data = &rcar_info_gen2,
+	},
+	{
+		.compatible = "renesas,vin-r8a7793",
+		.data = &rcar_info_gen2,
+	},
+	{
+		.compatible = "renesas,vin-r8a7791",
+		.data = &rcar_info_gen2,
+	},
+	{
+		.compatible = "renesas,vin-r8a7790",
+		.data = &rcar_info_gen2,
+	},
+	{
+		.compatible = "renesas,vin-r8a7779",
+		.data = &rcar_info_h1,
+	},
+	{
+		.compatible = "renesas,vin-r8a7778",
+		.data = &rcar_info_m1,
+	},
+	{
+		.compatible = "renesas,rcar-gen2-vin",
+		.data = &rcar_info_gen2,
+	},
 	{ },
 };
 MODULE_DEVICE_TABLE(of, rvin_of_id_table);
@@ -283,7 +316,7 @@ static int rcar_vin_probe(struct platform_device *pdev)
 		return -ENODEV;
 
 	vin->dev = &pdev->dev;
-	vin->chip = (enum chip_id)match->data;
+	vin->info = match->data;
 
 	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (mem == NULL)
diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
index 27b7733e96afe3e9..7deca15d22b4d6e3 100644
--- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
+++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
@@ -272,7 +272,8 @@ static int __rvin_try_format(struct rvin_dev *vin,
 	pix->sizeimage = max_t(u32, pix->sizeimage,
 			       rvin_format_sizeimage(pix));
 
-	if (vin->chip == RCAR_M1 && pix->pixelformat == V4L2_PIX_FMT_XBGR32) {
+	if (vin->info->chip == RCAR_M1 &&
+	    pix->pixelformat == V4L2_PIX_FMT_XBGR32) {
 		vin_err(vin, "pixel format XBGR32 not supported on M1\n");
 		return -EINVAL;
 	}
diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h b/drivers/media/platform/rcar-vin/rcar-vin.h
index 9454ef80bc2b3961..c07b4a6893440a6a 100644
--- a/drivers/media/platform/rcar-vin/rcar-vin.h
+++ b/drivers/media/platform/rcar-vin/rcar-vin.h
@@ -89,10 +89,18 @@ struct rvin_graph_entity {
 };
 
 /**
+ * struct rvin_info- Information about the particular VIN implementation
+ * @chip:		type of VIN chip
+ */
+struct rvin_info {
+	enum chip_id chip;
+};
+
+/**
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
 
 	struct video_device *vdev;
 	struct v4l2_device v4l2_dev;
-- 
2.12.0
