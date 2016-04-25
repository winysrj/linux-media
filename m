Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:37359 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965160AbcDYVgY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Apr 2016 17:36:24 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH v2 05/13] v4l: vsp1: Add FCP support
Date: Tue, 26 Apr 2016 00:36:30 +0300
Message-Id: <1461620198-13428-6-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1461620198-13428-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1461620198-13428-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On some platforms the VSP performs memory accesses through an FCP. When
that's the case get a reference to the FCP from the VSP DT node and
enable/disable it at runtime as needed.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 .../devicetree/bindings/media/renesas,vsp1.txt      |  5 +++++
 drivers/media/platform/Kconfig                      |  1 +
 drivers/media/platform/vsp1/vsp1.h                  |  2 ++
 drivers/media/platform/vsp1/vsp1_drv.c              | 21 ++++++++++++++++++++-
 4 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/media/renesas,vsp1.txt b/Documentation/devicetree/bindings/media/renesas,vsp1.txt
index 627405abd144..9b695bcbf219 100644
--- a/Documentation/devicetree/bindings/media/renesas,vsp1.txt
+++ b/Documentation/devicetree/bindings/media/renesas,vsp1.txt
@@ -14,6 +14,11 @@ Required properties:
   - interrupts: VSP interrupt specifier.
   - clocks: A phandle + clock-specifier pair for the VSP functional clock.
 
+Optional properties:
+
+  - renesas,fcp: A phandle referencing the FCP that handles memory accesses
+                 for the VSP. Not needed on Gen2, mandatory on Gen3.
+
 
 Example: R8A7790 (R-Car H2) VSP1-S node
 
diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index f453910050be..a3304466e628 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -264,6 +264,7 @@ config VIDEO_RENESAS_VSP1
 	tristate "Renesas VSP1 Video Processing Engine"
 	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API && HAS_DMA
 	depends on (ARCH_RENESAS && OF) || COMPILE_TEST
+	depends on !ARM64 || VIDEO_RENESAS_FCP
 	select VIDEOBUF2_DMA_CONTIG
 	---help---
 	  This is a V4L2 driver for the Renesas VSP1 video processing engine.
diff --git a/drivers/media/platform/vsp1/vsp1.h b/drivers/media/platform/vsp1/vsp1.h
index 37cc05e34de0..7cb0f5e428df 100644
--- a/drivers/media/platform/vsp1/vsp1.h
+++ b/drivers/media/platform/vsp1/vsp1.h
@@ -25,6 +25,7 @@
 
 struct clk;
 struct device;
+struct rcar_fcp_device;
 
 struct vsp1_drm;
 struct vsp1_entity;
@@ -62,6 +63,7 @@ struct vsp1_device {
 	const struct vsp1_device_info *info;
 
 	void __iomem *mmio;
+	struct rcar_fcp_device *fcp;
 
 	struct vsp1_bru *bru;
 	struct vsp1_hsit *hsi;
diff --git a/drivers/media/platform/vsp1/vsp1_drv.c b/drivers/media/platform/vsp1/vsp1_drv.c
index 13907d4f08af..e655639af7e2 100644
--- a/drivers/media/platform/vsp1/vsp1_drv.c
+++ b/drivers/media/platform/vsp1/vsp1_drv.c
@@ -22,6 +22,7 @@
 #include <linux/pm_runtime.h>
 #include <linux/videodev2.h>
 
+#include <media/rcar-fcp.h>
 #include <media/v4l2-subdev.h>
 
 #include "vsp1.h"
@@ -514,6 +515,10 @@ static int vsp1_pm_resume(struct device *dev)
 
 static int vsp1_pm_runtime_suspend(struct device *dev)
 {
+	struct vsp1_device *vsp1 = dev_get_drvdata(dev);
+
+	rcar_fcp_disable(vsp1->fcp);
+
 	return 0;
 }
 
@@ -528,7 +533,7 @@ static int vsp1_pm_runtime_resume(struct device *dev)
 			return ret;
 	}
 
-	return 0;
+	return rcar_fcp_enable(vsp1->fcp);
 }
 
 static const struct dev_pm_ops vsp1_pm_ops = {
@@ -614,6 +619,7 @@ static const struct vsp1_device_info vsp1_device_infos[] = {
 static int vsp1_probe(struct platform_device *pdev)
 {
 	struct vsp1_device *vsp1;
+	struct device_node *fcp_node;
 	struct resource *irq;
 	struct resource *io;
 	unsigned int i;
@@ -649,6 +655,18 @@ static int vsp1_probe(struct platform_device *pdev)
 		return ret;
 	}
 
+	/* FCP (optional) */
+	fcp_node = of_parse_phandle(pdev->dev.of_node, "renesas,fcp", 0);
+	if (fcp_node) {
+		vsp1->fcp = rcar_fcp_get(fcp_node);
+		of_node_put(fcp_node);
+		if (IS_ERR(vsp1->fcp)) {
+			dev_dbg(&pdev->dev, "FCP not found (%ld)\n",
+				PTR_ERR(vsp1->fcp));
+			return PTR_ERR(vsp1->fcp);
+		}
+	}
+
 	/* Configure device parameters based on the version register. */
 	pm_runtime_enable(&pdev->dev);
 
@@ -694,6 +712,7 @@ static int vsp1_remove(struct platform_device *pdev)
 	struct vsp1_device *vsp1 = platform_get_drvdata(pdev);
 
 	vsp1_destroy_entities(vsp1);
+	rcar_fcp_put(vsp1->fcp);
 
 	pm_runtime_disable(&pdev->dev);
 
-- 
2.7.3

