Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:64498 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752431Ab3CGHkE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Mar 2013 02:40:04 -0500
Received: by mail-pa0-f44.google.com with SMTP id kp1so257752pab.31
        for <linux-media@vger.kernel.org>; Wed, 06 Mar 2013 23:40:03 -0800 (PST)
From: Vikas Sajjan <vikas.sajjan@linaro.org>
To: dri-devel@lists.freedesktop.org
Cc: linux-media@vger.kernel.org, kgene.kim@samsung.com,
	inki.dae@samsung.com, l.krishna@samsung.com, joshi@samsung.com,
	linaro-kernel@lists.linaro.org
Subject: [PATCH v12 2/2] drm/exynos: enable OF_VIDEOMODE and FB_MODE_HELPERS for exynos drm fimd
Date: Thu,  7 Mar 2013 13:09:44 +0530
Message-Id: <1362641984-2706-3-git-send-email-vikas.sajjan@linaro.org>
In-Reply-To: <1362641984-2706-1-git-send-email-vikas.sajjan@linaro.org>
References: <1362641984-2706-1-git-send-email-vikas.sajjan@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

patch adds "select OF_VIDEOMODE" and "select FB_MODE_HELPERS" when
EXYNOS_DRM_FIMD config is selected.

Signed-off-by: Vikas Sajjan <vikas.sajjan@linaro.org>
---
 drivers/gpu/drm/exynos/Kconfig |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/exynos/Kconfig b/drivers/gpu/drm/exynos/Kconfig
index 046bcda..bb25130 100644
--- a/drivers/gpu/drm/exynos/Kconfig
+++ b/drivers/gpu/drm/exynos/Kconfig
@@ -25,6 +25,8 @@ config DRM_EXYNOS_DMABUF
 config DRM_EXYNOS_FIMD
 	bool "Exynos DRM FIMD"
 	depends on DRM_EXYNOS && !FB_S3C && !ARCH_MULTIPLATFORM
+	select OF_VIDEOMODE
+	select FB_MODE_HELPERS
 	help
 	  Choose this option if you want to use Exynos FIMD for DRM.
 
-- 
1.7.9.5

