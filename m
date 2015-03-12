Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48954 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752582AbbCLJ67 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Mar 2015 05:58:59 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: dri-devel@lists.freedesktop.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: David Airlie <airlied@linux.ie>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Boris Brezillion <boris.brezillon@free-electrons.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Steve Longerbeam <slongerbeam@gmail.com>,
	Russell King <rmk+kernel@arm.linux.org.uk>,
	Emil Renner Berthing <kernel@esmil.dk>,
	linux-media@vger.kernel.org, kernel@pengutronix.de,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v3 10/10] drm/imx: imx-ldb: allow to determine bus format from the connected panel
Date: Thu, 12 Mar 2015 10:58:16 +0100
Message-Id: <1426154296-30665-11-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1426154296-30665-1-git-send-email-p.zabel@pengutronix.de>
References: <1426154296-30665-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch makes the fsl,data-width and fsl,data-mapping device tree
properties optional if a panel is connected to the ldb output port
via the of_graph bindings. The data mapping is determined from the
display_info.bus_format field provided by the panel.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/gpu/drm/imx/imx-ldb.c | 116 +++++++++++++++++++++++-------------------
 1 file changed, 63 insertions(+), 53 deletions(-)

diff --git a/drivers/gpu/drm/imx/imx-ldb.c b/drivers/gpu/drm/imx/imx-ldb.c
index 544282b..abacc8f 100644
--- a/drivers/gpu/drm/imx/imx-ldb.c
+++ b/drivers/gpu/drm/imx/imx-ldb.c
@@ -63,6 +63,7 @@ struct imx_ldb_channel {
 	int edid_len;
 	struct drm_display_mode mode;
 	int mode_valid;
+	int bus_format;
 };
 
 struct bus_mux {
@@ -96,7 +97,11 @@ static int imx_ldb_connector_get_modes(struct drm_connector *connector)
 
 	if (imx_ldb_ch->panel && imx_ldb_ch->panel->funcs &&
 	    imx_ldb_ch->panel->funcs->get_modes) {
+		struct drm_display_info *di = &connector->display_info;
+
 		num_modes = imx_ldb_ch->panel->funcs->get_modes(imx_ldb_ch->panel);
+		if (!imx_ldb_ch->bus_format && di->num_bus_formats)
+			imx_ldb_ch->bus_format = di->bus_formats[0];
 		if (num_modes > 0)
 			return num_modes;
 	}
@@ -173,21 +178,33 @@ static void imx_ldb_encoder_prepare(struct drm_encoder *encoder)
 {
 	struct imx_ldb_channel *imx_ldb_ch = enc_to_imx_ldb_ch(encoder);
 	struct imx_ldb *ldb = imx_ldb_ch->ldb;
+	int dual = ldb->ldb_ctrl & LDB_SPLIT_MODE_EN;
 	u32 bus_format;
 
-	switch (imx_ldb_ch->chno) {
-	case 0:
-		bus_format = (ldb->ldb_ctrl & LDB_DATA_WIDTH_CH0_24) ?
-			MEDIA_BUS_FMT_RGB888_1X24 : MEDIA_BUS_FMT_RGB666_1X18;
+	switch (imx_ldb_ch->bus_format) {
+	default:
+		dev_warn(ldb->dev,
+			 "could not determine data mapping, default to 18-bit \"spwg\"\n");
+		/* fallthrough */
+	case MEDIA_BUS_FMT_RGB666_1X7X3_SPWG:
+		bus_format = MEDIA_BUS_FMT_RGB666_1X18;
 		break;
-	case 1:
-		bus_format = (ldb->ldb_ctrl & LDB_DATA_WIDTH_CH1_24) ?
-			MEDIA_BUS_FMT_RGB888_1X24 : MEDIA_BUS_FMT_RGB666_1X18;
+	case MEDIA_BUS_FMT_RGB888_1X7X4_SPWG:
+		bus_format = MEDIA_BUS_FMT_RGB888_1X24;
+		if (imx_ldb_ch->chno == 0 || dual)
+			ldb->ldb_ctrl |= LDB_DATA_WIDTH_CH0_24;
+		if (imx_ldb_ch->chno == 1 || dual)
+			ldb->ldb_ctrl |= LDB_DATA_WIDTH_CH1_24;
 		break;
-	default:
-		dev_err(ldb->dev, "unable to config di%d panel format\n",
-			imx_ldb_ch->chno);
+	case MEDIA_BUS_FMT_RGB888_1X7X4_JEIDA:
 		bus_format = MEDIA_BUS_FMT_RGB888_1X24;
+		if (imx_ldb_ch->chno == 0 || dual)
+			ldb->ldb_ctrl |= LDB_DATA_WIDTH_CH0_24 |
+					 LDB_BIT_MAP_CH0_JEIDA;
+		if (imx_ldb_ch->chno == 1 || dual)
+			ldb->ldb_ctrl |= LDB_DATA_WIDTH_CH1_24 |
+					 LDB_BIT_MAP_CH1_JEIDA;
+		break;
 	}
 
 	imx_drm_set_bus_format(encoder, bus_format);
@@ -426,25 +443,39 @@ enum {
 	LVDS_BIT_MAP_JEIDA
 };
 
-static const char * const imx_ldb_bit_mappings[] = {
-	[LVDS_BIT_MAP_SPWG]  = "spwg",
-	[LVDS_BIT_MAP_JEIDA] = "jeida",
+struct imx_ldb_bit_mapping {
+	u32 bus_format;
+	u32 datawidth;
+	const char * const mapping;
 };
 
-static const int of_get_data_mapping(struct device_node *np)
+static const struct imx_ldb_bit_mapping imx_ldb_bit_mappings[] = {
+	{ MEDIA_BUS_FMT_RGB666_1X7X3_SPWG,  18, "spwg" },
+	{ MEDIA_BUS_FMT_RGB888_1X7X4_SPWG,  24, "spwg" },
+	{ MEDIA_BUS_FMT_RGB888_1X7X4_JEIDA, 24, "jeida" },
+};
+
+static u32 of_get_bus_format(struct device *dev, struct device_node *np)
 {
 	const char *bm;
+	u32 datawidth = 0;
 	int ret, i;
 
 	ret = of_property_read_string(np, "fsl,data-mapping", &bm);
 	if (ret < 0)
 		return ret;
 
-	for (i = 0; i < ARRAY_SIZE(imx_ldb_bit_mappings); i++)
-		if (!strcasecmp(bm, imx_ldb_bit_mappings[i]))
-			return i;
+	of_property_read_u32(np, "fsl,data-width", &datawidth);
+
+	for (i = 0; i < ARRAY_SIZE(imx_ldb_bit_mappings); i++) {
+		if (!strcasecmp(bm, imx_ldb_bit_mappings[i].mapping) &&
+		    datawidth == imx_ldb_bit_mappings[i].datawidth)
+			return imx_ldb_bit_mappings[i].bus_format;
+	}
+
+	dev_err(dev, "invalid data mapping: %d-bit \"%s\"\n", datawidth, bm);
 
-	return -EINVAL;
+	return -ENOENT;
 }
 
 static struct bus_mux imx6q_lvds_mux[2] = {
@@ -481,8 +512,6 @@ static int imx_ldb_bind(struct device *dev, struct device *master, void *data)
 	struct device_node *child;
 	const u8 *edidp;
 	struct imx_ldb *imx_ldb;
-	int datawidth;
-	int mapping;
 	int dual;
 	int ret;
 	int i;
@@ -583,39 +612,20 @@ static int imx_ldb_bind(struct device *dev, struct device *master, void *data)
 				channel->mode_valid = 1;
 		}
 
-		ret = of_property_read_u32(child, "fsl,data-width", &datawidth);
-		if (ret)
-			datawidth = 0;
-		else if (datawidth != 18 && datawidth != 24)
-			return -EINVAL;
-
-		mapping = of_get_data_mapping(child);
-		switch (mapping) {
-		case LVDS_BIT_MAP_SPWG:
-			if (datawidth == 24) {
-				if (i == 0 || dual)
-					imx_ldb->ldb_ctrl |=
-						LDB_DATA_WIDTH_CH0_24;
-				if (i == 1 || dual)
-					imx_ldb->ldb_ctrl |=
-						LDB_DATA_WIDTH_CH1_24;
-			}
-			break;
-		case LVDS_BIT_MAP_JEIDA:
-			if (datawidth == 18) {
-				dev_err(dev, "JEIDA standard only supported in 24 bit\n");
-				return -EINVAL;
-			}
-			if (i == 0 || dual)
-				imx_ldb->ldb_ctrl |= LDB_DATA_WIDTH_CH0_24 |
-					LDB_BIT_MAP_CH0_JEIDA;
-			if (i == 1 || dual)
-				imx_ldb->ldb_ctrl |= LDB_DATA_WIDTH_CH1_24 |
-					LDB_BIT_MAP_CH1_JEIDA;
-			break;
-		default:
-			dev_err(dev, "data mapping not specified or invalid\n");
-			return -EINVAL;
+		channel->bus_format = of_get_bus_format(dev, child);
+		if (channel->bus_format == -EINVAL) {
+			/*
+			 * If no bus format was specified in the device tree,
+			 * we can still get it from the connected panel later.
+			 */
+			if (channel->panel && channel->panel->funcs &&
+			    channel->panel->funcs->get_modes)
+				channel->bus_format = 0;
+		}
+		if (channel->bus_format < 0) {
+			dev_err(dev, "could not determine data mapping: %d\n",
+				channel->bus_format);
+			return channel->bus_format;
 		}
 
 		ret = imx_ldb_register(drm, channel);
-- 
2.1.4

