Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-da0-f47.google.com ([209.85.210.47]:43337 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937Ab3B0KdL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Feb 2013 05:33:11 -0500
Received: by mail-da0-f47.google.com with SMTP id s35so237312dak.6
        for <linux-media@vger.kernel.org>; Wed, 27 Feb 2013 02:33:10 -0800 (PST)
From: Vikas Sajjan <vikas.sajjan@linaro.org>
To: dri-devel@lists.freedesktop.org
Cc: linux-media@vger.kernel.org, kgene.kim@samsung.com,
	inki.dae@samsung.com, l.krishna@samsung.com,
	jy0922.shim@samsung.com, kyungmin.park@samsung.com,
	s.nawrocki@samsung.com, t.figa@samsung.com
Subject: [PATCH] drm/exynos: modify the compatible string for exynos fimd
Date: Wed, 27 Feb 2013 16:02:58 +0530
Message-Id: <1361961178-1912-1-git-send-email-vikas.sajjan@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

modified compatible string for exynos4 fimd as "exynos4210-fimd" and
exynos5 fimd as "exynos5250-fimd" to stick to the rule that compatible
value should be named after first specific SoC model in which this
particular IP version was included as discussed at
https://patchwork.kernel.org/patch/2144861/

Signed-off-by: Vikas Sajjan <vikas.sajjan@linaro.org>
---
 drivers/gpu/drm/exynos/exynos_drm_fimd.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_fimd.c b/drivers/gpu/drm/exynos/exynos_drm_fimd.c
index 9537761..433ed35 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_fimd.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_fimd.c
@@ -109,9 +109,9 @@ struct fimd_context {
 
 #ifdef CONFIG_OF
 static const struct of_device_id fimd_driver_dt_match[] = {
-	{ .compatible = "samsung,exynos4-fimd",
+	{ .compatible = "samsung,exynos4210-fimd",
 	  .data = &exynos4_fimd_driver_data },
-	{ .compatible = "samsung,exynos5-fimd",
+	{ .compatible = "samsung,exynos5250-fimd",
 	  .data = &exynos5_fimd_driver_data },
 	{},
 };
-- 
1.7.9.5

