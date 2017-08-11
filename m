Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-3.sys.kth.se ([130.237.48.192]:39266 "EHLO
        smtp-3.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752950AbdHKJ5Z (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 Aug 2017 05:57:25 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Benoit Parrot <bparrot@ti.com>,
        linux-renesas-soc@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH 11/20] rcar-csi2: when starting CSI-2 receiver use frame descriptor information
Date: Fri, 11 Aug 2017 11:56:54 +0200
Message-Id: <20170811095703.6170-12-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20170811095703.6170-1-niklas.soderlund+renesas@ragnatech.se>
References: <20170811095703.6170-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The driver now have access to frame descriptor information, use it. Only
enable the virtual channels which are described in the frame descriptor
and calculate the PHY PLL based on all streams described.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-csi2.c | 85 ++++++++++++++---------------
 1 file changed, 42 insertions(+), 43 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-csi2.c b/drivers/media/platform/rcar-vin/rcar-csi2.c
index 12a8ea7a219ac7d3..b8ec03d595ba8ac4 100644
--- a/drivers/media/platform/rcar-vin/rcar-csi2.c
+++ b/drivers/media/platform/rcar-vin/rcar-csi2.c
@@ -242,24 +242,22 @@ static const struct phypll_hsfreqrange hsfreqrange_m3w_h3es1[] = {
 #define CSI0CLKFREQRANGE(n)		((n & 0x3f) << 16)
 
 struct rcar_csi2_format {
-	unsigned int code;
 	unsigned int datatype;
 	unsigned int bpp;
 };
 
 static const struct rcar_csi2_format rcar_csi2_formats[] = {
-	{ .code = MEDIA_BUS_FMT_RGB888_1X24,	.datatype = 0x24, .bpp = 24 },
-	{ .code = MEDIA_BUS_FMT_UYVY8_1X16,	.datatype = 0x1e, .bpp = 16 },
-	{ .code = MEDIA_BUS_FMT_UYVY8_2X8,	.datatype = 0x1e, .bpp = 16 },
-	{ .code = MEDIA_BUS_FMT_YUYV10_2X10,	.datatype = 0x1e, .bpp = 16 },
+	{ .datatype = 0x1e, .bpp = 16 },
+	{ .datatype = 0x24, .bpp = 24 },
 };
 
-static const struct rcar_csi2_format *rcar_csi2_code_to_fmt(unsigned int code)
+static const struct rcar_csi2_format
+*rcar_csi2_datatype_to_fmt(unsigned int datatype)
 {
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(rcar_csi2_formats); i++)
-		if (rcar_csi2_formats[i].code == code)
+		if (rcar_csi2_formats[i].datatype == datatype)
 			return rcar_csi2_formats + i;
 	return NULL;
 }
@@ -348,12 +346,14 @@ static int rcar_csi2_wait_phy_start(struct rcar_csi2 *priv)
 
 static int rcar_csi2_calc_phypll(struct rcar_csi2 *priv,
 				 struct v4l2_subdev *source,
-				 struct v4l2_mbus_framefmt *mf,
+				 struct v4l2_mbus_frame_desc *fd,
 				 u32 *phypll)
 {
+	struct v4l2_mbus_frame_desc_entry *entry;
 	const struct phypll_hsfreqrange *hsfreq;
 	const struct rcar_csi2_format *format;
 	struct v4l2_ctrl *ctrl;
+	unsigned int i, bpp = 0;
 	u64 mbps;
 
 	ctrl = v4l2_ctrl_find(source->ctrl_handler, V4L2_CID_PIXEL_RATE);
@@ -363,13 +363,20 @@ static int rcar_csi2_calc_phypll(struct rcar_csi2 *priv,
 		return -EINVAL;
 	}
 
-	format = rcar_csi2_code_to_fmt(mf->code);
-	if (!format) {
-		dev_err(priv->dev, "Unknown format: %d\n", mf->code);
-		return -EINVAL;
+	for (i = 0; i < fd->num_entries; i++) {
+		entry = &fd->entry[i];
+
+		format = rcar_csi2_datatype_to_fmt(entry->csi2.datatype);
+		if (!format) {
+			dev_err(priv->dev, "Unknown datatype: %d\n",
+				entry->csi2.datatype);
+			return -EINVAL;
+		}
+
+		bpp += format->bpp;
 	}
 
-	mbps = v4l2_ctrl_g_ctrl_int64(ctrl) * format->bpp;
+	mbps = v4l2_ctrl_g_ctrl_int64(ctrl) * bpp;
 	do_div(mbps, priv->lanes * 1000000);
 
 	for (hsfreq = priv->info->hsfreqrange; hsfreq->mbps != 0; hsfreq++)
@@ -391,11 +398,10 @@ static int rcar_csi2_calc_phypll(struct rcar_csi2 *priv,
 
 static int rcar_csi2_start(struct rcar_csi2 *priv)
 {
-	const struct rcar_csi2_format *format;
-	struct v4l2_subdev_format fmt;
+	struct v4l2_mbus_frame_desc_entry *entry;
 	struct media_pad *pad, *source_pad;
 	struct v4l2_subdev *source = NULL;
-	struct v4l2_mbus_framefmt *mf = &fmt.format;
+	struct v4l2_mbus_frame_desc fd;
 	u32 phycnt, phypll, tmp;
 	u32 vcdt = 0, vcdt2 = 0;
 	unsigned int i;
@@ -417,40 +423,33 @@ static int rcar_csi2_start(struct rcar_csi2 *priv)
 	dev_dbg(priv->dev, "Using source %s pad: %u\n", source->name,
 		source_pad->index);
 
-	fmt.which = V4L2_SUBDEV_FORMAT_ACTIVE;
-	fmt.pad = source_pad->index;
-	ret = v4l2_subdev_call(source, pad, get_fmt, NULL, &fmt);
-	if (ret)
-		return ret;
+	if (v4l2_subdev_call(source, pad, get_frame_desc, source_pad->index,
+			     &fd)) {
+		dev_err(priv->dev, "Could not read frame desc\n");
+		return -EINVAL;
+	}
 
-	dev_dbg(priv->dev, "Input size (%dx%d%c)\n", mf->width,
-		mf->height, mf->field == V4L2_FIELD_NONE ? 'p' : 'i');
-
-	/*
-	 * Enable all Virtual Channels
-	 *
-	 * NOTE: It's not possible to get individual format for each
-	 *       source virtual channel. Once this is possible in V4L2
-	 *       it should be used here.
-	 */
-	for (i = 0; i < 4; i++) {
-		format = rcar_csi2_code_to_fmt(mf->code);
-		if (!format) {
-			dev_err(priv->dev, "Unsupported media bus format: %d\n",
-				mf->code);
+	for (i = 0; i < fd.num_entries; i++) {
+		entry = &fd.entry[i];
+
+		if ((entry->flags & V4L2_MBUS_FRAME_DESC_FL_CSI2) == 0)
 			return -EINVAL;
-		}
 
-		tmp = VCDT_SEL_VC(i) | VCDT_VCDTN_EN | VCDT_SEL_DTN_ON |
-			VCDT_SEL_DT(format->datatype);
+		tmp = VCDT_SEL_VC(entry->csi2.channel) | VCDT_VCDTN_EN |
+			VCDT_SEL_DTN_ON | VCDT_SEL_DT(entry->csi2.datatype);
 
 		/* Store in correct reg and offset */
-		if (i < 2)
-			vcdt |= tmp << ((i % 2) * 16);
+		if (entry->csi2.channel < 2)
+			vcdt |= tmp << ((entry->csi2.channel % 2) * 16);
 		else
-			vcdt2 |= tmp << ((i % 2) * 16);
+			vcdt2 |= tmp << ((entry->csi2.channel % 2) * 16);
+
+		dev_dbg(priv->dev, "VC%d datatype: 0x%x\n",
+			entry->csi2.channel, entry->csi2.datatype);
 	}
 
+	dev_dbg(priv->dev, "VCDT: 0x%08x VCDT2: 0x%08x\n", vcdt, vcdt2);
+
 	switch (priv->lanes) {
 	case 1:
 		phycnt = PHYCNT_ENABLECLK | PHYCNT_ENABLE_0;
@@ -466,7 +465,7 @@ static int rcar_csi2_start(struct rcar_csi2 *priv)
 		return -EINVAL;
 	}
 
-	ret = rcar_csi2_calc_phypll(priv, source, mf, &phypll);
+	ret = rcar_csi2_calc_phypll(priv, source, &fd, &phypll);
 	if (ret)
 		return ret;
 
-- 
2.13.3
