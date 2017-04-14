Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:59991 "EHLO
        lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751898AbdDNKZY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Apr 2017 06:25:24 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>,
        dri-devel@lists.freedesktop.org,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 2/8] omapdrm: encoder-tpd12s015: keep ls_oe_gpio high if CEC is enabled
Date: Fri, 14 Apr 2017 12:25:06 +0200
Message-Id: <20170414102512.48834-3-hverkuil@xs4all.nl>
In-Reply-To: <20170414102512.48834-1-hverkuil@xs4all.nl>
References: <20170414102512.48834-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

When the OMAP4 CEC support is enabled the CEC pin should always
be on. So keep ls_oe_gpio high when CONFIG_OMAP4_DSS_HDMI_CEC
is set.

Background: even if the HPD is low it should still be possible
to use CEC. Some displays will set the HPD low when they go into standby or
when they switch to another input, but CEC is still available and able
to wake up/change input for such a display.

This is explicitly allowed by the CEC standard.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/gpu/drm/omapdrm/displays/encoder-tpd12s015.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/gpu/drm/omapdrm/displays/encoder-tpd12s015.c b/drivers/gpu/drm/omapdrm/displays/encoder-tpd12s015.c
index 58276a48112e..757554e6d62f 100644
--- a/drivers/gpu/drm/omapdrm/displays/encoder-tpd12s015.c
+++ b/drivers/gpu/drm/omapdrm/displays/encoder-tpd12s015.c
@@ -46,6 +46,9 @@ static int tpd_connect(struct omap_dss_device *dssdev,
 	dssdev->dst = dst;
 
 	gpiod_set_value_cansleep(ddata->ct_cp_hpd_gpio, 1);
+#ifdef CONFIG_OMAP4_DSS_HDMI_CEC
+	gpiod_set_value_cansleep(ddata->ls_oe_gpio, 1);
+#endif
 	/* DC-DC converter needs at max 300us to get to 90% of 5V */
 	udelay(300);
 
@@ -64,6 +67,7 @@ static void tpd_disconnect(struct omap_dss_device *dssdev,
 		return;
 
 	gpiod_set_value_cansleep(ddata->ct_cp_hpd_gpio, 0);
+	gpiod_set_value_cansleep(ddata->ls_oe_gpio, 0);
 
 	dst->src = NULL;
 	dssdev->dst = NULL;
@@ -146,11 +150,15 @@ static int tpd_read_edid(struct omap_dss_device *dssdev,
 	if (!gpiod_get_value_cansleep(ddata->hpd_gpio))
 		return -ENODEV;
 
+#ifndef CONFIG_OMAP4_DSS_HDMI_CEC
 	gpiod_set_value_cansleep(ddata->ls_oe_gpio, 1);
+#endif
 
 	r = in->ops.hdmi->read_edid(in, edid, len);
 
+#ifndef CONFIG_OMAP4_DSS_HDMI_CEC
 	gpiod_set_value_cansleep(ddata->ls_oe_gpio, 0);
+#endif
 
 	return r;
 }
-- 
2.11.0
