Return-Path: <SRS0=HTTW=RT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C7EAC4360F
	for <linux-media@archiver.kernel.org>; Sat, 16 Mar 2019 15:47:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DBA47218E0
	for <linux-media@archiver.kernel.org>; Sat, 16 Mar 2019 15:47:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726698AbfCPPrk (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 16 Mar 2019 11:47:40 -0400
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:49297 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726504AbfCPPrk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 16 Mar 2019 11:47:40 -0400
X-Originating-IP: 2.224.242.101
Received: from uno.lan (2-224-242-101.ip172.fastwebnet.it [2.224.242.101])
        (Authenticated sender: jacopo@jmondi.org)
        by relay8-d.mail.gandi.net (Postfix) with ESMTPSA id 3610B1BF20B;
        Sat, 16 Mar 2019 15:47:36 +0000 (UTC)
From:   Jacopo Mondi <jacopo+renesas@jmondi.org>
To:     sakari.ailus@linux.intel.com, laurent.pinchart@ideasonboard.com,
        niklas.soderlund+renesas@ragnatech.se,
        kieran.bingham@ideasonboard.com
Cc:     Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        dave.stevenson@raspberrypi.org
Subject: [RFC 2/5] media: adv748x: Post-pone IO10 write to power up
Date:   Sat, 16 Mar 2019 16:47:58 +0100
Message-Id: <20190316154801.20460-3-jacopo+renesas@jmondi.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190316154801.20460-1-jacopo+renesas@jmondi.org>
References: <20190316154801.20460-1-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Post-pone the write of the ADV748X_IO_10 register that controls the active
routing between the CP and AFE cores to the 4-lanes CSI-2 TXA at TX
power-up time.

While at there, use the 'csi4_in_sel' name, which matches the register
field description in the manual, in place of 'io_10' which is the full
register name.

Fixes: 9423ca350df7 ("media: adv748x: Implement TX link_setup callback")
Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
 drivers/media/i2c/adv748x/adv748x-core.c | 53 ++++++++++++++----------
 drivers/media/i2c/adv748x/adv748x.h      |  2 +
 2 files changed, 33 insertions(+), 22 deletions(-)

diff --git a/drivers/media/i2c/adv748x/adv748x-core.c b/drivers/media/i2c/adv748x/adv748x-core.c
index 0e5a75eb6d75..02135741b1a6 100644
--- a/drivers/media/i2c/adv748x/adv748x-core.c
+++ b/drivers/media/i2c/adv748x/adv748x-core.c
@@ -305,23 +305,35 @@ static int adv748x_power_down_tx(struct adv748x_csi2 *tx)

 int adv748x_tx_power(struct adv748x_csi2 *tx, bool on)
 {
-	int val;
+	u8 io10_mask = ADV748X_IO_10_CSI1_EN | ADV748X_IO_10_CSI4_EN |
+		       ADV748X_IO_10_CSI4_IN_SEL_AFE;
+	struct adv748x_state *state = tx->state;
+	int ret;

 	if (!is_tx_enabled(tx))
 		return 0;

-	val = tx_read(tx, ADV748X_CSI_FS_AS_LS);
-	if (val < 0)
-		return val;
+	ret = tx_read(tx, ADV748X_CSI_FS_AS_LS);
+	if (ret < 0)
+		return ret;

 	/*
 	 * This test against BIT(6) is not documented by the datasheet, but was
 	 * specified in the downstream driver.
 	 * Track with a WARN_ONCE to determine if it is ever set by HW.
 	 */
-	WARN_ONCE((on && val & ADV748X_CSI_FS_AS_LS_UNKNOWN),
+	WARN_ONCE((on && ret & ADV748X_CSI_FS_AS_LS_UNKNOWN),
 			"Enabling with unknown bit set");

+	/* Configure TXA routing. */
+	if (on) {
+		ret = io_clrset(state, ADV748X_IO_10, io10_mask,
+				state->csi4_in_sel);
+		if (ret)
+			return ret;
+	}
+
+
 	return on ? adv748x_power_up_tx(tx) : adv748x_power_down_tx(tx);
 }

@@ -337,10 +349,7 @@ static int adv748x_link_setup(struct media_entity *entity,
 	struct adv748x_state *state = v4l2_get_subdevdata(sd);
 	struct adv748x_csi2 *tx = adv748x_sd_to_csi2(sd);
 	bool enable = flags & MEDIA_LNK_FL_ENABLED;
-	u8 io10_mask = ADV748X_IO_10_CSI1_EN |
-		       ADV748X_IO_10_CSI4_EN |
-		       ADV748X_IO_10_CSI4_IN_SEL_AFE;
-	u8 io10 = 0;
+	u8 csi4_in_sel = 0;

 	/* Refuse to enable multiple links to the same TX at the same time. */
 	if (enable && tx->src)
@@ -359,17 +368,19 @@ static int adv748x_link_setup(struct media_entity *entity,

 	if (state->afe.tx) {
 		/* AFE Requires TXA enabled, even when output to TXB */
-		io10 |= ADV748X_IO_10_CSI4_EN;
+		csi4_in_sel |= ADV748X_IO_10_CSI4_EN;
 		if (is_txa(tx))
-			io10 |= ADV748X_IO_10_CSI4_IN_SEL_AFE;
+			csi4_in_sel |= ADV748X_IO_10_CSI4_IN_SEL_AFE;
 		else
-			io10 |= ADV748X_IO_10_CSI1_EN;
+			csi4_in_sel |= ADV748X_IO_10_CSI1_EN;
 	}

 	if (state->hdmi.tx)
-		io10 |= ADV748X_IO_10_CSI4_EN;
+		csi4_in_sel |= ADV748X_IO_10_CSI4_EN;

-	return io_clrset(state, ADV748X_IO_10, io10_mask, io10);
+	state->csi4_in_sel = csi4_in_sel;
+
+	return 0;
 }

 static const struct media_entity_operations adv748x_tx_media_ops = {
@@ -485,7 +496,6 @@ static int adv748x_sw_reset(struct adv748x_state *state)
 static int adv748x_reset(struct adv748x_state *state)
 {
 	int ret;
-	u8 regval = 0;

 	ret = adv748x_sw_reset(state);
 	if (ret < 0)
@@ -504,6 +514,12 @@ static int adv748x_reset(struct adv748x_state *state)
 	if (ret)
 		return ret;

+	/* Conditionally enable TXa and TXb. */
+	if (is_tx_enabled(&state->txa))
+		state->csi4_in_sel |= ADV748X_IO_10_CSI4_EN;
+	if (is_tx_enabled(&state->txb))
+		state->csi4_in_sel |= ADV748X_IO_10_CSI1_EN;
+
 	/* Reset TXA and TXB */
 	adv748x_tx_power(&state->txa, 1);
 	adv748x_tx_power(&state->txa, 0);
@@ -513,13 +529,6 @@ static int adv748x_reset(struct adv748x_state *state)
 	/* Disable chip powerdown & Enable HDMI Rx block */
 	io_write(state, ADV748X_IO_PD, ADV748X_IO_PD_RX_EN);

-	/* Conditionally enable TXa and TXb. */
-	if (is_tx_enabled(&state->txa))
-		regval |= ADV748X_IO_10_CSI4_EN;
-	if (is_tx_enabled(&state->txb))
-		regval |= ADV748X_IO_10_CSI1_EN;
-	io_write(state, ADV748X_IO_10, regval);
-
 	/* Use vid_std and v_freq as freerun resolution for CP */
 	cp_clrset(state, ADV748X_CP_CLMP_POS, ADV748X_CP_CLMP_POS_DIS_AUTO,
 					      ADV748X_CP_CLMP_POS_DIS_AUTO);
diff --git a/drivers/media/i2c/adv748x/adv748x.h b/drivers/media/i2c/adv748x/adv748x.h
index 4a5a6445604f..27c116d09284 100644
--- a/drivers/media/i2c/adv748x/adv748x.h
+++ b/drivers/media/i2c/adv748x/adv748x.h
@@ -196,6 +196,8 @@ struct adv748x_state {
 	struct adv748x_afe afe;
 	struct adv748x_csi2 txa;
 	struct adv748x_csi2 txb;
+
+	unsigned int csi4_in_sel;
 };

 #define adv748x_hdmi_to_state(h) container_of(h, struct adv748x_state, hdmi)
--
2.21.0

