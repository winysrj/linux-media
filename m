Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:38468 "EHLO
        lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751087AbdGPKsH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 16 Jul 2017 06:48:07 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, Eric Anholt <eric@anholt.net>,
        boris.brezillon@free-electrons.com,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 2/3] drm/vc4: prepare for CEC support
Date: Sun, 16 Jul 2017 12:48:03 +0200
Message-Id: <20170716104804.48308-3-hverkuil@xs4all.nl>
In-Reply-To: <20170716104804.48308-1-hverkuil@xs4all.nl>
References: <20170716104804.48308-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

In order to support CEC the hsm clock needs to be enabled in
vc4_hdmi_bind(), not in vc4_hdmi_encoder_enable(). Otherwise you wouldn't
be able to support CEC when there is no hotplug detect signal, which is
required by some monitors that turn off the HPD when in standby, but keep
the CEC bus alive so they can be woken up.

The HDMI core also has to be enabled in vc4_hdmi_bind() for the same
reason.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/gpu/drm/vc4/vc4_hdmi.c | 59 +++++++++++++++++++++---------------------
 1 file changed, 29 insertions(+), 30 deletions(-)

diff --git a/drivers/gpu/drm/vc4/vc4_hdmi.c b/drivers/gpu/drm/vc4/vc4_hdmi.c
index ed63d4e85762..e0104f96011e 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -463,11 +463,6 @@ static void vc4_hdmi_encoder_disable(struct drm_encoder *encoder)
 	HD_WRITE(VC4_HD_VID_CTL,
 		 HD_READ(VC4_HD_VID_CTL) & ~VC4_HD_VID_CTL_ENABLE);
 
-	HD_WRITE(VC4_HD_M_CTL, VC4_HD_M_SW_RST);
-	udelay(1);
-	HD_WRITE(VC4_HD_M_CTL, 0);
-
-	clk_disable_unprepare(hdmi->hsm_clock);
 	clk_disable_unprepare(hdmi->pixel_clock);
 
 	ret = pm_runtime_put(&hdmi->pdev->dev);
@@ -509,16 +504,6 @@ static void vc4_hdmi_encoder_enable(struct drm_encoder *encoder)
 		return;
 	}
 
-	/* This is the rate that is set by the firmware.  The number
-	 * needs to be a bit higher than the pixel clock rate
-	 * (generally 148.5Mhz).
-	 */
-	ret = clk_set_rate(hdmi->hsm_clock, 163682864);
-	if (ret) {
-		DRM_ERROR("Failed to set HSM clock rate: %d\n", ret);
-		return;
-	}
-
 	ret = clk_set_rate(hdmi->pixel_clock,
 			   mode->clock * 1000 *
 			   ((mode->flags & DRM_MODE_FLAG_DBLCLK) ? 2 : 1));
@@ -533,20 +518,6 @@ static void vc4_hdmi_encoder_enable(struct drm_encoder *encoder)
 		return;
 	}
 
-	ret = clk_prepare_enable(hdmi->hsm_clock);
-	if (ret) {
-		DRM_ERROR("Failed to turn on HDMI state machine clock: %d\n",
-			  ret);
-		clk_disable_unprepare(hdmi->pixel_clock);
-		return;
-	}
-
-	HD_WRITE(VC4_HD_M_CTL, VC4_HD_M_SW_RST);
-	udelay(1);
-	HD_WRITE(VC4_HD_M_CTL, 0);
-
-	HD_WRITE(VC4_HD_M_CTL, VC4_HD_M_ENABLE);
-
 	HDMI_WRITE(VC4_HDMI_SW_RESET_CONTROL,
 		   VC4_HDMI_SW_RESET_HDMI |
 		   VC4_HDMI_SW_RESET_FORMAT_DETECT);
@@ -1205,6 +1176,23 @@ static int vc4_hdmi_bind(struct device *dev, struct device *master, void *data)
 		return -EPROBE_DEFER;
 	}
 
+	/* This is the rate that is set by the firmware.  The number
+	 * needs to be a bit higher than the pixel clock rate
+	 * (generally 148.5Mhz).
+	 */
+	ret = clk_set_rate(hdmi->hsm_clock, 163682864);
+	if (ret) {
+		DRM_ERROR("Failed to set HSM clock rate: %d\n", ret);
+		goto err_put_i2c;
+	}
+
+	ret = clk_prepare_enable(hdmi->hsm_clock);
+	if (ret) {
+		DRM_ERROR("Failed to turn on HDMI state machine clock: %d\n",
+			  ret);
+		goto err_put_i2c;
+	}
+
 	/* Only use the GPIO HPD pin if present in the DT, otherwise
 	 * we'll use the HDMI core's register.
 	 */
@@ -1216,7 +1204,7 @@ static int vc4_hdmi_bind(struct device *dev, struct device *master, void *data)
 							 &hpd_gpio_flags);
 		if (hdmi->hpd_gpio < 0) {
 			ret = hdmi->hpd_gpio;
-			goto err_put_i2c;
+			goto err_unprepare_hsm;
 		}
 
 		hdmi->hpd_active_low = hpd_gpio_flags & OF_GPIO_ACTIVE_LOW;
@@ -1224,6 +1212,14 @@ static int vc4_hdmi_bind(struct device *dev, struct device *master, void *data)
 
 	vc4->hdmi = hdmi;
 
+	/* HDMI core must be enabled. */
+	if (!(HD_READ(VC4_HD_M_CTL) & VC4_HD_M_ENABLE)) {
+		HD_WRITE(VC4_HD_M_CTL, VC4_HD_M_SW_RST);
+		udelay(1);
+		HD_WRITE(VC4_HD_M_CTL, 0);
+
+		HD_WRITE(VC4_HD_M_CTL, VC4_HD_M_ENABLE);
+	}
 	pm_runtime_enable(dev);
 
 	drm_encoder_init(drm, hdmi->encoder, &vc4_hdmi_encoder_funcs,
@@ -1244,6 +1240,8 @@ static int vc4_hdmi_bind(struct device *dev, struct device *master, void *data)
 
 err_destroy_encoder:
 	vc4_hdmi_encoder_destroy(hdmi->encoder);
+err_unprepare_hsm:
+	clk_disable_unprepare(hdmi->hsm_clock);
 	pm_runtime_disable(dev);
 err_put_i2c:
 	put_device(&hdmi->ddc->dev);
@@ -1263,6 +1261,7 @@ static void vc4_hdmi_unbind(struct device *dev, struct device *master,
 	vc4_hdmi_connector_destroy(hdmi->connector);
 	vc4_hdmi_encoder_destroy(hdmi->encoder);
 
+	clk_disable_unprepare(hdmi->hsm_clock);
 	pm_runtime_disable(dev);
 
 	put_device(&hdmi->ddc->dev);
-- 
2.13.2
