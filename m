Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:53774 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756179Ab3BFEYZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Feb 2013 23:24:25 -0500
Received: by mail-pa0-f43.google.com with SMTP id bh2so564800pad.30
        for <linux-media@vger.kernel.org>; Tue, 05 Feb 2013 20:24:25 -0800 (PST)
From: Vikas Sajjan <vikas.sajjan@linaro.org>
To: dri-devel@lists.freedesktop.org
Cc: linux-media@vger.kernel.org, kgene.kim@samsung.com,
	inki.dae@samsung.com, l.krishna@samsung.com,
	paulepanter@users.sourceforge.net
Subject: [PATCH v5 1/1] video: drm: exynos: Add display-timing node parsing using video helper function
Date: Wed,  6 Feb 2013 09:54:15 +0530
Message-Id: <1360124655-22902-2-git-send-email-vikas.sajjan@linaro.org>
In-Reply-To: <1360124655-22902-1-git-send-email-vikas.sajjan@linaro.org>
References: <1360124655-22902-1-git-send-email-vikas.sajjan@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for parsing the display-timing node using video helper
function.

The DT node parsing and pinctrl selection is done only if 'dev.of_node'
exists and the NON-DT logic is still maintained under the 'else' part.

Signed-off-by: Leela Krishna Amudala <l.krishna@samsung.com>
Signed-off-by: Vikas Sajjan <vikas.sajjan@linaro.org>
---
 drivers/gpu/drm/exynos/exynos_drm_fimd.c |   41 +++++++++++++++++++++++++++---
 1 file changed, 37 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_fimd.c b/drivers/gpu/drm/exynos/exynos_drm_fimd.c
index bf0d9ba..978e866 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_fimd.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_fimd.c
@@ -19,6 +19,7 @@
 #include <linux/clk.h>
 #include <linux/of_device.h>
 #include <linux/pm_runtime.h>
+#include <linux/pinctrl/consumer.h>
 
 #include <video/samsung_fimd.h>
 #include <drm/exynos_drm.h>
@@ -905,16 +906,48 @@ static int __devinit fimd_probe(struct platform_device *pdev)
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
+			DRM_ERROR("failed: of_get_fb_videomode()\n"
+				"with return value: %d\n", ret);
+			return ret;
+		}
+		pdata->panel.timing = (struct fb_videomode) *fbmode;
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

