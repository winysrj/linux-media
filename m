Return-Path: <SRS0=HTTW=RT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00395C10F03
	for <linux-media@archiver.kernel.org>; Sat, 16 Mar 2019 15:47:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D17B3218E0
	for <linux-media@archiver.kernel.org>; Sat, 16 Mar 2019 15:47:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726888AbfCPPrp (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 16 Mar 2019 11:47:45 -0400
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:35781 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726815AbfCPPro (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 16 Mar 2019 11:47:44 -0400
X-Originating-IP: 2.224.242.101
Received: from uno.lan (2-224-242-101.ip172.fastwebnet.it [2.224.242.101])
        (Authenticated sender: jacopo@jmondi.org)
        by relay8-d.mail.gandi.net (Postfix) with ESMTPSA id 273201BF209;
        Sat, 16 Mar 2019 15:47:40 +0000 (UTC)
From:   Jacopo Mondi <jacopo+renesas@jmondi.org>
To:     sakari.ailus@linux.intel.com, laurent.pinchart@ideasonboard.com,
        niklas.soderlund+renesas@ragnatech.se,
        kieran.bingham@ideasonboard.com
Cc:     Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        dave.stevenson@raspberrypi.org
Subject: [RFC 5/5] media: rcar-csi2: Configure CSI-2 with frame desc
Date:   Sat, 16 Mar 2019 16:48:01 +0100
Message-Id: <20190316154801.20460-6-jacopo+renesas@jmondi.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190316154801.20460-1-jacopo+renesas@jmondi.org>
References: <20190316154801.20460-1-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Use the D-PHY configuration reported by the remote subdevice in its
frame descriptor to configure the interface.

Store the number of lanes reported through the 'data-lanes' DT property
as the number of phyisically available lanes, which might not correspond
to the number of lanes actually in use.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
 drivers/media/platform/rcar-vin/rcar-csi2.c | 71 +++++++++++++--------
 1 file changed, 43 insertions(+), 28 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-csi2.c b/drivers/media/platform/rcar-vin/rcar-csi2.c
index 6c46bcc0ee83..70b9a8165a6e 100644
--- a/drivers/media/platform/rcar-vin/rcar-csi2.c
+++ b/drivers/media/platform/rcar-vin/rcar-csi2.c
@@ -375,8 +375,8 @@ struct rcar_csi2 {
 	struct mutex lock;
 	int stream_count;
 
-	unsigned short lanes;
-	unsigned char lane_swap[4];
+	unsigned short available_data_lanes;
+	unsigned short num_data_lanes;
 };
 
 static inline struct rcar_csi2 *sd_to_csi2(struct v4l2_subdev *sd)
@@ -424,7 +424,7 @@ static int rcsi2_get_remote_frame_desc(struct rcar_csi2 *priv,
 	if (ret)
 		return -ENODEV;
 
-	if (fd->type != V4L2_MBUS_FRAME_DESC_TYPE_CSI2) {
+	if (fd->type != V4L2_MBUS_FRAME_DESC_TYPE_CSI2_DPHY) {
 		dev_err(priv->dev, "Frame desc do not describe CSI-2 link");
 		return -EINVAL;
 	}
@@ -438,7 +438,7 @@ static int rcsi2_wait_phy_start(struct rcar_csi2 *priv)
 
 	/* Wait for the clock and data lanes to enter LP-11 state. */
 	for (timeout = 0; timeout <= 20; timeout++) {
-		const u32 lane_mask = (1 << priv->lanes) - 1;
+		const u32 lane_mask = (1 << priv->num_data_lanes) - 1;
 
 		if ((rcsi2_read(priv, PHCLM_REG) & PHCLM_STOPSTATECKL)  &&
 		    (rcsi2_read(priv, PHDLM_REG) & lane_mask) == lane_mask)
@@ -511,14 +511,15 @@ static int rcsi2_calc_mbps(struct rcar_csi2 *priv,
 	 * bps = link_freq * 2
 	 */
 	mbps = v4l2_ctrl_g_ctrl_int64(ctrl) * bpp;
-	do_div(mbps, priv->lanes * 1000000);
+	do_div(mbps, priv->num_data_lanes * 1000000);
 
 	return mbps;
 }
 
 static int rcsi2_start(struct rcar_csi2 *priv)
 {
-	u32 phycnt, vcdt = 0, vcdt2 = 0;
+	struct v4l2_mbus_frame_desc_entry_csi2_dphy *dphy;
+	u32 phycnt, vcdt = 0, vcdt2 = 0, lswap = 0;
 	struct v4l2_mbus_frame_desc fd;
 	unsigned int i;
 	int mbps, ret;
@@ -548,8 +549,26 @@ static int rcsi2_start(struct rcar_csi2 *priv)
 			entry->bus.csi2.channel, entry->bus.csi2.data_type);
 	}
 
+	/* Get description of the D-PHY media bus configuration. */
+	dphy = &fd.phy.csi2_dphy;
+	if (dphy->clock_lane != 0) {
+		dev_err(priv->dev,
+			"CSI-2 configuration not supported: clock at index %u",
+			dphy->clock_lane);
+		return -EINVAL;
+	}
+
+	if (dphy->num_data_lanes > priv->available_data_lanes ||
+	    dphy->num_data_lanes == 3) {
+		dev_err(priv->dev,
+			"Number of CSI-2 data lanes not supported: %u",
+			dphy->num_data_lanes);
+		return -EINVAL;
+	}
+	priv->num_data_lanes = dphy->num_data_lanes;
+
 	phycnt = PHYCNT_ENABLECLK;
-	phycnt |= (1 << priv->lanes) - 1;
+	phycnt |= (1 << priv->num_data_lanes) - 1;
 
 	mbps = rcsi2_calc_mbps(priv, &fd);
 	if (mbps < 0)
@@ -566,12 +585,11 @@ static int rcsi2_start(struct rcar_csi2 *priv)
 	rcsi2_write(priv, VCDT_REG, vcdt);
 	if (vcdt2)
 		rcsi2_write(priv, VCDT2_REG, vcdt2);
+
 	/* Lanes are zero indexed. */
-	rcsi2_write(priv, LSWAP_REG,
-		    LSWAP_L0SEL(priv->lane_swap[0] - 1) |
-		    LSWAP_L1SEL(priv->lane_swap[1] - 1) |
-		    LSWAP_L2SEL(priv->lane_swap[2] - 1) |
-		    LSWAP_L3SEL(priv->lane_swap[3] - 1));
+	for (i = 0; i < priv->num_data_lanes; ++i)
+		lswap |= (dphy->data_lanes[i] - 1) << (i * 2);
+	rcsi2_write(priv, LSWAP_REG, lswap);
 
 	/* Start */
 	if (priv->info->init_phtw) {
@@ -822,7 +840,7 @@ static const struct v4l2_async_notifier_operations rcar_csi2_notify_ops = {
 static int rcsi2_parse_v4l2(struct rcar_csi2 *priv,
 			    struct v4l2_fwnode_endpoint *vep)
 {
-	unsigned int i;
+	unsigned int num_data_lanes;
 
 	/* Only port 0 endpoint 0 is valid. */
 	if (vep->base.port || vep->base.id)
@@ -833,24 +851,21 @@ static int rcsi2_parse_v4l2(struct rcar_csi2 *priv,
 		return -EINVAL;
 	}
 
-	priv->lanes = vep->bus.mipi_csi2.num_data_lanes;
-	if (priv->lanes != 1 && priv->lanes != 2 && priv->lanes != 4) {
+	num_data_lanes = vep->bus.mipi_csi2.num_data_lanes;
+	switch (num_data_lanes) {
+	case 1:
+		/* fallthrough */
+	case 2:
+		/* fallthrough */
+	case 4:
+		priv->available_data_lanes = num_data_lanes;
+		break;
+	default:
 		dev_err(priv->dev, "Unsupported number of data-lanes: %u\n",
-			priv->lanes);
+			num_data_lanes);
 		return -EINVAL;
 	}
 
-	for (i = 0; i < ARRAY_SIZE(priv->lane_swap); i++) {
-		priv->lane_swap[i] = i < priv->lanes ?
-			vep->bus.mipi_csi2.data_lanes[i] : i;
-
-		/* Check for valid lane number. */
-		if (priv->lane_swap[i] < 1 || priv->lane_swap[i] > 4) {
-			dev_err(priv->dev, "data-lanes must be in 1-4 range\n");
-			return -EINVAL;
-		}
-	}
-
 	return 0;
 }
 
@@ -1235,7 +1250,7 @@ static int rcsi2_probe(struct platform_device *pdev)
 	if (ret < 0)
 		goto error;
 
-	dev_info(priv->dev, "%d lanes found\n", priv->lanes);
+	dev_info(priv->dev, "%d lanes found\n", priv->available_data_lanes);
 
 	return 0;
 
-- 
2.21.0

