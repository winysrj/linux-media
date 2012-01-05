Return-path: <linux-media-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:61915 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731Ab2AEGXr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Jan 2012 01:23:47 -0500
Date: Thu, 5 Jan 2012 09:23:28 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [patch] [media] af9013: change & to &&
Message-ID: <20120105062328.GA25744@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is just a cleanup, it doesn't change how the code works.  These
are compound conditions and not bitwise operations so it should be &&
and not &.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/media/dvb/frontends/af9013.c b/drivers/media/dvb/frontends/af9013.c
index e6ba3e0..1413c51 100644
--- a/drivers/media/dvb/frontends/af9013.c
+++ b/drivers/media/dvb/frontends/af9013.c
@@ -120,8 +120,8 @@ static int af9013_wr_regs(struct af9013_state *priv, u16 reg, const u8 *val,
 	int ret, i;
 	u8 mbox = (0 << 7)|(0 << 6)|(1 << 1)|(1 << 0);
 
-	if ((priv->config.ts_mode == AF9013_TS_USB) &
-		((reg & 0xff00) != 0xff00) & ((reg & 0xff00) != 0xae00)) {
+	if ((priv->config.ts_mode == AF9013_TS_USB) &&
+		((reg & 0xff00) != 0xff00) && ((reg & 0xff00) != 0xae00)) {
 		mbox |= ((len - 1) << 2);
 		ret = af9013_wr_regs_i2c(priv, mbox, reg, val, len);
 	} else {
@@ -142,8 +142,8 @@ static int af9013_rd_regs(struct af9013_state *priv, u16 reg, u8 *val, int len)
 	int ret, i;
 	u8 mbox = (0 << 7)|(0 << 6)|(1 << 1)|(0 << 0);
 
-	if ((priv->config.ts_mode == AF9013_TS_USB) &
-		((reg & 0xff00) != 0xff00) & ((reg & 0xff00) != 0xae00)) {
+	if ((priv->config.ts_mode == AF9013_TS_USB) &&
+		((reg & 0xff00) != 0xff00) && ((reg & 0xff00) != 0xae00)) {
 		mbox |= ((len - 1) << 2);
 		ret = af9013_rd_regs_i2c(priv, mbox, reg, val, len);
 	} else {
