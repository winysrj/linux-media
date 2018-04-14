Return-path: <linux-media-owner@vger.kernel.org>
Received: from bin-mail-out-05.binero.net ([195.74.38.228]:2469 "EHLO
        bin-mail-out-05.binero.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750898AbeDNMDI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 14 Apr 2018 08:03:08 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v14 31/33] rcar-vin: enable support for r8a7795
Date: Sat, 14 Apr 2018 13:57:24 +0200
Message-Id: <20180414115726.5075-32-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20180414115726.5075-1-niklas.soderlund+renesas@ragnatech.se>
References: <20180414115726.5075-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add the SoC specific information for Renesas r8a7795 ES1.x and ES2.0.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/rcar-vin/Kconfig     |   2 +-
 drivers/media/platform/rcar-vin/rcar-core.c | 120 ++++++++++++++++++++++++++++
 2 files changed, 121 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/rcar-vin/Kconfig b/drivers/media/platform/rcar-vin/Kconfig
index af4c98b44d2e22cb..8fa7ee468c63afb9 100644
--- a/drivers/media/platform/rcar-vin/Kconfig
+++ b/drivers/media/platform/rcar-vin/Kconfig
@@ -6,7 +6,7 @@ config VIDEO_RCAR_VIN
 	select V4L2_FWNODE
 	---help---
 	  Support for Renesas R-Car Video Input (VIN) driver.
-	  Supports R-Car Gen2 SoCs.
+	  Supports R-Car Gen2 and Gen3 SoCs.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called rcar-vin.
diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index 0cc76d73115e9277..81119ae4402d0990 100644
--- a/drivers/media/platform/rcar-vin/rcar-core.c
+++ b/drivers/media/platform/rcar-vin/rcar-core.c
@@ -21,6 +21,7 @@
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
 #include <linux/slab.h>
+#include <linux/sys_soc.h>
 
 #include <media/v4l2-async.h>
 #include <media/v4l2-fwnode.h>
@@ -832,6 +833,104 @@ static const struct rvin_info rcar_info_gen2 = {
 	.max_height = 2048,
 };
 
+static const struct rvin_group_route rcar_info_r8a7795_routes[] = {
+	{ .csi = RVIN_CSI40, .channel = 0, .vin = 0, .mask = BIT(0) | BIT(3) },
+	{ .csi = RVIN_CSI20, .channel = 0, .vin = 0, .mask = BIT(1) | BIT(4) },
+	{ .csi = RVIN_CSI40, .channel = 1, .vin = 0, .mask = BIT(2) },
+	{ .csi = RVIN_CSI20, .channel = 0, .vin = 1, .mask = BIT(0) },
+	{ .csi = RVIN_CSI40, .channel = 1, .vin = 1, .mask = BIT(1) | BIT(3) },
+	{ .csi = RVIN_CSI40, .channel = 0, .vin = 1, .mask = BIT(2) },
+	{ .csi = RVIN_CSI20, .channel = 1, .vin = 1, .mask = BIT(4) },
+	{ .csi = RVIN_CSI20, .channel = 1, .vin = 2, .mask = BIT(0) },
+	{ .csi = RVIN_CSI40, .channel = 0, .vin = 2, .mask = BIT(1) },
+	{ .csi = RVIN_CSI20, .channel = 0, .vin = 2, .mask = BIT(2) },
+	{ .csi = RVIN_CSI40, .channel = 2, .vin = 2, .mask = BIT(3) },
+	{ .csi = RVIN_CSI20, .channel = 2, .vin = 2, .mask = BIT(4) },
+	{ .csi = RVIN_CSI40, .channel = 1, .vin = 3, .mask = BIT(0) },
+	{ .csi = RVIN_CSI20, .channel = 1, .vin = 3, .mask = BIT(1) | BIT(2) },
+	{ .csi = RVIN_CSI40, .channel = 3, .vin = 3, .mask = BIT(3) },
+	{ .csi = RVIN_CSI20, .channel = 3, .vin = 3, .mask = BIT(4) },
+	{ .csi = RVIN_CSI41, .channel = 0, .vin = 4, .mask = BIT(0) | BIT(3) },
+	{ .csi = RVIN_CSI20, .channel = 0, .vin = 4, .mask = BIT(1) | BIT(4) },
+	{ .csi = RVIN_CSI41, .channel = 1, .vin = 4, .mask = BIT(2) },
+	{ .csi = RVIN_CSI20, .channel = 0, .vin = 5, .mask = BIT(0) },
+	{ .csi = RVIN_CSI41, .channel = 1, .vin = 5, .mask = BIT(1) | BIT(3) },
+	{ .csi = RVIN_CSI41, .channel = 0, .vin = 5, .mask = BIT(2) },
+	{ .csi = RVIN_CSI20, .channel = 1, .vin = 5, .mask = BIT(4) },
+	{ .csi = RVIN_CSI20, .channel = 1, .vin = 6, .mask = BIT(0) },
+	{ .csi = RVIN_CSI41, .channel = 0, .vin = 6, .mask = BIT(1) },
+	{ .csi = RVIN_CSI20, .channel = 0, .vin = 6, .mask = BIT(2) },
+	{ .csi = RVIN_CSI41, .channel = 2, .vin = 6, .mask = BIT(3) },
+	{ .csi = RVIN_CSI20, .channel = 2, .vin = 6, .mask = BIT(4) },
+	{ .csi = RVIN_CSI41, .channel = 1, .vin = 7, .mask = BIT(0) },
+	{ .csi = RVIN_CSI20, .channel = 1, .vin = 7, .mask = BIT(1) | BIT(2) },
+	{ .csi = RVIN_CSI41, .channel = 3, .vin = 7, .mask = BIT(3) },
+	{ .csi = RVIN_CSI20, .channel = 3, .vin = 7, .mask = BIT(4) },
+	{ /* Sentinel */ }
+};
+
+static const struct rvin_info rcar_info_r8a7795 = {
+	.model = RCAR_GEN3,
+	.use_mc = true,
+	.max_width = 4096,
+	.max_height = 4096,
+	.routes = rcar_info_r8a7795_routes,
+};
+
+static const struct rvin_group_route rcar_info_r8a7795es1_routes[] = {
+	{ .csi = RVIN_CSI40, .channel = 0, .vin = 0, .mask = BIT(0) | BIT(3) },
+	{ .csi = RVIN_CSI20, .channel = 0, .vin = 0, .mask = BIT(1) | BIT(4) },
+	{ .csi = RVIN_CSI21, .channel = 0, .vin = 0, .mask = BIT(2) | BIT(5) },
+	{ .csi = RVIN_CSI20, .channel = 0, .vin = 1, .mask = BIT(0) },
+	{ .csi = RVIN_CSI21, .channel = 0, .vin = 1, .mask = BIT(1) },
+	{ .csi = RVIN_CSI40, .channel = 0, .vin = 1, .mask = BIT(2) },
+	{ .csi = RVIN_CSI40, .channel = 1, .vin = 1, .mask = BIT(3) },
+	{ .csi = RVIN_CSI20, .channel = 1, .vin = 1, .mask = BIT(4) },
+	{ .csi = RVIN_CSI21, .channel = 1, .vin = 1, .mask = BIT(5) },
+	{ .csi = RVIN_CSI21, .channel = 0, .vin = 2, .mask = BIT(0) },
+	{ .csi = RVIN_CSI40, .channel = 0, .vin = 2, .mask = BIT(1) },
+	{ .csi = RVIN_CSI20, .channel = 0, .vin = 2, .mask = BIT(2) },
+	{ .csi = RVIN_CSI40, .channel = 2, .vin = 2, .mask = BIT(3) },
+	{ .csi = RVIN_CSI20, .channel = 2, .vin = 2, .mask = BIT(4) },
+	{ .csi = RVIN_CSI21, .channel = 2, .vin = 2, .mask = BIT(5) },
+	{ .csi = RVIN_CSI40, .channel = 1, .vin = 3, .mask = BIT(0) },
+	{ .csi = RVIN_CSI20, .channel = 1, .vin = 3, .mask = BIT(1) },
+	{ .csi = RVIN_CSI21, .channel = 1, .vin = 3, .mask = BIT(2) },
+	{ .csi = RVIN_CSI40, .channel = 3, .vin = 3, .mask = BIT(3) },
+	{ .csi = RVIN_CSI20, .channel = 3, .vin = 3, .mask = BIT(4) },
+	{ .csi = RVIN_CSI21, .channel = 3, .vin = 3, .mask = BIT(5) },
+	{ .csi = RVIN_CSI41, .channel = 0, .vin = 4, .mask = BIT(0) | BIT(3) },
+	{ .csi = RVIN_CSI20, .channel = 0, .vin = 4, .mask = BIT(1) | BIT(4) },
+	{ .csi = RVIN_CSI21, .channel = 0, .vin = 4, .mask = BIT(2) | BIT(5) },
+	{ .csi = RVIN_CSI20, .channel = 0, .vin = 5, .mask = BIT(0) },
+	{ .csi = RVIN_CSI21, .channel = 0, .vin = 5, .mask = BIT(1) },
+	{ .csi = RVIN_CSI41, .channel = 0, .vin = 5, .mask = BIT(2) },
+	{ .csi = RVIN_CSI41, .channel = 1, .vin = 5, .mask = BIT(3) },
+	{ .csi = RVIN_CSI20, .channel = 1, .vin = 5, .mask = BIT(4) },
+	{ .csi = RVIN_CSI21, .channel = 1, .vin = 5, .mask = BIT(5) },
+	{ .csi = RVIN_CSI21, .channel = 0, .vin = 6, .mask = BIT(0) },
+	{ .csi = RVIN_CSI41, .channel = 0, .vin = 6, .mask = BIT(1) },
+	{ .csi = RVIN_CSI20, .channel = 0, .vin = 6, .mask = BIT(2) },
+	{ .csi = RVIN_CSI41, .channel = 2, .vin = 6, .mask = BIT(3) },
+	{ .csi = RVIN_CSI20, .channel = 2, .vin = 6, .mask = BIT(4) },
+	{ .csi = RVIN_CSI21, .channel = 2, .vin = 6, .mask = BIT(5) },
+	{ .csi = RVIN_CSI41, .channel = 1, .vin = 7, .mask = BIT(0) },
+	{ .csi = RVIN_CSI20, .channel = 1, .vin = 7, .mask = BIT(1) },
+	{ .csi = RVIN_CSI21, .channel = 1, .vin = 7, .mask = BIT(2) },
+	{ .csi = RVIN_CSI41, .channel = 3, .vin = 7, .mask = BIT(3) },
+	{ .csi = RVIN_CSI20, .channel = 3, .vin = 7, .mask = BIT(4) },
+	{ .csi = RVIN_CSI21, .channel = 3, .vin = 7, .mask = BIT(5) },
+	{ /* Sentinel */ }
+};
+
+static const struct rvin_info rcar_info_r8a7795es1 = {
+	.model = RCAR_GEN3,
+	.use_mc = true,
+	.max_width = 4096,
+	.max_height = 4096,
+	.routes = rcar_info_r8a7795es1_routes,
+};
+
 static const struct of_device_id rvin_of_id_table[] = {
 	{
 		.compatible = "renesas,vin-r8a7778",
@@ -861,12 +960,25 @@ static const struct of_device_id rvin_of_id_table[] = {
 		.compatible = "renesas,rcar-gen2-vin",
 		.data = &rcar_info_gen2,
 	},
+	{
+		.compatible = "renesas,vin-r8a7795",
+		.data = &rcar_info_r8a7795,
+	},
 	{ /* Sentinel */ },
 };
 MODULE_DEVICE_TABLE(of, rvin_of_id_table);
 
+static const struct soc_device_attribute r8a7795es1[] = {
+	{
+		.soc_id = "r8a7795", .revision = "ES1.*",
+		.data = &rcar_info_r8a7795es1,
+	},
+	{ /* Sentinel */ }
+};
+
 static int rcar_vin_probe(struct platform_device *pdev)
 {
+	const struct soc_device_attribute *attr;
 	struct rvin_dev *vin;
 	struct resource *mem;
 	int irq, ret;
@@ -878,6 +990,14 @@ static int rcar_vin_probe(struct platform_device *pdev)
 	vin->dev = &pdev->dev;
 	vin->info = of_device_get_match_data(&pdev->dev);
 
+	/*
+	 * Special care is needed on r8a7795 ES1.x since it
+	 * uses different routing than r8a7795 ES2.0.
+	 */
+	attr = soc_device_match(r8a7795es1);
+	if (attr)
+		vin->info = attr->data;
+
 	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (mem == NULL)
 		return -EINVAL;
-- 
2.16.2
