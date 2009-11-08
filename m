Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f188.google.com ([209.85.222.188]:61626 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752445AbZKHIlp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 Nov 2009 03:41:45 -0500
Received: by pzk26 with SMTP id 26so1521692pzk.4
        for <linux-media@vger.kernel.org>; Sun, 08 Nov 2009 00:41:51 -0800 (PST)
From: hiranotaka@zng.jp
Date: Sun, 08 Nov 2009 17:42:28 +0900
Message-Id: <87eio9xv9n.fsf@wei.zng.jp>
To: mchehab@infradead.org, linux-media@vger.kernel.org
Subject: [PATCH] pt1: Support FE_READ_SNR
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

pt1: Support FE_READ_SNR

Signed-off-by: HIRANO Takahito <hiranotaka@zng.info>

diff -r bb412b4e19a0 -r b386a38c7a1e linux/drivers/media/dvb/pt1/va1j5jf8007s.c
--- a/linux/drivers/media/dvb/pt1/va1j5jf8007s.c	Sun Nov 01 03:59:42 2009 +0900
+++ b/linux/drivers/media/dvb/pt1/va1j5jf8007s.c	Sun Nov 08 17:37:13 2009 +0900
@@ -48,6 +48,60 @@
 	enum va1j5jf8007s_tune_state tune_state;
 };
 
+static int va1j5jf8007s_read_snr(struct dvb_frontend *fe, u16 *snr)
+{
+	struct va1j5jf8007s_state *state;
+	u8 addr;
+	int i;
+	u8 write_buf[1], read_buf[1];
+	struct i2c_msg msgs[2];
+	s32 word, x1, x2, x3, x4, x5, y;
+
+	state = fe->demodulator_priv;
+	addr = state->config->demod_address;
+
+	word = 0;
+	for (i = 0; i < 2; i++) {
+		write_buf[0] = 0xbc + i;
+
+		msgs[0].addr = addr;
+		msgs[0].flags = 0;
+		msgs[0].len = sizeof(write_buf);
+		msgs[0].buf = write_buf;
+
+		msgs[1].addr = addr;
+		msgs[1].flags = I2C_M_RD;
+		msgs[1].len = sizeof(read_buf);
+		msgs[1].buf = read_buf;
+
+		if (i2c_transfer(state->adap, msgs, 2) != 2)
+			return -EREMOTEIO;
+
+		word <<= 8;
+		word |= read_buf[0];
+	}
+
+	word -= 3000;
+	if (word < 0)
+		word = 0;
+
+	x1 = int_sqrt(word << 16) * ((15625ll << 21) / 1000000);
+	x2 = (s64)x1 * x1 >> 31;
+	x3 = (s64)x2 * x1 >> 31;
+	x4 = (s64)x2 * x2 >> 31;
+	x5 = (s64)x4 * x1 >> 31;
+
+	y = (58857ll << 23) / 1000;
+	y -= (s64)x1 * ((89565ll << 24) / 1000) >> 30;
+	y += (s64)x2 * ((88977ll << 24) / 1000) >> 28;
+	y -= (s64)x3 * ((50259ll << 25) / 1000) >> 27;
+	y += (s64)x4 * ((14341ll << 27) / 1000) >> 27;
+	y -= (s64)x5 * ((16346ll << 30) / 10000) >> 28;
+
+	*snr = y < 0 ? 0 : y >> 15;
+	return 0;
+}
+
 static int va1j5jf8007s_get_frontend_algo(struct dvb_frontend *fe)
 {
 	return DVBFE_ALGO_HW;
@@ -536,6 +590,7 @@
 			FE_CAN_GUARD_INTERVAL_AUTO | FE_CAN_HIERARCHY_AUTO,
 	},
 
+	.read_snr = va1j5jf8007s_read_snr,
 	.get_frontend_algo = va1j5jf8007s_get_frontend_algo,
 	.read_status = va1j5jf8007s_read_status,
 	.tune = va1j5jf8007s_tune,
diff -r bb412b4e19a0 -r b386a38c7a1e linux/drivers/media/dvb/pt1/va1j5jf8007t.c
--- a/linux/drivers/media/dvb/pt1/va1j5jf8007t.c	Sun Nov 01 03:59:42 2009 +0900
+++ b/linux/drivers/media/dvb/pt1/va1j5jf8007t.c	Sun Nov 08 17:37:13 2009 +0900
@@ -46,6 +46,52 @@
 	enum va1j5jf8007t_tune_state tune_state;
 };
 
+static int va1j5jf8007t_read_snr(struct dvb_frontend *fe, u16 *snr)
+{
+	struct va1j5jf8007t_state *state;
+	u8 addr;
+	int i;
+	u8 write_buf[1], read_buf[1];
+	struct i2c_msg msgs[2];
+	s32 word, x, y;
+
+	state = fe->demodulator_priv;
+	addr = state->config->demod_address;
+
+	word = 0;
+	for (i = 0; i < 3; i++) {
+		write_buf[0] = 0x8b + i;
+
+		msgs[0].addr = addr;
+		msgs[0].flags = 0;
+		msgs[0].len = sizeof(write_buf);
+		msgs[0].buf = write_buf;
+
+		msgs[1].addr = addr;
+		msgs[1].flags = I2C_M_RD;
+		msgs[1].len = sizeof(read_buf);
+		msgs[1].buf = read_buf;
+
+		if (i2c_transfer(state->adap, msgs, 2) != 2)
+			return -EREMOTEIO;
+
+		word <<= 8;
+		word |= read_buf[0];
+	}
+
+	if (!word)
+		return -EIO;
+
+	x = 10 * (intlog10(0x540000 * 100 / word) - (2 << 24));
+	y = (24ll << 46) / 1000000;
+	y = ((s64)y * x >> 30) - (16ll << 40) / 10000;
+	y = ((s64)y * x >> 29) + (398ll << 35) / 10000;
+	y = ((s64)y * x >> 30) + (5491ll << 29) / 10000;
+	y = ((s64)y * x >> 30) + (30965ll << 23) / 10000;
+	*snr = y >> 15;
+	return 0;
+}
+
 static int va1j5jf8007t_get_frontend_algo(struct dvb_frontend *fe)
 {
 	return DVBFE_ALGO_HW;
@@ -393,6 +439,7 @@
 			FE_CAN_GUARD_INTERVAL_AUTO | FE_CAN_HIERARCHY_AUTO,
 	},
 
+	.read_snr = va1j5jf8007t_read_snr,
 	.get_frontend_algo = va1j5jf8007t_get_frontend_algo,
 	.read_status = va1j5jf8007t_read_status,
 	.tune = va1j5jf8007t_tune,
