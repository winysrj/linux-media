Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:6642 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754456Ab0I1Syh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Sep 2010 14:54:37 -0400
Date: Tue, 28 Sep 2010 15:46:59 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Srinivasa.Deevi@conexant.com, Palash.Bandyopadhyay@conexant.com,
	dheitmueller@kernellabs.com,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 08/10] V4L/DVB: tda18271: allow restricting max out to 4
 bytes
Message-ID: <20100928154659.0e7e4147@pedra>
In-Reply-To: <cover.1285699057.git.mchehab@redhat.com>
References: <cover.1285699057.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

By default, tda18271 tries to optimize I2C bus by updating all registers
at the same time. Unfortunately, some devices doesn't support it.

The current logic has a problem when small_i2c is equal to 8, since there
are some transfers using 11 + 1 bytes.

Fix the problem by enforcing the max size at the right place, and allows
reducing it to max = 3 + 1.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/common/tuners/tda18271-common.c b/drivers/media/common/tuners/tda18271-common.c
index e1f6782..195b30e 100644
--- a/drivers/media/common/tuners/tda18271-common.c
+++ b/drivers/media/common/tuners/tda18271-common.c
@@ -193,20 +193,46 @@ int tda18271_write_regs(struct dvb_frontend *fe, int idx, int len)
 	unsigned char *regs = priv->tda18271_regs;
 	unsigned char buf[TDA18271_NUM_REGS + 1];
 	struct i2c_msg msg = { .addr = priv->i2c_props.addr, .flags = 0,
-			       .buf = buf, .len = len + 1 };
-	int i, ret;
+			       .buf = buf };
+	int i, ret = 1, max;
 
 	BUG_ON((len == 0) || (idx + len > sizeof(buf)));
 
-	buf[0] = idx;
-	for (i = 1; i <= len; i++)
-		buf[i] = regs[idx - 1 + i];
+
+	switch (priv->small_i2c) {
+	case TDA18271_03_BYTE_CHUNK_INIT:
+		max = 3;
+		break;
+	case TDA18271_08_BYTE_CHUNK_INIT:
+		max = 8;
+		break;
+	case TDA18271_16_BYTE_CHUNK_INIT:
+		max = 16;
+		break;
+	case TDA18271_39_BYTE_CHUNK_INIT:
+	default:
+		max = 39;
+	}
 
 	tda18271_i2c_gate_ctrl(fe, 1);
+	while (len) {
+		if (max > len)
+			max = len;
 
-	/* write registers */
-	ret = i2c_transfer(priv->i2c_props.adap, &msg, 1);
+		buf[0] = idx;
+		for (i = 1; i <= max; i++)
+			buf[i] = regs[idx - 1 + i];
 
+		msg.len = max + 1;
+
+		/* write registers */
+		ret = i2c_transfer(priv->i2c_props.adap, &msg, 1);
+		if (ret != 1)
+			break;
+
+		idx += max;
+		len -= max;
+	}
 	tda18271_i2c_gate_ctrl(fe, 0);
 
 	if (ret != 1)
@@ -326,24 +352,7 @@ int tda18271_init_regs(struct dvb_frontend *fe)
 	regs[R_EB22] = 0x48;
 	regs[R_EB23] = 0xb0;
 
-	switch (priv->small_i2c) {
-	case TDA18271_08_BYTE_CHUNK_INIT:
-		tda18271_write_regs(fe, 0x00, 0x08);
-		tda18271_write_regs(fe, 0x08, 0x08);
-		tda18271_write_regs(fe, 0x10, 0x08);
-		tda18271_write_regs(fe, 0x18, 0x08);
-		tda18271_write_regs(fe, 0x20, 0x07);
-		break;
-	case TDA18271_16_BYTE_CHUNK_INIT:
-		tda18271_write_regs(fe, 0x00, 0x10);
-		tda18271_write_regs(fe, 0x10, 0x10);
-		tda18271_write_regs(fe, 0x20, 0x07);
-		break;
-	case TDA18271_39_BYTE_CHUNK_INIT:
-	default:
-		tda18271_write_regs(fe, 0x00, TDA18271_NUM_REGS);
-		break;
-	}
+	tda18271_write_regs(fe, 0x00, TDA18271_NUM_REGS);
 
 	/* setup agc1 gain */
 	regs[R_EB17] = 0x00;
diff --git a/drivers/media/common/tuners/tda18271.h b/drivers/media/common/tuners/tda18271.h
index d7fcc36..3abb221 100644
--- a/drivers/media/common/tuners/tda18271.h
+++ b/drivers/media/common/tuners/tda18271.h
@@ -80,8 +80,9 @@ enum tda18271_output_options {
 
 enum tda18271_small_i2c {
 	TDA18271_39_BYTE_CHUNK_INIT = 0,
-	TDA18271_16_BYTE_CHUNK_INIT = 1,
-	TDA18271_08_BYTE_CHUNK_INIT = 2,
+	TDA18271_16_BYTE_CHUNK_INIT = 16,
+	TDA18271_08_BYTE_CHUNK_INIT = 8,
+	TDA18271_03_BYTE_CHUNK_INIT = 3,
 };
 
 struct tda18271_config {
diff --git a/drivers/media/video/tuner-core.c b/drivers/media/video/tuner-core.c
index fa406b9..1a047c5 100644
--- a/drivers/media/video/tuner-core.c
+++ b/drivers/media/video/tuner-core.c
@@ -428,7 +428,7 @@ static void set_type(struct i2c_client *c, unsigned int type,
 	{
 		struct tda18271_config cfg = {
 			.config = t->config,
-			.small_i2c = TDA18271_08_BYTE_CHUNK_INIT,
+			.small_i2c = TDA18271_03_BYTE_CHUNK_INIT,
 		};
 
 		if (!dvb_attach(tda18271_attach, &t->fe, t->i2c->addr,
-- 
1.7.1


