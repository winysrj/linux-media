Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:48961 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849Ab3BEFc5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Feb 2013 00:32:57 -0500
Received: by mail-pa0-f53.google.com with SMTP id bg4so3787674pad.12
        for <linux-media@vger.kernel.org>; Mon, 04 Feb 2013 21:32:57 -0800 (PST)
From: Vikas Sajjan <vikas.sajjan@linaro.org>
To: dri-devel@lists.freedesktop.org
Cc: linux-media@vger.kernel.org, kgene.kim@samsung.com,
	inki.dae@samsung.com, l.krishna@samsung.com
Subject: [PATCH v4 1/1] video: drm: exynos: Adds display-timing node parsing using video helper function
Date: Tue,  5 Feb 2013 11:02:47 +0530
Message-Id: <1360042367-16397-2-git-send-email-vikas.sajjan@linaro.org>
In-Reply-To: <1360042367-16397-1-git-send-email-vikas.sajjan@linaro.org>
References: <1360042367-16397-1-git-send-email-vikas.sajjan@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds display-timing node parsing using video helper function

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
+			DRM_ERROR("failed: of_get_fb_videomode() :"
+				"return value: %d\n", ret);
+			return ret;
+		}
+		pdata->panel.timing = (struct fb_videomode) *fbmode;
+
+		pctrl = devm_pinctrl_get_select_default(dev);
+		if (IS_ERR_OR_NULL(pctrl)) {
+			DRM_ERROR("failed: devm_pinctrl_get_select_default()"
+				"return value: %d\n", PTR_RET(pctrl));
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

