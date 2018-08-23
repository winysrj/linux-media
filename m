Return-path: <linux-media-owner@vger.kernel.org>
Received: from bin-mail-out-05.binero.net ([195.74.38.228]:12584 "EHLO
        bin-mail-out-05.binero.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730851AbeHWQ6H (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 23 Aug 2018 12:58:07 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH 29/30] rcar-csi2: use frame description information to configure CSI-2 bus
Date: Thu, 23 Aug 2018 15:25:43 +0200
Message-Id: <20180823132544.521-30-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20180823132544.521-1-niklas.soderlund+renesas@ragnatech.se>
References: <20180823132544.521-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The driver can now access frame descriptor information, use it when
configuring the CSI-2 bus. Only enable the virtual channels which are
described in the frame descriptor and calculate the link based on all
enabled streams.

With multiplexed stream supported it's now meaningful to have different
formats on the different source pads. Make source formats independent
off each other and disallowing a format on the multiplexed sink pad.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-csi2.c | 135 ++++++++++++++------
 1 file changed, 98 insertions(+), 37 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-csi2.c b/drivers/media/platform/rcar-vin/rcar-csi2.c
index dc5ae8025832ab6e..467722007b328e4e 100644
--- a/drivers/media/platform/rcar-vin/rcar-csi2.c
+++ b/drivers/media/platform/rcar-vin/rcar-csi2.c
@@ -304,25 +304,22 @@ static const struct rcsi2_mbps_reg hsfreqrange_m3w_h3es1[] = {
 #define CSI0CLKFREQRANGE(n)		((n & 0x3f) << 16)
 
 struct rcar_csi2_format {
-	u32 code;
 	unsigned int datatype;
 	unsigned int bpp;
 };
 
 static const struct rcar_csi2_format rcar_csi2_formats[] = {
-	{ .code = MEDIA_BUS_FMT_RGB888_1X24,	.datatype = 0x24, .bpp = 24 },
-	{ .code = MEDIA_BUS_FMT_UYVY8_1X16,	.datatype = 0x1e, .bpp = 16 },
-	{ .code = MEDIA_BUS_FMT_YUYV8_1X16,	.datatype = 0x1e, .bpp = 16 },
-	{ .code = MEDIA_BUS_FMT_UYVY8_2X8,	.datatype = 0x1e, .bpp = 16 },
-	{ .code = MEDIA_BUS_FMT_YUYV10_2X10,	.datatype = 0x1e, .bpp = 20 },
+	{ .datatype = 0x1e, .bpp = 16 },
+	{ .datatype = 0x24, .bpp = 24 },
 };
 
-static const struct rcar_csi2_format *rcsi2_code_to_fmt(unsigned int code)
+static const struct rcar_csi2_format
+*rcsi2_datatype_to_fmt(unsigned int datatype)
 {
 	unsigned int i;
 
 	for (i = 0; i < ARRAY_SIZE(rcar_csi2_formats); i++)
-		if (rcar_csi2_formats[i].code == code)
+		if (rcar_csi2_formats[i].datatype == datatype)
 			return &rcar_csi2_formats[i];
 
 	return NULL;
@@ -337,6 +334,14 @@ enum rcar_csi2_pads {
 	NR_OF_RCAR_CSI2_PAD,
 };
 
+static int rcsi2_pad_to_vc(unsigned int pad)
+{
+	if (pad < RCAR_CSI2_SOURCE_VC0 || pad > RCAR_CSI2_SOURCE_VC3)
+		return -EINVAL;
+
+	return pad - RCAR_CSI2_SOURCE_VC0;
+}
+
 struct rcar_csi2_info {
 	int (*init_phtw)(struct rcar_csi2 *priv, unsigned int mbps);
 	int (*confirm_start)(struct rcar_csi2 *priv);
@@ -357,7 +362,7 @@ struct rcar_csi2 {
 	struct v4l2_async_subdev asd;
 	struct v4l2_subdev *remote;
 
-	struct v4l2_mbus_framefmt mf;
+	struct v4l2_mbus_framefmt mf[4];
 
 	struct mutex lock;
 	int stream_count;
@@ -393,6 +398,32 @@ static void rcsi2_reset(struct rcar_csi2 *priv)
 	rcsi2_write(priv, SRST_REG, 0);
 }
 
+static int rcsi2_get_remote_frame_desc(struct rcar_csi2 *priv,
+				       struct v4l2_mbus_frame_desc *fd)
+{
+	struct media_pad *pad;
+	int ret;
+
+	if (!priv->remote)
+		return -ENODEV;
+
+	pad = media_entity_remote_pad(&priv->pads[RCAR_CSI2_SINK]);
+	if (!pad)
+		return -ENODEV;
+
+	ret = v4l2_subdev_call(priv->remote, pad, get_frame_desc,
+			       pad->index, fd);
+	if (ret)
+		return -ENODEV;
+
+	if (fd->type != V4L2_MBUS_FRAME_DESC_TYPE_CSI2) {
+		dev_err(priv->dev, "Frame desc do not describe CSI-2 link");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static int rcsi2_wait_phy_start(struct rcar_csi2 *priv)
 {
 	unsigned int timeout;
@@ -431,10 +462,12 @@ static int rcsi2_set_phypll(struct rcar_csi2 *priv, unsigned int mbps)
 	return 0;
 }
 
-static int rcsi2_calc_mbps(struct rcar_csi2 *priv, unsigned int bpp)
+static int rcsi2_calc_mbps(struct rcar_csi2 *priv,
+			   struct v4l2_mbus_frame_desc *fd)
 {
 	struct v4l2_subdev *source;
 	struct v4l2_ctrl *ctrl;
+	unsigned int i, bpp = 0;
 	u64 mbps;
 
 	if (!priv->remote)
@@ -450,6 +483,21 @@ static int rcsi2_calc_mbps(struct rcar_csi2 *priv, unsigned int bpp)
 		return -EINVAL;
 	}
 
+	/* Calculate total bpp */
+	for (i = 0; i < fd->num_entries; i++) {
+		const struct rcar_csi2_format *format;
+
+		format = rcsi2_datatype_to_fmt(
+					fd->entry[i].bus.csi2.data_type);
+		if (!format) {
+			dev_err(priv->dev, "Unknown data type: %d\n",
+				fd->entry[i].bus.csi2.data_type);
+			return -EINVAL;
+		}
+
+		bpp += format->bpp;
+	}
+
 	/*
 	 * Calculate the phypll in mbps.
 	 * link_freq = (pixel_rate * bits_per_sample) / (2 * nr_of_lanes)
@@ -463,42 +511,40 @@ static int rcsi2_calc_mbps(struct rcar_csi2 *priv, unsigned int bpp)
 
 static int rcsi2_start(struct rcar_csi2 *priv)
 {
-	const struct rcar_csi2_format *format;
+	struct v4l2_mbus_frame_desc fd;
 	u32 phycnt, vcdt = 0, vcdt2 = 0;
 	unsigned int i;
 	int mbps, ret;
 
-	dev_dbg(priv->dev, "Input size (%ux%u%c)\n",
-		priv->mf.width, priv->mf.height,
-		priv->mf.field == V4L2_FIELD_NONE ? 'p' : 'i');
-
-	/* Code is validated in set_fmt. */
-	format = rcsi2_code_to_fmt(priv->mf.code);
+	/* Get information about multiplexed link. */
+	ret = rcsi2_get_remote_frame_desc(priv, &fd);
+	if (ret)
+		return ret;
 
-	/*
-	 * Enable all Virtual Channels.
-	 *
-	 * NOTE: It's not possible to get individual datatype for each
-	 *       source virtual channel. Once this is possible in V4L2
-	 *       it should be used here.
-	 */
-	for (i = 0; i < 4; i++) {
+	for (i = 0; i < fd.num_entries; i++) {
+		struct v4l2_mbus_frame_desc_entry *entry = &fd.entry[i];
 		u32 vcdt_part;
 
-		vcdt_part = VCDT_SEL_VC(i) | VCDT_VCDTN_EN | VCDT_SEL_DTN_ON |
-			VCDT_SEL_DT(format->datatype);
+		vcdt_part = VCDT_SEL_VC(entry->bus.csi2.channel) |
+			VCDT_VCDTN_EN | VCDT_SEL_DTN_ON |
+			VCDT_SEL_DT(entry->bus.csi2.data_type);
 
 		/* Store in correct reg and offset. */
-		if (i < 2)
-			vcdt |= vcdt_part << ((i % 2) * 16);
+		if (entry->bus.csi2.channel < 2)
+			vcdt |= vcdt_part <<
+				((entry->bus.csi2.channel % 2) * 16);
 		else
-			vcdt2 |= vcdt_part << ((i % 2) * 16);
+			vcdt2 |= vcdt_part <<
+				((entry->bus.csi2.channel % 2) * 16);
+
+		dev_dbg(priv->dev, "VC%d datatype: 0x%x\n",
+			entry->bus.csi2.channel, entry->bus.csi2.data_type);
 	}
 
 	phycnt = PHYCNT_ENABLECLK;
 	phycnt |= (1 << priv->lanes) - 1;
 
-	mbps = rcsi2_calc_mbps(priv, format->bpp);
+	mbps = rcsi2_calc_mbps(priv, &fd);
 	if (mbps < 0)
 		return mbps;
 
@@ -619,14 +665,16 @@ static int rcsi2_set_pad_format(struct v4l2_subdev *sd,
 {
 	struct rcar_csi2 *priv = sd_to_csi2(sd);
 	struct v4l2_mbus_framefmt *framefmt;
+	int vc;
 
-	if (!rcsi2_code_to_fmt(format->format.code))
-		format->format.code = rcar_csi2_formats[0].code;
+	vc = rcsi2_pad_to_vc(format->pad);
+	if (vc < 0)
+		return vc;
 
 	if (format->which == V4L2_SUBDEV_FORMAT_ACTIVE) {
-		priv->mf = format->format;
+		priv->mf[vc] = format->format;
 	} else {
-		framefmt = v4l2_subdev_get_try_format(sd, cfg, 0);
+		framefmt = v4l2_subdev_get_try_format(sd, cfg, format->pad);
 		*framefmt = format->format;
 	}
 
@@ -638,11 +686,17 @@ static int rcsi2_get_pad_format(struct v4l2_subdev *sd,
 				struct v4l2_subdev_format *format)
 {
 	struct rcar_csi2 *priv = sd_to_csi2(sd);
+	int vc;
+
+	vc = rcsi2_pad_to_vc(format->pad);
+	if (vc < 0)
+		return vc;
 
 	if (format->which == V4L2_SUBDEV_FORMAT_ACTIVE)
-		format->format = priv->mf;
+		format->format = priv->mf[vc];
 	else
-		format->format = *v4l2_subdev_get_try_format(sd, cfg, 0);
+		format->format = *v4l2_subdev_get_try_format(sd, cfg,
+							     format->pad);
 
 	return 0;
 }
@@ -672,6 +726,13 @@ static int rcsi2_notify_bound(struct v4l2_async_notifier *notifier,
 	struct rcar_csi2 *priv = notifier_to_csi2(notifier);
 	int pad;
 
+	if (!v4l2_subdev_has_op(subdev, pad, get_frame_desc)) {
+		dev_err(priv->dev,
+			"Failed as '%s' do not support frame descriptors\n",
+			subdev->name);
+		return -EINVAL;
+	}
+
 	pad = media_entity_get_fwnode_pad(&subdev->entity, asd->match.fwnode,
 					  MEDIA_PAD_FL_SOURCE);
 	if (pad < 0) {
-- 
2.18.0
