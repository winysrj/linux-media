Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:46145 "EHLO
        lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751898AbdDNKZ3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Apr 2017 06:25:29 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>,
        dri-devel@lists.freedesktop.org,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 6/8] omapdrm: hdmi4: refcount hdmi_power_on/off_core
Date: Fri, 14 Apr 2017 12:25:10 +0200
Message-Id: <20170414102512.48834-7-hverkuil@xs4all.nl>
In-Reply-To: <20170414102512.48834-1-hverkuil@xs4all.nl>
References: <20170414102512.48834-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The hdmi_power_on/off_core functions can be called multiple times:
when the HPD changes and when the HDMI CEC support needs to power
the HDMI core.

So use a counter to know when to really power on or off the HDMI core.

Also call hdmi4_core_powerdown_disable() in hdmi_power_on_core() to
power up the HDMI core (needed for CEC).

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/gpu/drm/omapdrm/dss/hdmi4.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/omapdrm/dss/hdmi4.c b/drivers/gpu/drm/omapdrm/dss/hdmi4.c
index 4a164dc01f15..e371b47ff6ff 100644
--- a/drivers/gpu/drm/omapdrm/dss/hdmi4.c
+++ b/drivers/gpu/drm/omapdrm/dss/hdmi4.c
@@ -124,14 +124,19 @@ static int hdmi_power_on_core(struct omap_dss_device *dssdev)
 {
 	int r;
 
+	if (hdmi.core.core_pwr_cnt++)
+		return 0;
+
 	r = regulator_enable(hdmi.vdda_reg);
 	if (r)
-		return r;
+		goto err_reg_enable;
 
 	r = hdmi_runtime_get();
 	if (r)
 		goto err_runtime_get;
 
+	hdmi4_core_powerdown_disable(&hdmi.core);
+
 	/* Make selection of HDMI in DSS */
 	dss_select_hdmi_venc_clk_source(DSS_HDMI_M_PCLK);
 
@@ -141,12 +146,17 @@ static int hdmi_power_on_core(struct omap_dss_device *dssdev)
 
 err_runtime_get:
 	regulator_disable(hdmi.vdda_reg);
+err_reg_enable:
+	hdmi.core.core_pwr_cnt--;
 
 	return r;
 }
 
 static void hdmi_power_off_core(struct omap_dss_device *dssdev)
 {
+	if (--hdmi.core.core_pwr_cnt)
+		return;
+
 	hdmi.core_enabled = false;
 
 	hdmi_runtime_put();
-- 
2.11.0
