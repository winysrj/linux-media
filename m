Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-da0-f48.google.com ([209.85.210.48]:51069 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759656Ab3B0LuX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Feb 2013 06:50:23 -0500
Received: by mail-da0-f48.google.com with SMTP id w4so263784dam.7
        for <linux-media@vger.kernel.org>; Wed, 27 Feb 2013 03:50:22 -0800 (PST)
From: Vikas Sajjan <vikas.sajjan@linaro.org>
To: dri-devel@lists.freedesktop.org
Cc: linux-media@vger.kernel.org, kgene.kim@samsung.com,
	joshi@samsung.com, inki.dae@samsung.com, l.krishna@samsung.com,
	patches@linaro.org, linaro-dev@lists.linaro.org
Subject: [PATCH v8 2/2] video: drm: exynos: Add pinctrl support to fimd
Date: Wed, 27 Feb 2013 17:19:56 +0530
Message-Id: <1361965796-16117-3-git-send-email-vikas.sajjan@linaro.org>
In-Reply-To: <1361965796-16117-1-git-send-email-vikas.sajjan@linaro.org>
References: <1361965796-16117-1-git-send-email-vikas.sajjan@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adds support for pinctrl to drm fimd

Signed-off-by: Leela Krishna Amudala <l.krishna@samsung.com>
Signed-off-by: Vikas Sajjan <vikas.sajjan@linaro.org>
---
 drivers/gpu/drm/exynos/exynos_drm_fimd.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_fimd.c b/drivers/gpu/drm/exynos/exynos_drm_fimd.c
index 7932dc2..7d93475 100644
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
 
@@ -898,6 +900,13 @@ static int fimd_probe(struct platform_device *pdev)
 				"with return value: %d\n", ret);
 			return ret;
 		}
+		pctrl = devm_pinctrl_get_select_default(dev);
+		if (IS_ERR(pctrl)) {
+			DRM_ERROR("failed: devm_pinctrl_get_select_default()\n"
+				"with return value: %d\n", PTR_RET(pctrl));
+			return PTR_ERR(pctrl);
+		}
+
 	} else {
 		pdata = pdev->dev.platform_data;
 		if (!pdata) {
-- 
1.7.9.5

