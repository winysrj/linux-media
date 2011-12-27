Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8010 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753800Ab1L0BJl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Dec 2011 20:09:41 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBR19fEq015670
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 26 Dec 2011 20:09:41 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH RFC 30/91] [media] it913x-fe: convert set_fontend to use DVBv5 parameters
Date: Mon, 26 Dec 2011 23:08:18 -0200
Message-Id: <1324948159-23709-31-git-send-email-mchehab@redhat.com>
In-Reply-To: <1324948159-23709-30-git-send-email-mchehab@redhat.com>
References: <1324948159-23709-1-git-send-email-mchehab@redhat.com>
 <1324948159-23709-2-git-send-email-mchehab@redhat.com>
 <1324948159-23709-3-git-send-email-mchehab@redhat.com>
 <1324948159-23709-4-git-send-email-mchehab@redhat.com>
 <1324948159-23709-5-git-send-email-mchehab@redhat.com>
 <1324948159-23709-6-git-send-email-mchehab@redhat.com>
 <1324948159-23709-7-git-send-email-mchehab@redhat.com>
 <1324948159-23709-8-git-send-email-mchehab@redhat.com>
 <1324948159-23709-9-git-send-email-mchehab@redhat.com>
 <1324948159-23709-10-git-send-email-mchehab@redhat.com>
 <1324948159-23709-11-git-send-email-mchehab@redhat.com>
 <1324948159-23709-12-git-send-email-mchehab@redhat.com>
 <1324948159-23709-13-git-send-email-mchehab@redhat.com>
 <1324948159-23709-14-git-send-email-mchehab@redhat.com>
 <1324948159-23709-15-git-send-email-mchehab@redhat.com>
 <1324948159-23709-16-git-send-email-mchehab@redhat.com>
 <1324948159-23709-17-git-send-email-mchehab@redhat.com>
 <1324948159-23709-18-git-send-email-mchehab@redhat.com>
 <1324948159-23709-19-git-send-email-mchehab@redhat.com>
 <1324948159-23709-20-git-send-email-mchehab@redhat.com>
 <1324948159-23709-21-git-send-email-mchehab@redhat.com>
 <1324948159-23709-22-git-send-email-mchehab@redhat.com>
 <1324948159-23709-23-git-send-email-mchehab@redhat.com>
 <1324948159-23709-24-git-send-email-mchehab@redhat.com>
 <1324948159-23709-25-git-send-email-mchehab@redhat.com>
 <1324948159-23709-26-git-send-email-mchehab@redhat.com>
 <1324948159-23709-27-git-send-email-mchehab@redhat.com>
 <1324948159-23709-28-git-send-email-mchehab@redhat.com>
 <1324948159-23709-29-git-send-email-mchehab@redhat.com>
 <1324948159-23709-30-git-send-email-mchehab@redhat.com>
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
 drivers/media/dvb/frontends/it913x-fe-priv.h |   64 ++++++++++----------
 drivers/media/dvb/frontends/it913x-fe.c      |   79 ++++++++++++++-----------
 2 files changed, 76 insertions(+), 67 deletions(-)

diff --git a/drivers/media/dvb/frontends/it913x-fe-priv.h b/drivers/media/dvb/frontends/it913x-fe-priv.h
index ad2b644..93b086e 100644
--- a/drivers/media/dvb/frontends/it913x-fe-priv.h
+++ b/drivers/media/dvb/frontends/it913x-fe-priv.h
@@ -22,126 +22,126 @@ struct adctable {	u32 adcFrequency;
 /* clock and coeff tables only table 3 is used with IT9137*/
 /* TODO other tables relate AF9035 may be removed */
 static struct adctable tab1[] = {
-	{	20156250, BANDWIDTH_6_MHZ,
+	{	20156250, 6000000,
 		0x02b8ba6e, 0x015c5d37, 0x00ae340d, 0x00ae2e9b, 0x00ae292a,
 		0x015c5d37, 0x00ae2e9b, 0x0057174e, 0x02f1, 0x015c	},
-	{	20156250, BANDWIDTH_7_MHZ,
+	{	20156250, 7000000,
 		0x032cd980, 0x01966cc0, 0x00cb3cba, 0x00cb3660, 0x00cb3007,
 		0x01966cc0, 0x00cb3660, 0x00659b30, 0x0285, 0x0196	},
-	{	20156250, BANDWIDTH_8_MHZ,
+	{	20156250, 8000000,
 		0x03a0f893, 0x01d07c49, 0x00e84567, 0x00e83e25, 0x00e836e3,
 		0x01d07c49, 0x00e83e25, 0x00741f12, 0x0234, 0x01d0	},
-	{	20156250, BANDWIDTH_5_MHZ,
+	{	20156250, 5000000,
 		0x02449b5c, 0x01224dae, 0x00912b60, 0x009126d7, 0x0091224e,
 		0x01224dae, 0x009126d7, 0x0048936b, 0x0387, 0x0122	}
 };
 
 static struct adctable tab2[] = {
-	{	20187500, BANDWIDTH_6_MHZ,
+	{	20187500, 6000000,
 		0x02b7a654, 0x015bd32a, 0x00adef04, 0x00ade995, 0x00ade426,
 		0x015bd32a, 0x00ade995, 0x0056f4ca, 0x02f2, 0x015c	},
-	{	20187500, BANDWIDTH_7_MHZ,
+	{	20187500, 7000000,
 		0x032b9761, 0x0195cbb1, 0x00caec30, 0x00cae5d8, 0x00cadf81,
 		0x0195cbb1, 0x00cae5d8, 0x006572ec, 0x0286, 0x0196	},
-	{	20187500, BANDWIDTH_8_MHZ,
+	{	20187500, 8000000,
 		0x039f886f, 0x01cfc438, 0x00e7e95b, 0x00e7e21c, 0x00e7dadd,
 		0x01cfc438, 0x00e7e21c, 0x0073f10e, 0x0235, 0x01d0	},
-	{	20187500, BANDWIDTH_5_MHZ,
+	{	20187500, 5000000,
 		0x0243b546, 0x0121daa3, 0x0090f1d9, 0x0090ed51, 0x0090e8ca,
 		0x0121daa3, 0x0090ed51, 0x004876a9, 0x0388, 0x0122	}
 
 };
 
 static struct adctable tab3[] = {
-	{	20250000, BANDWIDTH_6_MHZ,
+	{	20250000, 6000000,
 		0x02b580ad, 0x015ac057, 0x00ad6597, 0x00ad602b, 0x00ad5ac1,
 		0x015ac057, 0x00ad602b, 0x0056b016, 0x02f4, 0x015b	},
-	{	20250000, BANDWIDTH_7_MHZ,
+	{	20250000, 7000000,
 		0x03291620, 0x01948b10, 0x00ca4bda, 0x00ca4588, 0x00ca3f36,
 		0x01948b10, 0x00ca4588, 0x006522c4, 0x0288, 0x0195	},
-	{	20250000, BANDWIDTH_8_MHZ,
+	{	20250000, 8000000,
 		0x039cab92, 0x01ce55c9, 0x00e7321e, 0x00e72ae4, 0x00e723ab,
 		0x01ce55c9, 0x00e72ae4, 0x00739572, 0x0237, 0x01ce	},
-	{	20250000, BANDWIDTH_5_MHZ,
+	{	20250000, 5000000,
 		0x0241eb3b, 0x0120f59e, 0x00907f53, 0x00907acf, 0x0090764b,
 		0x0120f59e, 0x00907acf, 0x00483d67, 0x038b, 0x0121	}
 
 };
 
 static struct adctable tab4[] = {
-	{	20583333, BANDWIDTH_6_MHZ,
+	{	20583333, 6000000,
 		0x02aa4598, 0x015522cc, 0x00aa96bb, 0x00aa9166, 0x00aa8c12,
 		0x015522cc, 0x00aa9166, 0x005548b3, 0x0300, 0x0155	},
-	{	20583333, BANDWIDTH_7_MHZ,
+	{	20583333, 7000000,
 		0x031bfbdc, 0x018dfdee, 0x00c7052f, 0x00c6fef7, 0x00c6f8bf,
 		0x018dfdee, 0x00c6fef7, 0x00637f7b, 0x0293, 0x018e	},
-	{	20583333, BANDWIDTH_8_MHZ,
+	{	20583333, 8000000,
 		0x038db21f, 0x01c6d910, 0x00e373a3, 0x00e36c88, 0x00e3656d,
 		0x01c6d910, 0x00e36c88, 0x0071b644, 0x0240, 0x01c7	},
-	{	20583333, BANDWIDTH_5_MHZ,
+	{	20583333, 5000000,
 		0x02388f54, 0x011c47aa, 0x008e2846, 0x008e23d5, 0x008e1f64,
 		0x011c47aa, 0x008e23d5, 0x004711ea, 0x039a, 0x011c	}
 
 };
 
 static struct adctable tab5[] = {
-	{	20416667, BANDWIDTH_6_MHZ,
+	{	20416667, 6000000,
 		0x02afd765, 0x0157ebb3, 0x00abfb39, 0x00abf5d9, 0x00abf07a,
 		0x0157ebb3, 0x00abf5d9, 0x0055faed, 0x02fa, 0x0158	},
-	{	20416667, BANDWIDTH_7_MHZ,
+	{	20416667, 7000000,
 		0x03227b4b, 0x01913da6, 0x00c8a518, 0x00c89ed3, 0x00c8988e,
 		0x01913da6, 0x00c89ed3, 0x00644f69, 0x028d, 0x0191	},
-	{	20416667, BANDWIDTH_8_MHZ,
+	{	20416667, 8000000,
 		0x03951f32, 0x01ca8f99, 0x00e54ef7, 0x00e547cc, 0x00e540a2,
 		0x01ca8f99, 0x00e547cc, 0x0072a3e6, 0x023c, 0x01cb	},
-	{	20416667, BANDWIDTH_5_MHZ,
+	{	20416667, 5000000,
 		0x023d337f, 0x011e99c0, 0x008f515a, 0x008f4ce0, 0x008f4865,
 		0x011e99c0, 0x008f4ce0, 0x0047a670, 0x0393, 0x011f	}
 
 };
 
 static struct adctable tab6[] = {
-	{	20480000, BANDWIDTH_6_MHZ,
+	{	20480000, 6000000,
 		0x02adb6db, 0x0156db6e, 0x00ab7312, 0x00ab6db7, 0x00ab685c,
 		0x0156db6e, 0x00ab6db7, 0x0055b6db, 0x02fd, 0x0157	},
-	{	20480000, BANDWIDTH_7_MHZ,
+	{	20480000, 7000000,
 		0x03200000, 0x01900000, 0x00c80640, 0x00c80000, 0x00c7f9c0,
 		0x01900000, 0x00c80000, 0x00640000, 0x028f, 0x0190	},
-	{	20480000, BANDWIDTH_8_MHZ,
+	{	20480000, 8000000,
 		0x03924925, 0x01c92492, 0x00e4996e, 0x00e49249, 0x00e48b25,
 		0x01c92492, 0x00e49249, 0x00724925, 0x023d, 0x01c9	},
-	{	20480000, BANDWIDTH_5_MHZ,
+	{	20480000, 5000000,
 		0x023b6db7, 0x011db6db, 0x008edfe5, 0x008edb6e, 0x008ed6f7,
 		0x011db6db, 0x008edb6e, 0x00476db7, 0x0396, 0x011e	}
 };
 
 static struct adctable tab7[] = {
-	{	20500000, BANDWIDTH_6_MHZ,
+	{	20500000, 6000000,
 		0x02ad0b99, 0x015685cc, 0x00ab4840, 0x00ab42e6, 0x00ab3d8c,
 		0x015685cc, 0x00ab42e6, 0x0055a173, 0x02fd, 0x0157	},
-	{	20500000, BANDWIDTH_7_MHZ,
+	{	20500000, 7000000,
 		0x031f3832, 0x018f9c19, 0x00c7d44b, 0x00c7ce0c, 0x00c7c7ce,
 		0x018f9c19, 0x00c7ce0c, 0x0063e706, 0x0290, 0x0190	},
-	{	20500000, BANDWIDTH_8_MHZ,
+	{	20500000, 8000000,
 		0x039164cb, 0x01c8b266, 0x00e46056, 0x00e45933, 0x00e45210,
 		0x01c8b266, 0x00e45933, 0x00722c99, 0x023e, 0x01c9	},
-	{	20500000, BANDWIDTH_5_MHZ,
+	{	20500000, 5000000,
 		0x023adeff, 0x011d6f80, 0x008ebc36, 0x008eb7c0, 0x008eb34a,
 		0x011d6f80, 0x008eb7c0, 0x00475be0, 0x0396, 0x011d	}
 
 };
 
 static struct adctable tab8[] = {
-	{	20625000, BANDWIDTH_6_MHZ,
+	{	20625000, 6000000,
 		0x02a8e4bd, 0x0154725e, 0x00aa3e81, 0x00aa392f, 0x00aa33de,
 		0x0154725e, 0x00aa392f, 0x00551c98, 0x0302, 0x0154	},
-	{	20625000, BANDWIDTH_7_MHZ,
+	{	20625000, 7000000,
 		0x031a6032, 0x018d3019, 0x00c69e41, 0x00c6980c, 0x00c691d8,
 		0x018d3019, 0x00c6980c, 0x00634c06, 0x0294, 0x018d	},
-	{	20625000, BANDWIDTH_8_MHZ,
+	{	20625000, 8000000,
 		0x038bdba6, 0x01c5edd3, 0x00e2fe02, 0x00e2f6ea, 0x00e2efd2,
 		0x01c5edd3, 0x00e2f6ea, 0x00717b75, 0x0242, 0x01c6	},
-	{	20625000, BANDWIDTH_5_MHZ,
+	{	20625000, 5000000,
 		0x02376948, 0x011bb4a4, 0x008ddec1, 0x008dda52, 0x008dd5e3,
 		0x011bb4a4, 0x008dda52, 0x0046ed29, 0x039c, 0x011c	}
 
diff --git a/drivers/media/dvb/frontends/it913x-fe.c b/drivers/media/dvb/frontends/it913x-fe.c
index a13f897..5a353cb 100644
--- a/drivers/media/dvb/frontends/it913x-fe.c
+++ b/drivers/media/dvb/frontends/it913x-fe.c
@@ -232,7 +232,7 @@ static int it913x_init_tuner(struct it913x_fe_state *state)
 }
 
 static int it9137_set_tuner(struct it913x_fe_state *state,
-		enum fe_bandwidth bandwidth, u32 frequency_m)
+		u32 bandwidth, u32 frequency_m)
 {
 	struct it913xset *set_tuner = set_it9137_template;
 	int ret, reg;
@@ -286,16 +286,21 @@ static int it9137_set_tuner(struct it913x_fe_state *state,
 		return -EINVAL;
 	set_tuner[0].reg[0] = lna_band;
 
-	if (bandwidth == BANDWIDTH_5_MHZ)
+	switch(bandwidth) {
+	case 5000000:
 		bw = 0;
-	else if (bandwidth == BANDWIDTH_6_MHZ)
+		break;
+	case 6000000:
 		bw = 2;
-	else if (bandwidth == BANDWIDTH_7_MHZ)
+		break;
+	case 7000000:
 		bw = 4;
-	else if (bandwidth == BANDWIDTH_8_MHZ)
-		bw = 6;
-	else
+		break;
+	default:
+	case 8000000:
 		bw = 6;
+		break;
+	}
 
 	set_tuner[1].reg[0] = bw;
 	set_tuner[2].reg[0] = 0xa0 | (l_band << 3);
@@ -374,7 +379,7 @@ static int it9137_set_tuner(struct it913x_fe_state *state,
 }
 
 static int it913x_fe_select_bw(struct it913x_fe_state *state,
-			enum fe_bandwidth bandwidth, u32 adcFrequency)
+			u32 bandwidth, u32 adcFrequency)
 {
 	int ret, i;
 	u8 buffer[256];
@@ -387,17 +392,21 @@ static int it913x_fe_select_bw(struct it913x_fe_state *state,
 
 	deb_info("Bandwidth %d Adc %d", bandwidth, adcFrequency);
 
-	if (bandwidth == BANDWIDTH_5_MHZ)
+	switch(bandwidth) {
+	case 5000000:
 		bw = 3;
-	else if (bandwidth == BANDWIDTH_6_MHZ)
+		break;
+	case 6000000:
 		bw = 0;
-	else if (bandwidth == BANDWIDTH_7_MHZ)
+		break;
+	case 7000000:
 		bw = 1;
-	else if (bandwidth == BANDWIDTH_8_MHZ)
-		bw = 2;
-	else
+		break;
+	default:
+	case 8000000:
 		bw = 2;
-
+		break;
+	}
 	ret = it913x_write_reg(state, PRO_DMOD, REG_BW, bw);
 
 	if (state->table == NULL)
@@ -564,7 +573,7 @@ static int it913x_fe_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
 }
 
 static int it913x_fe_get_frontend(struct dvb_frontend *fe,
-			struct dvb_frontend_parameters *p)
+			struct dtv_frontend_properties *p)
 {
 	struct it913x_fe_state *state = fe->demodulator_priv;
 	int ret;
@@ -573,30 +582,30 @@ static int it913x_fe_get_frontend(struct dvb_frontend *fe,
 	ret = it913x_read_reg(state, REG_TPSD_TX_MODE, reg, sizeof(reg));
 
 	if (reg[3] < 3)
-		p->u.ofdm.constellation = fe_con[reg[3]];
-
-	state->constellation = p->u.ofdm.constellation;
+		p->modulation= fe_con[reg[3]];
 
 	if (reg[0] < 3)
-		p->u.ofdm.transmission_mode = fe_mode[reg[0]];
-
-	state->transmission_mode = p->u.ofdm.transmission_mode;
+		p->transmission_mode = fe_mode[reg[0]];
 
 	if (reg[1] < 4)
-		p->u.ofdm.guard_interval = fe_gi[reg[1]];
+		p->guard_interval = fe_gi[reg[1]];
 
 	if (reg[2] < 4)
-		p->u.ofdm.hierarchy_information = fe_hi[reg[2]];
+		p->hierarchy = fe_hi[reg[2]];
+
+	p->code_rate_HP = (reg[6] < 6) ? fe_code[reg[6]] : FEC_NONE;
+	p->code_rate_LP = (reg[7] < 6) ? fe_code[reg[7]] : FEC_NONE;
 
-	p->u.ofdm.code_rate_HP = (reg[6] < 6) ? fe_code[reg[6]] : FEC_NONE;
-	p->u.ofdm.code_rate_LP = (reg[7] < 6) ? fe_code[reg[7]] : FEC_NONE;
+	/* Update internal state to reflect the autodetected props */
+	state->constellation = p->modulation;
+	state->transmission_mode = p->transmission_mode;
 
 	return 0;
 }
 
-static int it913x_fe_set_frontend(struct dvb_frontend *fe,
-			struct dvb_frontend_parameters *p)
+static int it913x_fe_set_frontend(struct dvb_frontend *fe)
 {
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct it913x_fe_state *state = fe->demodulator_priv;
 	int ret, i;
 	u8 empty_ch, last_ch;
@@ -604,7 +613,7 @@ static int it913x_fe_set_frontend(struct dvb_frontend *fe,
 	state->it913x_status = 0;
 
 	/* Set bw*/
-	ret = it913x_fe_select_bw(state, p->u.ofdm.bandwidth,
+	ret = it913x_fe_select_bw(state, p->bandwidth_hz,
 		state->adcFrequency);
 
 	/* Training Mode Off */
@@ -624,8 +633,8 @@ static int it913x_fe_set_frontend(struct dvb_frontend *fe,
 			i = 1;
 	else if ((p->frequency >= 1450000000) && (p->frequency <= 1680000000))
 			i = 2;
-		else
-			return -EOPNOTSUPP;
+	else
+		return -EOPNOTSUPP;
 
 	ret = it913x_write_reg(state, PRO_DMOD, FREE_BAND, i);
 
@@ -638,7 +647,7 @@ static int it913x_fe_set_frontend(struct dvb_frontend *fe,
 	case IT9135_61:
 	case IT9135_62:
 		ret = it9137_set_tuner(state,
-			p->u.ofdm.bandwidth, p->frequency);
+			p->bandwidth_hz, p->frequency);
 		break;
 	default:
 		if (fe->ops.tuner_ops.set_params) {
@@ -918,7 +927,7 @@ error:
 EXPORT_SYMBOL(it913x_fe_attach);
 
 static struct dvb_frontend_ops it913x_fe_ofdm_ops = {
-
+	.delsys = { SYS_DVBT },
 	.info = {
 		.name			= "it913x-fe DVB-T",
 		.type			= FE_OFDM,
@@ -939,8 +948,8 @@ static struct dvb_frontend_ops it913x_fe_ofdm_ops = {
 	.init = it913x_fe_init,
 	.sleep = it913x_fe_sleep,
 
-	.set_frontend_legacy = it913x_fe_set_frontend,
-	.get_frontend_legacy = it913x_fe_get_frontend,
+	.set_frontend = it913x_fe_set_frontend,
+	.get_frontend = it913x_fe_get_frontend,
 
 	.read_status = it913x_fe_read_status,
 	.read_signal_strength = it913x_fe_read_signal_strength,
-- 
1.7.8.352.g876a6

