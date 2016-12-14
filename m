Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wj0-f179.google.com ([209.85.210.179]:33783 "EHLO
        mail-wj0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755403AbcLNM67 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Dec 2016 07:58:59 -0500
Received: by mail-wj0-f179.google.com with SMTP id xy5so32280678wjc.0
        for <linux-media@vger.kernel.org>; Wed, 14 Dec 2016 04:57:21 -0800 (PST)
From: Benjamin Gaignard <benjamin.gaignard@linaro.org>
To: linux-media@vger.kernel.org, hverkuil@xs4all.nl
Cc: linux@armlinux.org.uk, linux-fbdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org, kernel@stlinux.com,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: [PATCH 1/2] sti: hdmi: add HDMI notifier support
Date: Wed, 14 Dec 2016 13:57:08 +0100
Message-Id: <1481720229-7587-2-git-send-email-benjamin.gaignard@linaro.org>
In-Reply-To: <1481720229-7587-1-git-send-email-benjamin.gaignard@linaro.org>
References: <1481720229-7587-1-git-send-email-benjamin.gaignard@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Implement the HDMI notifier support to allow CEC drivers to
be informed when there is a new EDID and when a connect or
disconnect happens.

Signed-off-by: Benjamin Gaignard <benjamin.gaignard@linaro.org>
---
 drivers/gpu/drm/sti/Kconfig    |  1 +
 drivers/gpu/drm/sti/sti_hdmi.c | 15 +++++++++++++++
 drivers/gpu/drm/sti/sti_hdmi.h |  2 ++
 3 files changed, 18 insertions(+)

diff --git a/drivers/gpu/drm/sti/Kconfig b/drivers/gpu/drm/sti/Kconfig
index acd7286..59ceffc 100644
--- a/drivers/gpu/drm/sti/Kconfig
+++ b/drivers/gpu/drm/sti/Kconfig
@@ -8,5 +8,6 @@ config DRM_STI
 	select DRM_PANEL
 	select FW_LOADER
 	select SND_SOC_HDMI_CODEC if SND_SOC
+	select HDMI_NOTIFIERS
 	help
 	  Choose this option to enable DRM on STM stiH4xx chipset
diff --git a/drivers/gpu/drm/sti/sti_hdmi.c b/drivers/gpu/drm/sti/sti_hdmi.c
index 376b076..6667371 100644
--- a/drivers/gpu/drm/sti/sti_hdmi.c
+++ b/drivers/gpu/drm/sti/sti_hdmi.c
@@ -786,6 +786,8 @@ static void sti_hdmi_disable(struct drm_bridge *bridge)
 	clk_disable_unprepare(hdmi->clk_pix);
 
 	hdmi->enabled = false;
+
+	hdmi_event_disconnect(hdmi->notifier);
 }
 
 static void sti_hdmi_pre_enable(struct drm_bridge *bridge)
@@ -892,6 +894,10 @@ static int sti_hdmi_connector_get_modes(struct drm_connector *connector)
 	if (!edid)
 		goto fail;
 
+	hdmi_event_connect(hdmi->notifier);
+	hdmi_event_new_edid(hdmi->notifier, edid,
+			    EDID_LENGTH * (edid->extensions + 1));
+
 	count = drm_add_edid_modes(connector, edid);
 	drm_mode_connector_update_edid_property(connector, edid);
 	drm_edid_to_eld(connector, edid);
@@ -949,10 +955,12 @@ struct drm_connector_helper_funcs sti_hdmi_connector_helper_funcs = {
 
 	if (hdmi->hpd) {
 		DRM_DEBUG_DRIVER("hdmi cable connected\n");
+		hdmi_event_connect(hdmi->notifier);
 		return connector_status_connected;
 	}
 
 	DRM_DEBUG_DRIVER("hdmi cable disconnected\n");
+	hdmi_event_disconnect(hdmi->notifier);
 	return connector_status_disconnected;
 }
 
@@ -1464,6 +1472,10 @@ static int sti_hdmi_probe(struct platform_device *pdev)
 		goto release_adapter;
 	}
 
+	hdmi->notifier = hdmi_notifier_get(&pdev->dev);
+	if (!hdmi->notifier)
+		goto release_adapter;
+
 	hdmi->reset = devm_reset_control_get(dev, "hdmi");
 	/* Take hdmi out of reset */
 	if (!IS_ERR(hdmi->reset))
@@ -1483,11 +1495,14 @@ static int sti_hdmi_remove(struct platform_device *pdev)
 {
 	struct sti_hdmi *hdmi = dev_get_drvdata(&pdev->dev);
 
+	hdmi_event_disconnect(hdmi->notifier);
+
 	i2c_put_adapter(hdmi->ddc_adapt);
 	if (hdmi->audio_pdev)
 		platform_device_unregister(hdmi->audio_pdev);
 	component_del(&pdev->dev, &sti_hdmi_ops);
 
+	hdmi_notifier_put(hdmi->notifier);
 	return 0;
 }
 
diff --git a/drivers/gpu/drm/sti/sti_hdmi.h b/drivers/gpu/drm/sti/sti_hdmi.h
index 119bc35..70aac98 100644
--- a/drivers/gpu/drm/sti/sti_hdmi.h
+++ b/drivers/gpu/drm/sti/sti_hdmi.h
@@ -8,6 +8,7 @@
 #define _STI_HDMI_H_
 
 #include <linux/hdmi.h>
+#include <linux/hdmi-notifier.h>
 #include <linux/platform_device.h>
 
 #include <drm/drmP.h>
@@ -102,6 +103,7 @@ struct sti_hdmi {
 	struct platform_device *audio_pdev;
 	struct hdmi_audio_params audio;
 	struct drm_connector *drm_connector;
+	struct hdmi_notifier *notifier;
 };
 
 u32 hdmi_read(struct sti_hdmi *hdmi, int offset);
-- 
1.9.1

