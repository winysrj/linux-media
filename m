Return-path: <linux-media-owner@vger.kernel.org>
Received: from nasmtp01.atmel.com ([192.199.1.245]:11516 "EHLO
        DVREDG01.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750868AbdIADOA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 31 Aug 2017 23:14:00 -0400
From: Wenyou Yang <wenyou.yang@microchip.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
CC: <linux-kernel@vger.kernel.org>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        "Jonathan Corbet" <corbet@lwn.net>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        <linux-arm-kernel@lists.infradead.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Wenyou Yang <wenyou.yang@microchip.com>
Subject: [PATCH 1/4] media: atmel_isc: Add spin lock for clock enable ops
Date: Fri, 1 Sep 2017 11:09:32 +0800
Message-ID: <20170901030935.29717-2-wenyou.yang@microchip.com>
In-Reply-To: <20170901030935.29717-1-wenyou.yang@microchip.com>
References: <20170901030935.29717-1-wenyou.yang@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add the spin lock for the clock enable and disable operations.

Signed-off-by: Wenyou Yang <wenyou.yang@microchip.com>
---

 drivers/media/platform/atmel/atmel-isc.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/atmel/atmel-isc.c b/drivers/media/platform/atmel/atmel-isc.c
index d7103c5f92c3..d119c5d39ede 100644
--- a/drivers/media/platform/atmel/atmel-isc.c
+++ b/drivers/media/platform/atmel/atmel-isc.c
@@ -65,6 +65,7 @@ struct isc_clk {
 	struct clk_hw   hw;
 	struct clk      *clk;
 	struct regmap   *regmap;
+	spinlock_t	*lock;
 	u8		id;
 	u8		parent_id;
 	u32		div;
@@ -312,26 +313,37 @@ static int isc_clk_enable(struct clk_hw *hw)
 	struct isc_clk *isc_clk = to_isc_clk(hw);
 	u32 id = isc_clk->id;
 	struct regmap *regmap = isc_clk->regmap;
+	unsigned long flags;
+	unsigned int status;
 
 	dev_dbg(isc_clk->dev, "ISC CLK: %s, div = %d, parent id = %d\n",
 		__func__, isc_clk->div, isc_clk->parent_id);
 
+	spin_lock_irqsave(isc_clk->lock, flags);
 	regmap_update_bits(regmap, ISC_CLKCFG,
 			   ISC_CLKCFG_DIV_MASK(id) | ISC_CLKCFG_SEL_MASK(id),
 			   (isc_clk->div << ISC_CLKCFG_DIV_SHIFT(id)) |
 			   (isc_clk->parent_id << ISC_CLKCFG_SEL_SHIFT(id)));
 
 	regmap_write(regmap, ISC_CLKEN, ISC_CLK(id));
+	spin_unlock_irqrestore(isc_clk->lock, flags);
 
-	return 0;
+	regmap_read(regmap, ISC_CLKSR, &status);
+	if (status & ISC_CLK(id))
+		return 0;
+	else
+		return -EINVAL;
 }
 
 static void isc_clk_disable(struct clk_hw *hw)
 {
 	struct isc_clk *isc_clk = to_isc_clk(hw);
 	u32 id = isc_clk->id;
+	unsigned long flags;
 
+	spin_lock_irqsave(isc_clk->lock, flags);
 	regmap_write(isc_clk->regmap, ISC_CLKDIS, ISC_CLK(id));
+	spin_unlock_irqrestore(isc_clk->lock, flags);
 }
 
 static int isc_clk_is_enabled(struct clk_hw *hw)
-- 
2.13.0
