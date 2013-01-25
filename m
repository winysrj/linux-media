Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:60754 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755909Ab3AYKEU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Jan 2013 05:04:20 -0500
Received: by mail-pa0-f54.google.com with SMTP id bi5so175707pad.41
        for <linux-media@vger.kernel.org>; Fri, 25 Jan 2013 02:04:19 -0800 (PST)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	devicetree-discuss@lists.ozlabs.org
Cc: k.debski@samsung.com, inki.dae@samsung.com,
	sachin.kamat@linaro.org, ajaykumar.rs@samsung.com,
	patches@linaro.org, s.nawrocki@samsung.com
Subject: [PATCH 2/2] drm/exynos: Add device tree based discovery support for G2D
Date: Fri, 25 Jan 2013 15:25:22 +0530
Message-Id: <1359107722-9974-2-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1359107722-9974-1-git-send-email-sachin.kamat@linaro.org>
References: <1359107722-9974-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Ajay Kumar <ajaykumar.rs@samsung.com>

This patch adds device tree match table for Exynos G2D controller.

Signed-off-by: Ajay Kumar <ajaykumar.rs@samsung.com>
Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/gpu/drm/exynos/exynos_drm_g2d.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_g2d.c b/drivers/gpu/drm/exynos/exynos_drm_g2d.c
index ddcfb5d..d24b170 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_g2d.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_g2d.c
@@ -19,6 +19,7 @@
 #include <linux/workqueue.h>
 #include <linux/dma-mapping.h>
 #include <linux/dma-attrs.h>
+#include <linux/of.h>
 
 #include <drm/drmP.h>
 #include <drm/exynos_drm.h>
@@ -1240,6 +1241,14 @@ static int g2d_resume(struct device *dev)
 
 static SIMPLE_DEV_PM_OPS(g2d_pm_ops, g2d_suspend, g2d_resume);
 
+#ifdef CONFIG_OF
+static const struct of_device_id exynos_g2d_match[] = {
+	{ .compatible = "samsung,g2d-v41" },
+	{},
+};
+MODULE_DEVICE_TABLE(of, exynos_g2d_match);
+#endif
+
 struct platform_driver g2d_driver = {
 	.probe		= g2d_probe,
 	.remove		= g2d_remove,
@@ -1247,5 +1256,6 @@ struct platform_driver g2d_driver = {
 		.name	= "s5p-g2d",
 		.owner	= THIS_MODULE,
 		.pm	= &g2d_pm_ops,
+		.of_match_table = of_match_ptr(exynos_g2d_match),
 	},
 };
-- 
1.7.4.1

