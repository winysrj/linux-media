Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:42953 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816Ab3HFFXh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Aug 2013 01:23:37 -0400
Received: by mail-pa0-f46.google.com with SMTP id fa1so246281pad.33
        for <linux-media@vger.kernel.org>; Mon, 05 Aug 2013 22:23:37 -0700 (PDT)
From: Vikas Sajjan <vikas.sajjan@linaro.org>
To: linux-samsung-soc@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: linux-media@vger.kernel.org, kgene.kim@samsung.com,
	inki.dae@samsung.com, s.nawrocki@samsung.com,
	m.szyprowski@samsung.com, tomasz.figa@gmail.com,
	robdclark@gmail.com, arun.kk@samsung.com, patches@linaro.org,
	linaro-kernel@lists.linaro.org, joshi@samsung.com
Subject: [PATCH v3] drm/exynos: Add fallback option to get non physically continous memory for fb
Date: Tue,  6 Aug 2013 10:53:24 +0530
Message-Id: <1375766604-15455-1-git-send-email-vikas.sajjan@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

While trying to get boot-logo up on exynos5420 SMDK which has eDP panel
connected with resolution 2560x1600, following error occured even with
IOMMU enabled:
[0.880000] [drm:lowlevel_buffer_allocate] *ERROR* failed to allocate buffer.
[0.890000] [drm] Initialized exynos 1.0.0 20110530 on minor 0

To address the cases where physically continous memory MAY NOT be a
mandatory requirement for fb, the patch adds a feature to get non physically
continous memory for fb if IOMMU is supported and if CONTIG memory allocation
fails.

Signed-off-by: Vikas Sajjan <vikas.sajjan@linaro.org>
Signed-off-by: Arun Kumar <arun.kk@samsung.com>
Reviewed-by: Rob Clark <robdclark@gmail.com>
---
changes since v2:
	- addressed comments given by Tomasz Figa <tomasz.figa@gmail.com>.

changes since v1:
	 - Modified to add the fallback patch if CONTIG alloc fails as suggested
	 by Rob Clark robdclark@gmail.com and Tomasz Figa <tomasz.figa@gmail.com>.

	 - changed the commit message.
---
 drivers/gpu/drm/exynos/exynos_drm_fbdev.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_fbdev.c b/drivers/gpu/drm/exynos/exynos_drm_fbdev.c
index 8e60bd6..faec77e 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_fbdev.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_fbdev.c
@@ -16,6 +16,7 @@
 #include <drm/drm_crtc.h>
 #include <drm/drm_fb_helper.h>
 #include <drm/drm_crtc_helper.h>
+#include <drm/exynos_drm.h>
 
 #include "exynos_drm_drv.h"
 #include "exynos_drm_fb.h"
@@ -165,8 +166,17 @@ static int exynos_drm_fbdev_create(struct drm_fb_helper *helper,
 
 	size = mode_cmd.pitches[0] * mode_cmd.height;
 
-	/* 0 means to allocate physically continuous memory */
-	exynos_gem_obj = exynos_drm_gem_create(dev, 0, size);
+	exynos_gem_obj = exynos_drm_gem_create(dev, EXYNOS_BO_CONTIG, size);
+	/*
+	 * If IOMMU is supported then try to get buffer from non physically
+	 * continous memory area.
+	 */
+	if (IS_ERR(exynos_gem_obj) && is_drm_iommu_supported(dev)) {
+		dev_warn(&pdev->dev, "contiguous FB allocation failed, falling back to non-contiguous\n");
+		exynos_gem_obj = exynos_drm_gem_create(dev, EXYNOS_BO_NONCONTIG,
+							size);
+	}
+
 	if (IS_ERR(exynos_gem_obj)) {
 		ret = PTR_ERR(exynos_gem_obj);
 		goto err_release_framebuffer;
-- 
1.7.9.5

