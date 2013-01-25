Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f45.google.com ([209.85.160.45]:49063 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754902Ab3AYKEQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Jan 2013 05:04:16 -0500
Received: by mail-pb0-f45.google.com with SMTP id rq13so127905pbb.32
        for <linux-media@vger.kernel.org>; Fri, 25 Jan 2013 02:04:15 -0800 (PST)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	devicetree-discuss@lists.ozlabs.org
Cc: k.debski@samsung.com, inki.dae@samsung.com,
	sachin.kamat@linaro.org, ajaykumar.rs@samsung.com,
	patches@linaro.org, s.nawrocki@samsung.com
Subject: [PATCH 1/2] [media] s5p-g2d: Add DT based discovery support
Date: Fri, 25 Jan 2013 15:25:21 +0530
Message-Id: <1359107722-9974-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds device tree based discovery support to G2D driver

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/platform/s5p-g2d/g2d.c |   17 ++++++++++++++++-
 1 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/drivers/media/platform/s5p-g2d/g2d.c b/drivers/media/platform/s5p-g2d/g2d.c
index 7e41529..210e142 100644
--- a/drivers/media/platform/s5p-g2d/g2d.c
+++ b/drivers/media/platform/s5p-g2d/g2d.c
@@ -18,6 +18,7 @@
 #include <linux/slab.h>
 #include <linux/clk.h>
 #include <linux/interrupt.h>
+#include <linux/of.h>
 
 #include <linux/platform_device.h>
 #include <media/v4l2-mem2mem.h>
@@ -796,7 +797,8 @@ static int g2d_probe(struct platform_device *pdev)
 	}
 
 	def_frame.stride = (def_frame.width * def_frame.fmt->depth) >> 3;
-	dev->variant = g2d_get_drv_data(pdev);
+	if (!pdev->dev.of_node)
+		dev->variant = g2d_get_drv_data(pdev);
 
 	return 0;
 
@@ -844,6 +846,18 @@ static struct g2d_variant g2d_drvdata_v4x = {
 	.hw_rev = TYPE_G2D_4X, /* Revision 4.1 for Exynos4X12 and Exynos5 */
 };
 
+static const struct of_device_id exynos_g2d_match[] = {
+	{
+		.compatible = "samsung,g2d-v3",
+		.data = &g2d_drvdata_v3x,
+	}, {
+		.compatible = "samsung,g2d-v41",
+		.data = &g2d_drvdata_v4x,
+	},
+	{},
+};
+MODULE_DEVICE_TABLE(of, exynos_g2d_match);
+
 static struct platform_device_id g2d_driver_ids[] = {
 	{
 		.name = "s5p-g2d",
@@ -863,6 +877,7 @@ static struct platform_driver g2d_pdrv = {
 	.driver		= {
 		.name = G2D_NAME,
 		.owner = THIS_MODULE,
+		.of_match_table = of_match_ptr(exynos_g2d_match),
 	},
 };
 
-- 
1.7.4.1

