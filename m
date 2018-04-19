Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:37477 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752546AbeDSJbl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 19 Apr 2018 05:31:41 -0400
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: architt@codeaurora.org, a.hajda@samsung.com,
        Laurent.pinchart@ideasonboard.com, airlied@linux.ie
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>, daniel@ffwll.ch,
        peda@axentia.se, linux-renesas-soc@vger.kernel.org,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH 7/8] drm: panel: Use _LE LVDS formats for data mirroring
Date: Thu, 19 Apr 2018 11:31:08 +0200
Message-Id: <1524130269-32688-8-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1524130269-32688-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1524130269-32688-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As now both bridges and panels report supported image formats,
use the newly introduced _LE version of LVDS media bus formats in place
of the DRM_BUS_FLAG_DATA_ flags defined in drm_connector.h

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
 drivers/gpu/drm/panel/panel-lvds.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/panel/panel-lvds.c b/drivers/gpu/drm/panel/panel-lvds.c
index 5185819..ac03eab 100644
--- a/drivers/gpu/drm/panel/panel-lvds.c
+++ b/drivers/gpu/drm/panel/panel-lvds.c
@@ -37,7 +37,6 @@ struct panel_lvds {
 	unsigned int height;
 	struct videomode video_mode;
 	unsigned int bus_format;
-	bool data_mirror;
 
 	struct backlight_device *backlight;
 	struct regulator *supply;
@@ -129,9 +128,6 @@ static int panel_lvds_get_modes(struct drm_panel *panel)
 	connector->display_info.height_mm = lvds->height;
 	drm_display_info_set_bus_formats(&connector->display_info,
 					 &lvds->bus_format, 1);
-	connector->display_info.bus_flags = lvds->data_mirror
-					  ? DRM_BUS_FLAG_DATA_LSB_TO_MSB
-					  : DRM_BUS_FLAG_DATA_MSB_TO_LSB;
 
 	return 1;
 }
@@ -149,6 +145,7 @@ static int panel_lvds_parse_dt(struct panel_lvds *lvds)
 	struct device_node *np = lvds->dev->of_node;
 	struct display_timing timing;
 	const char *mapping;
+	bool data_mirror;
 	int ret;
 
 	ret = of_get_display_timing(np, "panel-timing", &timing);
@@ -179,20 +176,26 @@ static int panel_lvds_parse_dt(struct panel_lvds *lvds)
 		return -ENODEV;
 	}
 
+	data_mirror = of_property_read_bool(np, "data-mirror");
+
 	if (!strcmp(mapping, "jeida-18")) {
-		lvds->bus_format = MEDIA_BUS_FMT_RGB666_1X7X3_SPWG;
+		lvds->bus_format = data_mirror ?
+				   MEDIA_BUS_FMT_RGB666_1X7X3_SPWG_LE :
+				   MEDIA_BUS_FMT_RGB666_1X7X3_SPWG;
 	} else if (!strcmp(mapping, "jeida-24")) {
-		lvds->bus_format = MEDIA_BUS_FMT_RGB888_1X7X4_JEIDA;
+		lvds->bus_format = data_mirror ?
+				   MEDIA_BUS_FMT_RGB888_1X7X4_JEIDA_LE :
+				   MEDIA_BUS_FMT_RGB888_1X7X4_JEIDA;
 	} else if (!strcmp(mapping, "vesa-24")) {
-		lvds->bus_format = MEDIA_BUS_FMT_RGB888_1X7X4_SPWG;
+		lvds->bus_format = data_mirror ?
+				   MEDIA_BUS_FMT_RGB888_1X7X4_SPWG_LE :
+				   MEDIA_BUS_FMT_RGB888_1X7X4_SPWG;
 	} else {
 		dev_err(lvds->dev, "%pOF: invalid or missing %s DT property\n",
 			np, "data-mapping");
 		return -EINVAL;
 	}
 
-	lvds->data_mirror = of_property_read_bool(np, "data-mirror");
-
 	return 0;
 }
 
-- 
2.7.4
