Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:59629 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729333AbeKEUjF (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 5 Nov 2018 15:39:05 -0500
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: niklas.soderlund@ragnatech.se, laurent.pinchart@ideasonboard.com,
        kieran.bingham@ideasonboard.com
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: [PATCH 6/6] media: rcar-csi2: Handle per-SoC number of channels
Date: Mon,  5 Nov 2018 12:19:11 +0100
Message-Id: <1541416751-19810-7-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1541416751-19810-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1541416751-19810-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The R-Car CSI-2 interface has a number of selectable 'channels' that
provides pixel data to the VINs during image acquisition.

Each channel can be used to match a CSI-2 data type and a CSI-2 virtual
channel to be routed to output path.

Different SoCs have different number of channels, with R-Car E3 being the
notable exception supporting only 2 of them.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
 drivers/media/platform/rcar-vin/rcar-csi2.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-csi2.c b/drivers/media/platform/rcar-vin/rcar-csi2.c
index 5689a60..95a3dd4 100644
--- a/drivers/media/platform/rcar-vin/rcar-csi2.c
+++ b/drivers/media/platform/rcar-vin/rcar-csi2.c
@@ -349,6 +349,7 @@ struct rcar_csi2_info {
 	int (*confirm_start)(struct rcar_csi2 *priv);
 	const struct rcsi2_mbps_reg *hsfreqrange;
 	unsigned int csi0clkfreqrange;
+	unsigned int num_channels;
 	bool clear_ulps;
 };
 
@@ -483,13 +484,14 @@ static int rcsi2_start(struct rcar_csi2 *priv)
 	format = rcsi2_code_to_fmt(priv->mf.code);
 
 	/*
-	 * Enable all Virtual Channels.
+	 * Enable all supported CSI-2 channels with virtual channel and
+	 * data type matching.
 	 *
 	 * NOTE: It's not possible to get individual datatype for each
 	 *       source virtual channel. Once this is possible in V4L2
 	 *       it should be used here.
 	 */
-	for (i = 0; i < 4; i++) {
+	for (i = 0; i < priv->info->num_channels; i++) {
 		u32 vcdt_part;
 
 		vcdt_part = VCDT_SEL_VC(i) | VCDT_VCDTN_EN | VCDT_SEL_DTN_ON |
@@ -518,7 +520,8 @@ static int rcsi2_start(struct rcar_csi2 *priv)
 	rcsi2_write(priv, FLD_REG, FLD_FLD_NUM(2) | FLD_FLD_EN4 |
 		    FLD_FLD_EN3 | FLD_FLD_EN2 | FLD_FLD_EN);
 	rcsi2_write(priv, VCDT_REG, vcdt);
-	rcsi2_write(priv, VCDT2_REG, vcdt2);
+	if (vcdt2)
+		rcsi2_write(priv, VCDT2_REG, vcdt2);
 	/* Lanes are zero indexed. */
 	rcsi2_write(priv, LSWAP_REG,
 		    LSWAP_L0SEL(priv->lane_swap[0] - 1) |
@@ -947,32 +950,38 @@ static const struct rcar_csi2_info rcar_csi2_info_r8a7795 = {
 	.init_phtw = rcsi2_init_phtw_h3_v3h_m3n,
 	.hsfreqrange = hsfreqrange_h3_v3h_m3n,
 	.csi0clkfreqrange = 0x20,
+	.num_channels = 4,
 	.clear_ulps = true,
 };
 
 static const struct rcar_csi2_info rcar_csi2_info_r8a7795es1 = {
 	.hsfreqrange = hsfreqrange_m3w_h3es1,
+	.num_channels = 4,
 };
 
 static const struct rcar_csi2_info rcar_csi2_info_r8a7796 = {
 	.hsfreqrange = hsfreqrange_m3w_h3es1,
+	.num_channels = 4,
 };
 
 static const struct rcar_csi2_info rcar_csi2_info_r8a77965 = {
 	.init_phtw = rcsi2_init_phtw_h3_v3h_m3n,
 	.hsfreqrange = hsfreqrange_h3_v3h_m3n,
 	.csi0clkfreqrange = 0x20,
+	.num_channels = 4,
 	.clear_ulps = true,
 };
 
 static const struct rcar_csi2_info rcar_csi2_info_r8a77970 = {
 	.init_phtw = rcsi2_init_phtw_v3m_e3,
 	.confirm_start = rcsi2_confirm_start_v3m_e3,
+	.num_channels = 4,
 };
 
 static const struct rcar_csi2_info rcar_csi2_info_r8a77990 = {
 	.init_phtw = rcsi2_init_phtw_v3m_e3,
 	.confirm_start = rcsi2_confirm_start_v3m_e3,
+	.num_channels = 2,
 };
 
 static const struct of_device_id rcar_csi2_of_table[] = {
-- 
2.7.4
