Return-path: <linux-media-owner@vger.kernel.org>
Received: from vsp-unauthed02.binero.net ([195.74.38.227]:33186 "EHLO
        vsp-unauthed02.binero.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727977AbeJEDhb (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 4 Oct 2018 23:37:31 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>
To: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Jacopo Mondi <jacopo@jmondi.org>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v2 3/5] i2c: adv748x: reuse power up sequence when initializing CSI-2
Date: Thu,  4 Oct 2018 22:41:36 +0200
Message-Id: <20181004204138.2784-4-niklas.soderlund@ragnatech.se>
In-Reply-To: <20181004204138.2784-1-niklas.soderlund@ragnatech.se>
References: <20181004204138.2784-1-niklas.soderlund@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

Instead of duplicate the register writes to power on the CSI-2
transmitter when initialization the hardware reuse the dedicated power
control functions.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/i2c/adv748x/adv748x-core.c | 28 ++----------------------
 1 file changed, 2 insertions(+), 26 deletions(-)

diff --git a/drivers/media/i2c/adv748x/adv748x-core.c b/drivers/media/i2c/adv748x/adv748x-core.c
index 721ed6552bc1cde6..41cc0cdd6a5fcef5 100644
--- a/drivers/media/i2c/adv748x/adv748x-core.c
+++ b/drivers/media/i2c/adv748x/adv748x-core.c
@@ -390,19 +390,6 @@ static const struct adv748x_reg_value adv748x_init_txa_4lane[] = {
 	{ADV748X_PAGE_TXA, 0x72, 0x11},	/* ADI Required Write */
 	{ADV748X_PAGE_TXA, 0xf0, 0x00},	/* i2c_dphy_pwdn - 1'b0 */
 
-	{ADV748X_PAGE_TXA, 0x00, 0x84},	/* Enable 4-lane MIPI */
-	{ADV748X_PAGE_TXA, 0x00, 0xa4},	/* Set Auto DPHY Timing */
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
 
@@ -442,19 +429,6 @@ static const struct adv748x_reg_value adv748x_init_txb_1lane[] = {
 	{ADV748X_PAGE_TXB, 0x72, 0x11},	/* ADI Required Write */
 	{ADV748X_PAGE_TXB, 0xf0, 0x00},	/* i2c_dphy_pwdn - 1'b0 */
 
-	{ADV748X_PAGE_TXB, 0x00, 0x81},	/* Enable 1-lane MIPI */
-	{ADV748X_PAGE_TXB, 0x00, 0xa1},	/* Set Auto DPHY Timing */
-
-	{ADV748X_PAGE_TXB, 0x31, 0x82},	/* ADI Required Write */
-	{ADV748X_PAGE_TXB, 0x1e, 0x40},	/* ADI Required Write */
-	{ADV748X_PAGE_TXB, 0xda, 0x01},	/* i2c_mipi_pll_en - 1'b1 */
-	{ADV748X_PAGE_WAIT, 0x00, 0x02},/* delay 2 */
-	{ADV748X_PAGE_TXB, 0x00, 0x21 },/* Power-up CSI-TX */
-	{ADV748X_PAGE_WAIT, 0x00, 0x01},/* delay 1 */
-	{ADV748X_PAGE_TXB, 0xc1, 0x2b},	/* ADI Required Write */
-	{ADV748X_PAGE_WAIT, 0x00, 0x01},/* delay 1 */
-	{ADV748X_PAGE_TXB, 0x31, 0x80},	/* ADI Required Write */
-
 	{ADV748X_PAGE_EOR, 0xff, 0xff}	/* End of register table */
 };
 
@@ -476,6 +450,7 @@ static int adv748x_reset(struct adv748x_state *state)
 	if (ret)
 		return ret;
 
+	adv748x_tx_power(&state->txa, 1);
 	adv748x_tx_power(&state->txa, 0);
 
 	/* Init and power down TXB */
@@ -483,6 +458,7 @@ static int adv748x_reset(struct adv748x_state *state)
 	if (ret)
 		return ret;
 
+	adv748x_tx_power(&state->txb, 1);
 	adv748x_tx_power(&state->txb, 0);
 
 	/* Disable chip powerdown & Enable HDMI Rx block */
-- 
2.19.0
