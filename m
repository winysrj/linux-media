Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:58251 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726824AbeIQQ6G (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Sep 2018 12:58:06 -0400
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: laurent.pinchart@ideasonboard.com,
        kieran.bingham+renesas@ideasonboard.com,
        niklas.soderlund+renesas@ragnatech.se
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org
Subject: [PATCH v3 3/4] media: i2c: adv748x: Conditionally enable only CSI-2 outputs
Date: Mon, 17 Sep 2018 13:30:56 +0200
Message-Id: <1537183857-29173-4-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1537183857-29173-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1537183857-29173-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The ADV748x has two CSI-2 output port and one TTL input/output port for
digital video reception/transmission. The TTL digital pad is unconditionally
enabled during the device reset even if not used. Same goes for the TXA
and TXB CSI-2 outputs, which are enabled by the initial settings blob
programmed into the chip.

In order to improve power saving, do not enable unused output interfaces:
keep TTL output disabled, as it is not used, and drop CSI-2 output enabling
from the initial settings list, as they get conditionally enabled later.

Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
 drivers/media/i2c/adv748x/adv748x-core.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/media/i2c/adv748x/adv748x-core.c b/drivers/media/i2c/adv748x/adv748x-core.c
index 72a6692..7b79b0c 100644
--- a/drivers/media/i2c/adv748x/adv748x-core.c
+++ b/drivers/media/i2c/adv748x/adv748x-core.c
@@ -386,8 +386,6 @@ static const struct adv748x_reg_value adv748x_init_txa_4lane[] = {
 
 	{ADV748X_PAGE_IO, 0x0c, 0xe0},	/* Enable LLC_DLL & Double LLC Timing */
 	{ADV748X_PAGE_IO, 0x0e, 0xdd},	/* LLC/PIX/SPI PINS TRISTATED AUD */
-	/* Outputs Enabled */
-	{ADV748X_PAGE_IO, 0x10, 0xa0},	/* Enable 4-lane CSI Tx & Pixel Port */
 
 	{ADV748X_PAGE_TXA, 0x00, 0x84},	/* Enable 4-lane MIPI */
 	{ADV748X_PAGE_TXA, 0x00, 0xa4},	/* Set Auto DPHY Timing */
@@ -441,10 +439,6 @@ static const struct adv748x_reg_value adv748x_init_txb_1lane[] = {
 	{ADV748X_PAGE_SDP, 0x31, 0x12},	/* ADI Required Write */
 	{ADV748X_PAGE_SDP, 0xe6, 0x4f},  /* V bit end pos manually in NTSC */
 
-	/* Enable 1-Lane MIPI Tx, */
-	/* enable pixel output and route SD through Pixel port */
-	{ADV748X_PAGE_IO, 0x10, 0x70},
-
 	{ADV748X_PAGE_TXB, 0x00, 0x81},	/* Enable 1-lane MIPI */
 	{ADV748X_PAGE_TXB, 0x00, 0xa1},	/* Set Auto DPHY Timing */
 	{ADV748X_PAGE_TXB, 0xd2, 0x40},	/* ADI Required Write */
@@ -469,7 +463,7 @@ static const struct adv748x_reg_value adv748x_init_txb_1lane[] = {
 static int adv748x_reset(struct adv748x_state *state)
 {
 	int ret;
-	u8 regval = ADV748X_IO_10_PIX_OUT_EN;
+	u8 regval = 0;
 
 	ret = adv748x_write_regs(state, adv748x_sw_reset);
 	if (ret < 0)
-- 
2.7.4
