Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:34830 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753317Ab3A3GbB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Jan 2013 01:31:01 -0500
Received: by mail-pa0-f46.google.com with SMTP id kp14so890018pab.19
        for <linux-media@vger.kernel.org>; Tue, 29 Jan 2013 22:31:00 -0800 (PST)
From: Vikas Sajjan <vikas.sajjan@linaro.org>
To: dri-devel@lists.freedesktop.org
Cc: linux-media@vger.kernel.org, kgene.kim@samsung.com,
	s.trumtrar@pengutronix.de, inki.dae@samsung.com,
	l.krishna@samsung.com
Subject: [PATCH v2 1/1] video: drm: exynos: Adds display-timing node parsing using video helper function
Date: Wed, 30 Jan 2013 12:00:49 +0530
Message-Id: <1359527449-5174-2-git-send-email-vikas.sajjan@linaro.org>
In-Reply-To: <1359527449-5174-1-git-send-email-vikas.sajjan@linaro.org>
References: <1359527449-5174-1-git-send-email-vikas.sajjan@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds display-timing node parsing using video helper function

Signed-off-by: Leela Krishna Amudala <l.krishna@samsung.com>
Signed-off-by: Vikas Sajjan <vikas.sajjan@linaro.org>
---
 drivers/gpu/drm/exynos/exynos_drm_fimd.c |   38 +++++++++++++++++++++++++++---
 1 file changed, 35 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_fimd.c b/drivers/gpu/drm/exynos/exynos_drm_fimd.c
index bf0d9ba..94729ed 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_fimd.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_fimd.c
@@ -19,6 +19,7 @@
 #include <linux/clk.h>
 #include <linux/of_device.h>
 #include <linux/pm_runtime.h>
+#include <linux/pinctrl/consumer.h>
 
 #include <video/samsung_fimd.h>
 #include <drm/exynos_drm.h>
@@ -905,15 +906,46 @@ static int __devinit fimd_probe(struct platform_device *pdev)
 	struct exynos_drm_subdrv *subdrv;
 	struct exynos_drm_fimd_pdata *pdata;
 	struct exynos_drm_panel_info *panel;
+	struct fb_videomode *fbmode;
+	struct device *disp_dev = &pdev->dev;
+	struct pinctrl *pctrl;
 	struct resource *res;
 	int win;
 	int ret = -EINVAL;
 
 	DRM_DEBUG_KMS("%s\n", __FILE__);
 
-	pdata = pdev->dev.platform_data;
-	if (!pdata) {
-		dev_err(dev, "no platform data specified\n");
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
+		ret = of_get_fb_videomode(disp_dev->of_node, fbmode, -1);
+		if (ret) {
+			DRM_ERROR("failed to get fb_videomode\n");
+			return -EINVAL;
+		}
+		pdata->panel.timing = (struct fb_videomode) *fbmode;
+
+	} else {
+		pdata = pdev->dev.platform_data;
+		if (!pdata) {
+			DRM_ERROR("no platform data specified\n");
+			return -EINVAL;
+		}
+	}
+
+	pctrl = devm_pinctrl_get_select_default(dev);
+	if (IS_ERR(pctrl)) {
+		DRM_ERROR("no pinctrl data provided.\n");
 		return -EINVAL;
 	}
 
-- 
1.7.9.5

