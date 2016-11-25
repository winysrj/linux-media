Return-path: <linux-media-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:51152 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932544AbcKYQt1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 Nov 2016 11:49:27 -0500
From: Brian Starkey <brian.starkey@arm.com>
To: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Cc: linux-media@vger.kernel.org, daniel@ffwll.ch, gustavo@padovan.org,
        laurent.pinchart@ideasonboard.com, eric@anholt.net,
        ville.syrjala@linux.intel.com, liviu.dudau@arm.com
Subject: [PATCH 3/6] drm: mali-dp: Rename malidp_input_format
Date: Fri, 25 Nov 2016 16:49:01 +0000
Message-Id: <1480092544-1725-4-git-send-email-brian.starkey@arm.com>
In-Reply-To: <1480092544-1725-1-git-send-email-brian.starkey@arm.com>
References: <1480092544-1725-1-git-send-email-brian.starkey@arm.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We're going to use the same format list for output formats, so rename
everything related to input formats to avoid confusion.

Signed-off-by: Brian Starkey <brian.starkey@arm.com>
Reviewed-by: Liviu Dudau <Liviu.Dudau@arm.com>
---
 drivers/gpu/drm/arm/malidp_hw.c     |   24 ++++++++++++------------
 drivers/gpu/drm/arm/malidp_hw.h     |    8 ++++----
 drivers/gpu/drm/arm/malidp_planes.c |    8 ++++----
 3 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/gpu/drm/arm/malidp_hw.c b/drivers/gpu/drm/arm/malidp_hw.c
index 4bdf531..9ec6d69 100644
--- a/drivers/gpu/drm/arm/malidp_hw.c
+++ b/drivers/gpu/drm/arm/malidp_hw.c
@@ -21,7 +21,7 @@
 #include "malidp_drv.h"
 #include "malidp_hw.h"
 
-static const struct malidp_input_format malidp500_de_formats[] = {
+static const struct malidp_format_id malidp500_de_formats[] = {
 	/*    fourcc,   layers supporting the format,     internal id  */
 	{ DRM_FORMAT_ARGB2101010, DE_VIDEO1 | DE_GRAPHICS1 | DE_GRAPHICS2,  0 },
 	{ DRM_FORMAT_ABGR2101010, DE_VIDEO1 | DE_GRAPHICS1 | DE_GRAPHICS2,  1 },
@@ -69,7 +69,7 @@
 	{ DRM_FORMAT_NV12, DE_VIDEO1 | DE_VIDEO2, MALIDP_ID(5, 6) },	\
 	{ DRM_FORMAT_YUV420, DE_VIDEO1 | DE_VIDEO2, MALIDP_ID(5, 7) }
 
-static const struct malidp_input_format malidp550_de_formats[] = {
+static const struct malidp_format_id malidp550_de_formats[] = {
 	MALIDP_COMMON_FORMATS,
 };
 
@@ -436,8 +436,8 @@ static int malidp650_query_hw(struct malidp_hw_device *hwdev)
 				.irq_mask = MALIDP500_DE_IRQ_CONF_VALID,
 				.vsync_irq = MALIDP500_DE_IRQ_CONF_VALID,
 			},
-			.input_formats = malidp500_de_formats,
-			.n_input_formats = ARRAY_SIZE(malidp500_de_formats),
+			.pixel_formats = malidp500_de_formats,
+			.n_pixel_formats = ARRAY_SIZE(malidp500_de_formats),
 			.bus_align_bytes = 8,
 		},
 		.query_hw = malidp500_query_hw,
@@ -469,8 +469,8 @@ static int malidp650_query_hw(struct malidp_hw_device *hwdev)
 				.irq_mask = MALIDP550_DC_IRQ_CONF_VALID,
 				.vsync_irq = MALIDP550_DC_IRQ_CONF_VALID,
 			},
-			.input_formats = malidp550_de_formats,
-			.n_input_formats = ARRAY_SIZE(malidp550_de_formats),
+			.pixel_formats = malidp550_de_formats,
+			.n_pixel_formats = ARRAY_SIZE(malidp550_de_formats),
 			.bus_align_bytes = 8,
 		},
 		.query_hw = malidp550_query_hw,
@@ -503,8 +503,8 @@ static int malidp650_query_hw(struct malidp_hw_device *hwdev)
 				.irq_mask = MALIDP550_DC_IRQ_CONF_VALID,
 				.vsync_irq = MALIDP550_DC_IRQ_CONF_VALID,
 			},
-			.input_formats = malidp550_de_formats,
-			.n_input_formats = ARRAY_SIZE(malidp550_de_formats),
+			.pixel_formats = malidp550_de_formats,
+			.n_pixel_formats = ARRAY_SIZE(malidp550_de_formats),
 			.bus_align_bytes = 16,
 		},
 		.query_hw = malidp650_query_hw,
@@ -522,10 +522,10 @@ u8 malidp_hw_get_format_id(const struct malidp_hw_regmap *map,
 {
 	unsigned int i;
 
-	for (i = 0; i < map->n_input_formats; i++) {
-		if (((map->input_formats[i].layer & layer_id) == layer_id) &&
-		    (map->input_formats[i].format == format))
-			return map->input_formats[i].id;
+	for (i = 0; i < map->n_pixel_formats; i++) {
+		if (((map->pixel_formats[i].layer & layer_id) == layer_id) &&
+		    (map->pixel_formats[i].format == format))
+			return map->pixel_formats[i].id;
 	}
 
 	return MALIDP_INVALID_FORMAT_ID;
diff --git a/drivers/gpu/drm/arm/malidp_hw.h b/drivers/gpu/drm/arm/malidp_hw.h
index 087e1202..4f8c884 100644
--- a/drivers/gpu/drm/arm/malidp_hw.h
+++ b/drivers/gpu/drm/arm/malidp_hw.h
@@ -35,7 +35,7 @@ enum {
 	DE_SMART = BIT(4),
 };
 
-struct malidp_input_format {
+struct malidp_format_id {
 	u32 format;		/* DRM fourcc */
 	u8 layer;		/* bitmask of layers supporting it */
 	u8 id;			/* used internally */
@@ -85,9 +85,9 @@ struct malidp_hw_regmap {
 	const struct malidp_irq_map se_irq_map;
 	const struct malidp_irq_map dc_irq_map;
 
-	/* list of supported input formats for each layer */
-	const struct malidp_input_format *input_formats;
-	const u8 n_input_formats;
+	/* list of supported pixel formats for each layer */
+	const struct malidp_format_id *pixel_formats;
+	const u8 n_pixel_formats;
 
 	/* pitch alignment requirement in bytes */
 	const u8 bus_align_bytes;
diff --git a/drivers/gpu/drm/arm/malidp_planes.c b/drivers/gpu/drm/arm/malidp_planes.c
index 63eec8f..e3cfd3a 100644
--- a/drivers/gpu/drm/arm/malidp_planes.c
+++ b/drivers/gpu/drm/arm/malidp_planes.c
@@ -258,7 +258,7 @@ int malidp_de_planes_init(struct drm_device *drm)
 	u32 *formats;
 	int ret, i, j, n;
 
-	formats = kcalloc(map->n_input_formats, sizeof(*formats), GFP_KERNEL);
+	formats = kcalloc(map->n_pixel_formats, sizeof(*formats), GFP_KERNEL);
 	if (!formats) {
 		ret = -ENOMEM;
 		goto cleanup;
@@ -274,9 +274,9 @@ int malidp_de_planes_init(struct drm_device *drm)
 		}
 
 		/* build the list of DRM supported formats based on the map */
-		for (n = 0, j = 0;  j < map->n_input_formats; j++) {
-			if ((map->input_formats[j].layer & id) == id)
-				formats[n++] = map->input_formats[j].format;
+		for (n = 0, j = 0;  j < map->n_pixel_formats; j++) {
+			if ((map->pixel_formats[j].layer & id) == id)
+				formats[n++] = map->pixel_formats[j].format;
 		}
 
 		plane_type = (i == 0) ? DRM_PLANE_TYPE_PRIMARY :
-- 
1.7.9.5

