Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:49141 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754131AbcJDQXj (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 4 Oct 2016 12:23:39 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: dri-devel@lists.freedesktop.org
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 2/2] drm: rcar-du: Add support for LVDS mode selection
Date: Tue,  4 Oct 2016 19:23:30 +0300
Message-Id: <1475598210-26857-3-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1475598210-26857-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1475598210-26857-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Retrieve the LVDS mode from the panel node and configure the LVDS
encoder accordingly. LVDS mode selection is static as LVDS panels can't
be hot-plugged on any of the device supported by the driver. Support for
dynamic mode selection can be implemented in the future if needed
without any impact on the DT bindings.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/gpu/drm/rcar-du/rcar_du_lvdscon.c | 29 +++++++++++++++++++++++++++++
 drivers/gpu/drm/rcar-du/rcar_du_lvdsenc.c | 11 +++++++++--
 drivers/gpu/drm/rcar-du/rcar_du_lvdsenc.h | 13 +++++++++++++
 3 files changed, 51 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/rcar-du/rcar_du_lvdscon.c b/drivers/gpu/drm/rcar-du/rcar_du_lvdscon.c
index 64e9f0b86e58..71a70b06f16b 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_lvdscon.c
+++ b/drivers/gpu/drm/rcar-du/rcar_du_lvdscon.c
@@ -24,6 +24,7 @@
 #include "rcar_du_encoder.h"
 #include "rcar_du_kms.h"
 #include "rcar_du_lvdscon.h"
+#include "rcar_du_lvdsenc.h"
 
 struct rcar_du_lvds_connector {
 	struct rcar_du_connector connector;
@@ -33,6 +34,8 @@ struct rcar_du_lvds_connector {
 		unsigned int height_mm;		/* Panel height in mm */
 		struct videomode mode;
 	} panel;
+
+	unsigned int mode;
 };
 
 #define to_rcar_lvds_connector(c) \
@@ -100,6 +103,32 @@ int rcar_du_lvds_connector_init(struct rcar_du_device *rcdu,
 	of_property_read_u32(np, "width-mm", &lvdscon->panel.width_mm);
 	of_property_read_u32(np, "height-mm", &lvdscon->panel.height_mm);
 
+	if (of_device_is_compatible(np, "panel-lvds")) {
+		enum rcar_lvds_mode mode = 0;
+		const char *mapping = NULL;
+
+		of_property_read_string(np, "data-mapping", &mapping);
+		if (!mapping) {
+			dev_dbg(rcdu->dev,
+				"required property %s not found in %s node\n",
+				"data-mapping", np->full_name);
+			return -EINVAL;
+		}
+
+		if (!strcmp(mapping, "jeida-18") ||
+		    !strcmp(mapping, "jeida-24"))
+			mode = RCAR_LVDS_MODE_JEIDA;
+		else if (!strcmp(mapping, "vesa-24"))
+			mode = RCAR_LVDS_MODE_VESA;
+		else
+			return -EINVAL;
+
+		if (of_find_property(np, "data-mirror", NULL))
+			mode |= RCAR_LVDS_MODE_MIRROR;
+
+		rcar_du_lvdsenc_set_mode(renc->lvds, mode);
+	}
+
 	connector = &lvdscon->connector.connector;
 	connector->display_info.width_mm = lvdscon->panel.width_mm;
 	connector->display_info.height_mm = lvdscon->panel.height_mm;
diff --git a/drivers/gpu/drm/rcar-du/rcar_du_lvdsenc.c b/drivers/gpu/drm/rcar-du/rcar_du_lvdsenc.c
index b74105a80a6e..c8c22850947a 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_lvdsenc.c
+++ b/drivers/gpu/drm/rcar-du/rcar_du_lvdsenc.c
@@ -31,6 +31,7 @@ struct rcar_du_lvdsenc {
 	bool enabled;
 
 	enum rcar_lvds_input input;
+	enum rcar_lvds_mode mode;
 };
 
 static void rcar_lvds_write(struct rcar_du_lvdsenc *lvds, u32 reg, u32 data)
@@ -61,7 +62,7 @@ static void rcar_du_lvdsenc_start_gen2(struct rcar_du_lvdsenc *lvds,
 	/* Select the input, hardcode mode 0, enable LVDS operation and turn
 	 * bias circuitry on.
 	 */
-	lvdcr0 = LVDCR0_BEN | LVDCR0_LVEN;
+	lvdcr0 = (lvds->mode << LVDCR0_LVMD_SHIFT) | LVDCR0_BEN | LVDCR0_LVEN;
 	if (rcrtc->index == 2)
 		lvdcr0 |= LVDCR0_DUSEL;
 	rcar_lvds_write(lvds, LVDCR0, lvdcr0);
@@ -107,7 +108,7 @@ static void rcar_du_lvdsenc_start_gen3(struct rcar_du_lvdsenc *lvds,
 	/* Turn the PLL on, set it to LVDS normal mode, wait for the startup
 	 * delay and turn the output on.
 	 */
-	lvdcr0 = LVDCR0_PLLON;
+	lvdcr0 = (lvds->mode << LVDCR0_LVMD_SHIFT) | LVDCR0_PLLON;
 	rcar_lvds_write(lvds, LVDCR0, lvdcr0);
 
 	lvdcr0 |= LVDCR0_PWD;
@@ -210,6 +211,12 @@ void rcar_du_lvdsenc_atomic_check(struct rcar_du_lvdsenc *lvds,
 		mode->clock = clamp(mode->clock, 25175, 148500);
 }
 
+void rcar_du_lvdsenc_set_mode(struct rcar_du_lvdsenc *lvds,
+			      enum rcar_lvds_mode mode)
+{
+	lvds->mode = mode;
+}
+
 static int rcar_du_lvdsenc_get_resources(struct rcar_du_lvdsenc *lvds,
 					 struct platform_device *pdev)
 {
diff --git a/drivers/gpu/drm/rcar-du/rcar_du_lvdsenc.h b/drivers/gpu/drm/rcar-du/rcar_du_lvdsenc.h
index dfdba746edf4..7218ac89333e 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_lvdsenc.h
+++ b/drivers/gpu/drm/rcar-du/rcar_du_lvdsenc.h
@@ -26,8 +26,17 @@ enum rcar_lvds_input {
 	RCAR_LVDS_INPUT_DU2,
 };
 
+/* Keep in sync with the LVDCR0.LVMD hardware register values. */
+enum rcar_lvds_mode {
+	RCAR_LVDS_MODE_JEIDA = 0,
+	RCAR_LVDS_MODE_MIRROR = 1,
+	RCAR_LVDS_MODE_VESA = 4,
+};
+
 #if IS_ENABLED(CONFIG_DRM_RCAR_LVDS)
 int rcar_du_lvdsenc_init(struct rcar_du_device *rcdu);
+void rcar_du_lvdsenc_set_mode(struct rcar_du_lvdsenc *lvds,
+			      enum rcar_lvds_mode mode);
 int rcar_du_lvdsenc_enable(struct rcar_du_lvdsenc *lvds,
 			   struct drm_crtc *crtc, bool enable);
 void rcar_du_lvdsenc_atomic_check(struct rcar_du_lvdsenc *lvds,
@@ -37,6 +46,10 @@ static inline int rcar_du_lvdsenc_init(struct rcar_du_device *rcdu)
 {
 	return 0;
 }
+static inline void rcar_du_lvdsenc_set_mode(struct rcar_du_lvdsenc *lvds,
+					    enum rcar_lvds_mode mode)
+{
+}
 static inline int rcar_du_lvdsenc_enable(struct rcar_du_lvdsenc *lvds,
 					 struct drm_crtc *crtc, bool enable)
 {
-- 
Regards,

Laurent Pinchart

