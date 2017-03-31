Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:49889 "EHLO
        lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754511AbdCaMUt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 31 Mar 2017 08:20:49 -0400
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
        Patrice.chotard@st.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv6 03/10] exynos_hdmi: add CEC notifier support
Date: Fri, 31 Mar 2017 14:20:29 +0200
Message-Id: <20170331122036.55706-4-hverkuil@xs4all.nl>
In-Reply-To: <20170331122036.55706-1-hverkuil@xs4all.nl>
References: <20170331122036.55706-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Implement the CEC notifier support to allow CEC drivers to
be informed when there is a new physical address.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Acked-by: Krzysztof Kozlowski <krzk@kernel.org>
---
 drivers/gpu/drm/exynos/exynos_hdmi.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_hdmi.c b/drivers/gpu/drm/exynos/exynos_hdmi.c
index 88ccc0469316..bc4c8d0a66f4 100644
--- a/drivers/gpu/drm/exynos/exynos_hdmi.c
+++ b/drivers/gpu/drm/exynos/exynos_hdmi.c
@@ -43,6 +43,8 @@
 
 #include <drm/exynos_drm.h>
 
+#include <media/cec-notifier.h>
+
 #include "exynos_drm_drv.h"
 #include "exynos_drm_crtc.h"
 
@@ -119,6 +121,7 @@ struct hdmi_context {
 	bool				dvi_mode;
 	struct delayed_work		hotplug_work;
 	struct drm_display_mode		current_mode;
+	struct cec_notifier		*notifier;
 	const struct hdmi_driver_data	*drv_data;
 
 	void __iomem			*regs;
@@ -822,6 +825,7 @@ static enum drm_connector_status hdmi_detect(struct drm_connector *connector,
 	if (gpiod_get_value(hdata->hpd_gpio))
 		return connector_status_connected;
 
+	cec_notifier_set_phys_addr(hdata->notifier, CEC_PHYS_ADDR_INVALID);
 	return connector_status_disconnected;
 }
 
@@ -860,6 +864,7 @@ static int hdmi_get_modes(struct drm_connector *connector)
 		edid->width_cm, edid->height_cm);
 
 	drm_mode_connector_update_edid_property(connector, edid);
+	cec_notifier_set_phys_addr_from_edid(hdata->notifier, edid);
 
 	ret = drm_add_edid_modes(connector, edid);
 
@@ -1503,6 +1508,7 @@ static void hdmi_disable(struct drm_encoder *encoder)
 	if (funcs && funcs->disable)
 		(*funcs->disable)(crtc);
 
+	cec_notifier_set_phys_addr(hdata->notifier, CEC_PHYS_ADDR_INVALID);
 	cancel_delayed_work(&hdata->hotplug_work);
 
 	hdmiphy_disable(hdata);
@@ -1878,15 +1884,22 @@ static int hdmi_probe(struct platform_device *pdev)
 		}
 	}
 
+	hdata->notifier = cec_notifier_get(&pdev->dev);
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
+	cec_notifier_put(hdata->notifier);
 	pm_runtime_disable(dev);
 
 err_hdmiphy:
@@ -1905,9 +1918,11 @@ static int hdmi_remove(struct platform_device *pdev)
 	struct hdmi_context *hdata = platform_get_drvdata(pdev);
 
 	cancel_delayed_work_sync(&hdata->hotplug_work);
+	cec_notifier_set_phys_addr(hdata->notifier, CEC_PHYS_ADDR_INVALID);
 
 	component_del(&pdev->dev, &hdmi_component_ops);
 
+	cec_notifier_put(hdata->notifier);
 	pm_runtime_disable(&pdev->dev);
 
 	if (!IS_ERR(hdata->reg_hdmi_en))
-- 
2.11.0
