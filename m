Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:42733 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752342AbdHBIyN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 2 Aug 2017 04:54:13 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>,
        dri-devel@lists.freedesktop.org,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 1/9] omapdrm: encoder-tpd12s015: keep ls_oe_gpio high
Date: Wed,  2 Aug 2017 10:54:00 +0200
Message-Id: <20170802085408.16204-2-hverkuil@xs4all.nl>
In-Reply-To: <20170802085408.16204-1-hverkuil@xs4all.nl>
References: <20170802085408.16204-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

For OMAP4 CEC support the CEC pin should always be on. So keep
ls_oe_gpio high all the time in order to support CEC.

Background: even if the HPD is low it should still be possible
to use CEC. Some displays will set the HPD low when they go into standby or
when they switch to another input, but CEC is still available and able
to wake up/change input for such a display.

This is explicitly allowed by the CEC standard.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/gpu/drm/omapdrm/displays/encoder-tpd12s015.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/omapdrm/displays/encoder-tpd12s015.c b/drivers/gpu/drm/omapdrm/displays/encoder-tpd12s015.c
index a9e9d667c55e..293b8fd07cfc 100644
--- a/drivers/gpu/drm/omapdrm/displays/encoder-tpd12s015.c
+++ b/drivers/gpu/drm/omapdrm/displays/encoder-tpd12s015.c
@@ -51,6 +51,8 @@ static int tpd_connect(struct omap_dss_device *dssdev,
 	dssdev->dst = dst;
 
 	gpiod_set_value_cansleep(ddata->ct_cp_hpd_gpio, 1);
+	gpiod_set_value_cansleep(ddata->ls_oe_gpio, 1);
+
 	/* DC-DC converter needs at max 300us to get to 90% of 5V */
 	udelay(300);
 
@@ -69,6 +71,7 @@ static void tpd_disconnect(struct omap_dss_device *dssdev,
 		return;
 
 	gpiod_set_value_cansleep(ddata->ct_cp_hpd_gpio, 0);
+	gpiod_set_value_cansleep(ddata->ls_oe_gpio, 0);
 
 	dst->src = NULL;
 	dssdev->dst = NULL;
@@ -146,18 +149,11 @@ static int tpd_read_edid(struct omap_dss_device *dssdev,
 {
 	struct panel_drv_data *ddata = to_panel_data(dssdev);
 	struct omap_dss_device *in = ddata->in;
-	int r;
 
 	if (!gpiod_get_value_cansleep(ddata->hpd_gpio))
 		return -ENODEV;
 
-	gpiod_set_value_cansleep(ddata->ls_oe_gpio, 1);
-
-	r = in->ops.hdmi->read_edid(in, edid, len);
-
-	gpiod_set_value_cansleep(ddata->ls_oe_gpio, 0);
-
-	return r;
+	return in->ops.hdmi->read_edid(in, edid, len);
 }
 
 static bool tpd_detect(struct omap_dss_device *dssdev)
-- 
2.13.2
