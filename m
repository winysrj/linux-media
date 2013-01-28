Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:42487 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436Ab3A1Fps (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Jan 2013 00:45:48 -0500
Received: by mail-pa0-f42.google.com with SMTP id rl6so1310247pac.15
        for <linux-media@vger.kernel.org>; Sun, 27 Jan 2013 21:45:48 -0800 (PST)
From: Vikas Sajjan <vikas.sajjan@linaro.org>
To: dri-devel@lists.freedesktop.org
Cc: linux-media@vger.kernel.org, kgene.kim@samsung.com,
	s.trumtrar@pengutronix.de, inki.dae@samsung.com,
	l.krishna@samsung.com
Subject: [PATCH] video: drm: exynos: Adds display-timing node parsing using video helper function
Date: Mon, 28 Jan 2013 11:15:36 +0530
Message-Id: <1359351936-20618-2-git-send-email-vikas.sajjan@linaro.org>
In-Reply-To: <1359351936-20618-1-git-send-email-vikas.sajjan@linaro.org>
References: <1359351936-20618-1-git-send-email-vikas.sajjan@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds display-timing node parsing using video helper function

Signed-off-by: Leela Krishna Amudala <l.krishna@samsung.com>
Signed-off-by: Vikas Sajjan <vikas.sajjan@linaro.org>
---
 drivers/gpu/drm/exynos/exynos_drm_fimd.c |   35 ++++++++++++++++++++++++++++--
 1 file changed, 33 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_fimd.c b/drivers/gpu/drm/exynos/exynos_drm_fimd.c
index bf0d9ba..975e7f7 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_fimd.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_fimd.c
@@ -19,6 +19,7 @@
 #include <linux/clk.h>
 #include <linux/of_device.h>
 #include <linux/pm_runtime.h>
+#include <linux/pinctrl/consumer.h>
 
 #include <video/samsung_fimd.h>
 #include <drm/exynos_drm.h>
@@ -903,21 +904,51 @@ static int __devinit fimd_probe(struct platform_device *pdev)
 	struct device *dev = &pdev->dev;
 	struct fimd_context *ctx;
 	struct exynos_drm_subdrv *subdrv;
-	struct exynos_drm_fimd_pdata *pdata;
+	struct exynos_drm_fimd_pdata *pdata = pdev->dev.platform_data;
 	struct exynos_drm_panel_info *panel;
+	struct fb_videomode *fbmode;
+	struct device *disp_dev = &pdev->dev;
+	struct pinctrl *pctrl;
 	struct resource *res;
 	int win;
 	int ret = -EINVAL;
 
 	DRM_DEBUG_KMS("%s\n", __FILE__);
 
-	pdata = pdev->dev.platform_data;
+	if (pdev->dev.of_node) {
+		pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
+		if (!pdata) {
+			dev_err(dev, "memory allocation for pdata failed\n");
+			return -ENOMEM;
+		}
+
+		fbmode = devm_kzalloc(dev, sizeof(*fbmode), GFP_KERNEL);
+		if (!fbmode) {
+			dev_err(dev, "memory allocation for fbmode failed\n");
+			return -ENOMEM;
+		}
+
+		ret = of_get_fb_videomode(disp_dev->of_node, fbmode, -1);
+		if (ret) {
+			dev_err(dev, "failed to get fb_videomode\n");
+			return -EINVAL;
+		}
+		pdata->panel.timing = (struct fb_videomode) *fbmode;
+	}
+
 	if (!pdata) {
 		dev_err(dev, "no platform data specified\n");
 		return -EINVAL;
 	}
 
+	pctrl = devm_pinctrl_get_select_default(dev);
+	if (IS_ERR(pctrl)) {
+		dev_err(dev, "no pinctrl data provided.\n");
+		return -EINVAL;
+	}
+
 	panel = &pdata->panel;
+
 	if (!panel) {
 		dev_err(dev, "panel is null.\n");
 		return -EINVAL;
-- 
1.7.9.5

