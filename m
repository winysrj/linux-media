Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:15929 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752357AbaDOJ2D (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Apr 2014 05:28:03 -0400
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
To: linux-samsung-soc@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, robh+dt@kernel.org, inki.dae@samsung.com,
	kyungmin.park@samsung.com, sw0312.kim@samsung.com,
	t.figa@samsung.com, b.zolnierkie@samsung.com,
	jy0922.shim@samsung.com, rahul.sharma@samsung.com,
	pawel.moll@arm.com, Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCHv2 3/4] drm: exynos: add compatibles for HDMI and Mixer chips
 and exynos4210 SoC
Date: Tue, 15 Apr 2014 11:27:19 +0200
Message-id: <1397554040-4037-4-git-send-email-t.stanislaws@samsung.com>
In-reply-to: <1397554040-4037-1-git-send-email-t.stanislaws@samsung.com>
References: <1397554040-4037-1-git-send-email-t.stanislaws@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch add proper compatibles for Mixer and HDMI chip
available on exynos4210 SoCs.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_hdmi.c  |    7 +++++++
 drivers/gpu/drm/exynos/exynos_mixer.c |    3 +++
 2 files changed, 10 insertions(+)

diff --git a/drivers/gpu/drm/exynos/exynos_hdmi.c b/drivers/gpu/drm/exynos/exynos_hdmi.c
index 47c6e85..2a18f4e 100644
--- a/drivers/gpu/drm/exynos/exynos_hdmi.c
+++ b/drivers/gpu/drm/exynos/exynos_hdmi.c
@@ -204,6 +204,10 @@ struct hdmiphy_config {
 	u8 conf[32];
 };
 
+struct hdmi_driver_data exynos4210_hdmi_driver_data = {
+	.type	= HDMI_TYPE13,
+};
+
 struct hdmi_driver_data exynos4212_hdmi_driver_data = {
 	.type	= HDMI_TYPE14,
 };
@@ -2032,6 +2036,9 @@ static struct s5p_hdmi_platform_data *drm_hdmi_dt_parse_pdata
 
 static struct of_device_id hdmi_match_types[] = {
 	{
+		.compatible = "samsung,exynos4210-hdmi",
+		.data = &exynos4210_hdmi_driver_data,
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

