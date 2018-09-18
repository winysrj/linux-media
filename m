Return-path: <linux-media-owner@vger.kernel.org>
Received: from bin-mail-out-06.binero.net ([195.74.38.229]:30472 "EHLO
        bin-mail-out-06.binero.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726974AbeIRHUK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Sep 2018 03:20:10 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Jacopo Mondi <jacopo@jmondi.org>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH 3/3] i2c: adv748x: fix typo in comment for TXB CSI-2 transmitter power down
Date: Tue, 18 Sep 2018 03:45:09 +0200
Message-Id: <20180918014509.6394-4-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20180918014509.6394-1-niklas.soderlund+renesas@ragnatech.se>
References: <20180918014509.6394-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix copy-and-past error in comment for TXB CSI-2 transmitter power down
sequence.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/i2c/adv748x/adv748x-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/adv748x/adv748x-core.c b/drivers/media/i2c/adv748x/adv748x-core.c
index 9a82cdf301bccb41..86cb38f4d7cc11c6 100644
--- a/drivers/media/i2c/adv748x/adv748x-core.c
+++ b/drivers/media/i2c/adv748x/adv748x-core.c
@@ -299,7 +299,7 @@ static const struct adv748x_reg_value adv748x_power_down_txb_1lane[] = {
 
 	{ADV748X_PAGE_TXB, 0x31, 0x82},	/* ADI Required Write */
 	{ADV748X_PAGE_TXB, 0x1e, 0x00},	/* ADI Required Write */
-	{ADV748X_PAGE_TXB, 0x00, 0x81},	/* Enable 4-lane MIPI */
+	{ADV748X_PAGE_TXB, 0x00, 0x81},	/* Enable 1-lane MIPI */
 	{ADV748X_PAGE_TXB, 0xda, 0x01},	/* i2c_mipi_pll_en - 1'b1 */
 	{ADV748X_PAGE_TXB, 0xc1, 0x3b},	/* ADI Required Write */
 
-- 
2.18.0
