Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:58531 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752489AbeDSJbj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 19 Apr 2018 05:31:39 -0400
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: architt@codeaurora.org, a.hajda@samsung.com,
        Laurent.pinchart@ideasonboard.com, airlied@linux.ie
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>, daniel@ffwll.ch,
        peda@axentia.se, linux-renesas-soc@vger.kernel.org,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH 6/8] drm: rcar-du: rcar-lvds: Add bridge format support
Date: Thu, 19 Apr 2018 11:31:07 +0200
Message-Id: <1524130269-32688-7-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1524130269-32688-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1524130269-32688-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

With the introduction of static input image format enumeration in DRM
bridges, add support to retrieve the format in rcar-lvds LVDS encoder
from both panel or bridge, to set the desired LVDS mode.

Do not rely on 'DRM_BUS_FLAG_DATA_LSB_TO_MSB' flag to mirror the LVDS
format, as it is only defined for drm connectors, but use the newly
introduced _LE version of LVDS mbus image formats.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
 drivers/gpu/drm/rcar-du/rcar_lvds.c | 64 +++++++++++++++++++++++++------------
 1 file changed, 44 insertions(+), 20 deletions(-)

diff --git a/drivers/gpu/drm/rcar-du/rcar_lvds.c b/drivers/gpu/drm/rcar-du/rcar_lvds.c
index 3d2d3bb..2fa875f 100644
--- a/drivers/gpu/drm/rcar-du/rcar_lvds.c
+++ b/drivers/gpu/drm/rcar-du/rcar_lvds.c
@@ -280,41 +280,65 @@ static bool rcar_lvds_mode_fixup(struct drm_bridge *bridge,
 	return true;
 }
 
-static void rcar_lvds_get_lvds_mode(struct rcar_lvds *lvds)
+static int rcar_lvds_get_lvds_mode_from_connector(struct rcar_lvds *lvds,
+						  unsigned int *bus_fmt)
 {
 	struct drm_display_info *info = &lvds->connector.display_info;
-	enum rcar_lvds_mode mode;
-
-	/*
-	 * There is no API yet to retrieve LVDS mode from a bridge, only panels
-	 * are supported.
-	 */
-	if (!lvds->panel)
-		return;
 
 	if (!info->num_bus_formats || !info->bus_formats) {
 		dev_err(lvds->dev, "no LVDS bus format reported\n");
-		return;
+		return -EINVAL;
+	}
+
+	*bus_fmt = info->bus_formats[0];
+
+	return 0;
+}
+
+static int rcar_lvds_get_lvds_mode_from_bridge(struct rcar_lvds *lvds,
+					       unsigned int *bus_fmt)
+{
+	if (!lvds->next_bridge->num_bus_formats ||
+	    !lvds->next_bridge->bus_formats) {
+		dev_err(lvds->dev, "no LVDS bus format reported\n");
+		return -EINVAL;
 	}
 
-	switch (info->bus_formats[0]) {
+	*bus_fmt = lvds->next_bridge->bus_formats[0];
+
+	return 0;
+}
+
+static void rcar_lvds_get_lvds_mode(struct rcar_lvds *lvds)
+{
+	unsigned int bus_fmt;
+	int ret;
+
+	if (lvds->panel)
+		ret = rcar_lvds_get_lvds_mode_from_connector(lvds, &bus_fmt);
+	else
+		ret = rcar_lvds_get_lvds_mode_from_bridge(lvds, &bus_fmt);
+	if (ret)
+		return;
+
+	switch (bus_fmt) {
+	case MEDIA_BUS_FMT_RGB666_1X7X3_SPWG_LE:
+	case MEDIA_BUS_FMT_RGB888_1X7X4_JEIDA_LE:
+		lvds->mode |= RCAR_LVDS_MODE_MIRROR;
 	case MEDIA_BUS_FMT_RGB666_1X7X3_SPWG:
 	case MEDIA_BUS_FMT_RGB888_1X7X4_JEIDA:
-		mode = RCAR_LVDS_MODE_JEIDA;
+		lvds->mode = RCAR_LVDS_MODE_JEIDA;
 		break;
+
+	case MEDIA_BUS_FMT_RGB888_1X7X4_SPWG_LE:
+		lvds->mode |= RCAR_LVDS_MODE_MIRROR;
 	case MEDIA_BUS_FMT_RGB888_1X7X4_SPWG:
-		mode = RCAR_LVDS_MODE_VESA;
+		lvds->mode = RCAR_LVDS_MODE_VESA;
 		break;
 	default:
 		dev_err(lvds->dev, "unsupported LVDS bus format 0x%04x\n",
-			info->bus_formats[0]);
-		return;
+			bus_fmt);
 	}
-
-	if (info->bus_flags & DRM_BUS_FLAG_DATA_LSB_TO_MSB)
-		mode |= RCAR_LVDS_MODE_MIRROR;
-
-	lvds->mode = mode;
 }
 
 static void rcar_lvds_mode_set(struct drm_bridge *bridge,
-- 
2.7.4
