Return-path: <linux-media-owner@vger.kernel.org>
Received: from baptiste.telenet-ops.be ([195.130.132.51]:33842 "EHLO
	baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753848AbbJGKjk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Oct 2015 06:39:40 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org,
	Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH v2 2/2] [media] rcar_vin: Remove obsolete platform data support
Date: Wed,  7 Oct 2015 12:39:36 +0200
Message-Id: <1444214376-26931-3-git-send-email-geert+renesas@glider.be>
In-Reply-To: <1444214376-26931-1-git-send-email-geert+renesas@glider.be>
References: <1444214376-26931-1-git-send-email-geert+renesas@glider.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since commit 3d7608e4c169af03 ("ARM: shmobile: bockw: remove legacy
board file and config"), Renesas R-Car SoCs are only supported in
generic DT-only ARM multi-platform builds.  The driver doesn't need to
use platform data anymore, hence remove platform data configuration.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
Commit 3d7608e4c169af03 is now in arm-soc/for-next.

v2:
  - New.

---
 drivers/media/platform/soc_camera/rcar_vin.c | 75 +++++++++++-----------------
 include/linux/platform_data/camera-rcar.h    | 25 ----------
 2 files changed, 29 insertions(+), 71 deletions(-)
 delete mode 100644 include/linux/platform_data/camera-rcar.h

diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
index 4069587ae8b6..493566de4f4b 100644
--- a/drivers/media/platform/soc_camera/rcar_vin.c
+++ b/drivers/media/platform/soc_camera/rcar_vin.c
@@ -21,7 +21,6 @@
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
-#include <linux/platform_data/camera-rcar.h>
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
 #include <linux/slab.h>
@@ -138,6 +137,11 @@
 
 #define TIMEOUT_MS		100
 
+#define RCAR_VIN_HSYNC_ACTIVE_LOW	(1 << 0)
+#define RCAR_VIN_VSYNC_ACTIVE_LOW	(1 << 1)
+#define RCAR_VIN_BT601			(1 << 2)
+#define RCAR_VIN_BT656			(1 << 3)
+
 enum chip_id {
 	RCAR_GEN2,
 	RCAR_H1,
@@ -1845,63 +1849,43 @@ static const struct of_device_id rcar_vin_of_table[] = {
 MODULE_DEVICE_TABLE(of, rcar_vin_of_table);
 #endif
 
-static struct platform_device_id rcar_vin_id_table[] = {
-	{ "r8a7779-vin",  RCAR_H1 },
-	{ "r8a7778-vin",  RCAR_M1 },
-	{ "uPD35004-vin", RCAR_E1 },
-	{},
-};
-MODULE_DEVICE_TABLE(platform, rcar_vin_id_table);
-
 static int rcar_vin_probe(struct platform_device *pdev)
 {
 	const struct of_device_id *match = NULL;
 	struct rcar_vin_priv *priv;
+	struct v4l2_of_endpoint ep;
+	struct device_node *np;
 	struct resource *mem;
-	struct rcar_vin_platform_data *pdata;
 	unsigned int pdata_flags;
 	int irq, ret;
 
-	if (pdev->dev.of_node) {
-		struct v4l2_of_endpoint ep;
-		struct device_node *np;
+	match = of_match_device(of_match_ptr(rcar_vin_of_table), &pdev->dev);
 
-		match = of_match_device(of_match_ptr(rcar_vin_of_table),
-					&pdev->dev);
-
-		np = of_graph_get_next_endpoint(pdev->dev.of_node, NULL);
-		if (!np) {
-			dev_err(&pdev->dev, "could not find endpoint\n");
-			return -EINVAL;
-		}
+	np = of_graph_get_next_endpoint(pdev->dev.of_node, NULL);
+	if (!np) {
+		dev_err(&pdev->dev, "could not find endpoint\n");
+		return -EINVAL;
+	}
 
-		ret = v4l2_of_parse_endpoint(np, &ep);
-		if (ret) {
-			dev_err(&pdev->dev, "could not parse endpoint\n");
-			return ret;
-		}
+	ret = v4l2_of_parse_endpoint(np, &ep);
+	if (ret) {
+		dev_err(&pdev->dev, "could not parse endpoint\n");
+		return ret;
+	}
 
-		if (ep.bus_type == V4L2_MBUS_BT656)
-			pdata_flags = RCAR_VIN_BT656;
-		else {
-			pdata_flags = 0;
-			if (ep.bus.parallel.flags & V4L2_MBUS_HSYNC_ACTIVE_LOW)
-				pdata_flags |= RCAR_VIN_HSYNC_ACTIVE_LOW;
-			if (ep.bus.parallel.flags & V4L2_MBUS_VSYNC_ACTIVE_LOW)
-				pdata_flags |= RCAR_VIN_VSYNC_ACTIVE_LOW;
-		}
+	if (ep.bus_type == V4L2_MBUS_BT656)
+		pdata_flags = RCAR_VIN_BT656;
+	else {
+		pdata_flags = 0;
+		if (ep.bus.parallel.flags & V4L2_MBUS_HSYNC_ACTIVE_LOW)
+			pdata_flags |= RCAR_VIN_HSYNC_ACTIVE_LOW;
+		if (ep.bus.parallel.flags & V4L2_MBUS_VSYNC_ACTIVE_LOW)
+			pdata_flags |= RCAR_VIN_VSYNC_ACTIVE_LOW;
+	}
 
-		of_node_put(np);
+	of_node_put(np);
 
-		dev_dbg(&pdev->dev, "pdata_flags = %08x\n", pdata_flags);
-	} else {
-		pdata = pdev->dev.platform_data;
-		if (!pdata || !pdata->flags) {
-			dev_err(&pdev->dev, "platform data not set\n");
-			return -EINVAL;
-		}
-		pdata_flags = pdata->flags;
-	}
+	dev_dbg(&pdev->dev, "pdata_flags = %08x\n", pdata_flags);
 
 	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (mem == NULL)
@@ -1984,7 +1968,6 @@ static struct platform_driver rcar_vin_driver = {
 		.name		= DRV_NAME,
 		.of_match_table	= of_match_ptr(rcar_vin_of_table),
 	},
-	.id_table	= rcar_vin_id_table,
 };
 
 module_platform_driver(rcar_vin_driver);
diff --git a/include/linux/platform_data/camera-rcar.h b/include/linux/platform_data/camera-rcar.h
deleted file mode 100644
index dfc83c581593..000000000000
--- a/include/linux/platform_data/camera-rcar.h
+++ /dev/null
@@ -1,25 +0,0 @@
-/*
- * Platform data for Renesas R-Car VIN soc-camera driver
- *
- * Copyright (C) 2011-2013 Renesas Solutions Corp.
- * Copyright (C) 2013 Cogent Embedded, Inc., <source@cogentembedded.com>
- *
- * This program is free software; you can redistribute  it and/or modify it
- * under  the terms of  the GNU General  Public License as published by the
- * Free Software Foundation;  either version 2 of the  License, or (at your
- * option) any later version.
- */
-
-#ifndef __CAMERA_RCAR_H_
-#define __CAMERA_RCAR_H_
-
-#define RCAR_VIN_HSYNC_ACTIVE_LOW	(1 << 0)
-#define RCAR_VIN_VSYNC_ACTIVE_LOW	(1 << 1)
-#define RCAR_VIN_BT601			(1 << 2)
-#define RCAR_VIN_BT656			(1 << 3)
-
-struct rcar_vin_platform_data {
-	unsigned int flags;
-};
-
-#endif /* __CAMERA_RCAR_H_ */
-- 
1.9.1

