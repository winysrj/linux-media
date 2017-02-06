Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:56092 "EHLO
        lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751805AbdBFKaS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 6 Feb 2017 05:30:18 -0500
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
Subject: [PATCHv4 7/9] sti: hdmi: add HPD notifier support
Date: Mon,  6 Feb 2017 11:29:49 +0100
Message-Id: <20170206102951.12623-8-hverkuil@xs4all.nl>
In-Reply-To: <20170206102951.12623-1-hverkuil@xs4all.nl>
References: <20170206102951.12623-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Benjamin Gaignard <benjamin.gaignard@linaro.org>

Implement the HPD notifier support to allow CEC drivers to
be informed when there is a new EDID and when a connect or
disconnect happens.

Signed-off-by: Benjamin Gaignard <benjamin.gaignard@linaro.org>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/gpu/drm/sti/Kconfig    |  1 +
 drivers/gpu/drm/sti/sti_hdmi.c | 14 ++++++++++++++
 drivers/gpu/drm/sti/sti_hdmi.h |  3 +++
 3 files changed, 18 insertions(+)

diff --git a/drivers/gpu/drm/sti/Kconfig b/drivers/gpu/drm/sti/Kconfig
index acd72865feac..f5c9572b4169 100644
--- a/drivers/gpu/drm/sti/Kconfig
+++ b/drivers/gpu/drm/sti/Kconfig
@@ -8,5 +8,6 @@ config DRM_STI
 	select DRM_PANEL
 	select FW_LOADER
 	select SND_SOC_HDMI_CODEC if SND_SOC
+	select HPD_NOTIFIER
 	help
 	  Choose this option to enable DRM on STM stiH4xx chipset
diff --git a/drivers/gpu/drm/sti/sti_hdmi.c b/drivers/gpu/drm/sti/sti_hdmi.c
index 376b0763c874..d32a38362391 100644
--- a/drivers/gpu/drm/sti/sti_hdmi.c
+++ b/drivers/gpu/drm/sti/sti_hdmi.c
@@ -786,6 +786,8 @@ static void sti_hdmi_disable(struct drm_bridge *bridge)
 	clk_disable_unprepare(hdmi->clk_pix);
 
 	hdmi->enabled = false;
+
+	hpd_event_disconnect(hdmi->notifier);
 }
 
 static void sti_hdmi_pre_enable(struct drm_bridge *bridge)
@@ -892,6 +894,9 @@ static int sti_hdmi_connector_get_modes(struct drm_connector *connector)
 	if (!edid)
 		goto fail;
 
+	hpd_event_new_edid(hdmi->notifier, edid,
+			   EDID_LENGTH * (edid->extensions + 1));
+
 	count = drm_add_edid_modes(connector, edid);
 	drm_mode_connector_update_edid_property(connector, edid);
 	drm_edid_to_eld(connector, edid);
@@ -949,10 +954,12 @@ sti_hdmi_connector_detect(struct drm_connector *connector, bool force)
 
 	if (hdmi->hpd) {
 		DRM_DEBUG_DRIVER("hdmi cable connected\n");
+		hpd_event_connect(hdmi->notifier);
 		return connector_status_connected;
 	}
 
 	DRM_DEBUG_DRIVER("hdmi cable disconnected\n");
+	hpd_event_disconnect(hdmi->notifier);
 	return connector_status_disconnected;
 }
 
@@ -1464,6 +1471,10 @@ static int sti_hdmi_probe(struct platform_device *pdev)
 		goto release_adapter;
 	}
 
+	hdmi->notifier = hpd_notifier_get(&pdev->dev);
+	if (!hdmi->notifier)
+		goto release_adapter;
+
 	hdmi->reset = devm_reset_control_get(dev, "hdmi");
 	/* Take hdmi out of reset */
 	if (!IS_ERR(hdmi->reset))
@@ -1483,11 +1494,14 @@ static int sti_hdmi_remove(struct platform_device *pdev)
 {
 	struct sti_hdmi *hdmi = dev_get_drvdata(&pdev->dev);
 
+	hpd_event_disconnect(hdmi->notifier);
+
 	i2c_put_adapter(hdmi->ddc_adapt);
 	if (hdmi->audio_pdev)
 		platform_device_unregister(hdmi->audio_pdev);
 	component_del(&pdev->dev, &sti_hdmi_ops);
 
+	hpd_notifier_put(hdmi->notifier);
 	return 0;
 }
 
diff --git a/drivers/gpu/drm/sti/sti_hdmi.h b/drivers/gpu/drm/sti/sti_hdmi.h
index 119bc3582ac7..2109c97eb933 100644
--- a/drivers/gpu/drm/sti/sti_hdmi.h
+++ b/drivers/gpu/drm/sti/sti_hdmi.h
@@ -8,6 +8,7 @@
 #define _STI_HDMI_H_
 
 #include <linux/hdmi.h>
+#include <linux/hpd-notifier.h>
 #include <linux/platform_device.h>
 
 #include <drm/drmP.h>
@@ -77,6 +78,7 @@ static const struct drm_prop_enum_list colorspace_mode_names[] = {
  * @audio_pdev: ASoC hdmi-codec platform device
  * @audio: hdmi audio parameters.
  * @drm_connector: hdmi connector
+ * @notifier: hotplug detect notifier
  */
 struct sti_hdmi {
 	struct device dev;
@@ -102,6 +104,7 @@ struct sti_hdmi {
 	struct platform_device *audio_pdev;
 	struct hdmi_audio_params audio;
 	struct drm_connector *drm_connector;
+	struct hpd_notifier *notifier;
 };
 
 u32 hdmi_read(struct sti_hdmi *hdmi, int offset);
-- 
2.11.0

