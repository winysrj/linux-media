Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:45554 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713Ab1IUXHH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Sep 2011 19:07:07 -0400
Received: by wwf22 with SMTP id 22so1343733wwf.1
        for <linux-media@vger.kernel.org>; Wed, 21 Sep 2011 16:07:06 -0700 (PDT)
Subject: [PATCH] [ver 1.06] it913x-fe - correct tuner settings. Resend
From: tvboxspy <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Date: Thu, 22 Sep 2011 00:06:58 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <4e7a6e19.cb60e30a.62c6.ffffb2a3@mx.google.com>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Correct tuner settings for more accuracy. This now makes the tuner
 section more compatible with other versions of the IT913X
 series.

TODOs
Version 2 chip

Patch sent last week appears to be mangled and marked superseded.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/media/dvb/frontends/it913x-fe-priv.h |   24 +----
 drivers/media/dvb/frontends/it913x-fe.c      |  139 ++++++++++++++++++++------
 2 files changed, 113 insertions(+), 50 deletions(-)

diff --git a/drivers/media/dvb/frontends/it913x-fe-priv.h b/drivers/media/dvb/frontends/it913x-fe-priv.h
index b80634ab..40e1d9b 100644
--- a/drivers/media/dvb/frontends/it913x-fe-priv.h
+++ b/drivers/media/dvb/frontends/it913x-fe-priv.h
@@ -316,27 +316,13 @@ static struct it913xset it9137_set[] = {
 	{0xff, 0x0000, {0x00}, 0x00}, /* Terminating Entry */
 };
 
-static struct it913xset it9137_tuner[] = {
-	{PRO_DMOD, 0xec57, {0x00}, 0x01},
-	{PRO_DMOD, 0xec58, {0x00}, 0x01},
-	{PRO_DMOD, 0xec40, {0x00}, 0x01},
-	{PRO_DMOD, 0xec02, {	0x00, 0x0c, 0x00, 0x40, 0x00, 0x80, 0x80,
-				0x00, 0x00, 0x00, 0x00	}, 0x0b},
-	{PRO_DMOD, 0xec0d, {	0x00, 0x40, 0x00, 0x00, 0x00, 0x00, 0x00,
-				0x00, 0x00, 0x00, 0x00	}, 0x0b},
-	{PRO_DMOD, 0xec19, {	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-				0x00, 0x00}, 0x08},
-	{PRO_DMOD, 0xec22, {	0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-				0x00, 0x00, 0x00	}, 0x0a},
-	{PRO_DMOD, 0xec3f, {0x01}, 0x01},
-	/* Clear any existing tune */
-	{PRO_DMOD, 0xec4c, {0xa8, 0x00, 0x00, 0x00, 0x00}, 0x05},
-	{0xff, 0x0000, {0x00}, 0x00}, /* Terminating Entry */
-};
-
 static struct it913xset set_it9137_template[] = {
 	{PRO_DMOD, 0xee06, {0x00}, 0x01},
 	{PRO_DMOD, 0xec56, {0x00}, 0x01},
-	{PRO_DMOD, 0xec4c, {0x00, 0x00, 0x00, 0x00, 0x00}, 0x05},
+	{PRO_DMOD, 0xec4c, {0x00}, 0x01},
+	{PRO_DMOD, 0xec4d, {0x00}, 0x01},
+	{PRO_DMOD, 0xec4e, {0x00}, 0x01},
+	{PRO_DMOD, 0xec4f, {0x00}, 0x01},
+	{PRO_DMOD, 0xec50, {0x00}, 0x01},
 	{0xff, 0x0000, {0x00}, 0x00}, /* Terminating Entry */
 };
diff --git a/drivers/media/dvb/frontends/it913x-fe.c b/drivers/media/dvb/frontends/it913x-fe.c
index c92b3ec..02839a8b7 100644
--- a/drivers/media/dvb/frontends/it913x-fe.c
+++ b/drivers/media/dvb/frontends/it913x-fe.c
@@ -58,6 +58,10 @@ struct it913x_fe_state {
 	u8 tuner_type;
 	struct adctable *table;
 	fe_status_t it913x_status;
+	u16 tun_xtal;
+	u8 tun_fdiv;
+	u8 tun_clk_mode;
+	u32 tun_fn_min;
 };
 
 static int it913x_read_reg(struct it913x_fe_state *state,
@@ -159,13 +163,74 @@ static int it913x_fe_script_loader(struct it913x_fe_state *state,
 	return 0;
 }
 
+static int it913x_init_tuner(struct it913x_fe_state *state)
+{
+	int ret, i, reg;
+	u8 val, nv_val;
+	u8 nv[] = {48, 32, 24, 16, 12, 8, 6, 4, 2};
+	u8 b[2];
+
+	reg = it913x_read_reg_u8(state, 0xec86);
+	switch (reg) {
+	case 0:
+		state->tun_clk_mode = reg;
+		state->tun_xtal = 2000;
+		state->tun_fdiv = 3;
+		val = 16;
+		break;
+	case -ENODEV:
+		return -ENODEV;
+	case 1:
+	default:
+		state->tun_clk_mode = reg;
+		state->tun_xtal = 640;
+		state->tun_fdiv = 1;
+		val = 6;
+		break;
+	}
+
+	reg = it913x_read_reg_u8(state, 0xed03);
+
+	if (reg < 0)
+		return -ENODEV;
+	else if (reg < sizeof(nv))
+		nv_val = nv[reg];
+	else
+		nv_val = 2;
+
+	for (i = 0; i < 50; i++) {
+		ret = it913x_read_reg(state, 0xed23, &b[0], sizeof(b));
+		reg = (b[1] << 8) + b[0];
+		if (reg > 0)
+			break;
+		if (ret < 0)
+			return -ENODEV;
+		udelay(2000);
+	}
+	state->tun_fn_min = state->tun_xtal * reg;
+	state->tun_fn_min /= (state->tun_fdiv * nv_val);
+	deb_info("Tuner fn_min %d", state->tun_fn_min);
+
+	for (i = 0; i < 50; i++) {
+		reg = it913x_read_reg_u8(state, 0xec82);
+		if (reg > 0)
+			break;
+		if (reg < 0)
+			return -ENODEV;
+		udelay(2000);
+	}
+
+	return it913x_write_reg(state, PRO_DMOD, 0xed81, val);
+}
+
 static int it9137_set_tuner(struct it913x_fe_state *state,
 		enum fe_bandwidth bandwidth, u32 frequency_m)
 {
 	struct it913xset *set_tuner = set_it9137_template;
-	int ret;
+	int ret, reg;
 	u32 frequency = frequency_m / 1000;
-	u32 freq;
+	u32 freq, temp_f, tmp;
+	u16 iqik_m_cal;
 	u16 n_div;
 	u8 n;
 	u8 l_band;
@@ -218,10 +283,11 @@ static int it9137_set_tuner(struct it913x_fe_state *state,
 		bw = 6;
 	else
 		bw = 6;
+
 	set_tuner[1].reg[0] = bw;
 	set_tuner[2].reg[0] = 0xa0 | (l_band << 3);
 
-	if (frequency > 49000 && frequency <= 74000) {
+	if (frequency > 53000 && frequency <= 74000) {
 		n_div = 48;
 		n = 0;
 	} else if (frequency > 74000 && frequency <= 111000) {
@@ -239,10 +305,10 @@ static int it9137_set_tuner(struct it913x_fe_state *state,
 	} else if (frequency > 296000 && frequency <= 445000) {
 		n_div = 8;
 		n = 5;
-	} else if (frequency > 445000 && frequency <= 560000) {
+	} else if (frequency > 445000 && frequency <= state->tun_fn_min) {
 		n_div = 6;
 		n = 6;
-	} else if (frequency > 560000 && frequency <= 860000) {
+	} else if (frequency > state->tun_fn_min && frequency <= 950000) {
 		n_div = 4;
 		n = 7;
 	} else if (frequency > 1450000 && frequency <= 1680000) {
@@ -251,26 +317,47 @@ static int it9137_set_tuner(struct it913x_fe_state *state,
 	} else
 		return -EINVAL;
 
+	reg = it913x_read_reg_u8(state, 0xed81);
+	iqik_m_cal = (u16)reg * n_div;
 
-	/* Frequency + 3000 TODO not sure this is bandwidth setting */
-	/* Xtal frequency 21327? but it works */
-	freq = (u32) (n_div * 32  * (frequency + 3000) / 21327);
-	freq += (u32) n << 13;
-	set_tuner[2].reg[1] =  freq & 0xff;
-	set_tuner[2].reg[2] =  (freq >> 8) & 0xff;
+	if (reg < 0x20) {
+		if (state->tun_clk_mode == 0)
+			iqik_m_cal = (iqik_m_cal * 9) >> 5;
+		else
+			iqik_m_cal >>= 1;
+	} else {
+		iqik_m_cal = 0x40 - iqik_m_cal;
+		if (state->tun_clk_mode == 0)
+			iqik_m_cal = ~((iqik_m_cal * 9) >> 5);
+		else
+			iqik_m_cal = ~(iqik_m_cal >> 1);
+	}
+
+	temp_f = frequency * (u32)n_div * (u32)state->tun_fdiv;
+	freq = temp_f / state->tun_xtal;
+	tmp = freq * state->tun_xtal;
+
+	if ((temp_f - tmp) >= (state->tun_xtal >> 1))
+		freq++;
 
-	/* frequency */
-	freq = (u32) (n_div * 32  * frequency / 21327);
 	freq += (u32) n << 13;
-	set_tuner[2].reg[3] =  freq & 0xff;
-	set_tuner[2].reg[4] =  (freq >> 8) & 0xff;
+	/* Frequency OMEGA_IQIK_M_CAL_MID*/
+	temp_f = freq + (u32)iqik_m_cal;
 
-	deb_info("Frequency = %08x, Bandwidth = %02x, ", freq, bw);
+	set_tuner[3].reg[0] =  temp_f & 0xff;
+	set_tuner[4].reg[0] =  (temp_f >> 8) & 0xff;
+
+	deb_info("High Frequency = %04x", temp_f);
+
+	/* Lower frequency */
+	set_tuner[5].reg[0] =  freq & 0xff;
+	set_tuner[6].reg[0] =  (freq >> 8) & 0xff;
+
+	deb_info("low Frequency = %04x", freq);
 
 	ret = it913x_fe_script_loader(state, set_tuner);
 
 	return (ret < 0) ? -ENODEV : 0;
-
 }
 
 static int it913x_fe_select_bw(struct it913x_fe_state *state,
@@ -593,6 +680,8 @@ static int it913x_fe_start(struct it913x_fe_state *state)
 	u32 adc, xtal;
 	u8 b[4];
 
+	ret = it913x_init_tuner(state);
+
 	if (adf < 12) {
 		state->crystalFrequency = fe_clockTable[adf].xtal ;
 		state->table = fe_clockTable[adf].table;
@@ -612,7 +701,6 @@ static int it913x_fe_start(struct it913x_fe_state *state)
 	ret |= it913x_write_reg(state, PRO_LINK, GPIOH3_ON, 0x1);
 	ret |= it913x_write_reg(state, PRO_LINK, GPIOH3_O, 0x1);
 
-	ret |= it913x_write_reg(state, PRO_DMOD, 0xed81, 0x10);
 	ret |= it913x_write_reg(state, PRO_LINK, 0xf641, state->tuner_type);
 	ret |= it913x_write_reg(state, PRO_DMOD, 0xf5ca, 0x01);
 	ret |= it913x_write_reg(state, PRO_DMOD, 0xf715, 0x01);
@@ -635,6 +723,7 @@ static int it913x_fe_start(struct it913x_fe_state *state)
 	default:
 		return -EINVAL;
 	}
+
 	/* set the demod */
 	ret = it913x_fe_script_loader(state, set_fe);
 	/* Always solo frontend */
@@ -648,20 +737,8 @@ static int it913x_fe_start(struct it913x_fe_state *state)
 static int it913x_fe_init(struct dvb_frontend *fe)
 {
 	struct it913x_fe_state *state = fe->demodulator_priv;
-	struct it913xset *set_tuner;
 	int ret = 0;
 
-	switch (state->tuner_type) {
-	case IT9137: /* Tuner type 0x38 */
-		set_tuner = it9137_tuner;
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	/* set any tuner reg(s) */
-	ret = it913x_fe_script_loader(state, set_tuner);
-
 	it913x_write_reg(state, PRO_DMOD, AFE_MEM0, 0x0);
 
 	ret |= it913x_fe_script_loader(state, init_1);
@@ -743,5 +820,5 @@ static struct dvb_frontend_ops it913x_fe_ofdm_ops = {
 
 MODULE_DESCRIPTION("it913x Frontend and it9137 tuner");
 MODULE_AUTHOR("Malcolm Priestley tvboxspy@gmail.com");
-MODULE_VERSION("1.05");
+MODULE_VERSION("1.06");
 MODULE_LICENSE("GPL");
-- 
1.7.5.4


