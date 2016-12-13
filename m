Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:42016 "EHLO
        lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753225AbcLMPIW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Dec 2016 10:08:22 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Russell King <linux@armlinux.org.uk>, linux-fbdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 2/4] exynos_hdmi: add HDMI notifier support
Date: Tue, 13 Dec 2016 16:08:11 +0100
Message-Id: <20161213150813.37966-3-hverkuil@xs4all.nl>
In-Reply-To: <20161213150813.37966-1-hverkuil@xs4all.nl>
References: <20161213150813.37966-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Implement the HDMI notifier support to allow CEC drivers to
be informed when there is a new EDID and when a connect or
disconnect happens.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/gpu/drm/exynos/Kconfig       |  1 +
 drivers/gpu/drm/exynos/exynos_hdmi.c | 24 +++++++++++++++++++++---
 2 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/exynos/Kconfig b/drivers/gpu/drm/exynos/Kconfig
index 465d344f..34f3b6f 100644
--- a/drivers/gpu/drm/exynos/Kconfig
+++ b/drivers/gpu/drm/exynos/Kconfig
@@ -77,6 +77,7 @@ config DRM_EXYNOS_DP
 config DRM_EXYNOS_HDMI
 	bool "HDMI"
 	depends on DRM_EXYNOS_MIXER || DRM_EXYNOS5433_DECON
+	select HDMI_NOTIFIERS
 	help
 	  Choose this option if you want to use Exynos HDMI for DRM.
 
diff --git a/drivers/gpu/drm/exynos/exynos_hdmi.c b/drivers/gpu/drm/exynos/exynos_hdmi.c
index e8fb6ef..2bfc411 100644
--- a/drivers/gpu/drm/exynos/exynos_hdmi.c
+++ b/drivers/gpu/drm/exynos/exynos_hdmi.c
@@ -31,6 +31,7 @@
 #include <linux/pm_runtime.h>
 #include <linux/clk.h>
 #include <linux/gpio/consumer.h>
+#include <linux/hdmi-notifier.h>
 #include <linux/regulator/consumer.h>
 #include <linux/io.h>
 #include <linux/of_address.h>
@@ -132,6 +133,7 @@ struct hdmi_context {
 	struct delayed_work		hotplug_work;
 	struct drm_display_mode		current_mode;
 	u8				cea_video_id;
+	struct hdmi_notifier		*notifier;
 	const struct hdmi_driver_data	*drv_data;
 
 	void __iomem			*regs;
@@ -857,9 +859,12 @@ static enum drm_connector_status hdmi_detect(struct drm_connector *connector,
 {
 	struct hdmi_context *hdata = connector_to_hdmi(connector);
 
-	if (gpiod_get_value(hdata->hpd_gpio))
+	if (gpiod_get_value(hdata->hpd_gpio)) {
+		hdmi_event_connect(hdata->notifier);
 		return connector_status_connected;
+	}
 
+	hdmi_event_disconnect(hdata->notifier);
 	return connector_status_disconnected;
 }
 
@@ -898,6 +903,9 @@ static int hdmi_get_modes(struct drm_connector *connector)
 		edid->width_cm, edid->height_cm);
 
 	drm_mode_connector_update_edid_property(connector, edid);
+	hdmi_event_connect(hdata->notifier);
+	hdmi_event_new_edid(hdata->notifier, edid,
+			    EDID_LENGTH * (1 + edid->extensions));
 
 	ret = drm_add_edid_modes(connector, edid);
 
@@ -1544,6 +1552,7 @@ static void hdmi_disable(struct drm_encoder *encoder)
 	if (funcs && funcs->disable)
 		(*funcs->disable)(crtc);
 
+	hdmi_event_disconnect(hdata->notifier);
 	cancel_delayed_work(&hdata->hotplug_work);
 
 	hdmiphy_disable(hdata);
@@ -1893,15 +1902,22 @@ static int hdmi_probe(struct platform_device *pdev)
 		}
 	}
 
+	hdata->notifier = hdmi_notifier_get(&pdev->dev);
+	if (hdata->notifier == NULL) {
+		ret = -ENOMEM;
+		goto err_hdmiphy;
+	}
+
 	pm_runtime_enable(dev);
 
 	ret = component_add(&pdev->dev, &hdmi_component_ops);
 	if (ret)
-		goto err_disable_pm_runtime;
+		goto err_notifier_put;
 
 	return ret;
 
-err_disable_pm_runtime:
+err_notifier_put:
+	hdmi_notifier_put(hdata->notifier);
 	pm_runtime_disable(dev);
 
 err_hdmiphy:
@@ -1918,9 +1934,11 @@ static int hdmi_remove(struct platform_device *pdev)
 	struct hdmi_context *hdata = platform_get_drvdata(pdev);
 
 	cancel_delayed_work_sync(&hdata->hotplug_work);
+	hdmi_event_disconnect(hdata->notifier);
 
 	component_del(&pdev->dev, &hdmi_component_ops);
 
+	hdmi_notifier_put(hdata->notifier);
 	pm_runtime_disable(&pdev->dev);
 
 	if (!IS_ERR(hdata->reg_hdmi_en))
-- 
2.10.2

