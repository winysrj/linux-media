Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:43816 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269Ab3CAFfE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Mar 2013 00:35:04 -0500
Received: by mail-pa0-f43.google.com with SMTP id bh2so1608163pad.16
        for <linux-media@vger.kernel.org>; Thu, 28 Feb 2013 21:35:04 -0800 (PST)
From: Vikas Sajjan <vikas.sajjan@linaro.org>
To: dri-devel@lists.freedesktop.org
Cc: linux-media@vger.kernel.org, kgene.kim@samsung.com,
	inki.dae@samsung.com, l.krishna@samsung.com,
	jy0922.shim@samsung.com, sylvester.nawrocki@gmail.com
Subject: [PATCH v10 2/2] video: drm: exynos: Add pinctrl support to fimd
Date: Fri,  1 Mar 2013 11:04:40 +0530
Message-Id: <1362116080-20063-3-git-send-email-vikas.sajjan@linaro.org>
In-Reply-To: <1362116080-20063-1-git-send-email-vikas.sajjan@linaro.org>
References: <1362116080-20063-1-git-send-email-vikas.sajjan@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adds support for pinctrl to drm fimd

Signed-off-by: Leela Krishna Amudala <l.krishna@samsung.com>
Signed-off-by: Vikas Sajjan <vikas.sajjan@linaro.org>
---
 drivers/gpu/drm/exynos/exynos_drm_fimd.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_fimd.c b/drivers/gpu/drm/exynos/exynos_drm_fimd.c
index e323cf9..c00aa4a 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_fimd.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_fimd.c
@@ -19,6 +19,7 @@
 #include <linux/clk.h>
 #include <linux/of_device.h>
 #include <linux/pm_runtime.h>
+#include <linux/pinctrl/consumer.h>
 
 #include <video/of_display_timing.h>
 #include <video/samsung_fimd.h>
@@ -879,6 +880,7 @@ static int fimd_probe(struct platform_device *pdev)
 	struct exynos_drm_fimd_pdata *pdata;
 	struct exynos_drm_panel_info *panel;
 	struct resource *res;
+	struct pinctrl *pctrl;
 	int win;
 	int ret = -EINVAL;
 
@@ -897,6 +899,13 @@ static int fimd_probe(struct platform_device *pdev)
 			DRM_ERROR("failed: of_get_fb_videomode() : %d\n", ret);
 			return ret;
 		}
+		pctrl = devm_pinctrl_get_select_default(dev);
+		if (IS_ERR(pctrl)) {
+			DRM_ERROR("failed: devm_pinctrl_get_select_default():\n"
+				"%d\n", PTR_RET(pctrl));
+			return PTR_ERR(pctrl);
+		}
+
 	} else {
 		pdata = pdev->dev.platform_data;
 		if (!pdata) {
-- 
1.7.9.5

