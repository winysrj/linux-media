Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:38501 "EHLO
        mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755370AbdBQKrE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Feb 2017 05:47:04 -0500
Received: by mail-wm0-f46.google.com with SMTP id r141so7235299wmg.1
        for <linux-media@vger.kernel.org>; Fri, 17 Feb 2017 02:47:03 -0800 (PST)
From: Benjamin Gaignard <benjamin.gaignard@linaro.org>
To: hverkuil@xs4all.nl
Cc: devicetree@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux@armlinux.org.uk, krzk@kernel.org, javier@osg.samsung.com,
        hans.verkuil@cisco.com, dri-devel@lists.freedesktop.org,
        daniel.vetter@intel.com, m.szyprowski@samsung.com,
        linux-media@vger.kernel.org, robh@kernel.org,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: [PATCH v3 1/3] sti: hdmi: add HPD notifier support
Date: Fri, 17 Feb 2017 11:46:50 +0100
Message-Id: <1487328412-8305-2-git-send-email-benjamin.gaignard@linaro.org>
In-Reply-To: <1487328412-8305-1-git-send-email-benjamin.gaignard@linaro.org>
References: <1487328412-8305-1-git-send-email-benjamin.gaignard@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

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
index acd7286..f5c9572 100644
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
index 376b076..d32a383 100644
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
@@ -949,10 +954,12 @@ struct drm_connector_helper_funcs sti_hdmi_connector_helper_funcs = {
 
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
index 119bc35..2109c97 100644
--- a/drivers/gpu/drm/sti/sti_hdmi.h
+++ b/drivers/gpu/drm/sti/sti_hdmi.h
@@ -8,6 +8,7 @@
 #define _STI_HDMI_H_
 
 #include <linux/hdmi.h>
+#include <linux/hpd-notifier.h>
 #include <linux/platform_device.h>
 
 #include <drm/drmP.h>
@@ -77,6 +78,7 @@ enum sti_hdmi_modes {
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
1.9.1
