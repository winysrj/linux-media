Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:41789 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161118Ab3BOGnW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Feb 2013 01:43:22 -0500
Received: by mail-pa0-f54.google.com with SMTP id fa10so1639222pad.27
        for <linux-media@vger.kernel.org>; Thu, 14 Feb 2013 22:43:22 -0800 (PST)
From: Vikas Sajjan <vikas.sajjan@linaro.org>
To: dri-devel@lists.freedesktop.org
Cc: linux-media@vger.kernel.org, kgene.kim@samsung.com,
	inki.dae@samsung.com, l.krishna@samsung.com, patches@linaro.org
Subject: [PATCH v6 1/1] video: drm: exynos: Add display-timing node parsing using video helper function
Date: Fri, 15 Feb 2013 12:13:07 +0530
Message-Id: <1360910587-25548-2-git-send-email-vikas.sajjan@linaro.org>
In-Reply-To: <1360910587-25548-1-git-send-email-vikas.sajjan@linaro.org>
References: <1360910587-25548-1-git-send-email-vikas.sajjan@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for parsing the display-timing node using video helper
function.

The DT node parsing and pinctrl selection is done only if 'dev.of_node'
exists and the NON-DT logic is still maintained under the 'else' part.

Signed-off-by: Leela Krishna Amudala <l.krishna@samsung.com>
Signed-off-by: Vikas Sajjan <vikas.sajjan@linaro.org>
---
 drivers/gpu/drm/exynos/exynos_drm_fimd.c |   37 ++++++++++++++++++++++++++----
 1 file changed, 33 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_fimd.c b/drivers/gpu/drm/exynos/exynos_drm_fimd.c
index 9537761..8b2c0ff 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_fimd.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_fimd.c
@@ -19,7 +19,9 @@
 #include <linux/clk.h>
 #include <linux/of_device.h>
 #include <linux/pm_runtime.h>
+#include <linux/pinctrl/consumer.h>
 
+#include <video/of_display_timing.h>
 #include <video/samsung_fimd.h>
 #include <drm/exynos_drm.h>
 
@@ -877,16 +879,43 @@ static int fimd_probe(struct platform_device *pdev)
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
+		fbmode = &pdata->panel.timing;
+		ret = of_get_fb_videomode(dev->of_node, fbmode,
+					OF_USE_NATIVE_MODE);
+		if (ret) {
+			DRM_ERROR("failed: of_get_fb_videomode()\n"
+				"with return value: %d\n", ret);
+			return ret;
+		}
+
+		pctrl = devm_pinctrl_get_select_default(dev);
+		if (IS_ERR_OR_NULL(pctrl)) {
+			DRM_ERROR("failed: devm_pinctrl_get_select_default()\n"
+				"with return value: %d\n", PTR_RET(pctrl));
+			return PTR_RET(pctrl);
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

