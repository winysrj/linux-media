Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:55499 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751813Ab2HUOTW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Aug 2012 10:19:22 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 2/2] qt1010: remove debug register dump
Date: Tue, 21 Aug 2012 17:18:59 +0300
Message-Id: <1345558739-12562-2-git-send-email-crope@iki.fi>
In-Reply-To: <1345558739-12562-1-git-send-email-crope@iki.fi>
References: <1345558739-12562-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I didn't found easy way to handle register dump only when needed so
remove it totally. It is quite useless and trivial function, every
developer could write new one in few minutes when needed.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/qt1010.c | 23 -----------------------
 1 file changed, 23 deletions(-)

diff --git a/drivers/media/tuners/qt1010.c b/drivers/media/tuners/qt1010.c
index 5fab622..bc419f8 100644
--- a/drivers/media/tuners/qt1010.c
+++ b/drivers/media/tuners/qt1010.c
@@ -54,27 +54,6 @@ static int qt1010_writereg(struct qt1010_priv *priv, u8 reg, u8 val)
 	return 0;
 }
 
-/* dump all registers */
-static void qt1010_dump_regs(struct qt1010_priv *priv)
-{
-	u8 reg, val;
-
-	for (reg = 0; ; reg++) {
-		if (reg % 16 == 0) {
-			if (reg)
-				printk(KERN_CONT "\n");
-			printk(KERN_DEBUG "%02x:", reg);
-		}
-		if (qt1010_readreg(priv, reg, &val) == 0)
-			printk(KERN_CONT " %02x", val);
-		else
-			printk(KERN_CONT " --");
-		if (reg == 0x2f)
-			break;
-	}
-	printk(KERN_CONT "\n");
-}
-
 static int qt1010_set_params(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
@@ -240,8 +219,6 @@ static int qt1010_set_params(struct dvb_frontend *fe)
 		if (err) return err;
 	}
 
-	qt1010_dump_regs(priv);
-
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 0); /* close i2c_gate */
 
-- 
1.7.11.4

