Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-da0-f52.google.com ([209.85.210.52]:42408 "EHLO
	mail-da0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756526Ab3BAMAA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Feb 2013 07:00:00 -0500
Received: by mail-da0-f52.google.com with SMTP id f10so1714076dak.25
        for <linux-media@vger.kernel.org>; Fri, 01 Feb 2013 04:00:00 -0800 (PST)
From: Vikas Sajjan <vikas.sajjan@linaro.org>
To: dri-devel@lists.freedesktop.org
Cc: linux-media@vger.kernel.org, kgene.kim@samsung.com,
	s.trumtrar@pengutronix.de, inki.dae@samsung.com,
	l.krishna@samsung.com
Subject: [PATCH v3 1/1] video: drm: exynos: Adds display-timing node parsing using video helper function
Date: Fri,  1 Feb 2013 17:29:49 +0530
Message-Id: <1359719989-29628-2-git-send-email-vikas.sajjan@linaro.org>
In-Reply-To: <1359719989-29628-1-git-send-email-vikas.sajjan@linaro.org>
References: <1359719989-29628-1-git-send-email-vikas.sajjan@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds display-timing node parsing using video helper function

Signed-off-by: Leela Krishna Amudala <l.krishna@samsung.com>
Signed-off-by: Vikas Sajjan <vikas.sajjan@linaro.org>
---
 drivers/gpu/drm/exynos/exynos_drm_fimd.c |   39 +++++++++++++++++++++++++++---
 1 file changed, 35 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_fimd.c b/drivers/gpu/drm/exynos/exynos_drm_fimd.c
index bf0d9ba..8eee13f 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_fimd.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_fimd.c
@@ -19,6 +19,7 @@
 #include <linux/clk.h>
 #include <linux/of_device.h>
 #include <linux/pm_runtime.h>
+#include <linux/pinctrl/consumer.h>
 
 #include <video/samsung_fimd.h>
 #include <drm/exynos_drm.h>
@@ -905,16 +906,46 @@ static int __devinit fimd_probe(struct platform_device *pdev)
 	struct exynos_drm_subdrv *subdrv;
 	struct exynos_drm_fimd_pdata *pdata;
 	struct exynos_drm_panel_info *panel;
+	struct fb_videomode *fbmode;
+	struct pinctrl *pctrl;
 	struct resource *res;
 	int win;
 	int ret = -EINVAL;
 
 	DRM_DEBUG_KMS("%s\n", __FILE__);
 
-	pdata = pdev->dev.platform_data;
-	if (!pdata) {
-		dev_err(dev, "no platform data specified\n");
-		return -EINVAL;
+	if (pdev->dev.of_node) {
+		pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
+		if (!pdata) {
+			DRM_ERROR("memory allocation for pdata failed\n");
+			return -ENOMEM;
+		}
+
+		fbmode = devm_kzalloc(dev, sizeof(*fbmode), GFP_KERNEL);
+		if (!fbmode) {
+			DRM_ERROR("memory allocation for fbmode failed\n");
+			return -ENOMEM;
+		}
+
+		ret = of_get_fb_videomode(dev->of_node, fbmode, -1);
+		if (ret) {
+			DRM_ERROR("failed to get fb_videomode\n");
+			return -EINVAL;
+		}
+		pdata->panel.timing = (struct fb_videomode) *fbmode;
+
+		pctrl = devm_pinctrl_get_select_default(dev);
+		if (IS_ERR(pctrl)) {
+			DRM_ERROR("no pinctrl data provided.\n");
+			return -EINVAL;
+		}
+
+	} else {
+		pdata = pdev->dev.platform_data;
+		if (!pdata) {
+			DRM_ERROR("no platform data specified\n");
+			return -EINVAL;
+		}
 	}
 
 	panel = &pdata->panel;
-- 
1.7.9.5

