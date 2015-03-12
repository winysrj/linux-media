Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48971 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752539AbbCLJ7c (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Mar 2015 05:59:32 -0400
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
Subject: [PATCH v3 09/10] drm/imx: imx-ldb: reset display clock input when disabling LVDS
Date: Thu, 12 Mar 2015 10:58:15 +0100
Message-Id: <1426154296-30665-10-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1426154296-30665-1-git-send-email-p.zabel@pengutronix.de>
References: <1426154296-30665-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The LDB driver changes the attached display interface's input clock mux
to the LDB_DI clock reference. Change it back again when disabling the
LVDS display. Changing back to the PLL5 for example allows to configure
the same DI for HDMI output later.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/gpu/drm/imx/imx-ldb.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/gpu/drm/imx/imx-ldb.c b/drivers/gpu/drm/imx/imx-ldb.c
index 4286399..544282b 100644
--- a/drivers/gpu/drm/imx/imx-ldb.c
+++ b/drivers/gpu/drm/imx/imx-ldb.c
@@ -77,6 +77,7 @@ struct imx_ldb {
 	struct imx_ldb_channel channel[2];
 	struct clk *clk[2]; /* our own clock */
 	struct clk *clk_sel[4]; /* parent of display clock */
+	struct clk *clk_parent[4]; /* original parent of clk_sel */
 	struct clk *clk_pll[2]; /* upstream clock we can adjust */
 	u32 ldb_ctrl;
 	const struct bus_mux *lvds_mux;
@@ -287,6 +288,7 @@ static void imx_ldb_encoder_disable(struct drm_encoder *encoder)
 {
 	struct imx_ldb_channel *imx_ldb_ch = enc_to_imx_ldb_ch(encoder);
 	struct imx_ldb *ldb = imx_ldb_ch->ldb;
+	int mux, ret;
 
 	/*
 	 * imx_ldb_encoder_disable is called by
@@ -314,6 +316,28 @@ static void imx_ldb_encoder_disable(struct drm_encoder *encoder)
 		clk_disable_unprepare(ldb->clk[1]);
 	}
 
+	if (ldb->lvds_mux) {
+		const struct bus_mux *lvds_mux = NULL;
+
+		if (imx_ldb_ch == &ldb->channel[0])
+			lvds_mux = &ldb->lvds_mux[0];
+		else if (imx_ldb_ch == &ldb->channel[1])
+			lvds_mux = &ldb->lvds_mux[1];
+
+		regmap_read(ldb->regmap, lvds_mux->reg, &mux);
+		mux &= lvds_mux->mask;
+		mux >>= lvds_mux->shift;
+	} else {
+		mux = (imx_ldb_ch == &ldb->channel[0]) ? 0 : 1;
+	}
+
+	/* set display clock mux back to original input clock */
+	ret = clk_set_parent(ldb->clk_sel[mux], ldb->clk_parent[mux]);
+	if (ret)
+		dev_err(ldb->dev,
+			"unable to set di%d parent clock to original parent\n",
+			mux);
+
 	drm_panel_unprepare(imx_ldb_ch->panel);
 }
 
@@ -499,6 +523,8 @@ static int imx_ldb_bind(struct device *dev, struct device *master, void *data)
 			imx_ldb->clk_sel[i] = NULL;
 			break;
 		}
+
+		imx_ldb->clk_parent[i] = clk_get_parent(imx_ldb->clk_sel[i]);
 	}
 	if (i == 0)
 		return ret;
-- 
2.1.4

