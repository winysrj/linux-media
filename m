Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:40202 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752555AbaAYRLJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Jan 2014 12:11:09 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 44/52] rtl2832_sdr: improve ADC device programming logic
Date: Sat, 25 Jan 2014 19:10:38 +0200
Message-Id: <1390669846-8131-45-git-send-email-crope@iki.fi>
In-Reply-To: <1390669846-8131-1-git-send-email-crope@iki.fi>
References: <1390669846-8131-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Refactor and implement properly RTL2832 programming logic. Implement
some things more correctly. Restore some critical registers to POR
default state, making it possible to use it as a DVB-T device without
resetting or replugging.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c | 283 ++++++++++++++---------
 1 file changed, 177 insertions(+), 106 deletions(-)

diff --git a/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c b/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
index ddacfd2..0bc417d 100644
--- a/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
+++ b/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
@@ -187,7 +187,6 @@ static int rtl2832_sdr_wr(struct rtl2832_sdr_state *s, u8 reg, const u8 *val,
 	return ret;
 }
 
-#if 0
 /* read multiple hardware registers */
 static int rtl2832_sdr_rd(struct rtl2832_sdr_state *s, u8 reg, u8 *val, int len)
 {
@@ -217,7 +216,6 @@ static int rtl2832_sdr_rd(struct rtl2832_sdr_state *s, u8 reg, u8 *val, int len)
 	}
 	return ret;
 }
-#endif
 
 /* write multiple registers */
 static int rtl2832_sdr_wr_regs(struct rtl2832_sdr_state *s, u16 reg,
@@ -239,7 +237,6 @@ static int rtl2832_sdr_wr_regs(struct rtl2832_sdr_state *s, u16 reg,
 	return rtl2832_sdr_wr(s, reg2, val, len);
 }
 
-#if 0
 /* read multiple registers */
 static int rtl2832_sdr_rd_regs(struct rtl2832_sdr_state *s, u16 reg, u8 *val,
 		int len)
@@ -259,7 +256,6 @@ static int rtl2832_sdr_rd_regs(struct rtl2832_sdr_state *s, u16 reg, u8 *val,
 
 	return rtl2832_sdr_rd(s, reg2, val, len);
 }
-#endif
 
 /* write single register */
 static int rtl2832_sdr_wr_reg(struct rtl2832_sdr_state *s, u16 reg, u8 val)
@@ -273,6 +269,7 @@ static int rtl2832_sdr_rd_reg(struct rtl2832_sdr_state *s, u16 reg, u8 *val)
 {
 	return rtl2832_sdr_rd_regs(s, reg, val, 1);
 }
+#endif
 
 /* write single register with mask */
 static int rtl2832_sdr_wr_reg_mask(struct rtl2832_sdr_state *s, u16 reg,
@@ -295,6 +292,7 @@ static int rtl2832_sdr_wr_reg_mask(struct rtl2832_sdr_state *s, u16 reg,
 	return rtl2832_sdr_wr_regs(s, reg, &val, 1);
 }
 
+#if 0
 /* read single register with mask */
 static int rtl2832_sdr_rd_reg_mask(struct rtl2832_sdr_state *s, u16 reg,
 		u8 *val, u8 mask)
@@ -662,10 +660,9 @@ static int rtl2832_sdr_set_adc(struct rtl2832_sdr_state *s)
 	struct dvb_frontend *fe = s->fe;
 	int ret;
 	unsigned int f_sr, f_if;
-	u8 buf[4], tmp;
+	u8 buf[4], u8tmp1, u8tmp2;
 	u64 u64tmp;
 	u32 u32tmp;
-
 	dev_dbg(&s->udev->dev, "%s: f_adc=%u\n", __func__, s->f_adc);
 
 	if (!test_bit(POWER_ON, &s->flags))
@@ -677,9 +674,12 @@ static int rtl2832_sdr_set_adc(struct rtl2832_sdr_state *s)
 	f_sr = s->f_adc;
 
 	ret = rtl2832_sdr_wr_regs(s, 0x13e, "\x00\x00", 2);
-	ret = rtl2832_sdr_wr_regs(s, 0x115, "\x00", 1);
-	ret = rtl2832_sdr_wr_regs(s, 0x116, "\x00\x00", 2);
-	ret = rtl2832_sdr_wr_regs(s, 0x118, "\x00", 1);
+	if (ret)
+		goto err;
+
+	ret = rtl2832_sdr_wr_regs(s, 0x115, "\x00\x00\x00\x00", 4);
+	if (ret)
+		goto err;
 
 	/* get IF from tuner */
 	if (fe->ops.tuner_ops.get_if_frequency)
@@ -708,13 +708,25 @@ static int rtl2832_sdr_set_adc(struct rtl2832_sdr_state *s)
 	if (ret)
 		goto err;
 
-	/* program BB / IF mode */
-	if (f_if)
-		tmp = 0x00;
-	else
-		tmp = 0x01;
+	/* BB / IF mode */
+	/* POR: 0x1b1=0x1f, 0x008=0x0d, 0x006=0x80 */
+	if (f_if) {
+		u8tmp1 = 0x1a; /* disable Zero-IF */
+		u8tmp2 = 0x8d; /* enable ADC I */
+	} else {
+		u8tmp1 = 0x1b; /* enable Zero-IF, DC, IQ */
+		u8tmp2 = 0xcd; /* enable ADC I, ADC Q */
+	}
 
-	ret = rtl2832_sdr_wr_reg(s, 0x1b1, tmp);
+	ret = rtl2832_sdr_wr_reg(s, 0x1b1, u8tmp1);
+	if (ret)
+		goto err;
+
+	ret = rtl2832_sdr_wr_reg(s, 0x008, u8tmp2);
+	if (ret)
+		goto err;
+
+	ret = rtl2832_sdr_wr_reg(s, 0x006, 0x80);
 	if (ret)
 		goto err;
 
@@ -729,101 +741,59 @@ static int rtl2832_sdr_set_adc(struct rtl2832_sdr_state *s)
 	if (ret)
 		goto err;
 
-	ret = rtl2832_sdr_wr_regs(s, 0x11c, "\xca", 1);
-	ret = rtl2832_sdr_wr_regs(s, 0x11d, "\xdc", 1);
-	ret = rtl2832_sdr_wr_regs(s, 0x11e, "\xd7", 1);
-	ret = rtl2832_sdr_wr_regs(s, 0x11f, "\xd8", 1);
-	ret = rtl2832_sdr_wr_regs(s, 0x120, "\xe0", 1);
-	ret = rtl2832_sdr_wr_regs(s, 0x121, "\xf2", 1);
-	ret = rtl2832_sdr_wr_regs(s, 0x122, "\x0e", 1);
-	ret = rtl2832_sdr_wr_regs(s, 0x123, "\x35", 1);
-	ret = rtl2832_sdr_wr_regs(s, 0x124, "\x06", 1);
-	ret = rtl2832_sdr_wr_regs(s, 0x125, "\x50", 1);
-	ret = rtl2832_sdr_wr_regs(s, 0x126, "\x9c", 1);
-	ret = rtl2832_sdr_wr_regs(s, 0x127, "\x0d", 1);
-	ret = rtl2832_sdr_wr_regs(s, 0x128, "\x71", 1);
-	ret = rtl2832_sdr_wr_regs(s, 0x129, "\x11", 1);
-	ret = rtl2832_sdr_wr_regs(s, 0x12a, "\x14", 1);
-	ret = rtl2832_sdr_wr_regs(s, 0x12b, "\x71", 1);
-	ret = rtl2832_sdr_wr_regs(s, 0x12c, "\x74", 1);
-	ret = rtl2832_sdr_wr_regs(s, 0x12d, "\x19", 1);
-	ret = rtl2832_sdr_wr_regs(s, 0x12e, "\x41", 1);
-	ret = rtl2832_sdr_wr_regs(s, 0x12f, "\xa5", 1);
-	ret = rtl2832_sdr_wr_regs(s, 0x017, "\x11", 1);
-	ret = rtl2832_sdr_wr_regs(s, 0x018, "\x10", 1);
+	/* low-pass filter */
+	ret = rtl2832_sdr_wr_regs(s, 0x11c,
+			"\xca\xdc\xd7\xd8\xe0\xf2\x0e\x35\x06\x50\x9c\x0d\x71\x11\x14\x71\x74\x19\x41\xa5",
+			20);
+	if (ret)
+		goto err;
+
+	/* mode */
+	ret = rtl2832_sdr_wr_regs(s, 0x017, "\x11\x10", 2);
+	if (ret)
+		goto err;
+
 	ret = rtl2832_sdr_wr_regs(s, 0x019, "\x21", 1);
-	ret = rtl2832_sdr_wr_regs(s, 0x01f, "\xff", 1);
-	ret = rtl2832_sdr_wr_regs(s, 0x01e, "\x01", 1);
-	ret = rtl2832_sdr_wr_regs(s, 0x01d, "\x06", 1);
-	ret = rtl2832_sdr_wr_regs(s, 0x01c, "\x0d", 1);
-	ret = rtl2832_sdr_wr_regs(s, 0x01b, "\x16", 1);
-	ret = rtl2832_sdr_wr_regs(s, 0x01a, "\x1b", 1);
-	ret = rtl2832_sdr_wr_regs(s, 0x192, "\x00", 1);
-	ret = rtl2832_sdr_wr_regs(s, 0x193, "\xf0", 1);
-	ret = rtl2832_sdr_wr_regs(s, 0x194, "\x0f", 1);
+	if (ret)
+		goto err;
+
+	ret = rtl2832_sdr_wr_regs(s, 0x01a, "\x1b\x16\x0d\x06\x01\xff", 6);
+	if (ret)
+		goto err;
+
+	/* FSM */
+	ret = rtl2832_sdr_wr_regs(s, 0x192, "\x00\xf0\x0f", 3);
+	if (ret)
+		goto err;
+
+	/* PID filter */
 	ret = rtl2832_sdr_wr_regs(s, 0x061, "\x60", 1);
-	ret = rtl2832_sdr_wr_regs(s, 0x006, "\x80", 1);
-	ret = rtl2832_sdr_wr_regs(s, 0x112, "\x5a", 1);
-	ret = rtl2832_sdr_wr_regs(s, 0x102, "\x40", 1);
+	if (ret)
+		goto err;
 
-	if (s->cfg->tuner == RTL2832_TUNER_R820T) {
-		ret = rtl2832_sdr_wr_regs(s, 0x115, "\x01", 1);
-		ret = rtl2832_sdr_wr_regs(s, 0x103, "\x80", 1);
-		ret = rtl2832_sdr_wr_regs(s, 0x1c7, "\x24", 1);
-		ret = rtl2832_sdr_wr_regs(s, 0x104, "\xcc", 1);
-		ret = rtl2832_sdr_wr_regs(s, 0x105, "\xbe", 1);
-		ret = rtl2832_sdr_wr_regs(s, 0x1c8, "\x14", 1);
-	} else if (s->cfg->tuner == RTL2832_TUNER_FC0012 ||
-			s->cfg->tuner == RTL2832_TUNER_FC0013) {
-		ret = rtl2832_sdr_wr_regs(s, 0x103, "\x5a", 1);
-		ret = rtl2832_sdr_wr_regs(s, 0x1c7, "\x2c", 1);
-		ret = rtl2832_sdr_wr_regs(s, 0x104, "\xcc", 1);
-		ret = rtl2832_sdr_wr_regs(s, 0x105, "\xbe", 1);
-		ret = rtl2832_sdr_wr_regs(s, 0x1c8, "\x16", 1);
-	} else {
+	/* used RF tuner based settings */
+	switch (s->cfg->tuner) {
+	case RTL2832_TUNER_E4000:
+		ret = rtl2832_sdr_wr_regs(s, 0x112, "\x5a", 1);
+		ret = rtl2832_sdr_wr_regs(s, 0x102, "\x40", 1);
 		ret = rtl2832_sdr_wr_regs(s, 0x103, "\x5a", 1);
 		ret = rtl2832_sdr_wr_regs(s, 0x1c7, "\x30", 1);
 		ret = rtl2832_sdr_wr_regs(s, 0x104, "\xd0", 1);
 		ret = rtl2832_sdr_wr_regs(s, 0x105, "\xbe", 1);
 		ret = rtl2832_sdr_wr_regs(s, 0x1c8, "\x18", 1);
-	}
-
-	ret = rtl2832_sdr_wr_regs(s, 0x106, "\x35", 1);
-	ret = rtl2832_sdr_wr_regs(s, 0x1c9, "\x21", 1);
-	ret = rtl2832_sdr_wr_regs(s, 0x1ca, "\x21", 1);
-	ret = rtl2832_sdr_wr_regs(s, 0x1cb, "\x00", 1);
-	ret = rtl2832_sdr_wr_regs(s, 0x107, "\x40", 1);
-	ret = rtl2832_sdr_wr_regs(s, 0x1cd, "\x10", 1);
-	ret = rtl2832_sdr_wr_regs(s, 0x1ce, "\x10", 1);
-	ret = rtl2832_sdr_wr_regs(s, 0x108, "\x80", 1);
-	ret = rtl2832_sdr_wr_regs(s, 0x109, "\x7f", 1);
-	ret = rtl2832_sdr_wr_regs(s, 0x10a, "\x80", 1);
-	ret = rtl2832_sdr_wr_regs(s, 0x10b, "\x7f", 1);
-	ret = rtl2832_sdr_wr_regs(s, 0x00e, "\xfc", 1);
-	ret = rtl2832_sdr_wr_regs(s, 0x00e, "\xfc", 1);
-
-	if (s->cfg->tuner == RTL2832_TUNER_R820T) {
-		ret = rtl2832_sdr_wr_regs(s, 0x011, "\xf4", 1);
-		ret = rtl2832_sdr_wr_regs(s, 0x101, "\x14", 1);
-		ret = rtl2832_sdr_wr_regs(s, 0x101, "\x10", 1);
-		ret = rtl2832_sdr_wr_regs(s, 0x019, "\x21", 1);
-		ret = rtl2832_sdr_wr_regs(s, 0x116, "\x00\x00", 2);
-		ret = rtl2832_sdr_wr_regs(s, 0x118, "\x00", 1);
-	} else if (s->cfg->tuner == RTL2832_TUNER_FC0012 ||
-			s->cfg->tuner == RTL2832_TUNER_FC0013) {
-		ret = rtl2832_sdr_wr_regs(s, 0x011, "\xe9\xbf", 2);
-		ret = rtl2832_sdr_wr_regs(s, 0x1e5, "\xf0", 1);
-		ret = rtl2832_sdr_wr_regs(s, 0x1d9, "\x00", 1);
-		ret = rtl2832_sdr_wr_regs(s, 0x1db, "\x00", 1);
-		ret = rtl2832_sdr_wr_regs(s, 0x1dd, "\x11", 1);
-		ret = rtl2832_sdr_wr_regs(s, 0x1de, "\xef", 1);
-		ret = rtl2832_sdr_wr_regs(s, 0x1d8, "\x0c", 1);
-		ret = rtl2832_sdr_wr_regs(s, 0x1e6, "\x02", 1);
-		ret = rtl2832_sdr_wr_regs(s, 0x1d7, "\x09", 1);
-		ret = rtl2832_sdr_wr_regs(s, 0x008, "\xcd", 1);
-		ret = rtl2832_sdr_wr_regs(s, 0x101, "\x14", 1);
-		ret = rtl2832_sdr_wr_regs(s, 0x101, "\x10", 1);
-	} else {
+		ret = rtl2832_sdr_wr_regs(s, 0x106, "\x35", 1);
+		ret = rtl2832_sdr_wr_regs(s, 0x1c9, "\x21", 1);
+		ret = rtl2832_sdr_wr_regs(s, 0x1ca, "\x21", 1);
+		ret = rtl2832_sdr_wr_regs(s, 0x1cb, "\x00", 1);
+		ret = rtl2832_sdr_wr_regs(s, 0x107, "\x40", 1);
+		ret = rtl2832_sdr_wr_regs(s, 0x1cd, "\x10", 1);
+		ret = rtl2832_sdr_wr_regs(s, 0x1ce, "\x10", 1);
+		ret = rtl2832_sdr_wr_regs(s, 0x108, "\x80", 1);
+		ret = rtl2832_sdr_wr_regs(s, 0x109, "\x7f", 1);
+		ret = rtl2832_sdr_wr_regs(s, 0x10a, "\x80", 1);
+		ret = rtl2832_sdr_wr_regs(s, 0x10b, "\x7f", 1);
+		ret = rtl2832_sdr_wr_regs(s, 0x00e, "\xfc", 1);
+		ret = rtl2832_sdr_wr_regs(s, 0x00e, "\xfc", 1);
 		ret = rtl2832_sdr_wr_regs(s, 0x011, "\xd4", 1);
 		ret = rtl2832_sdr_wr_regs(s, 0x1e5, "\xf0", 1);
 		ret = rtl2832_sdr_wr_regs(s, 0x1d9, "\x00", 1);
@@ -838,16 +808,115 @@ static int rtl2832_sdr_set_adc(struct rtl2832_sdr_state *s)
 		ret = rtl2832_sdr_wr_regs(s, 0x00d, "\x87", 1);
 		ret = rtl2832_sdr_wr_regs(s, 0x00d, "\x85", 1);
 		ret = rtl2832_sdr_wr_regs(s, 0x013, "\x02", 1);
-		ret = rtl2832_sdr_wr_regs(s, 0x008, "\xcd", 1);
-		ret = rtl2832_sdr_wr_regs(s, 0x10c, "\x00", 1);
-		ret = rtl2832_sdr_wr_regs(s, 0x101, "\x14", 1);
-		ret = rtl2832_sdr_wr_regs(s, 0x101, "\x10", 1);
+		break;
+	case RTL2832_TUNER_FC0012:
+	case RTL2832_TUNER_FC0013:
+		ret = rtl2832_sdr_wr_regs(s, 0x112, "\x5a", 1);
+		ret = rtl2832_sdr_wr_regs(s, 0x102, "\x40", 1);
+		ret = rtl2832_sdr_wr_regs(s, 0x103, "\x5a", 1);
+		ret = rtl2832_sdr_wr_regs(s, 0x1c7, "\x2c", 1);
+		ret = rtl2832_sdr_wr_regs(s, 0x104, "\xcc", 1);
+		ret = rtl2832_sdr_wr_regs(s, 0x105, "\xbe", 1);
+		ret = rtl2832_sdr_wr_regs(s, 0x1c8, "\x16", 1);
+		ret = rtl2832_sdr_wr_regs(s, 0x106, "\x35", 1);
+		ret = rtl2832_sdr_wr_regs(s, 0x1c9, "\x21", 1);
+		ret = rtl2832_sdr_wr_regs(s, 0x1ca, "\x21", 1);
+		ret = rtl2832_sdr_wr_regs(s, 0x1cb, "\x00", 1);
+		ret = rtl2832_sdr_wr_regs(s, 0x107, "\x40", 1);
+		ret = rtl2832_sdr_wr_regs(s, 0x1cd, "\x10", 1);
+		ret = rtl2832_sdr_wr_regs(s, 0x1ce, "\x10", 1);
+		ret = rtl2832_sdr_wr_regs(s, 0x108, "\x80", 1);
+		ret = rtl2832_sdr_wr_regs(s, 0x109, "\x7f", 1);
+		ret = rtl2832_sdr_wr_regs(s, 0x10a, "\x80", 1);
+		ret = rtl2832_sdr_wr_regs(s, 0x10b, "\x7f", 1);
+		ret = rtl2832_sdr_wr_regs(s, 0x00e, "\xfc", 1);
+		ret = rtl2832_sdr_wr_regs(s, 0x00e, "\xfc", 1);
+		ret = rtl2832_sdr_wr_regs(s, 0x011, "\xe9\xbf", 2);
+		ret = rtl2832_sdr_wr_regs(s, 0x1e5, "\xf0", 1);
+		ret = rtl2832_sdr_wr_regs(s, 0x1d9, "\x00", 1);
+		ret = rtl2832_sdr_wr_regs(s, 0x1db, "\x00", 1);
+		ret = rtl2832_sdr_wr_regs(s, 0x1dd, "\x11", 1);
+		ret = rtl2832_sdr_wr_regs(s, 0x1de, "\xef", 1);
+		ret = rtl2832_sdr_wr_regs(s, 0x1d8, "\x0c", 1);
+		ret = rtl2832_sdr_wr_regs(s, 0x1e6, "\x02", 1);
+		ret = rtl2832_sdr_wr_regs(s, 0x1d7, "\x09", 1);
+		break;
+	case RTL2832_TUNER_R820T:
+		ret = rtl2832_sdr_wr_regs(s, 0x112, "\x5a", 1);
+		ret = rtl2832_sdr_wr_regs(s, 0x102, "\x40", 1);
+		ret = rtl2832_sdr_wr_regs(s, 0x115, "\x01", 1);
+		ret = rtl2832_sdr_wr_regs(s, 0x103, "\x80", 1);
+		ret = rtl2832_sdr_wr_regs(s, 0x1c7, "\x24", 1);
+		ret = rtl2832_sdr_wr_regs(s, 0x104, "\xcc", 1);
+		ret = rtl2832_sdr_wr_regs(s, 0x105, "\xbe", 1);
+		ret = rtl2832_sdr_wr_regs(s, 0x1c8, "\x14", 1);
+		ret = rtl2832_sdr_wr_regs(s, 0x106, "\x35", 1);
+		ret = rtl2832_sdr_wr_regs(s, 0x1c9, "\x21", 1);
+		ret = rtl2832_sdr_wr_regs(s, 0x1ca, "\x21", 1);
+		ret = rtl2832_sdr_wr_regs(s, 0x1cb, "\x00", 1);
+		ret = rtl2832_sdr_wr_regs(s, 0x107, "\x40", 1);
+		ret = rtl2832_sdr_wr_regs(s, 0x1cd, "\x10", 1);
+		ret = rtl2832_sdr_wr_regs(s, 0x1ce, "\x10", 1);
+		ret = rtl2832_sdr_wr_regs(s, 0x108, "\x80", 1);
+		ret = rtl2832_sdr_wr_regs(s, 0x109, "\x7f", 1);
+		ret = rtl2832_sdr_wr_regs(s, 0x10a, "\x80", 1);
+		ret = rtl2832_sdr_wr_regs(s, 0x10b, "\x7f", 1);
+		ret = rtl2832_sdr_wr_regs(s, 0x00e, "\xfc", 1);
+		ret = rtl2832_sdr_wr_regs(s, 0x00e, "\xfc", 1);
+		ret = rtl2832_sdr_wr_regs(s, 0x011, "\xf4", 1);
+		break;
+	default:
+		dev_notice(&s->udev->dev, "Unsupported tuner\n");
 	}
 
+	/* software reset */
+	ret = rtl2832_sdr_wr_reg_mask(s, 0x101, 0x04, 0x04);
+	if (ret)
+		goto err;
+
+	ret = rtl2832_sdr_wr_reg_mask(s, 0x101, 0x00, 0x04);
+	if (ret)
+		goto err;
 err:
 	return ret;
 };
 
+static void rtl2832_sdr_unset_adc(struct rtl2832_sdr_state *s)
+{
+	int ret;
+
+	dev_dbg(&s->udev->dev, "%s:\n", __func__);
+
+	/* PID filter */
+	ret = rtl2832_sdr_wr_regs(s, 0x061, "\xe0", 1);
+	if (ret)
+		goto err;
+
+	/* mode */
+	ret = rtl2832_sdr_wr_regs(s, 0x019, "\x20", 1);
+	if (ret)
+		goto err;
+
+	ret = rtl2832_sdr_wr_regs(s, 0x017, "\x11\x10", 2);
+	if (ret)
+		goto err;
+
+	/* FSM */
+	ret = rtl2832_sdr_wr_regs(s, 0x192, "\x00\x0f\xff", 3);
+	if (ret)
+		goto err;
+
+	ret = rtl2832_sdr_wr_regs(s, 0x13e, "\x40\x00", 2);
+	if (ret)
+		goto err;
+
+	ret = rtl2832_sdr_wr_regs(s, 0x115, "\x06\x3f\xce\xcc", 4);
+	if (ret)
+		goto err;
+err:
+	return;
+};
+
 static int rtl2832_sdr_set_tuner(struct rtl2832_sdr_state *s)
 {
 	struct dvb_frontend *fe = s->fe;
@@ -887,6 +956,7 @@ static int rtl2832_sdr_set_tuner(struct rtl2832_sdr_state *s)
 
 	c->bandwidth_hz = bandwidth;
 	c->frequency = f_rf;
+	c->delivery_system = SYS_DVBT;
 
 	if (fe->ops.tuner_ops.set_params)
 		fe->ops.tuner_ops.set_params(fe);
@@ -961,6 +1031,7 @@ static int rtl2832_sdr_stop_streaming(struct vb2_queue *vq)
 	rtl2832_sdr_free_urbs(s);
 	rtl2832_sdr_free_stream_bufs(s);
 	rtl2832_sdr_cleanup_queued_bufs(s);
+	rtl2832_sdr_unset_adc(s);
 	rtl2832_sdr_unset_tuner(s);
 
 	clear_bit(POWER_ON, &s->flags);
-- 
1.8.5.3

