Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:46755 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389Ab3BFFjK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Feb 2013 00:39:10 -0500
Received: by mail-pa0-f48.google.com with SMTP id hz10so588410pad.21
        for <linux-media@vger.kernel.org>; Tue, 05 Feb 2013 21:39:10 -0800 (PST)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	devicetree-discuss@lists.ozlabs.org
Cc: k.debski@samsung.com, sachin.kamat@linaro.org,
	inki.dae@samsung.com, s.nawrocki@samsung.com,
	kgene.kim@samsung.com, patches@linaro.org
Subject: [PATCH v2 1/2] [media] s5p-g2d: Add DT based discovery support
Date: Wed,  6 Feb 2013 10:59:43 +0530
Message-Id: <1360128584-23167-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds device tree based discovery support to G2D driver

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
Based on for_v3.9 branch of below tree:
git://linuxtv.org/snawrocki/samsung.git

Changes since v1:
* Addressed review comments from Sylwester <s.nawrocki@samsung.com>.
* Modified the compatible string as per the discussions at [1].
[1] https://patchwork1.kernel.org/patch/2045821/
---
 drivers/media/platform/s5p-g2d/g2d.c |   31 +++++++++++++++++++++++++++++--
 1 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/s5p-g2d/g2d.c b/drivers/media/platform/s5p-g2d/g2d.c
index 7e41529..6923be2 100644
--- a/drivers/media/platform/s5p-g2d/g2d.c
+++ b/drivers/media/platform/s5p-g2d/g2d.c
@@ -18,6 +18,7 @@
 #include <linux/slab.h>
 #include <linux/clk.h>
 #include <linux/interrupt.h>
+#include <linux/of.h>
 
 #include <linux/platform_device.h>
 #include <media/v4l2-mem2mem.h>
@@ -695,11 +696,14 @@ static struct v4l2_m2m_ops g2d_m2m_ops = {
 	.unlock		= g2d_unlock,
 };
 
+static const struct of_device_id exynos_g2d_match[];
+
 static int g2d_probe(struct platform_device *pdev)
 {
 	struct g2d_dev *dev;
 	struct video_device *vfd;
 	struct resource *res;
+	const struct of_device_id *of_id;
 	int ret = 0;
 
 	dev = devm_kzalloc(&pdev->dev, sizeof(*dev), GFP_KERNEL);
@@ -796,7 +800,17 @@ static int g2d_probe(struct platform_device *pdev)
 	}
 
 	def_frame.stride = (def_frame.width * def_frame.fmt->depth) >> 3;
-	dev->variant = g2d_get_drv_data(pdev);
+
+	if (!pdev->dev.of_node) {
+		dev->variant = g2d_get_drv_data(pdev);
+	} else {
+		of_id = of_match_node(exynos_g2d_match, pdev->dev.of_node);
+		if (!of_id) {
+			ret = -ENODEV;
+			goto unreg_video_dev;
+		}
+		dev->variant = (struct g2d_variant *)of_id->data;
+	}
 
 	return 0;
 
@@ -837,13 +851,25 @@ static int g2d_remove(struct platform_device *pdev)
 }
 
 static struct g2d_variant g2d_drvdata_v3x = {
-	.hw_rev = TYPE_G2D_3X,
+	.hw_rev = TYPE_G2D_3X, /* Revision 3.0 for S5PV210 and Exynos4210 */
 };
 
 static struct g2d_variant g2d_drvdata_v4x = {
 	.hw_rev = TYPE_G2D_4X, /* Revision 4.1 for Exynos4X12 and Exynos5 */
 };
 
+static const struct of_device_id exynos_g2d_match[] = {
+	{
+		.compatible = "samsung,s5pv210-g2d",
+		.data = &g2d_drvdata_v3x,
+	}, {
+		.compatible = "samsung,exynos4212-g2d",
+		.data = &g2d_drvdata_v4x,
+	},
+	{},
+};
+MODULE_DEVICE_TABLE(of, exynos_g2d_match);
+
 static struct platform_device_id g2d_driver_ids[] = {
 	{
 		.name = "s5p-g2d",
@@ -863,6 +889,7 @@ static struct platform_driver g2d_pdrv = {
 	.driver		= {
 		.name = G2D_NAME,
 		.owner = THIS_MODULE,
+		.of_match_table = exynos_g2d_match,
 	},
 };
 
-- 
1.7.4.1

