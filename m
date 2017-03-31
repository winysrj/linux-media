Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:51129 "EHLO
        lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933142AbdCaMUw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 31 Mar 2017 08:20:52 -0400
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
Subject: [PATCHv6 07/10] sti: hdmi: add CEC notifier support
Date: Fri, 31 Mar 2017 14:20:33 +0200
Message-Id: <20170331122036.55706-8-hverkuil@xs4all.nl>
In-Reply-To: <20170331122036.55706-1-hverkuil@xs4all.nl>
References: <20170331122036.55706-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Benjamin Gaignard <benjamin.gaignard@linaro.org>

Implement the CEC notifier support to allow CEC drivers to
be informed when there is a new physical address.

Signed-off-by: Benjamin Gaignard <benjamin.gaignard@linaro.org>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
---
 drivers/gpu/drm/sti/sti_hdmi.c | 11 +++++++++++
 drivers/gpu/drm/sti/sti_hdmi.h |  3 +++
 2 files changed, 14 insertions(+)

diff --git a/drivers/gpu/drm/sti/sti_hdmi.c b/drivers/gpu/drm/sti/sti_hdmi.c
index ce2dcba679d5..243905b6ae59 100644
--- a/drivers/gpu/drm/sti/sti_hdmi.c
+++ b/drivers/gpu/drm/sti/sti_hdmi.c
@@ -771,6 +771,8 @@ static void sti_hdmi_disable(struct drm_bridge *bridge)
 	clk_disable_unprepare(hdmi->clk_pix);
 
 	hdmi->enabled = false;
+
+	cec_notifier_set_phys_addr(hdmi->notifier, CEC_PHYS_ADDR_INVALID);
 }
 
 /**
@@ -973,6 +975,7 @@ static int sti_hdmi_connector_get_modes(struct drm_connector *connector)
 	DRM_DEBUG_KMS("%s : %dx%d cm\n",
 		      (hdmi->hdmi_monitor ? "hdmi monitor" : "dvi monitor"),
 		      edid->width_cm, edid->height_cm);
+	cec_notifier_set_phys_addr_from_edid(hdmi->notifier, edid);
 
 	count = drm_add_edid_modes(connector, edid);
 	drm_mode_connector_update_edid_property(connector, edid);
@@ -1035,6 +1038,7 @@ sti_hdmi_connector_detect(struct drm_connector *connector, bool force)
 	}
 
 	DRM_DEBUG_DRIVER("hdmi cable disconnected\n");
+	cec_notifier_set_phys_addr(hdmi->notifier, CEC_PHYS_ADDR_INVALID);
 	return connector_status_disconnected;
 }
 
@@ -1423,6 +1427,10 @@ static int sti_hdmi_probe(struct platform_device *pdev)
 		goto release_adapter;
 	}
 
+	hdmi->notifier = cec_notifier_get(&pdev->dev);
+	if (!hdmi->notifier)
+		goto release_adapter;
+
 	hdmi->reset = devm_reset_control_get(dev, "hdmi");
 	/* Take hdmi out of reset */
 	if (!IS_ERR(hdmi->reset))
@@ -1442,11 +1450,14 @@ static int sti_hdmi_remove(struct platform_device *pdev)
 {
 	struct sti_hdmi *hdmi = dev_get_drvdata(&pdev->dev);
 
+	cec_notifier_set_phys_addr(hdmi->notifier, CEC_PHYS_ADDR_INVALID);
+
 	i2c_put_adapter(hdmi->ddc_adapt);
 	if (hdmi->audio_pdev)
 		platform_device_unregister(hdmi->audio_pdev);
 	component_del(&pdev->dev, &sti_hdmi_ops);
 
+	cec_notifier_put(hdmi->notifier);
 	return 0;
 }
 
diff --git a/drivers/gpu/drm/sti/sti_hdmi.h b/drivers/gpu/drm/sti/sti_hdmi.h
index 407012350f1a..c6469b56ce7e 100644
--- a/drivers/gpu/drm/sti/sti_hdmi.h
+++ b/drivers/gpu/drm/sti/sti_hdmi.h
@@ -11,6 +11,7 @@
 #include <linux/platform_device.h>
 
 #include <drm/drmP.h>
+#include <media/cec-notifier.h>
 
 #define HDMI_STA           0x0010
 #define HDMI_STA_DLL_LCK   BIT(5)
@@ -64,6 +65,7 @@ static const struct drm_prop_enum_list colorspace_mode_names[] = {
  * @audio_pdev: ASoC hdmi-codec platform device
  * @audio: hdmi audio parameters.
  * @drm_connector: hdmi connector
+ * @notifier: hotplug detect notifier
  */
 struct sti_hdmi {
 	struct device dev;
@@ -89,6 +91,7 @@ struct sti_hdmi {
 	struct platform_device *audio_pdev;
 	struct hdmi_audio_params audio;
 	struct drm_connector *drm_connector;
+	struct cec_notifier *notifier;
 };
 
 u32 hdmi_read(struct sti_hdmi *hdmi, int offset);
-- 
2.11.0
