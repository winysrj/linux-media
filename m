Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:51221 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750957AbdHQNUC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 Aug 2017 09:20:02 -0400
Subject: [PATCHv3 9/9] omapdrm: omapdss_hdmi_ops: add lost_hotplug op
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>,
        dri-devel@lists.freedesktop.org,
        Hans Verkuil <hans.verkuil@cisco.com>
References: <20170802085408.16204-1-hverkuil@xs4all.nl>
 <20170802085408.16204-10-hverkuil@xs4all.nl>
Message-ID: <2323dc23-8a9e-9885-55c1-174a39e2e61e@xs4all.nl>
Date: Thu, 17 Aug 2017 15:19:57 +0200
MIME-Version: 1.0
In-Reply-To: <20170802085408.16204-10-hverkuil@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The CEC framework needs to know when the hotplug detect signal
disappears, since that means the CEC physical address has to be
invalidated (i.e. set to f.f.f.f).

Add a lost_hotplug op that is called when the HPD signal goes away.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
Change since v2: check that the lost_hotplug callback is set before
calling it in encoder-tpd12s015.c.
---
 drivers/gpu/drm/omapdrm/displays/connector-hdmi.c    | 8 ++++++--
 drivers/gpu/drm/omapdrm/displays/encoder-tpd12s015.c | 6 +++++-
 drivers/gpu/drm/omapdrm/dss/hdmi4.c                  | 8 ++++++--
 drivers/gpu/drm/omapdrm/dss/omapdss.h                | 1 +
 4 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/omapdrm/displays/connector-hdmi.c b/drivers/gpu/drm/omapdrm/displays/connector-hdmi.c
index d9d25df6fc1b..4600d3841c25 100644
--- a/drivers/gpu/drm/omapdrm/displays/connector-hdmi.c
+++ b/drivers/gpu/drm/omapdrm/displays/connector-hdmi.c
@@ -165,11 +165,15 @@ static bool hdmic_detect(struct omap_dss_device *dssdev)
 {
 	struct panel_drv_data *ddata = to_panel_data(dssdev);
 	struct omap_dss_device *in = ddata->in;
+	bool connected;

 	if (gpio_is_valid(ddata->hpd_gpio))
-		return gpio_get_value_cansleep(ddata->hpd_gpio);
+		connected = gpio_get_value_cansleep(ddata->hpd_gpio);
 	else
-		return in->ops.hdmi->detect(in);
+		connected = in->ops.hdmi->detect(in);
+	if (!connected && in->ops.hdmi->lost_hotplug)
+		in->ops.hdmi->lost_hotplug(in);
+	return connected;
 }

 static int hdmic_register_hpd_cb(struct omap_dss_device *dssdev,
diff --git a/drivers/gpu/drm/omapdrm/displays/encoder-tpd12s015.c b/drivers/gpu/drm/omapdrm/displays/encoder-tpd12s015.c
index 293b8fd07cfc..e3d98d78fc40 100644
--- a/drivers/gpu/drm/omapdrm/displays/encoder-tpd12s015.c
+++ b/drivers/gpu/drm/omapdrm/displays/encoder-tpd12s015.c
@@ -159,8 +159,12 @@ static int tpd_read_edid(struct omap_dss_device *dssdev,
 static bool tpd_detect(struct omap_dss_device *dssdev)
 {
 	struct panel_drv_data *ddata = to_panel_data(dssdev);
+	struct omap_dss_device *in = ddata->in;
+	bool connected = gpiod_get_value_cansleep(ddata->hpd_gpio);

-	return gpiod_get_value_cansleep(ddata->hpd_gpio);
+	if (!connected && in->ops.hdmi->lost_hotplug)
+		in->ops.hdmi->lost_hotplug(in);
+	return connected;
 }

 static int tpd_register_hpd_cb(struct omap_dss_device *dssdev,
diff --git a/drivers/gpu/drm/omapdrm/dss/hdmi4.c b/drivers/gpu/drm/omapdrm/dss/hdmi4.c
index e535010218e6..0eeba0d1a2f5 100644
--- a/drivers/gpu/drm/omapdrm/dss/hdmi4.c
+++ b/drivers/gpu/drm/omapdrm/dss/hdmi4.c
@@ -402,8 +402,6 @@ static void hdmi_display_disable(struct omap_dss_device *dssdev)

 	DSSDBG("Enter hdmi_display_disable\n");

-	hdmi4_cec_set_phys_addr(&hdmi.core, CEC_PHYS_ADDR_INVALID);
-
 	mutex_lock(&hdmi.lock);

 	spin_lock_irqsave(&hdmi.audio_playing_lock, flags);
@@ -515,6 +513,11 @@ static int hdmi_read_edid(struct omap_dss_device *dssdev,
 	return r;
 }

+static void hdmi_lost_hotplug(struct omap_dss_device *dssdev)
+{
+	hdmi4_cec_set_phys_addr(&hdmi.core, CEC_PHYS_ADDR_INVALID);
+}
+
 static int hdmi_set_infoframe(struct omap_dss_device *dssdev,
 		const struct hdmi_avi_infoframe *avi)
 {
@@ -541,6 +544,7 @@ static const struct omapdss_hdmi_ops hdmi_ops = {
 	.get_timings		= hdmi_display_get_timings,

 	.read_edid		= hdmi_read_edid,
+	.lost_hotplug		= hdmi_lost_hotplug,
 	.set_infoframe		= hdmi_set_infoframe,
 	.set_hdmi_mode		= hdmi_set_hdmi_mode,
 };
diff --git a/drivers/gpu/drm/omapdrm/dss/omapdss.h b/drivers/gpu/drm/omapdrm/dss/omapdss.h
index b9b0bb27069a..482a385894d7 100644
--- a/drivers/gpu/drm/omapdrm/dss/omapdss.h
+++ b/drivers/gpu/drm/omapdrm/dss/omapdss.h
@@ -402,6 +402,7 @@ struct omapdss_hdmi_ops {
 			    struct videomode *vm);

 	int (*read_edid)(struct omap_dss_device *dssdev, u8 *buf, int len);
+	void (*lost_hotplug)(struct omap_dss_device *dssdev);
 	bool (*detect)(struct omap_dss_device *dssdev);

 	int (*register_hpd_cb)(struct omap_dss_device *dssdev,
-- 
2.14.1
