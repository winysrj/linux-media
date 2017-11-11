Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-3.sys.kth.se ([130.237.48.192]:47716 "EHLO
        smtp-3.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754883AbdKKAjK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Nov 2017 19:39:10 -0500
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v7 24/25] rcar-vin: enable support for r8a7795
Date: Sat, 11 Nov 2017 01:38:34 +0100
Message-Id: <20171111003835.4909-25-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20171111003835.4909-1-niklas.soderlund+renesas@ragnatech.se>
References: <20171111003835.4909-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add the SoC specific information for Renesas r8a7795 ES1.x and ES2.0.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/rcar-vin/Kconfig     |   2 +-
 drivers/media/platform/rcar-vin/rcar-core.c | 150 ++++++++++++++++++++++++++++
 2 files changed, 151 insertions(+), 1 deletion(-)

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
index 79b0334d8c563328..b22f6596700d2479 100644
--- a/drivers/media/platform/rcar-vin/rcar-core.c
+++ b/drivers/media/platform/rcar-vin/rcar-core.c
@@ -21,6 +21,7 @@
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
 #include <linux/slab.h>
+#include <linux/sys_soc.h>
 
 #include <media/v4l2-async.h>
 #include <media/v4l2-fwnode.h>
@@ -955,6 +956,134 @@ static const struct rvin_info rcar_info_gen2 = {
 	.max_height = 2048,
 };
 
+static const struct rvin_info rcar_info_r8a7795 = {
+	.chip = RCAR_GEN3,
+	.use_mc = true,
+	.max_width = 4096,
+	.max_height = 4096,
+
+	.num_chsels = 5,
+	.chsels = {
+		{
+			{ .csi = RVIN_CSI40, .chan = 0 },
+			{ .csi = RVIN_CSI20, .chan = 0 },
+			{ .csi = RVIN_CSI40, .chan = 1 },
+			{ .csi = RVIN_CSI40, .chan = 0 },
+			{ .csi = RVIN_CSI20, .chan = 0 },
+		}, {
+			{ .csi = RVIN_CSI20, .chan = 0 },
+			{ .csi = RVIN_CSI40, .chan = 1 },
+			{ .csi = RVIN_CSI40, .chan = 0 },
+			{ .csi = RVIN_CSI40, .chan = 1 },
+			{ .csi = RVIN_CSI20, .chan = 1 },
+		}, {
+			{ .csi = RVIN_CSI20, .chan = 1 },
+			{ .csi = RVIN_CSI40, .chan = 0 },
+			{ .csi = RVIN_CSI20, .chan = 0 },
+			{ .csi = RVIN_CSI40, .chan = 2 },
+			{ .csi = RVIN_CSI20, .chan = 2 },
+		}, {
+			{ .csi = RVIN_CSI40, .chan = 1 },
+			{ .csi = RVIN_CSI20, .chan = 1 },
+			{ .csi = RVIN_CSI20, .chan = 1 },
+			{ .csi = RVIN_CSI40, .chan = 3 },
+			{ .csi = RVIN_CSI20, .chan = 3 },
+		}, {
+			{ .csi = RVIN_CSI41, .chan = 0 },
+			{ .csi = RVIN_CSI20, .chan = 0 },
+			{ .csi = RVIN_CSI41, .chan = 1 },
+			{ .csi = RVIN_CSI41, .chan = 0 },
+			{ .csi = RVIN_CSI20, .chan = 0 },
+		}, {
+			{ .csi = RVIN_CSI20, .chan = 0 },
+			{ .csi = RVIN_CSI41, .chan = 1 },
+			{ .csi = RVIN_CSI41, .chan = 0 },
+			{ .csi = RVIN_CSI41, .chan = 1 },
+			{ .csi = RVIN_CSI20, .chan = 1 },
+		}, {
+			{ .csi = RVIN_CSI20, .chan = 1 },
+			{ .csi = RVIN_CSI41, .chan = 0 },
+			{ .csi = RVIN_CSI20, .chan = 0 },
+			{ .csi = RVIN_CSI41, .chan = 2 },
+			{ .csi = RVIN_CSI20, .chan = 2 },
+		}, {
+			{ .csi = RVIN_CSI41, .chan = 1 },
+			{ .csi = RVIN_CSI20, .chan = 1 },
+			{ .csi = RVIN_CSI20, .chan = 1 },
+			{ .csi = RVIN_CSI41, .chan = 3 },
+			{ .csi = RVIN_CSI20, .chan = 3 },
+		},
+	},
+};
+
+static const struct rvin_info rcar_info_r8a7795es1 = {
+	.chip = RCAR_GEN3,
+	.use_mc = true,
+	.max_width = 4096,
+	.max_height = 4096,
+
+	.num_chsels = 6,
+	.chsels = {
+		{
+			{ .csi = RVIN_CSI40, .chan = 0 },
+			{ .csi = RVIN_CSI20, .chan = 0 },
+			{ .csi = RVIN_CSI21, .chan = 0 },
+			{ .csi = RVIN_CSI40, .chan = 0 },
+			{ .csi = RVIN_CSI20, .chan = 0 },
+			{ .csi = RVIN_CSI21, .chan = 0 },
+		}, {
+			{ .csi = RVIN_CSI20, .chan = 0 },
+			{ .csi = RVIN_CSI21, .chan = 0 },
+			{ .csi = RVIN_CSI40, .chan = 0 },
+			{ .csi = RVIN_CSI40, .chan = 1 },
+			{ .csi = RVIN_CSI20, .chan = 1 },
+			{ .csi = RVIN_CSI21, .chan = 1 },
+		}, {
+			{ .csi = RVIN_CSI21, .chan = 0 },
+			{ .csi = RVIN_CSI40, .chan = 0 },
+			{ .csi = RVIN_CSI20, .chan = 0 },
+			{ .csi = RVIN_CSI40, .chan = 2 },
+			{ .csi = RVIN_CSI20, .chan = 2 },
+			{ .csi = RVIN_CSI21, .chan = 2 },
+		}, {
+			{ .csi = RVIN_CSI40, .chan = 1 },
+			{ .csi = RVIN_CSI20, .chan = 1 },
+			{ .csi = RVIN_CSI21, .chan = 1 },
+			{ .csi = RVIN_CSI40, .chan = 3 },
+			{ .csi = RVIN_CSI20, .chan = 3 },
+			{ .csi = RVIN_CSI21, .chan = 3 },
+		}, {
+			{ .csi = RVIN_CSI41, .chan = 0 },
+			{ .csi = RVIN_CSI20, .chan = 0 },
+			{ .csi = RVIN_CSI21, .chan = 0 },
+			{ .csi = RVIN_CSI41, .chan = 0 },
+			{ .csi = RVIN_CSI20, .chan = 0 },
+			{ .csi = RVIN_CSI21, .chan = 0 },
+		}, {
+			{ .csi = RVIN_CSI20, .chan = 0 },
+			{ .csi = RVIN_CSI21, .chan = 0 },
+			{ .csi = RVIN_CSI41, .chan = 0 },
+			{ .csi = RVIN_CSI41, .chan = 1 },
+			{ .csi = RVIN_CSI20, .chan = 1 },
+			{ .csi = RVIN_CSI21, .chan = 1 },
+		}, {
+			{ .csi = RVIN_CSI21, .chan = 0 },
+			{ .csi = RVIN_CSI41, .chan = 0 },
+			{ .csi = RVIN_CSI20, .chan = 0 },
+			{ .csi = RVIN_CSI41, .chan = 2 },
+			{ .csi = RVIN_CSI20, .chan = 2 },
+			{ .csi = RVIN_CSI21, .chan = 2 },
+		}, {
+			{ .csi = RVIN_CSI41, .chan = 1 },
+			{ .csi = RVIN_CSI20, .chan = 1 },
+			{ .csi = RVIN_CSI21, .chan = 1 },
+			{ .csi = RVIN_CSI41, .chan = 3 },
+			{ .csi = RVIN_CSI20, .chan = 3 },
+			{ .csi = RVIN_CSI21, .chan = 3 },
+		},
+	},
+};
+
 static const struct of_device_id rvin_of_id_table[] = {
 	{
 		.compatible = "renesas,vin-r8a7778",
@@ -984,12 +1113,25 @@ static const struct of_device_id rvin_of_id_table[] = {
 		.compatible = "renesas,rcar-gen2-vin",
 		.data = &rcar_info_gen2,
 	},
+	{
+		.compatible = "renesas,vin-r8a7795",
+		.data = &rcar_info_r8a7795,
+	},
 	{ },
 };
 MODULE_DEVICE_TABLE(of, rvin_of_id_table);
 
+static const struct soc_device_attribute r8a7795es1[] = {
+	{
+		.soc_id = "r8a7795", .revision = "ES1.*",
+		.data = &rcar_info_r8a7795es1,
+	},
+	{ /* sentinel */ }
+};
+
 static int rcar_vin_probe(struct platform_device *pdev)
 {
+	const struct soc_device_attribute *attr;
 	struct rvin_dev *vin;
 	struct resource *mem;
 	int irq, ret;
@@ -1001,6 +1143,14 @@ static int rcar_vin_probe(struct platform_device *pdev)
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
2.15.0
