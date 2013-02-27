Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-da0-f52.google.com ([209.85.210.52]:60833 "EHLO
	mail-da0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759656Ab3B0LuS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Feb 2013 06:50:18 -0500
Received: by mail-da0-f52.google.com with SMTP id x33so263708dad.39
        for <linux-media@vger.kernel.org>; Wed, 27 Feb 2013 03:50:18 -0800 (PST)
From: Vikas Sajjan <vikas.sajjan@linaro.org>
To: dri-devel@lists.freedesktop.org
Cc: linux-media@vger.kernel.org, kgene.kim@samsung.com,
	joshi@samsung.com, inki.dae@samsung.com, l.krishna@samsung.com,
	patches@linaro.org, linaro-dev@lists.linaro.org
Subject: [PATCH v8 1/2] video: drm: exynos: Add display-timing node parsing using video helper function
Date: Wed, 27 Feb 2013 17:19:55 +0530
Message-Id: <1361965796-16117-2-git-send-email-vikas.sajjan@linaro.org>
In-Reply-To: <1361965796-16117-1-git-send-email-vikas.sajjan@linaro.org>
References: <1361965796-16117-1-git-send-email-vikas.sajjan@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for parsing the display-timing node using video helper
function.

The DT node parsing and pinctrl selection is done only if 'dev.of_node'
exists and the NON-DT logic is still maintained under the 'else' part.

Signed-off-by: Leela Krishna Amudala <l.krishna@samsung.com>
Signed-off-by: Vikas Sajjan <vikas.sajjan@linaro.org>
---
 drivers/gpu/drm/exynos/exynos_drm_fimd.c |   25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_fimd.c b/drivers/gpu/drm/exynos/exynos_drm_fimd.c
index 9537761..7932dc2 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_fimd.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_fimd.c
@@ -20,6 +20,7 @@
 #include <linux/of_device.h>
 #include <linux/pm_runtime.h>
 
+#include <video/of_display_timing.h>
 #include <video/samsung_fimd.h>
 #include <drm/exynos_drm.h>
 
@@ -883,10 +884,26 @@ static int fimd_probe(struct platform_device *pdev)
 
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
+		ret = of_get_fb_videomode(dev->of_node, &pdata->panel.timing,
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

