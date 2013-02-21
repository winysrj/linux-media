Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-da0-f51.google.com ([209.85.210.51]:53180 "EHLO
	mail-da0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521Ab3BUFMJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Feb 2013 00:12:09 -0500
Received: by mail-da0-f51.google.com with SMTP id n15so3865868dad.38
        for <linux-media@vger.kernel.org>; Wed, 20 Feb 2013 21:12:08 -0800 (PST)
From: Vikas Sajjan <vikas.sajjan@linaro.org>
To: dri-devel@lists.freedesktop.org
Cc: linux-media@vger.kernel.org, kgene.kim@samsung.com,
	inki.dae@samsung.com, l.krishna@samsung.com
Subject: [PATCH v7 1/2] video: drm: exynos: Add display-timing node parsing using video helper function
Date: Thu, 21 Feb 2013 10:41:51 +0530
Message-Id: <1361423512-2882-2-git-send-email-vikas.sajjan@linaro.org>
In-Reply-To: <1361423512-2882-1-git-send-email-vikas.sajjan@linaro.org>
References: <1361423512-2882-1-git-send-email-vikas.sajjan@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for parsing the display-timing node using video helper
function.

The DT node parsing and pinctrl selection is done only if 'dev.of_node'
exists and the NON-DT logic is still maintained under the 'else' part.

Signed-off-by: Leela Krishna Amudala <l.krishna@samsung.com>
Signed-off-by: Vikas Sajjan <vikas.sajjan@linaro.org>
---
 drivers/gpu/drm/exynos/exynos_drm_fimd.c |   27 +++++++++++++++++++++++----
 1 file changed, 23 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_fimd.c b/drivers/gpu/drm/exynos/exynos_drm_fimd.c
index 9537761..f80cf68 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_fimd.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_fimd.c
@@ -20,6 +20,7 @@
 #include <linux/of_device.h>
 #include <linux/pm_runtime.h>
 
+#include <video/of_display_timing.h>
 #include <video/samsung_fimd.h>
 #include <drm/exynos_drm.h>
 
@@ -877,16 +878,34 @@ static int fimd_probe(struct platform_device *pdev)
 	struct exynos_drm_subdrv *subdrv;
 	struct exynos_drm_fimd_pdata *pdata;
 	struct exynos_drm_panel_info *panel;
+	struct fb_videomode *fbmode;
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

