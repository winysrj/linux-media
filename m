Return-Path: <SRS0=h5dj=RI=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12FADC43381
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 18:52:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D0AC821019
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 18:52:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728793AbfCESwM (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 5 Mar 2019 13:52:12 -0500
Received: from relay12.mail.gandi.net ([217.70.178.232]:49199 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728789AbfCESwK (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 5 Mar 2019 13:52:10 -0500
Received: from uno.lan (2-224-242-101.ip172.fastwebnet.it [2.224.242.101])
        (Authenticated sender: jacopo@jmondi.org)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id D922F20000D;
        Tue,  5 Mar 2019 18:52:07 +0000 (UTC)
From:   Jacopo Mondi <jacopo+renesas@jmondi.org>
To:     sakari.ailus@linux.intel.com, laurent.pinchart@ideasonboard.com,
        niklas.soderlund+renesas@ragnatech.se
Cc:     Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: [PATCH v3 29/31] rcar-csi2: use frame description information to configure CSI-2 bus
Date:   Tue,  5 Mar 2019 19:51:48 +0100
Message-Id: <20190305185150.20776-30-jacopo+renesas@jmondi.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190305185150.20776-1-jacopo+renesas@jmondi.org>
References: <20190305185150.20776-1-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

The driver can now access frame descriptor information, use it when
configuring the CSI-2 bus. Only enable the virtual channels which are
described in the frame descriptor and calculate the link based on all
enabled streams.

With multiplexed stream supported it's now meaningful to have different
formats on the different source pads. Make source formats independent
off each other and disallowing a format on the multiplexed sink pad.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Reviewed-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
 drivers/media/platform/rcar-vin/rcar-csi2.c | 134 ++++++++++++++------
 1 file changed, 96 insertions(+), 38 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-csi2.c b/drivers/media/platform/rcar-vin/rcar-csi2.c
index f64528d2be3c..f9cc99ba00bc 100644
--- a/drivers/media/platform/rcar-vin/rcar-csi2.c
+++ b/drivers/media/platform/rcar-vin/rcar-csi2.c
@@ -304,25 +304,21 @@ static const struct rcsi2_mbps_reg hsfreqrange_m3w_h3es1[] = {
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
+static const struct rcar_csi2_format *rcsi2_datatype_to_fmt(unsigned int dt)
 {
 	unsigned int i;
 
 	for (i = 0; i < ARRAY_SIZE(rcar_csi2_formats); i++)
-		if (rcar_csi2_formats[i].code == code)
+		if (rcar_csi2_formats[i].datatype == dt)
 			return &rcar_csi2_formats[i];
 
 	return NULL;
@@ -337,6 +333,14 @@ enum rcar_csi2_pads {
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
@@ -358,7 +362,7 @@ struct rcar_csi2 {
 	struct v4l2_async_subdev asd;
 	struct v4l2_subdev *remote;
 
-	struct v4l2_mbus_framefmt mf;
+	struct v4l2_mbus_framefmt mf[4];
 
 	struct mutex lock;
 	int stream_count;
@@ -394,6 +398,32 @@ static void rcsi2_reset(struct rcar_csi2 *priv)
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
@@ -432,10 +462,12 @@ static int rcsi2_set_phypll(struct rcar_csi2 *priv, unsigned int mbps)
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
@@ -451,6 +483,20 @@ static int rcsi2_calc_mbps(struct rcar_csi2 *priv, unsigned int bpp)
 		return -EINVAL;
 	}
 
+	/* Calculate total bpp */
+	for (i = 0; i < fd->num_entries; i++) {
+		const struct rcar_csi2_format *format;
+
+		format = rcsi2_datatype_to_fmt(fd->entry[i].bus.csi2.data_type);
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
@@ -464,43 +510,40 @@ static int rcsi2_calc_mbps(struct rcar_csi2 *priv, unsigned int bpp)
 
 static int rcsi2_start(struct rcar_csi2 *priv)
 {
-	const struct rcar_csi2_format *format;
 	u32 phycnt, vcdt = 0, vcdt2 = 0;
+	struct v4l2_mbus_frame_desc fd;
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
-	 * Enable all supported CSI-2 channels with virtual channel and
-	 * data type matching.
-	 *
-	 * NOTE: It's not possible to get individual datatype for each
-	 *       source virtual channel. Once this is possible in V4L2
-	 *       it should be used here.
-	 */
-	for (i = 0; i < priv->info->num_channels; i++) {
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
 
@@ -622,14 +665,16 @@ static int rcsi2_set_pad_format(struct v4l2_subdev *sd,
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
 
@@ -641,11 +686,17 @@ static int rcsi2_get_pad_format(struct v4l2_subdev *sd,
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
@@ -675,6 +726,13 @@ static int rcsi2_notify_bound(struct v4l2_async_notifier *notifier,
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
2.20.1

