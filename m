Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:54949 "EHLO
        lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751773AbdBFKaH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 6 Feb 2017 05:30:07 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Daniel Vetter <daniel.vetter@intel.com>,
        Russell King <linux@armlinux.org.uk>,
        dri-devel@lists.freedesktop.org, linux-samsung-soc@vger.kernel.org,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Inki Dae <inki.dae@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv4 2/9] exynos_hdmi: add HPD notifier support
Date: Mon,  6 Feb 2017 11:29:44 +0100
Message-Id: <20170206102951.12623-3-hverkuil@xs4all.nl>
In-Reply-To: <20170206102951.12623-1-hverkuil@xs4all.nl>
References: <20170206102951.12623-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Implement the HPD notifier support to allow CEC drivers to
be informed when there is a new EDID and when a connect or
disconnect happens.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/gpu/drm/exynos/Kconfig       |  1 +
 drivers/gpu/drm/exynos/exynos_hdmi.c | 23 ++++++++++++++++++++---
 2 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/exynos/Kconfig b/drivers/gpu/drm/exynos/Kconfig
index d706ca4e2f02..50309409d450 100644
--- a/drivers/gpu/drm/exynos/Kconfig
+++ b/drivers/gpu/drm/exynos/Kconfig
@@ -77,6 +77,7 @@ config DRM_EXYNOS_DP
 config DRM_EXYNOS_HDMI
 	bool "HDMI"
 	depends on DRM_EXYNOS_MIXER || DRM_EXYNOS5433_DECON
+	select HPD_NOTIFIER
 	help
 	  Choose this option if you want to use Exynos HDMI for DRM.
 
diff --git a/drivers/gpu/drm/exynos/exynos_hdmi.c b/drivers/gpu/drm/exynos/exynos_hdmi.c
index 5ed8b1effe71..8d48a0a21565 100644
--- a/drivers/gpu/drm/exynos/exynos_hdmi.c
+++ b/drivers/gpu/drm/exynos/exynos_hdmi.c
@@ -31,6 +31,7 @@
 #include <linux/pm_runtime.h>
 #include <linux/clk.h>
 #include <linux/gpio/consumer.h>
+#include <linux/hpd-notifier.h>
 #include <linux/regulator/consumer.h>
 #include <linux/io.h>
 #include <linux/of_address.h>
@@ -118,6 +119,7 @@ struct hdmi_context {
 	bool				dvi_mode;
 	struct delayed_work		hotplug_work;
 	struct drm_display_mode		current_mode;
+	struct hpd_notifier		*notifier;
 	const struct hdmi_driver_data	*drv_data;
 
 	void __iomem			*regs;
@@ -807,9 +809,12 @@ static enum drm_connector_status hdmi_detect(struct drm_connector *connector,
 {
 	struct hdmi_context *hdata = connector_to_hdmi(connector);
 
-	if (gpiod_get_value(hdata->hpd_gpio))
+	if (gpiod_get_value(hdata->hpd_gpio)) {
+		hpd_event_connect(hdata->notifier);
 		return connector_status_connected;
+	}
 
+	hpd_event_disconnect(hdata->notifier);
 	return connector_status_disconnected;
 }
 
@@ -848,6 +853,8 @@ static int hdmi_get_modes(struct drm_connector *connector)
 		edid->width_cm, edid->height_cm);
 
 	drm_mode_connector_update_edid_property(connector, edid);
+	hpd_event_new_edid(hdata->notifier, edid,
+			    EDID_LENGTH * (1 + edid->extensions));
 
 	ret = drm_add_edid_modes(connector, edid);
 
@@ -1483,6 +1490,7 @@ static void hdmi_disable(struct drm_encoder *encoder)
 	if (funcs && funcs->disable)
 		(*funcs->disable)(crtc);
 
+	hpd_event_disconnect(hdata->notifier);
 	cancel_delayed_work(&hdata->hotplug_work);
 
 	hdmiphy_disable(hdata);
@@ -1832,15 +1840,22 @@ static int hdmi_probe(struct platform_device *pdev)
 		}
 	}
 
+	hdata->notifier = hpd_notifier_get(&pdev->dev);
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
+	hpd_notifier_put(hdata->notifier);
 	pm_runtime_disable(dev);
 
 err_hdmiphy:
@@ -1859,9 +1874,11 @@ static int hdmi_remove(struct platform_device *pdev)
 	struct hdmi_context *hdata = platform_get_drvdata(pdev);
 
 	cancel_delayed_work_sync(&hdata->hotplug_work);
+	hpd_event_disconnect(hdata->notifier);
 
 	component_del(&pdev->dev, &hdmi_component_ops);
 
+	hpd_notifier_put(hdata->notifier);
 	pm_runtime_disable(&pdev->dev);
 
 	if (!IS_ERR(hdata->reg_hdmi_en))
-- 
2.11.0

