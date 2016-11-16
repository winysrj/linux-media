Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49619 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753455AbcKPQnN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Nov 2016 11:43:13 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Michael Ira Krufky <mkrufky@linuxtv.org>
Subject: [PATCH 01/35] [media] stb0899_drv: get rid of continuation lines
Date: Wed, 16 Nov 2016 14:42:33 -0200
Message-Id: <4f24608117cb95a71b016bc0e75c89f2cc9d66ff.1479314177.git.mchehab@s-opensource.com>
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
 drivers/media/dvb-frontends/stb0899_drv.c | 21 ++++-----------------
 1 file changed, 4 insertions(+), 17 deletions(-)

diff --git a/drivers/media/dvb-frontends/stb0899_drv.c b/drivers/media/dvb-frontends/stb0899_drv.c
index 3d171b0e00c2..8e7cafb8f36a 100644
--- a/drivers/media/dvb-frontends/stb0899_drv.c
+++ b/drivers/media/dvb-frontends/stb0899_drv.c
@@ -485,15 +485,8 @@ int stb0899_read_regs(struct stb0899_state *state, unsigned int reg, u8 *buf, u3
 	    (((reg & 0xff00) == 0xf200) || ((reg & 0xff00) == 0xf600)))
 		_stb0899_read_reg(state, (reg | 0x00ff));
 
-	if (unlikely(*state->verbose >= FE_DEBUGREG)) {
-		int i;
-
-		printk(KERN_DEBUG "%s [0x%04x]:", __func__, reg);
-		for (i = 0; i < count; i++) {
-			printk(" %02x", buf[i]);
-		}
-		printk("\n");
-	}
+	dprintk(state->verbose, FE_DEBUGREG, 1,
+		"%s [0x%04x]: %*ph", __func__, reg, count, buf);
 
 	return 0;
 err:
@@ -522,14 +515,8 @@ int stb0899_write_regs(struct stb0899_state *state, unsigned int reg, u8 *data,
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
+	dprintk(state->verbose, FE_DEBUGREG, 1,
+		"%s [0x%04x]: %*ph", __func__, reg, count, data);
 	ret = i2c_transfer(state->i2c, &i2c_msg, 1);
 
 	/*
-- 
2.7.4


