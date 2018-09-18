Return-path: <linux-media-owner@vger.kernel.org>
Received: from bin-mail-out-06.binero.net ([195.74.38.229]:34042 "EHLO
        bin-mail-out-06.binero.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726990AbeIRHUI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Sep 2018 03:20:08 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Jacopo Mondi <jacopo@jmondi.org>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH 2/3] i2c: adv748x: configure number of lanes used for TXA CSI-2 transmitter
Date: Tue, 18 Sep 2018 03:45:08 +0200
Message-Id: <20180918014509.6394-3-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20180918014509.6394-1-niklas.soderlund+renesas@ragnatech.se>
References: <20180918014509.6394-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The driver fixed the TXA CSI-2 transmitter in 4-lane mode while it could
operate using 1-, 2- and 4-lanes. Update the driver to support all modes
the hardware does.

The driver make use of large tables of static register/value writes when
configuring the hardware, some writing to undocumented registers.
Instead of creating 3 sets of the register tables for the different
modes catch when the register containing NUM_LANES[2:0] is written to
and inject the correct number of lanes.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/i2c/adv748x/adv748x-core.c | 38 +++++++++++++++++++-----
 1 file changed, 30 insertions(+), 8 deletions(-)

diff --git a/drivers/media/i2c/adv748x/adv748x-core.c b/drivers/media/i2c/adv748x/adv748x-core.c
index a93f8ea89a228474..9a82cdf301bccb41 100644
--- a/drivers/media/i2c/adv748x/adv748x-core.c
+++ b/drivers/media/i2c/adv748x/adv748x-core.c
@@ -207,13 +207,23 @@ static int adv748x_write_regs(struct adv748x_state *state,
 			      const struct adv748x_reg_value *regs)
 {
 	int ret;
+	u8 value;
 
 	while (regs->page != ADV748X_PAGE_EOR) {
 		if (regs->page == ADV748X_PAGE_WAIT) {
 			msleep(regs->value);
 		} else {
+			value = regs->value;
+
+			/*
+			 * Register 0x00 in TXA needs to bei injected with
+			 * the number of CSI-2 lanes used to transmitt.
+			 */
+			if (regs->page == ADV748X_PAGE_TXA && regs->reg == 0x00)
+				value = (value & ~7) | state->txa.num_lanes;
+
 			ret = adv748x_write(state, regs->page, regs->reg,
-				      regs->value);
+					    value);
 			if (ret < 0) {
 				adv_err(state,
 					"Error regs page: 0x%02x reg: 0x%02x\n",
@@ -233,14 +243,18 @@ static int adv748x_write_regs(struct adv748x_state *state,
 
 static const struct adv748x_reg_value adv748x_power_up_txa_4lane[] = {
 
-	{ADV748X_PAGE_TXA, 0x00, 0x84},	/* Enable 4-lane MIPI */
-	{ADV748X_PAGE_TXA, 0x00, 0xa4},	/* Set Auto DPHY Timing */
+	/* NOTE: NUM_LANES[2:0] in TXA register 0x00 is injected on write. */
+	{ADV748X_PAGE_TXA, 0x00, 0x80},	/* Enable n-lane MIPI */
+	{ADV748X_PAGE_TXA, 0x00, 0xa0},	/* Set Auto DPHY Timing */
 
 	{ADV748X_PAGE_TXA, 0x31, 0x82},	/* ADI Required Write */
 	{ADV748X_PAGE_TXA, 0x1e, 0x40},	/* ADI Required Write */
 	{ADV748X_PAGE_TXA, 0xda, 0x01},	/* i2c_mipi_pll_en - 1'b1 */
 	{ADV748X_PAGE_WAIT, 0x00, 0x02},/* delay 2 */
-	{ADV748X_PAGE_TXA, 0x00, 0x24 },/* Power-up CSI-TX */
+
+	/* NOTE: NUM_LANES[2:0] in TXA register 0x00 is injected on write. */
+	{ADV748X_PAGE_TXA, 0x00, 0x20 },/* Power-up CSI-TX */
+
 	{ADV748X_PAGE_WAIT, 0x00, 0x01},/* delay 1 */
 	{ADV748X_PAGE_TXA, 0xc1, 0x2b},	/* ADI Required Write */
 	{ADV748X_PAGE_WAIT, 0x00, 0x01},/* delay 1 */
@@ -253,7 +267,10 @@ static const struct adv748x_reg_value adv748x_power_down_txa_4lane[] = {
 
 	{ADV748X_PAGE_TXA, 0x31, 0x82},	/* ADI Required Write */
 	{ADV748X_PAGE_TXA, 0x1e, 0x00},	/* ADI Required Write */
-	{ADV748X_PAGE_TXA, 0x00, 0x84},	/* Enable 4-lane MIPI */
+
+	/* NOTE: NUM_LANES[2:0] in TXA register 0x00 is injected on write. */
+	{ADV748X_PAGE_TXA, 0x00, 0x80},	/* Enable n-lane MIPI */
+
 	{ADV748X_PAGE_TXA, 0xda, 0x01},	/* i2c_mipi_pll_en - 1'b1 */
 	{ADV748X_PAGE_TXA, 0xc1, 0x3b},	/* ADI Required Write */
 
@@ -399,8 +416,10 @@ static const struct adv748x_reg_value adv748x_init_txa_4lane[] = {
 	/* Outputs Enabled */
 	{ADV748X_PAGE_IO, 0x10, 0xa0},	/* Enable 4-lane CSI Tx & Pixel Port */
 
-	{ADV748X_PAGE_TXA, 0x00, 0x84},	/* Enable 4-lane MIPI */
-	{ADV748X_PAGE_TXA, 0x00, 0xa4},	/* Set Auto DPHY Timing */
+	/* NOTE: NUM_LANES[2:0] in TXA register 0x00 is injected on write. */
+	{ADV748X_PAGE_TXA, 0x00, 0x80},	/* Enable n-lane MIPI */
+	{ADV748X_PAGE_TXA, 0x00, 0xa0},	/* Set Auto DPHY Timing */
+
 	{ADV748X_PAGE_TXA, 0xdb, 0x10},	/* ADI Required Write */
 	{ADV748X_PAGE_TXA, 0xd6, 0x07},	/* ADI Required Write */
 	{ADV748X_PAGE_TXA, 0xc4, 0x0a},	/* ADI Required Write */
@@ -412,7 +431,10 @@ static const struct adv748x_reg_value adv748x_init_txa_4lane[] = {
 	{ADV748X_PAGE_TXA, 0x1e, 0x40},	/* ADI Required Write */
 	{ADV748X_PAGE_TXA, 0xda, 0x01},	/* i2c_mipi_pll_en - 1'b1 */
 	{ADV748X_PAGE_WAIT, 0x00, 0x02},/* delay 2 */
-	{ADV748X_PAGE_TXA, 0x00, 0x24 },/* Power-up CSI-TX */
+
+	/* NOTE: NUM_LANES[2:0] in TXA register 0x00 is injected on write. */
+	{ADV748X_PAGE_TXA, 0x00, 0x20 },/* Power-up CSI-TX */
+
 	{ADV748X_PAGE_WAIT, 0x00, 0x01},/* delay 1 */
 	{ADV748X_PAGE_TXA, 0xc1, 0x2b},	/* ADI Required Write */
 	{ADV748X_PAGE_WAIT, 0x00, 0x01},/* delay 1 */
-- 
2.18.0
