Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:52570 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307AbcBLCAh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Feb 2016 21:00:37 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH/RFC 5/9] v4l: vsp1: Add FCP support
Date: Fri, 12 Feb 2016 04:00:46 +0200
Message-Id: <1455242450-24493-6-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1455242450-24493-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1455242450-24493-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On some platforms the VSP performs memory accesses through an FCP. When
that's the case get a reference to the FCP from the VSP DT node and
enable/disable it at runtime as needed.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 .../devicetree/bindings/media/renesas,vsp1.txt     |  5 +++++
 drivers/media/platform/Kconfig                     |  1 +
 drivers/media/platform/vsp1/vsp1.h                 |  2 ++
 drivers/media/platform/vsp1/vsp1_drv.c             | 24 +++++++++++++++++++++-
 4 files changed, 31 insertions(+), 1 deletion(-)

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
index cbb4e5735bf8..b12502555544 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -272,6 +272,7 @@ config VIDEO_RENESAS_VSP1
 	tristate "Renesas VSP1 Video Processing Engine"
 	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API && HAS_DMA
 	depends on (ARCH_SHMOBILE && OF) || COMPILE_TEST
+	depends on m || VIDEO_RENESAS_FCP != m
 	select VIDEOBUF2_DMA_CONTIG
 	---help---
 	  This is a V4L2 driver for the Renesas VSP1 video processing engine.
diff --git a/drivers/media/platform/vsp1/vsp1.h b/drivers/media/platform/vsp1/vsp1.h
index 910d6b8e8b50..4316766c6489 100644
--- a/drivers/media/platform/vsp1/vsp1.h
+++ b/drivers/media/platform/vsp1/vsp1.h
@@ -25,6 +25,7 @@
 
 struct clk;
 struct device;
+struct rcar_fcp_device;
 
 struct vsp1_dl;
 struct vsp1_drm;
@@ -63,6 +64,7 @@ struct vsp1_device {
 
 	void __iomem *mmio;
 	struct clk *clock;
+	struct rcar_fcp_device *fcp;
 
 	struct mutex lock;
 	int ref_count;
diff --git a/drivers/media/platform/vsp1/vsp1_drv.c b/drivers/media/platform/vsp1/vsp1_drv.c
index da43e3f35610..f1b8343cc166 100644
--- a/drivers/media/platform/vsp1/vsp1_drv.c
+++ b/drivers/media/platform/vsp1/vsp1_drv.c
@@ -21,6 +21,7 @@
 #include <linux/platform_device.h>
 #include <linux/videodev2.h>
 
+#include <media/rcar-fcp.h>
 #include <media/v4l2-subdev.h>
 
 #include "vsp1.h"
@@ -491,8 +492,11 @@ int vsp1_device_get(struct vsp1_device *vsp1)
 	if (ret < 0)
 		goto done;
 
+	rcar_fcp_enable(vsp1->fcp);
+
 	ret = vsp1_device_init(vsp1);
 	if (ret < 0) {
+		rcar_fcp_disable(vsp1->fcp);
 		clk_disable_unprepare(vsp1->clock);
 		goto done;
 	}
@@ -515,8 +519,10 @@ void vsp1_device_put(struct vsp1_device *vsp1)
 {
 	mutex_lock(&vsp1->lock);
 
-	if (--vsp1->ref_count == 0)
+	if (--vsp1->ref_count == 0) {
+		rcar_fcp_disable(vsp1->fcp);
 		clk_disable_unprepare(vsp1->clock);
+	}
 
 	mutex_unlock(&vsp1->lock);
 }
@@ -537,6 +543,7 @@ static int vsp1_pm_suspend(struct device *dev)
 
 	vsp1_pipelines_suspend(vsp1);
 
+	rcar_fcp_disable(vsp1->fcp);
 	clk_disable_unprepare(vsp1->clock);
 
 	return 0;
@@ -552,6 +559,7 @@ static int vsp1_pm_resume(struct device *dev)
 		return 0;
 
 	clk_prepare_enable(vsp1->clock);
+	rcar_fcp_enable(vsp1->fcp);
 
 	vsp1_pipelines_resume(vsp1);
 
@@ -633,6 +641,7 @@ static const struct vsp1_device_info vsp1_device_infos[] = {
 static int vsp1_probe(struct platform_device *pdev)
 {
 	struct vsp1_device *vsp1;
+	struct device_node *fcp_node;
 	struct resource *irq;
 	struct resource *io;
 	unsigned int i;
@@ -673,6 +682,18 @@ static int vsp1_probe(struct platform_device *pdev)
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
 	ret = clk_prepare_enable(vsp1->clock);
 	if (ret < 0)
@@ -713,6 +734,7 @@ static int vsp1_remove(struct platform_device *pdev)
 	struct vsp1_device *vsp1 = platform_get_drvdata(pdev);
 
 	vsp1_destroy_entities(vsp1);
+	rcar_fcp_put(vsp1->fcp);
 
 	return 0;
 }
-- 
2.4.10

