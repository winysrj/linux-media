Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:8608 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753585AbaDNPA6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Apr 2014 11:00:58 -0400
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
To: linux-samsung-soc@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, robh+dt@kernel.org, inki.dae@samsung.com,
	kyungmin.park@samsung.com, sw0312.kim@samsung.com,
	t.figa@samsung.com, b.zolnierkie@samsung.com,
	jy0922.shim@samsung.com, rahul.sharma@samsung.com,
	pawel.moll@arm.com, Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCH 3/4] drm: exynos: add compatibles for HDMI and Mixer chips and
 exynos4210 SoC
Date: Mon, 14 Apr 2014 17:00:21 +0200
Message-id: <1397487622-3577-4-git-send-email-t.stanislaws@samsung.com>
In-reply-to: <1397487622-3577-1-git-send-email-t.stanislaws@samsung.com>
References: <1397487622-3577-1-git-send-email-t.stanislaws@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch add proper compatibles for Mixer and HDMI chip
available on exynos4210 SoCs.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_hdmi.c  |    3 +++
 drivers/gpu/drm/exynos/exynos_mixer.c |    3 +++
 2 files changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/exynos/exynos_hdmi.c b/drivers/gpu/drm/exynos/exynos_hdmi.c
index d2d6e2e..6fa63ea 100644
--- a/drivers/gpu/drm/exynos/exynos_hdmi.c
+++ b/drivers/gpu/drm/exynos/exynos_hdmi.c
@@ -2032,6 +2032,9 @@ static struct s5p_hdmi_platform_data *drm_hdmi_dt_parse_pdata
 
 static struct of_device_id hdmi_match_types[] = {
 	{
+		.compatible = "samsung,exynos4210-hdmi",
+		.data	= (void	*)HDMI_TYPE13,
+	}, {
 		.compatible = "samsung,exynos5-hdmi",
 		.data = &exynos5_hdmi_driver_data,
 	}, {
diff --git a/drivers/gpu/drm/exynos/exynos_mixer.c b/drivers/gpu/drm/exynos/exynos_mixer.c
index e3306c8..fd8a9a0 100644
--- a/drivers/gpu/drm/exynos/exynos_mixer.c
+++ b/drivers/gpu/drm/exynos/exynos_mixer.c
@@ -1187,6 +1187,9 @@ static struct platform_device_id mixer_driver_types[] = {
 
 static struct of_device_id mixer_match_types[] = {
 	{
+		.compatible = "samsung,exynos4210-mixer",
+		.data	= &exynos4210_mxr_drv_data,
+	}, {
 		.compatible = "samsung,exynos5-mixer",
 		.data	= &exynos5250_mxr_drv_data,
 	}, {
-- 
1.7.9.5

