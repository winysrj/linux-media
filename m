Return-path: <mchehab@pedra>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:52252 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753039Ab1BFP35 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Feb 2011 10:29:57 -0500
Received: by wwa36 with SMTP id 36so3990890wwa.1
        for <linux-media@vger.kernel.org>; Sun, 06 Feb 2011 07:29:56 -0800 (PST)
Subject: [PATCH] DVB_PLL_OPERA1 -  DVB-S incorrect tune settings
 DW2102/DM1105/CX88
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 06 Feb 2011 15:29:51 +0000
Message-ID: <1297006191.2558.9.camel@tvboxspy>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This tuner PLL has missing initialisation settings resulting in
haphazard tuning. The PLL LPF was set to just 22000 symbol rate.

Basically, the module is a Sharp BS2F7HZ0194 (STV0299+IX2410)

I have had problems implementing the PLL in a new driver and
did not want to break the IX2410 out of the PLL.

This applies to DW2102, DM1105, CX88 and OPERA1 drivers.

Please report your findings.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/media/dvb/frontends/dvb-pll.c |   79 ++++++++++++++++++++++++++++-----
 1 files changed, 68 insertions(+), 11 deletions(-)

diff --git a/drivers/media/dvb/frontends/dvb-pll.c b/drivers/media/dvb/frontends/dvb-pll.c
index 4d4d0bb..62a65ef 100644
--- a/drivers/media/dvb/frontends/dvb-pll.c
+++ b/drivers/media/dvb/frontends/dvb-pll.c
@@ -64,6 +64,7 @@ struct dvb_pll_desc {
 	void (*set)(struct dvb_frontend *fe, u8 *buf,
 		    const struct dvb_frontend_parameters *params);
 	u8   *initdata;
+	u8   *initdata2;
 	u8   *sleepdata;
 	int  count;
 	struct {
@@ -321,26 +322,73 @@ static struct dvb_pll_desc dvb_pll_philips_sd1878_tda8261 = {
 static void opera1_bw(struct dvb_frontend *fe, u8 *buf,
 		      const struct dvb_frontend_parameters *params)
 {
-	if (params->u.ofdm.bandwidth == BANDWIDTH_8_MHZ)
-		buf[2] |= 0x08;
+	struct dvb_pll_priv *priv = fe->tuner_priv;
+	u32 b_w  = (params->u.qpsk.symbol_rate * 27) / 32000;
+	struct i2c_msg msg = {
+		.addr = priv->pll_i2c_address,
+		.flags = 0,
+		.buf = buf,
+		.len = 4
+	};
+	int result;
+	u8 lpf;
+
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 1);
+
+	result = i2c_transfer(priv->i2c, &msg, 1);
+	if (result != 1)
+		printk(KERN_ERR "%s: i2c_transfer failed:%d",
+			__func__, result);
+
+	if (b_w <= 10000)
+		lpf = 0xc;
+	else if (b_w <= 12000)
+		lpf = 0x2;
+	else if (b_w <= 14000)
+		lpf = 0xa;
+	else if (b_w <= 16000)
+		lpf = 0x6;
+	else if (b_w <= 18000)
+		lpf = 0xe;
+	else if (b_w <= 20000)
+		lpf = 0x1;
+	else if (b_w <= 22000)
+		lpf = 0x9;
+	else if (b_w <= 24000)
+		lpf = 0x5;
+	else if (b_w <= 26000)
+		lpf = 0xd;
+	else if (b_w <= 28000)
+		lpf = 0x3;
+		else
+		lpf = 0xb;
+	buf[2] ^= 0x1c; /* Flip bits 3-5 */
+	/* Set lpf */
+	buf[2] |= ((lpf >> 2) & 0x3) << 3;
+	buf[3] |= (lpf & 0x3) << 2;
+
+	return;
 }
 
 static struct dvb_pll_desc dvb_pll_opera1 = {
 	.name  = "Opera Tuner",
 	.min   =  900000,
 	.max   = 2250000,
+	.initdata = (u8[]){ 4, 0x08, 0xe5, 0xe1, 0x00 },
+	.initdata2 = (u8[]){ 4, 0x08, 0xe5, 0xe5, 0x00 },
 	.iffreq= 0,
 	.set   = opera1_bw,
 	.count = 8,
 	.entries = {
-		{ 1064000, 500, 0xe5, 0xc6 },
-		{ 1169000, 500, 0xe5, 0xe6 },
-		{ 1299000, 500, 0xe5, 0x24 },
-		{ 1444000, 500, 0xe5, 0x44 },
-		{ 1606000, 500, 0xe5, 0x64 },
-		{ 1777000, 500, 0xe5, 0x84 },
-		{ 1941000, 500, 0xe5, 0xa4 },
-		{ 2250000, 500, 0xe5, 0xc4 },
+		{ 1064000, 500, 0xf9, 0xc2 },
+		{ 1169000, 500, 0xf9, 0xe2 },
+		{ 1299000, 500, 0xf9, 0x20 },
+		{ 1444000, 500, 0xf9, 0x40 },
+		{ 1606000, 500, 0xf9, 0x60 },
+		{ 1777000, 500, 0xf9, 0x80 },
+		{ 1941000, 500, 0xf9, 0xa0 },
+		{ 2250000, 500, 0xf9, 0xc0 },
 	}
 };
 
@@ -648,8 +696,17 @@ static int dvb_pll_init(struct dvb_frontend *fe)
 		int result;
 		if (fe->ops.i2c_gate_ctrl)
 			fe->ops.i2c_gate_ctrl(fe, 1);
-		if ((result = i2c_transfer(priv->i2c, &msg, 1)) != 1) {
+		result = i2c_transfer(priv->i2c, &msg, 1);
+		if (result != 1)
 			return result;
+		if (priv->pll_desc->initdata2) {
+			msg.buf = priv->pll_desc->initdata2 + 1;
+			msg.len = priv->pll_desc->initdata2[0];
+			if (fe->ops.i2c_gate_ctrl)
+				fe->ops.i2c_gate_ctrl(fe, 1);
+			result = i2c_transfer(priv->i2c, &msg, 1);
+			if (result != 1)
+				return result;
 		}
 		return 0;
 	}
-- 
1.7.1

