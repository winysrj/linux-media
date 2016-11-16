Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49627 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753453AbcKPQnN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Nov 2016 11:43:13 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 02/35] [media] stv090x: get rid of continuation lines
Date: Wed, 16 Nov 2016 14:42:34 -0200
Message-Id: <85ae069890df221a78d1b657b42a8210e8fc8214.1479314177.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1479314177.git.mchehab@s-opensource.com>
References: <cover.1479314177.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1479314177.git.mchehab@s-opensource.com>
References: <cover.1479314177.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This driver has printk continuation lines for debugging purposes.
Since commit 563873318d32 ("Merge branch 'printk-cleanups'")',
this won't work as expected anymore.

So, use %*ph and get rid of it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-frontends/stv090x.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/media/dvb-frontends/stv090x.c b/drivers/media/dvb-frontends/stv090x.c
index 25bdf6e0f963..42d62cc9a357 100644
--- a/drivers/media/dvb-frontends/stv090x.c
+++ b/drivers/media/dvb-frontends/stv090x.c
@@ -739,14 +739,8 @@ static int stv090x_write_regs(struct stv090x_state *state, unsigned int reg, u8
 	buf[1] = reg & 0xff;
 	memcpy(&buf[2], data, count);
 
-	if (unlikely(*state->verbose >= FE_DEBUGREG)) {
-		int i;
-
-		printk(KERN_DEBUG "%s [0x%04x]:", __func__, reg);
-		for (i = 0; i < count; i++)
-			printk(" %02x", data[i]);
-		printk("\n");
-	}
+	dprintk(FE_DEBUGREG, 1, "%s [0x%04x]: %*ph",
+		__func__, reg, count, data);
 
 	ret = i2c_transfer(state->i2c, &i2c_msg, 1);
 	if (ret != 1) {
-- 
2.7.4


