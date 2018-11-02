Return-path: <linux-media-owner@vger.kernel.org>
Received: from bin-mail-out-05.binero.net ([195.74.38.228]:30550 "EHLO
        bin-mail-out-05.binero.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727250AbeKCBIe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 2 Nov 2018 21:08:34 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Jacopo Mondi <jacopo@jmondi.org>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v3 2/4] i2c: adv748x: reuse power up sequence when initializing CSI-2
Date: Fri,  2 Nov 2018 17:00:07 +0100
Message-Id: <20181102160009.17267-3-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20181102160009.17267-1-niklas.soderlund+renesas@ragnatech.se>
References: <20181102160009.17267-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Extend the MIPI CSI-2 power up sequence to match the power up sequence
in the hardware manual chapter "9.5.1 Power Up Sequence". This change
allows the power up functions to be reused when initializing the
hardware reducing code duplicating as well aligning with the
documentation.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

---
* Changes since v2
- Bring in the undocumented registers in the power on sequence from the
  initialization sequence after confirming in the hardware manual that
  this is the correct behavior.
---
 drivers/media/i2c/adv748x/adv748x-core.c | 50 ++++++------------------
 1 file changed, 13 insertions(+), 37 deletions(-)

diff --git a/drivers/media/i2c/adv748x/adv748x-core.c b/drivers/media/i2c/adv748x/adv748x-core.c
index 6854d898fdd1f192..2384f50dacb0ccff 100644
--- a/drivers/media/i2c/adv748x/adv748x-core.c
+++ b/drivers/media/i2c/adv748x/adv748x-core.c
@@ -234,6 +234,12 @@ static const struct adv748x_reg_value adv748x_power_up_txa_4lane[] = {
 
 	{ADV748X_PAGE_TXA, 0x00, 0x84},	/* Enable 4-lane MIPI */
 	{ADV748X_PAGE_TXA, 0x00, 0xa4},	/* Set Auto DPHY Timing */
+	{ADV748X_PAGE_TXA, 0xdb, 0x10},	/* ADI Required Write */
+	{ADV748X_PAGE_TXA, 0xd6, 0x07},	/* ADI Required Write */
+	{ADV748X_PAGE_TXA, 0xc4, 0x0a},	/* ADI Required Write */
+	{ADV748X_PAGE_TXA, 0x71, 0x33},	/* ADI Required Write */
+	{ADV748X_PAGE_TXA, 0x72, 0x11},	/* ADI Required Write */
+	{ADV748X_PAGE_TXA, 0xf0, 0x00},	/* i2c_dphy_pwdn - 1'b0 */
 
 	{ADV748X_PAGE_TXA, 0x31, 0x82},	/* ADI Required Write */
 	{ADV748X_PAGE_TXA, 0x1e, 0x40},	/* ADI Required Write */
@@ -263,6 +269,11 @@ static const struct adv748x_reg_value adv748x_power_up_txb_1lane[] = {
 
 	{ADV748X_PAGE_TXB, 0x00, 0x81},	/* Enable 1-lane MIPI */
 	{ADV748X_PAGE_TXB, 0x00, 0xa1},	/* Set Auto DPHY Timing */
+	{ADV748X_PAGE_TXB, 0xd2, 0x40},	/* ADI Required Write */
+	{ADV748X_PAGE_TXB, 0xc4, 0x0a},	/* ADI Required Write */
+	{ADV748X_PAGE_TXB, 0x71, 0x33},	/* ADI Required Write */
+	{ADV748X_PAGE_TXB, 0x72, 0x11},	/* ADI Required Write */
+	{ADV748X_PAGE_TXB, 0xf0, 0x00},	/* i2c_dphy_pwdn - 1'b0 */
 
 	{ADV748X_PAGE_TXB, 0x31, 0x82},	/* ADI Required Write */
 	{ADV748X_PAGE_TXB, 0x1e, 0x40},	/* ADI Required Write */
@@ -383,25 +394,6 @@ static const struct adv748x_reg_value adv748x_init_txa_4lane[] = {
 	{ADV748X_PAGE_IO, 0x0c, 0xe0},	/* Enable LLC_DLL & Double LLC Timing */
 	{ADV748X_PAGE_IO, 0x0e, 0xdd},	/* LLC/PIX/SPI PINS TRISTATED AUD */
 
-	{ADV748X_PAGE_TXA, 0x00, 0x84},	/* Enable 4-lane MIPI */
-	{ADV748X_PAGE_TXA, 0x00, 0xa4},	/* Set Auto DPHY Timing */
-	{ADV748X_PAGE_TXA, 0xdb, 0x10},	/* ADI Required Write */
-	{ADV748X_PAGE_TXA, 0xd6, 0x07},	/* ADI Required Write */
-	{ADV748X_PAGE_TXA, 0xc4, 0x0a},	/* ADI Required Write */
-	{ADV748X_PAGE_TXA, 0x71, 0x33},	/* ADI Required Write */
-	{ADV748X_PAGE_TXA, 0x72, 0x11},	/* ADI Required Write */
-	{ADV748X_PAGE_TXA, 0xf0, 0x00},	/* i2c_dphy_pwdn - 1'b0 */
-
-	{ADV748X_PAGE_TXA, 0x31, 0x82},	/* ADI Required Write */
-	{ADV748X_PAGE_TXA, 0x1e, 0x40},	/* ADI Required Write */
-	{ADV748X_PAGE_TXA, 0xda, 0x01},	/* i2c_mipi_pll_en - 1'b1 */
-	{ADV748X_PAGE_WAIT, 0x00, 0x02},/* delay 2 */
-	{ADV748X_PAGE_TXA, 0x00, 0x24 },/* Power-up CSI-TX */
-	{ADV748X_PAGE_WAIT, 0x00, 0x01},/* delay 1 */
-	{ADV748X_PAGE_TXA, 0xc1, 0x2b},	/* ADI Required Write */
-	{ADV748X_PAGE_WAIT, 0x00, 0x01},/* delay 1 */
-	{ADV748X_PAGE_TXA, 0x31, 0x80},	/* ADI Required Write */
-
 	{ADV748X_PAGE_EOR, 0xff, 0xff}	/* End of register table */
 };
 
@@ -435,24 +427,6 @@ static const struct adv748x_reg_value adv748x_init_txb_1lane[] = {
 	{ADV748X_PAGE_SDP, 0x31, 0x12},	/* ADI Required Write */
 	{ADV748X_PAGE_SDP, 0xe6, 0x4f},  /* V bit end pos manually in NTSC */
 
-	{ADV748X_PAGE_TXB, 0x00, 0x81},	/* Enable 1-lane MIPI */
-	{ADV748X_PAGE_TXB, 0x00, 0xa1},	/* Set Auto DPHY Timing */
-	{ADV748X_PAGE_TXB, 0xd2, 0x40},	/* ADI Required Write */
-	{ADV748X_PAGE_TXB, 0xc4, 0x0a},	/* ADI Required Write */
-	{ADV748X_PAGE_TXB, 0x71, 0x33},	/* ADI Required Write */
-	{ADV748X_PAGE_TXB, 0x72, 0x11},	/* ADI Required Write */
-	{ADV748X_PAGE_TXB, 0xf0, 0x00},	/* i2c_dphy_pwdn - 1'b0 */
-	{ADV748X_PAGE_TXB, 0x31, 0x82},	/* ADI Required Write */
-	{ADV748X_PAGE_TXB, 0x1e, 0x40},	/* ADI Required Write */
-	{ADV748X_PAGE_TXB, 0xda, 0x01},	/* i2c_mipi_pll_en - 1'b1 */
-
-	{ADV748X_PAGE_WAIT, 0x00, 0x02},/* delay 2 */
-	{ADV748X_PAGE_TXB, 0x00, 0x21 },/* Power-up CSI-TX */
-	{ADV748X_PAGE_WAIT, 0x00, 0x01},/* delay 1 */
-	{ADV748X_PAGE_TXB, 0xc1, 0x2b},	/* ADI Required Write */
-	{ADV748X_PAGE_WAIT, 0x00, 0x01},/* delay 1 */
-	{ADV748X_PAGE_TXB, 0x31, 0x80},	/* ADI Required Write */
-
 	{ADV748X_PAGE_EOR, 0xff, 0xff}	/* End of register table */
 };
 
@@ -474,6 +448,7 @@ static int adv748x_reset(struct adv748x_state *state)
 	if (ret)
 		return ret;
 
+	adv748x_tx_power(&state->txa, 1);
 	adv748x_tx_power(&state->txa, 0);
 
 	/* Init and power down TXB */
@@ -481,6 +456,7 @@ static int adv748x_reset(struct adv748x_state *state)
 	if (ret)
 		return ret;
 
+	adv748x_tx_power(&state->txb, 1);
 	adv748x_tx_power(&state->txb, 0);
 
 	/* Disable chip powerdown & Enable HDMI Rx block */
-- 
2.19.1
