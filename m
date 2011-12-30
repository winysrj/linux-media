Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10409 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752342Ab1L3PJ2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Dec 2011 10:09:28 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBUF9RVB026546
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 30 Dec 2011 10:09:28 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCHv2 31/94] [media] l64781: convert set_fontend to use DVBv5 parameters
Date: Fri, 30 Dec 2011 13:07:28 -0200
Message-Id: <1325257711-12274-32-git-send-email-mchehab@redhat.com>
In-Reply-To: <1325257711-12274-1-git-send-email-mchehab@redhat.com>
References: <1325257711-12274-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of using dvb_frontend_parameters struct, that were
designed for a subset of the supported standards, use the DVBv5
cache information.

Also, fill the supported delivery systems at dvb_frontend_ops
struct.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/frontends/l64781.c |  116 ++++++++++++++++++----------------
 1 files changed, 62 insertions(+), 54 deletions(-)

diff --git a/drivers/media/dvb/frontends/l64781.c b/drivers/media/dvb/frontends/l64781.c
index 1f1c598..1784e34 100644
--- a/drivers/media/dvb/frontends/l64781.c
+++ b/drivers/media/dvb/frontends/l64781.c
@@ -117,18 +117,17 @@ static int reset_and_configure (struct l64781_state* state)
 	return (i2c_transfer(state->i2c, &msg, 1) == 1) ? 0 : -ENODEV;
 }
 
-static int apply_frontend_param (struct dvb_frontend* fe, struct dvb_frontend_parameters *param)
+static int apply_frontend_param (struct dvb_frontend* fe)
 {
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct l64781_state* state = fe->demodulator_priv;
 	/* The coderates for FEC_NONE, FEC_4_5 and FEC_FEC_6_7 are arbitrary */
 	static const u8 fec_tab[] = { 7, 0, 1, 2, 9, 3, 10, 4 };
 	/* QPSK, QAM_16, QAM_64 */
 	static const u8 qam_tab [] = { 2, 4, 0, 6 };
-	static const u8 bw_tab [] = { 8, 7, 6 };  /* 8Mhz, 7MHz, 6MHz */
 	static const u8 guard_tab [] = { 1, 2, 4, 8 };
 	/* The Grundig 29504-401.04 Tuner comes with 18.432MHz crystal. */
 	static const u32 ppm = 8000;
-	struct dvb_ofdm_parameters *p = &param->u.ofdm;
 	u32 ddfs_offset_fixed;
 /*	u32 ddfs_offset_variable = 0x6000-((1000000UL+ppm)/ */
 /*			bw_tab[p->bandWidth]<<10)/15625; */
@@ -137,18 +136,29 @@ static int apply_frontend_param (struct dvb_frontend* fe, struct dvb_frontend_pa
 	u8 val0x04;
 	u8 val0x05;
 	u8 val0x06;
-	int bw = p->bandwidth - BANDWIDTH_8_MHZ;
+	int bw;
+
+	switch (p->bandwidth_hz) {
+	case 8000000:
+		bw = 8;
+		break;
+	case 7000000:
+		bw = 7;
+		break;
+	case 6000000:
+		bw = 6;
+		break;
+	default:
+		return -EINVAL;
+	}
 
 	if (fe->ops.tuner_ops.set_params) {
 		fe->ops.tuner_ops.set_params(fe);
 		if (fe->ops.i2c_gate_ctrl) fe->ops.i2c_gate_ctrl(fe, 0);
 	}
 
-	if (param->inversion != INVERSION_ON &&
-	    param->inversion != INVERSION_OFF)
-		return -EINVAL;
-
-	if (bw < 0 || bw > 2)
+	if (p->inversion != INVERSION_ON &&
+	    p->inversion != INVERSION_OFF)
 		return -EINVAL;
 
 	if (p->code_rate_HP != FEC_1_2 && p->code_rate_HP != FEC_2_3 &&
@@ -156,14 +166,14 @@ static int apply_frontend_param (struct dvb_frontend* fe, struct dvb_frontend_pa
 	    p->code_rate_HP != FEC_7_8)
 		return -EINVAL;
 
-	if (p->hierarchy_information != HIERARCHY_NONE &&
+	if (p->hierarchy != HIERARCHY_NONE &&
 	    (p->code_rate_LP != FEC_1_2 && p->code_rate_LP != FEC_2_3 &&
 	     p->code_rate_LP != FEC_3_4 && p->code_rate_LP != FEC_5_6 &&
 	     p->code_rate_LP != FEC_7_8))
 		return -EINVAL;
 
-	if (p->constellation != QPSK && p->constellation != QAM_16 &&
-	    p->constellation != QAM_64)
+	if (p->modulation != QPSK && p->modulation != QAM_16 &&
+	    p->modulation != QAM_64)
 		return -EINVAL;
 
 	if (p->transmission_mode != TRANSMISSION_MODE_2K &&
@@ -174,22 +184,22 @@ static int apply_frontend_param (struct dvb_frontend* fe, struct dvb_frontend_pa
 	    p->guard_interval > GUARD_INTERVAL_1_4)
 		return -EINVAL;
 
-	if (p->hierarchy_information < HIERARCHY_NONE ||
-	    p->hierarchy_information > HIERARCHY_4)
+	if (p->hierarchy < HIERARCHY_NONE ||
+	    p->hierarchy > HIERARCHY_4)
 		return -EINVAL;
 
-	ddfs_offset_fixed = 0x4000-(ppm<<16)/bw_tab[p->bandwidth]/1000000;
+	ddfs_offset_fixed = 0x4000-(ppm<<16)/bw/1000000;
 
 	/* This works up to 20000 ppm, it overflows if too large ppm! */
 	init_freq = (((8UL<<25) + (8UL<<19) / 25*ppm / (15625/25)) /
-			bw_tab[p->bandwidth] & 0xFFFFFF);
+			bw & 0xFFFFFF);
 
 	/* SPI bias calculation is slightly modified to fit in 32bit */
 	/* will work for high ppm only... */
 	spi_bias = 378 * (1 << 10);
 	spi_bias *= 16;
-	spi_bias *= bw_tab[p->bandwidth];
-	spi_bias *= qam_tab[p->constellation];
+	spi_bias *= bw;
+	spi_bias *= qam_tab[p->modulation];
 	spi_bias /= p->code_rate_HP + 1;
 	spi_bias /= (guard_tab[p->guard_interval] + 32);
 	spi_bias *= 1000;
@@ -199,10 +209,10 @@ static int apply_frontend_param (struct dvb_frontend* fe, struct dvb_frontend_pa
 	val0x04 = (p->transmission_mode << 2) | p->guard_interval;
 	val0x05 = fec_tab[p->code_rate_HP];
 
-	if (p->hierarchy_information != HIERARCHY_NONE)
+	if (p->hierarchy != HIERARCHY_NONE)
 		val0x05 |= (p->code_rate_LP - FEC_1_2) << 3;
 
-	val0x06 = (p->hierarchy_information << 2) | p->constellation;
+	val0x06 = (p->hierarchy << 2) | p->modulation;
 
 	l64781_writereg (state, 0x04, val0x04);
 	l64781_writereg (state, 0x05, val0x05);
@@ -220,7 +230,7 @@ static int apply_frontend_param (struct dvb_frontend* fe, struct dvb_frontend_pa
 	l64781_writereg (state, 0x1b, spi_bias & 0xff);
 	l64781_writereg (state, 0x1c, (spi_bias >> 8) & 0xff);
 	l64781_writereg (state, 0x1d, ((spi_bias >> 16) & 0x7f) |
-		(param->inversion == INVERSION_ON ? 0x80 : 0x00));
+		(p->inversion == INVERSION_ON ? 0x80 : 0x00));
 
 	l64781_writereg (state, 0x22, ddfs_offset_fixed & 0xff);
 	l64781_writereg (state, 0x23, (ddfs_offset_fixed >> 8) & 0x3f);
@@ -233,7 +243,8 @@ static int apply_frontend_param (struct dvb_frontend* fe, struct dvb_frontend_pa
 	return 0;
 }
 
-static int get_frontend(struct dvb_frontend* fe, struct dvb_frontend_parameters* param)
+static int get_frontend(struct dvb_frontend* fe,
+			struct dtv_frontend_properties *p)
 {
 	struct l64781_state* state = fe->demodulator_priv;
 	int tmp;
@@ -242,98 +253,95 @@ static int get_frontend(struct dvb_frontend* fe, struct dvb_frontend_parameters*
 	tmp = l64781_readreg(state, 0x04);
 	switch(tmp & 3) {
 	case 0:
-		param->u.ofdm.guard_interval = GUARD_INTERVAL_1_32;
+		p->guard_interval = GUARD_INTERVAL_1_32;
 		break;
 	case 1:
-		param->u.ofdm.guard_interval = GUARD_INTERVAL_1_16;
+		p->guard_interval = GUARD_INTERVAL_1_16;
 		break;
 	case 2:
-		param->u.ofdm.guard_interval = GUARD_INTERVAL_1_8;
+		p->guard_interval = GUARD_INTERVAL_1_8;
 		break;
 	case 3:
-		param->u.ofdm.guard_interval = GUARD_INTERVAL_1_4;
+		p->guard_interval = GUARD_INTERVAL_1_4;
 		break;
 	}
 	switch((tmp >> 2) & 3) {
 	case 0:
-		param->u.ofdm.transmission_mode = TRANSMISSION_MODE_2K;
+		p->transmission_mode = TRANSMISSION_MODE_2K;
 		break;
 	case 1:
-		param->u.ofdm.transmission_mode = TRANSMISSION_MODE_8K;
+		p->transmission_mode = TRANSMISSION_MODE_8K;
 		break;
 	default:
 		printk("Unexpected value for transmission_mode\n");
 	}
 
-
-
 	tmp = l64781_readreg(state, 0x05);
 	switch(tmp & 7) {
 	case 0:
-		param->u.ofdm.code_rate_HP = FEC_1_2;
+		p->code_rate_HP = FEC_1_2;
 		break;
 	case 1:
-		param->u.ofdm.code_rate_HP = FEC_2_3;
+		p->code_rate_HP = FEC_2_3;
 		break;
 	case 2:
-		param->u.ofdm.code_rate_HP = FEC_3_4;
+		p->code_rate_HP = FEC_3_4;
 		break;
 	case 3:
-		param->u.ofdm.code_rate_HP = FEC_5_6;
+		p->code_rate_HP = FEC_5_6;
 		break;
 	case 4:
-		param->u.ofdm.code_rate_HP = FEC_7_8;
+		p->code_rate_HP = FEC_7_8;
 		break;
 	default:
 		printk("Unexpected value for code_rate_HP\n");
 	}
 	switch((tmp >> 3) & 7) {
 	case 0:
-		param->u.ofdm.code_rate_LP = FEC_1_2;
+		p->code_rate_LP = FEC_1_2;
 		break;
 	case 1:
-		param->u.ofdm.code_rate_LP = FEC_2_3;
+		p->code_rate_LP = FEC_2_3;
 		break;
 	case 2:
-		param->u.ofdm.code_rate_LP = FEC_3_4;
+		p->code_rate_LP = FEC_3_4;
 		break;
 	case 3:
-		param->u.ofdm.code_rate_LP = FEC_5_6;
+		p->code_rate_LP = FEC_5_6;
 		break;
 	case 4:
-		param->u.ofdm.code_rate_LP = FEC_7_8;
+		p->code_rate_LP = FEC_7_8;
 		break;
 	default:
 		printk("Unexpected value for code_rate_LP\n");
 	}
 
-
 	tmp = l64781_readreg(state, 0x06);
 	switch(tmp & 3) {
 	case 0:
-		param->u.ofdm.constellation = QPSK;
+		p->modulation = QPSK;
 		break;
 	case 1:
-		param->u.ofdm.constellation = QAM_16;
+		p->modulation = QAM_16;
 		break;
 	case 2:
-		param->u.ofdm.constellation = QAM_64;
+		p->modulation = QAM_64;
 		break;
 	default:
-		printk("Unexpected value for constellation\n");
+		printk("Unexpected value for modulation\n");
 	}
 	switch((tmp >> 2) & 7) {
 	case 0:
-		param->u.ofdm.hierarchy_information = HIERARCHY_NONE;
+		p->hierarchy = HIERARCHY_NONE;
 		break;
 	case 1:
-		param->u.ofdm.hierarchy_information = HIERARCHY_1;
+		p->hierarchy = HIERARCHY_1;
 		break;
 	case 2:
-		param->u.ofdm.hierarchy_information = HIERARCHY_2;
+		p->hierarchy = HIERARCHY_2;
 		break;
 	case 3:
-		param->u.ofdm.hierarchy_information = HIERARCHY_4;
+		p->hierarchy = HIERARCHY_4;
 		break;
 	default:
 		printk("Unexpected value for hierarchy\n");
@@ -341,12 +349,12 @@ static int get_frontend(struct dvb_frontend* fe, struct dvb_frontend_parameters*
 
 
 	tmp = l64781_readreg (state, 0x1d);
-	param->inversion = (tmp & 0x80) ? INVERSION_ON : INVERSION_OFF;
+	p->inversion = (tmp & 0x80) ? INVERSION_ON : INVERSION_OFF;
 
 	tmp = (int) (l64781_readreg (state, 0x08) |
 		     (l64781_readreg (state, 0x09) << 8) |
 		     (l64781_readreg (state, 0x0a) << 16));
-	param->frequency += tmp;
+	p->frequency += tmp;
 
 	return 0;
 }
@@ -564,7 +572,7 @@ error:
 }
 
 static struct dvb_frontend_ops l64781_ops = {
-
+	.delsys = { SYS_DVBT },
 	.info = {
 		.name = "LSI L64781 DVB-T",
 		.type = FE_OFDM,
@@ -584,8 +592,8 @@ static struct dvb_frontend_ops l64781_ops = {
 	.init = l64781_init,
 	.sleep = l64781_sleep,
 
-	.set_frontend_legacy = apply_frontend_param,
-	.get_frontend_legacy = get_frontend,
+	.set_frontend = apply_frontend_param,
+	.get_frontend = get_frontend,
 	.get_tune_settings = l64781_get_tune_settings,
 
 	.read_status = l64781_read_status,
-- 
1.7.8.352.g876a6

