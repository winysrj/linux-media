Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-01.arcor-online.net ([151.189.21.41]:43814 "EHLO
	mail-in-01.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755886Ab0BORiU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Feb 2010 12:38:20 -0500
From: stefan.ringel@arcor.de
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, dheitmueller@kernellabs.com,
	Stefan Ringel <stefan.ringel@arcor.de>
Subject: [PATCH 09/11] zl10353: tm6000: bugfix reading problems with tm6000 i2c host
Date: Mon, 15 Feb 2010 18:37:22 +0100
Message-Id: <1266255444-7422-9-git-send-email-stefan.ringel@arcor.de>
In-Reply-To: <1266255444-7422-8-git-send-email-stefan.ringel@arcor.de>
References: <1266255444-7422-1-git-send-email-stefan.ringel@arcor.de>
 <1266255444-7422-2-git-send-email-stefan.ringel@arcor.de>
 <1266255444-7422-3-git-send-email-stefan.ringel@arcor.de>
 <1266255444-7422-4-git-send-email-stefan.ringel@arcor.de>
 <1266255444-7422-5-git-send-email-stefan.ringel@arcor.de>
 <1266255444-7422-6-git-send-email-stefan.ringel@arcor.de>
 <1266255444-7422-7-git-send-email-stefan.ringel@arcor.de>
 <1266255444-7422-8-git-send-email-stefan.ringel@arcor.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Stefan Ringel <stefan.ringel@arcor.de>

Signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>

diff --git a/drivers/media/dvb/frontends/zl10353.c b/drivers/media/dvb/frontends/zl10353.c
index 8c61271..9716d7e 100644
--- a/drivers/media/dvb/frontends/zl10353.c
+++ b/drivers/media/dvb/frontends/zl10353.c
@@ -74,7 +74,7 @@ static int zl10353_write(struct dvb_frontend *fe, u8 *ibuf, int ilen)
 	return 0;
 }
 
-static int zl10353_read_register(struct zl10353_state *state, u8 reg)
+static int zl10353_read1_register(struct zl10353_state *state, u8 reg)
 {
 	int ret;
 	u8 b0[1] = { reg };
@@ -97,6 +97,41 @@ static int zl10353_read_register(struct zl10353_state *state, u8 reg)
 	return b1[0];
 }
 
+static int zl10353_read2_register(struct zl10353_state *state, u8 reg)
+{
+	int ret;
+	u8 b0[1] = { reg - 1 };
+	u8 b1[1] = { 0 };
+	struct i2c_msg msg[2] = { { .addr = state->config.demod_address,
+				    .flags = 0,
+				    .buf = b0, .len = 1 },
+				  { .addr = state->config.demod_address,
+				    .flags = I2C_M_RD,
+				    .buf = b1, .len = 2 } };
+
+	ret = i2c_transfer(state->i2c, msg, 2);
+
+	if (ret != 2) {
+		printk("%s: readreg error (reg=%d, ret==%i)\n",
+		       __func__, reg, ret);
+		return ret;
+	}
+
+	return b1[1];
+}
+
+static int zl10353_read_register(struct zl10353_state *state, u8 reg)
+{
+	int ret;
+
+	if ((state->i2c->id == I2C_HW_B_TM6000) && (reg % 2 == 0))
+		ret = zl10353_read2_register(state, reg);
+	else
+		ret = zl10353_read1_register(state, reg);
+
+	return ret;
+}
+
 static void zl10353_dump_regs(struct dvb_frontend *fe)
 {
 	struct zl10353_state *state = fe->demodulator_priv;
-- 
1.6.6.1

