Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:45571 "EHLO
        relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbeIET6J (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 5 Sep 2018 15:58:09 -0400
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: laurent.pinchart@ideasonboard.com,
        kieran.bingham+renesas@ideasonboard.com,
        niklas.soderlund+renesas@ragnatech.se
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org
Subject: [PATCH v2 3/5] media: i2c: adv748x: Conditionally enable only CSI-2 outputs
Date: Wed,  5 Sep 2018 17:27:09 +0200
Message-Id: <1536161231-25221-4-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1536161231-25221-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1536161231-25221-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The ADV748x has two CSI-2 output port and one TLL input/output port for
digital video reception/transmission. The TTL digital pad is un-conditionally
enabled during the device reset even if not used. Same goes for the TXa
and TXb CSI-2 outputs, which are enabled by the initial settings blob
programmed into the chip.

In order to improve power saving and do not enable un-used output interfaces:
keep TLL output disabled, as it is not used, and drop CSI-2 output enabling
from the intial settings list, as they get conditionally enabled later.

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
