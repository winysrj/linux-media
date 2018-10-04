Return-path: <linux-media-owner@vger.kernel.org>
Received: from vsp-unauthed02.binero.net ([195.74.38.227]:33159 "EHLO
        vsp-unauthed02.binero.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727663AbeJEDhb (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 4 Oct 2018 23:37:31 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>
To: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Jacopo Mondi <jacopo@jmondi.org>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v2 2/5] i2c: adv748x: reorder register writes for CSI-2 transmitters initialization
Date: Thu,  4 Oct 2018 22:41:35 +0200
Message-Id: <20181004204138.2784-3-niklas.soderlund@ragnatech.se>
In-Reply-To: <20181004204138.2784-1-niklas.soderlund@ragnatech.se>
References: <20181004204138.2784-1-niklas.soderlund@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

Reorder the initialization order of registers to allow for refactoring.
The move could have been done at the same time as the refactoring but
since the documentation about some registers involved are missing do it
separately.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/i2c/adv748x/adv748x-core.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/media/i2c/adv748x/adv748x-core.c b/drivers/media/i2c/adv748x/adv748x-core.c
index 6854d898fdd1f192..721ed6552bc1cde6 100644
--- a/drivers/media/i2c/adv748x/adv748x-core.c
+++ b/drivers/media/i2c/adv748x/adv748x-core.c
@@ -383,8 +383,6 @@ static const struct adv748x_reg_value adv748x_init_txa_4lane[] = {
 	{ADV748X_PAGE_IO, 0x0c, 0xe0},	/* Enable LLC_DLL & Double LLC Timing */
 	{ADV748X_PAGE_IO, 0x0e, 0xdd},	/* LLC/PIX/SPI PINS TRISTATED AUD */
 
-	{ADV748X_PAGE_TXA, 0x00, 0x84},	/* Enable 4-lane MIPI */
-	{ADV748X_PAGE_TXA, 0x00, 0xa4},	/* Set Auto DPHY Timing */
 	{ADV748X_PAGE_TXA, 0xdb, 0x10},	/* ADI Required Write */
 	{ADV748X_PAGE_TXA, 0xd6, 0x07},	/* ADI Required Write */
 	{ADV748X_PAGE_TXA, 0xc4, 0x0a},	/* ADI Required Write */
@@ -392,6 +390,9 @@ static const struct adv748x_reg_value adv748x_init_txa_4lane[] = {
 	{ADV748X_PAGE_TXA, 0x72, 0x11},	/* ADI Required Write */
 	{ADV748X_PAGE_TXA, 0xf0, 0x00},	/* i2c_dphy_pwdn - 1'b0 */
 
+	{ADV748X_PAGE_TXA, 0x00, 0x84},	/* Enable 4-lane MIPI */
+	{ADV748X_PAGE_TXA, 0x00, 0xa4},	/* Set Auto DPHY Timing */
+
 	{ADV748X_PAGE_TXA, 0x31, 0x82},	/* ADI Required Write */
 	{ADV748X_PAGE_TXA, 0x1e, 0x40},	/* ADI Required Write */
 	{ADV748X_PAGE_TXA, 0xda, 0x01},	/* i2c_mipi_pll_en - 1'b1 */
@@ -435,17 +436,18 @@ static const struct adv748x_reg_value adv748x_init_txb_1lane[] = {
 	{ADV748X_PAGE_SDP, 0x31, 0x12},	/* ADI Required Write */
 	{ADV748X_PAGE_SDP, 0xe6, 0x4f},  /* V bit end pos manually in NTSC */
 
-	{ADV748X_PAGE_TXB, 0x00, 0x81},	/* Enable 1-lane MIPI */
-	{ADV748X_PAGE_TXB, 0x00, 0xa1},	/* Set Auto DPHY Timing */
 	{ADV748X_PAGE_TXB, 0xd2, 0x40},	/* ADI Required Write */
 	{ADV748X_PAGE_TXB, 0xc4, 0x0a},	/* ADI Required Write */
 	{ADV748X_PAGE_TXB, 0x71, 0x33},	/* ADI Required Write */
 	{ADV748X_PAGE_TXB, 0x72, 0x11},	/* ADI Required Write */
 	{ADV748X_PAGE_TXB, 0xf0, 0x00},	/* i2c_dphy_pwdn - 1'b0 */
+
+	{ADV748X_PAGE_TXB, 0x00, 0x81},	/* Enable 1-lane MIPI */
+	{ADV748X_PAGE_TXB, 0x00, 0xa1},	/* Set Auto DPHY Timing */
+
 	{ADV748X_PAGE_TXB, 0x31, 0x82},	/* ADI Required Write */
 	{ADV748X_PAGE_TXB, 0x1e, 0x40},	/* ADI Required Write */
 	{ADV748X_PAGE_TXB, 0xda, 0x01},	/* i2c_mipi_pll_en - 1'b1 */
-
 	{ADV748X_PAGE_WAIT, 0x00, 0x02},/* delay 2 */
 	{ADV748X_PAGE_TXB, 0x00, 0x21 },/* Power-up CSI-TX */
 	{ADV748X_PAGE_WAIT, 0x00, 0x01},/* delay 1 */
-- 
2.19.0
