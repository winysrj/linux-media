Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:41503 "EHLO
        lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751898AbdDNKZ0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Apr 2017 06:25:26 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>,
        dri-devel@lists.freedesktop.org,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 4/8] omapdrm: hdmi4: make low-level functions available
Date: Fri, 14 Apr 2017 12:25:08 +0200
Message-Id: <20170414102512.48834-5-hverkuil@xs4all.nl>
In-Reply-To: <20170414102512.48834-1-hverkuil@xs4all.nl>
References: <20170414102512.48834-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Three low-level functions in hdmi4.c and hdmi4_core.c are
made available for use by the OMAP4 CEC support.

Renamed the prefix to hdmi4 since these are OMAP4 specific.

These function deal with the HDMI core and are needed to
power it up for use with CEC, even when the HPD is low.

Background: even if the HPD is low it should still be possible
to use CEC. Some displays will set the HPD low when they go into standby or
when they switch to another input, but CEC is still available and able
to wake up/change input for such a display.

This is explicitly allowed by the CEC standard.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/gpu/drm/omapdrm/dss/hdmi4.c      | 12 ++++++------
 drivers/gpu/drm/omapdrm/dss/hdmi4_core.c |  6 +++---
 drivers/gpu/drm/omapdrm/dss/hdmi4_core.h |  4 ++++
 3 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/omapdrm/dss/hdmi4.c b/drivers/gpu/drm/omapdrm/dss/hdmi4.c
index e7162c16de2e..bd6075e34c94 100644
--- a/drivers/gpu/drm/omapdrm/dss/hdmi4.c
+++ b/drivers/gpu/drm/omapdrm/dss/hdmi4.c
@@ -393,11 +393,11 @@ static void hdmi_display_disable(struct omap_dss_device *dssdev)
 	mutex_unlock(&hdmi.lock);
 }
 
-static int hdmi_core_enable(struct omap_dss_device *dssdev)
+int hdmi4_core_enable(struct omap_dss_device *dssdev)
 {
 	int r = 0;
 
-	DSSDBG("ENTER omapdss_hdmi_core_enable\n");
+	DSSDBG("ENTER omapdss_hdmi4_core_enable\n");
 
 	mutex_lock(&hdmi.lock);
 
@@ -415,9 +415,9 @@ static int hdmi_core_enable(struct omap_dss_device *dssdev)
 	return r;
 }
 
-static void hdmi_core_disable(struct omap_dss_device *dssdev)
+void hdmi4_core_disable(struct omap_dss_device *dssdev)
 {
-	DSSDBG("Enter omapdss_hdmi_core_disable\n");
+	DSSDBG("Enter omapdss_hdmi4_core_disable\n");
 
 	mutex_lock(&hdmi.lock);
 
@@ -475,7 +475,7 @@ static int hdmi_read_edid(struct omap_dss_device *dssdev,
 	need_enable = hdmi.core_enabled == false;
 
 	if (need_enable) {
-		r = hdmi_core_enable(dssdev);
+		r = hdmi4_core_enable(dssdev);
 		if (r)
 			return r;
 	}
@@ -483,7 +483,7 @@ static int hdmi_read_edid(struct omap_dss_device *dssdev,
 	r = read_edid(edid, len);
 
 	if (need_enable)
-		hdmi_core_disable(dssdev);
+		hdmi4_core_disable(dssdev);
 
 	return r;
 }
diff --git a/drivers/gpu/drm/omapdrm/dss/hdmi4_core.c b/drivers/gpu/drm/omapdrm/dss/hdmi4_core.c
index e05b7ac4f7dd..130b6dc3f184 100644
--- a/drivers/gpu/drm/omapdrm/dss/hdmi4_core.c
+++ b/drivers/gpu/drm/omapdrm/dss/hdmi4_core.c
@@ -208,9 +208,9 @@ static void hdmi_core_init(struct hdmi_core_video_config *video_cfg)
 	video_cfg->tclk_sel_clkmult = HDMI_FPLL10IDCK;
 }
 
-static void hdmi_core_powerdown_disable(struct hdmi_core_data *core)
+void hdmi4_core_powerdown_disable(struct hdmi_core_data *core)
 {
-	DSSDBG("Enter hdmi_core_powerdown_disable\n");
+	DSSDBG("Enter hdmi4_core_powerdown_disable\n");
 	REG_FLD_MOD(core->base, HDMI_CORE_SYS_SYS_CTRL1, 0x1, 0, 0);
 }
 
@@ -336,7 +336,7 @@ void hdmi4_configure(struct hdmi_core_data *core,
 	hdmi_core_swreset_assert(core);
 
 	/* power down off */
-	hdmi_core_powerdown_disable(core);
+	hdmi4_core_powerdown_disable(core);
 
 	v_core_cfg.pkt_mode = HDMI_PACKETMODE24BITPERPIXEL;
 	v_core_cfg.hdmi_dvi = cfg->hdmi_dvi_mode;
diff --git a/drivers/gpu/drm/omapdrm/dss/hdmi4_core.h b/drivers/gpu/drm/omapdrm/dss/hdmi4_core.h
index a069f96ec6f6..b6ab579e44d2 100644
--- a/drivers/gpu/drm/omapdrm/dss/hdmi4_core.h
+++ b/drivers/gpu/drm/omapdrm/dss/hdmi4_core.h
@@ -266,6 +266,10 @@ void hdmi4_configure(struct hdmi_core_data *core, struct hdmi_wp_data *wp,
 void hdmi4_core_dump(struct hdmi_core_data *core, struct seq_file *s);
 int hdmi4_core_init(struct platform_device *pdev, struct hdmi_core_data *core);
 
+int hdmi4_core_enable(struct omap_dss_device *dssdev);
+void hdmi4_core_disable(struct omap_dss_device *dssdev);
+void hdmi4_core_powerdown_disable(struct hdmi_core_data *core);
+
 int hdmi4_audio_start(struct hdmi_core_data *core, struct hdmi_wp_data *wp);
 void hdmi4_audio_stop(struct hdmi_core_data *core, struct hdmi_wp_data *wp);
 int hdmi4_audio_config(struct hdmi_core_data *core, struct hdmi_wp_data *wp,
-- 
2.11.0
