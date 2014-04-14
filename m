Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:45431 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753177AbaDNPAp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Apr 2014 11:00:45 -0400
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
To: linux-samsung-soc@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, robh+dt@kernel.org, inki.dae@samsung.com,
	kyungmin.park@samsung.com, sw0312.kim@samsung.com,
	t.figa@samsung.com, b.zolnierkie@samsung.com,
	jy0922.shim@samsung.com, rahul.sharma@samsung.com,
	pawel.moll@arm.com, Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCH 1/4] drm: exynos: hdmi: simplify extracting hpd-gpio from DT
Date: Mon, 14 Apr 2014 17:00:19 +0200
Message-id: <1397487622-3577-2-git-send-email-t.stanislaws@samsung.com>
In-reply-to: <1397487622-3577-1-git-send-email-t.stanislaws@samsung.com>
References: <1397487622-3577-1-git-send-email-t.stanislaws@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch eliminates redundant checks while retrieving HPD gpio from DT during
HDMI's probe().

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_hdmi.c |   13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_hdmi.c b/drivers/gpu/drm/exynos/exynos_hdmi.c
index 9a6d652..d2d6e2e 100644
--- a/drivers/gpu/drm/exynos/exynos_hdmi.c
+++ b/drivers/gpu/drm/exynos/exynos_hdmi.c
@@ -2016,23 +2016,18 @@ static struct s5p_hdmi_platform_data *drm_hdmi_dt_parse_pdata
 {
 	struct device_node *np = dev->of_node;
 	struct s5p_hdmi_platform_data *pd;
-	u32 value;
 
 	pd = devm_kzalloc(dev, sizeof(*pd), GFP_KERNEL);
 	if (!pd)
-		goto err_data;
+		return NULL;
 
-	if (!of_find_property(np, "hpd-gpio", &value)) {
+	pd->hpd_gpio = of_get_named_gpio(np, "hpd-gpio", 0);
+	if (gpio_is_valid(pd->hpd_gpio)) {
 		DRM_ERROR("no hpd gpio property found\n");
-		goto err_data;
+		return NULL;
 	}
 
-	pd->hpd_gpio = of_get_named_gpio(np, "hpd-gpio", 0);
-
 	return pd;
-
-err_data:
-	return NULL;
 }
 
 static struct of_device_id hdmi_match_types[] = {
-- 
1.7.9.5

