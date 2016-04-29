Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:57446 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752454AbcD2JjS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Apr 2016 05:39:18 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: tomi.valkeinen@ti.com, dri-devel@lists.freedesktop.org,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 3/3] encoder-tpd12s015: keep the ls_oe_gpio on while the phys_addr is valid
Date: Fri, 29 Apr 2016 11:39:06 +0200
Message-Id: <1461922746-17521-4-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1461922746-17521-1-git-send-email-hverkuil@xs4all.nl>
References: <1461922746-17521-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

As long as there is a valid physical address in the EDID and the omap
CEC support is enabled, then we keep ls_oe_gpio on to ensure the CEC
signal is passed through the tpd12s015.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Suggested-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
---
 drivers/gpu/drm/omapdrm/displays/encoder-tpd12s015.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/omapdrm/displays/encoder-tpd12s015.c b/drivers/gpu/drm/omapdrm/displays/encoder-tpd12s015.c
index 916a899..efbba23 100644
--- a/drivers/gpu/drm/omapdrm/displays/encoder-tpd12s015.c
+++ b/drivers/gpu/drm/omapdrm/displays/encoder-tpd12s015.c
@@ -16,6 +16,7 @@
 #include <linux/platform_device.h>
 #include <linux/gpio/consumer.h>
 
+#include <media/cec-edid.h>
 #include <video/omapdss.h>
 #include <video/omap-panel-data.h>
 
@@ -65,6 +66,7 @@ static void tpd_disconnect(struct omap_dss_device *dssdev,
 		return;
 
 	gpiod_set_value_cansleep(ddata->ct_cp_hpd_gpio, 0);
+	gpiod_set_value_cansleep(ddata->ls_oe_gpio, 0);
 
 	dst->src = NULL;
 	dssdev->dst = NULL;
@@ -142,6 +144,7 @@ static int tpd_read_edid(struct omap_dss_device *dssdev,
 {
 	struct panel_drv_data *ddata = to_panel_data(dssdev);
 	struct omap_dss_device *in = ddata->in;
+	bool valid_phys_addr = 0;
 	int r;
 
 	if (!gpiod_get_value_cansleep(ddata->hpd_gpio))
@@ -151,7 +154,15 @@ static int tpd_read_edid(struct omap_dss_device *dssdev,
 
 	r = in->ops.hdmi->read_edid(in, edid, len);
 
-	gpiod_set_value_cansleep(ddata->ls_oe_gpio, 0);
+#ifdef CONFIG_OMAP2_DSS_HDMI_CEC
+	/*
+	 * In order to support CEC this pin should remain high
+	 * as long as the EDID has a valid physical address.
+	 */
+	valid_phys_addr =
+		cec_get_edid_phys_addr(edid, r, NULL) != CEC_PHYS_ADDR_INVALID;
+#endif
+	gpiod_set_value_cansleep(ddata->ls_oe_gpio, valid_phys_addr);
 
 	return r;
 }
-- 
2.8.1

