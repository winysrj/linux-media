Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f51.google.com ([209.85.160.51]:48854 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753849Ab3CIAKp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Mar 2013 19:10:45 -0500
Received: by mail-pb0-f51.google.com with SMTP id un15so1737151pbc.10
        for <linux-media@vger.kernel.org>; Fri, 08 Mar 2013 16:10:44 -0800 (PST)
From: Vikas Sajjan <vikas.sajjan@linaro.org>
To: dri-devel@lists.freedesktop.org
Cc: linux-media@vger.kernel.org, kgene.kim@samsung.com,
	inki.dae@samsung.com, l.krishna@samsung.com,
	linaro-kernel@lists.linaro.org
Subject: [PATCH v13 2/2] drm/exynos: enable OF_VIDEOMODE and FB_MODE_HELPERS for exynos drm fimd
Date: Sat,  9 Mar 2013 05:40:20 +0530
Message-Id: <1362787820-5305-3-git-send-email-vikas.sajjan@linaro.org>
In-Reply-To: <1362787820-5305-1-git-send-email-vikas.sajjan@linaro.org>
References: <1362787820-5305-1-git-send-email-vikas.sajjan@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

patch adds "select OF_VIDEOMODE" and "select FB_MODE_HELPERS" when
EXYNOS_DRM_FIMD config is selected. Also adds the "OF" dependency.

Signed-off-by: Vikas Sajjan <vikas.sajjan@linaro.org>
---
 drivers/gpu/drm/exynos/Kconfig |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/exynos/Kconfig b/drivers/gpu/drm/exynos/Kconfig
index 046bcda..406f32a 100644
--- a/drivers/gpu/drm/exynos/Kconfig
+++ b/drivers/gpu/drm/exynos/Kconfig
@@ -24,7 +24,9 @@ config DRM_EXYNOS_DMABUF
 
 config DRM_EXYNOS_FIMD
 	bool "Exynos DRM FIMD"
-	depends on DRM_EXYNOS && !FB_S3C && !ARCH_MULTIPLATFORM
+	depends on OF && DRM_EXYNOS && !FB_S3C && !ARCH_MULTIPLATFORM
+	select OF_VIDEOMODE
+	select FB_MODE_HELPERS
 	help
 	  Choose this option if you want to use Exynos FIMD for DRM.
 
-- 
1.7.9.5

