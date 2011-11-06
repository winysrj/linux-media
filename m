Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:63251 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621Ab1KFPTW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Nov 2011 10:19:22 -0500
Received: by wwf22 with SMTP id 22so3938879wwf.1
        for <linux-media@vger.kernel.org>; Sun, 06 Nov 2011 07:19:20 -0800 (PST)
Message-ID: <4eb6a578.8bcbe30a.30d9.fffff86a@mx.google.com>
Subject: [PATCH] it913x-fe ver 1.10 correct SNR reading from frontend.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Date: Sun, 06 Nov 2011 15:19:14 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Correction of reading from frontend and represents
a SNR nonlinear scale of minimum signal to full signal.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/media/dvb/frontends/it913x-fe.c |   56 +++++++++++++++++++++++++++----
 1 files changed, 49 insertions(+), 7 deletions(-)

diff --git a/drivers/media/dvb/frontends/it913x-fe.c b/drivers/media/dvb/frontends/it913x-fe.c
index 6d12dcc..07c1b46 100644
--- a/drivers/media/dvb/frontends/it913x-fe.c
+++ b/drivers/media/dvb/frontends/it913x-fe.c
@@ -53,6 +53,8 @@ struct it913x_fe_state {
 	struct ite_config *config;
 	u8 i2c_addr;
 	u32 frequency;
+	fe_modulation_t constellation;
+	fe_transmit_mode_t transmission_mode;
 	u32 crystalFrequency;
 	u32 adcFrequency;
 	u8 tuner_type;
@@ -496,14 +498,50 @@ static int it913x_fe_read_signal_strength(struct dvb_frontend *fe,
 	return 0;
 }
 
-static int it913x_fe_read_snr(struct dvb_frontend *fe, u16* snr)
+static int it913x_fe_read_snr(struct dvb_frontend *fe, u16 *snr)
 {
 	struct it913x_fe_state *state = fe->demodulator_priv;
-	int ret = it913x_read_reg_u8(state, SIGNAL_QUALITY);
-	ret = (ret * 0xff) / 0x64;
-	ret |= (ret << 0x8);
-	*snr = ~ret;
-	return 0;
+	int ret;
+	u8 reg[3];
+	u32 snr_val, snr_min, snr_max;
+	u32 temp;
+
+	ret = it913x_read_reg(state, 0x2c, reg, sizeof(reg));
+
+	snr_val = (u32)(reg[2] << 16) | (reg[1] < 8) | reg[0];
+
+	ret |= it913x_read_reg(state, 0xf78b, reg, 1);
+	if (reg[0])
+		snr_val /= reg[0];
+
+	if (state->transmission_mode == TRANSMISSION_MODE_2K)
+		snr_val *= 4;
+	else if (state->transmission_mode == TRANSMISSION_MODE_4K)
+		snr_val *= 2;
+
+	if (state->constellation == QPSK) {
+		snr_min = 0xb4711;
+		snr_max = 0x191451;
+	} else if (state->constellation == QAM_16) {
+		snr_min = 0x4f0d5;
+		snr_max = 0xc7925;
+	} else if (state->constellation == QAM_64) {
+		snr_min = 0x256d0;
+		snr_max = 0x626be;
+	} else
+		return -EINVAL;
+
+	if (snr_val < snr_min)
+		*snr = 0;
+	else if (snr_val < snr_max) {
+		temp = (snr_val - snr_min) >> 5;
+		temp *= 0xffff;
+		temp /= (snr_max - snr_min) >> 5;
+		*snr = (u16)temp;
+	} else
+		*snr = 0xffff;
+
+	return (ret < 0) ? -ENODEV : 0;
 }
 
 static int it913x_fe_read_ber(struct dvb_frontend *fe, u32 *ber)
@@ -530,9 +568,13 @@ static int it913x_fe_get_frontend(struct dvb_frontend *fe,
 	if (reg[3] < 3)
 		p->u.ofdm.constellation = fe_con[reg[3]];
 
+	state->constellation = p->u.ofdm.constellation;
+
 	if (reg[0] < 3)
 		p->u.ofdm.transmission_mode = fe_mode[reg[0]];
 
+	state->transmission_mode = p->u.ofdm.transmission_mode;
+
 	if (reg[1] < 4)
 		p->u.ofdm.guard_interval = fe_gi[reg[1]];
 
@@ -888,5 +930,5 @@ static struct dvb_frontend_ops it913x_fe_ofdm_ops = {
 
 MODULE_DESCRIPTION("it913x Frontend and it9137 tuner");
 MODULE_AUTHOR("Malcolm Priestley tvboxspy@gmail.com");
-MODULE_VERSION("1.09");
+MODULE_VERSION("1.10");
 MODULE_LICENSE("GPL");
-- 
1.7.5.4


