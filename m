Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:19790 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938AbaDNPBH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Apr 2014 11:01:07 -0400
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
To: linux-samsung-soc@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, robh+dt@kernel.org, inki.dae@samsung.com,
	kyungmin.park@samsung.com, sw0312.kim@samsung.com,
	t.figa@samsung.com, b.zolnierkie@samsung.com,
	jy0922.shim@samsung.com, rahul.sharma@samsung.com,
	pawel.moll@arm.com, Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCH 4/4] drm: exynos: hdmi: add support for pixel clock limitation
Date: Mon, 14 Apr 2014 17:00:22 +0200
Message-id: <1397487622-3577-5-git-send-email-t.stanislaws@samsung.com>
In-reply-to: <1397487622-3577-1-git-send-email-t.stanislaws@samsung.com>
References: <1397487622-3577-1-git-send-email-t.stanislaws@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adds support for limitation of maximal pixel clock of HDMI
signal. This feature is needed on boards that contains
lines or bridges with frequency limitations.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
---
 .../devicetree/bindings/video/exynos_hdmi.txt      |    4 ++++
 drivers/gpu/drm/exynos/exynos_hdmi.c               |   12 ++++++++++++
 include/media/s5p_hdmi.h                           |    1 +
 3 files changed, 17 insertions(+)

diff --git a/Documentation/devicetree/bindings/video/exynos_hdmi.txt b/Documentation/devicetree/bindings/video/exynos_hdmi.txt
index f9187a2..8718f8d 100644
--- a/Documentation/devicetree/bindings/video/exynos_hdmi.txt
+++ b/Documentation/devicetree/bindings/video/exynos_hdmi.txt
@@ -28,6 +28,10 @@ Required properties:
 - ddc: phandle to the hdmi ddc node
 - phy: phandle to the hdmi phy node
 
+Optional properties:
+- max-pixel-clock: used to limit the maximal pixel clock if a board has lines,
+	connectors or bridges not capable of carring higher frequencies
+
 Example:
 
 	hdmi {
diff --git a/drivers/gpu/drm/exynos/exynos_hdmi.c b/drivers/gpu/drm/exynos/exynos_hdmi.c
index 6fa63ea..ca313b3 100644
--- a/drivers/gpu/drm/exynos/exynos_hdmi.c
+++ b/drivers/gpu/drm/exynos/exynos_hdmi.c
@@ -195,6 +195,7 @@ struct hdmi_context {
 	struct hdmi_resources		res;
 
 	int				hpd_gpio;
+	u32				max_pixel_clock;
 
 	enum hdmi_type			type;
 };
@@ -883,6 +884,9 @@ static int hdmi_mode_valid(struct drm_connector *connector,
 	if (ret)
 		return MODE_BAD;
 
+	if (mode->clock * 1000 > hdata->max_pixel_clock)
+		return MODE_BAD;
+
 	ret = hdmi_find_phy_conf(hdata, mode->clock * 1000);
 	if (ret < 0)
 		return MODE_BAD;
@@ -2027,6 +2031,8 @@ static struct s5p_hdmi_platform_data *drm_hdmi_dt_parse_pdata
 		return NULL;
 	}
 
+	of_property_read_u32(np, "max-pixel-clock", &pd->max_pixel_clock);
+
 	return pd;
 }
 
@@ -2063,6 +2069,11 @@ static int hdmi_probe(struct platform_device *pdev)
 	if (!pdata)
 		return -EINVAL;
 
+	if (!pdata->max_pixel_clock) {
+		DRM_INFO("max-pixel-clock is zero, using INF\n");
+		pdata->max_pixel_clock = ULONG_MAX;
+	}
+
 	hdata = devm_kzalloc(dev, sizeof(struct hdmi_context), GFP_KERNEL);
 	if (!hdata)
 		return -ENOMEM;
@@ -2079,6 +2090,7 @@ static int hdmi_probe(struct platform_device *pdev)
 	hdata->type = drv_data->type;
 
 	hdata->hpd_gpio = pdata->hpd_gpio;
+	hdata->max_pixel_clock = pdata->max_pixel_clock;
 	hdata->dev = dev;
 
 	ret = hdmi_resources_init(hdata);
diff --git a/include/media/s5p_hdmi.h b/include/media/s5p_hdmi.h
index 181642b..7272d65 100644
--- a/include/media/s5p_hdmi.h
+++ b/include/media/s5p_hdmi.h
@@ -31,6 +31,7 @@ struct s5p_hdmi_platform_data {
 	int mhl_bus;
 	struct i2c_board_info *mhl_info;
 	int hpd_gpio;
+	u32 max_pixel_clock;
 };
 
 #endif /* S5P_HDMI_H */
-- 
1.7.9.5

