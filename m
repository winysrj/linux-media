Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:42997 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750851AbcLHPZc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 8 Dec 2016 10:25:32 -0500
From: Michael Tretter <m.tretter@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: p.zabel@pengutronix.de, Michael Tretter <m.tretter@pengutronix.de>
Subject: [PATCH 5/9] [media] coda: get VDOA device using dt phandle
Date: Thu,  8 Dec 2016 16:24:12 +0100
Message-Id: <20161208152416.16031-5-m.tretter@pengutronix.de>
In-Reply-To: <20161208152416.16031-1-m.tretter@pengutronix.de>
References: <20161208152416.16031-1-m.tretter@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Michael Tretter <m.tretter@pengutronix.de>
---
 drivers/media/platform/coda/coda-common.c | 43 +++++++++++++++++++++++++++++++
 drivers/media/platform/coda/coda.h        |  1 +
 2 files changed, 44 insertions(+)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index e0184194..1adb6f3 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -41,6 +41,7 @@
 #include <media/videobuf2-vmalloc.h>
 
 #include "coda.h"
+#include "imx-vdoa.h"
 
 #define CODA_NAME		"coda"
 
@@ -66,6 +67,10 @@ static int disable_tiling;
 module_param(disable_tiling, int, 0644);
 MODULE_PARM_DESC(disable_tiling, "Disable tiled frame buffers");
 
+static int disable_vdoa;
+module_param(disable_vdoa, int, 0644);
+MODULE_PARM_DESC(disable_vdoa, "Disable Video Data Order Adapter tiled to raster-scan conversion");
+
 void coda_write(struct coda_dev *dev, u32 data, u32 reg)
 {
 	v4l2_dbg(2, coda_debug, &dev->v4l2_dev,
@@ -325,6 +330,34 @@ const char *coda_product_name(int product)
 	}
 }
 
+static struct vdoa_data *coda_get_vdoa_data(struct device_node *np,
+					    const char *name)
+{
+	struct device_node *vdoa_node;
+	struct platform_device *vdoa_pdev;
+	struct vdoa_data *vdoa_data;
+
+	vdoa_node = of_parse_phandle(np, name, 0);
+	if (!vdoa_node)
+		return NULL;
+
+	vdoa_pdev = of_find_device_by_node(vdoa_node);
+	if (!vdoa_pdev) {
+		vdoa_data = NULL;
+		goto out;
+	}
+
+	vdoa_data = platform_get_drvdata(vdoa_pdev);
+	if (!vdoa_data)
+		vdoa_data = ERR_PTR(-EPROBE_DEFER);
+
+out:
+	if (vdoa_node)
+		of_node_put(vdoa_node);
+
+	return vdoa_data;
+}
+
 /*
  * V4L2 ioctl() operations.
  */
@@ -2256,6 +2289,16 @@ static int coda_probe(struct platform_device *pdev)
 	}
 	dev->iram_pool = pool;
 
+	/* Get VDOA from device tree if available */
+	if (!disable_tiling && !disable_vdoa) {
+		dev->vdoa = coda_get_vdoa_data(np, "vdoa");
+		if (PTR_ERR(dev->vdoa) == -EPROBE_DEFER)
+			return -EPROBE_DEFER;
+		if (!dev->vdoa)
+			dev_info(&pdev->dev,
+				 "vdoa not available; not using tiled intermediate format");
+	}
+
 	ret = v4l2_device_register(&pdev->dev, &dev->v4l2_dev);
 	if (ret)
 		return ret;
diff --git a/drivers/media/platform/coda/coda.h b/drivers/media/platform/coda/coda.h
index 53f9666..ae202dc 100644
--- a/drivers/media/platform/coda/coda.h
+++ b/drivers/media/platform/coda/coda.h
@@ -75,6 +75,7 @@ struct coda_dev {
 	struct platform_device	*plat_dev;
 	const struct coda_devtype *devtype;
 	int			firmware;
+	struct vdoa_data	*vdoa;
 
 	void __iomem		*regs_base;
 	struct clk		*clk_per;
-- 
2.10.2

