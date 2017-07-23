Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:35712 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751630AbdGWKN1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 23 Jul 2017 06:13:27 -0400
Received: by mail-wm0-f66.google.com with SMTP id m75so5412424wmb.2
        for <linux-media@vger.kernel.org>; Sun, 23 Jul 2017 03:13:26 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: jasmin@anw.at, r.scobie@clear.net.nz
Subject: [PATCH 7/7] [media] dvb-frontends/stv{0910,6111}: constify tables
Date: Sun, 23 Jul 2017 12:13:15 +0200
Message-Id: <20170723101315.12523-8-d.scheller.oss@gmail.com>
In-Reply-To: <20170723101315.12523-1-d.scheller.oss@gmail.com>
References: <20170723101315.12523-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Mark lookup tables and fe_ops things const so the compiler can put them
into .rodata.

While at it, improve name and identifier strings (moddesc, fe_ops).

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/dvb-frontends/stv0910.c | 24 ++++++++++++------------
 drivers/media/dvb-frontends/stv6111.c | 19 ++++++++++---------
 2 files changed, 22 insertions(+), 21 deletions(-)

diff --git a/drivers/media/dvb-frontends/stv0910.c b/drivers/media/dvb-frontends/stv0910.c
index e2162fa8cad6..a2648dd91a57 100644
--- a/drivers/media/dvb-frontends/stv0910.c
+++ b/drivers/media/dvb-frontends/stv0910.c
@@ -207,7 +207,7 @@ static int write_shared_reg(struct stv *state, u16 reg, u8 mask, u8 val)
 	return status;
 }
 
-static struct slookup s1_sn_lookup[] = {
+static const struct slookup s1_sn_lookup[] = {
 	{   0,    9242  }, /* C/N=   0dB */
 	{   5,    9105  }, /* C/N= 0.5dB */
 	{  10,    8950  }, /* C/N= 1.0dB */
@@ -264,7 +264,7 @@ static struct slookup s1_sn_lookup[] = {
 	{  510,    425  }  /* C/N=51.0dB */
 };
 
-static struct slookup s2_sn_lookup[] = {
+static const struct slookup s2_sn_lookup[] = {
 	{  -30,  13950  }, /* C/N=-2.5dB */
 	{  -25,  13580  }, /* C/N=-2.5dB */
 	{  -20,  13150  }, /* C/N=-2.0dB */
@@ -327,7 +327,7 @@ static struct slookup s2_sn_lookup[] = {
 	{  510,    463  }, /* C/N=51.0dB */
 };
 
-static struct slookup padc_lookup[] = {
+static const struct slookup padc_lookup[] = {
 	{    0,  118000 }, /* PADC= +0dBm */
 	{ -100,  93600  }, /* PADC= -1dBm */
 	{ -200,  74500  }, /* PADC= -2dBm */
@@ -349,7 +349,7 @@ static struct slookup padc_lookup[] = {
 /*********************************************************************
  * Tracking carrier loop carrier QPSK 1/4 to 8PSK 9/10 long Frame
  *********************************************************************/
-static u8 s2car_loop[] =	{
+static const u8 s2car_loop[] =	{
 	/*
 	 * Modcod  2MPon 2MPoff 5MPon 5MPoff 10MPon 10MPoff
 	 * 20MPon 20MPoff 30MPon 30MPoff
@@ -587,7 +587,7 @@ static int tracking_optimization(struct stv *state)
 	return 0;
 }
 
-static s32 table_lookup(struct slookup *table,
+static s32 table_lookup(const struct slookup *table,
 			int table_size, u32 reg_value)
 {
 	s32 value;
@@ -629,7 +629,7 @@ static int get_signal_to_noise(struct stv *state, s32 *signal_to_noise)
 	u8 data1;
 	u16 data;
 	int n_lookup;
-	struct slookup *lookup;
+	const struct slookup *lookup;
 
 	*signal_to_noise = 0;
 
@@ -693,7 +693,7 @@ static int get_bit_error_rate_s(struct stv *state, u32 *bernumerator,
 
 static u32 dvbs2_nbch(enum dvbs2_mod_cod mod_cod, enum dvbs2_fectype fectype)
 {
-	static u32 nbch[][2] = {
+	static const u32 nbch[][2] = {
 		{    0,     0}, /* DUMMY_PLF   */
 		{16200,  3240}, /* QPSK_1_4,   */
 		{21600,  5400}, /* QPSK_1_3,   */
@@ -953,7 +953,7 @@ static int set_vth_default(struct stv *state)
 
 static int set_vth(struct stv *state)
 {
-	static struct slookup vthlookup_table[] = {
+	static const struct slookup vthlookup_table[] = {
 		{250,	8780}, /* C/N= 1.5dB */
 		{100,	7405}, /* C/N= 4.5dB */
 		{40,	6330}, /* C/N= 6.5dB */
@@ -1515,7 +1515,7 @@ static int get_frontend(struct dvb_frontend *fe,
 
 	if (state->receive_mode == RCVMODE_DVBS2) {
 		u32 mc;
-		enum fe_modulation modcod2mod[0x20] = {
+		const enum fe_modulation modcod2mod[0x20] = {
 			QPSK, QPSK, QPSK, QPSK,
 			QPSK, QPSK, QPSK, QPSK,
 			QPSK, QPSK, QPSK, QPSK,
@@ -1525,7 +1525,7 @@ static int get_frontend(struct dvb_frontend *fe,
 			APSK_32, APSK_32, APSK_32, APSK_32,
 			APSK_32,
 		};
-		enum fe_code_rate modcod2fec[0x20] = {
+		const enum fe_code_rate modcod2fec[0x20] = {
 			FEC_NONE, FEC_NONE, FEC_NONE, FEC_2_5,
 			FEC_1_2, FEC_3_5, FEC_2_3, FEC_3_4,
 			FEC_4_5, FEC_5_6, FEC_8_9, FEC_9_10,
@@ -1673,10 +1673,10 @@ static int sleep(struct dvb_frontend *fe)
 	return 0;
 }
 
-static struct dvb_frontend_ops stv0910_ops = {
+static const struct dvb_frontend_ops stv0910_ops = {
 	.delsys = { SYS_DVBS, SYS_DVBS2, SYS_DSS },
 	.info = {
-		.name			= "STV0910",
+		.name			= "ST STV0910",
 		.frequency_min		= 950000,
 		.frequency_max		= 2150000,
 		.frequency_stepsize	= 0,
diff --git a/drivers/media/dvb-frontends/stv6111.c b/drivers/media/dvb-frontends/stv6111.c
index c4db5e6c18af..9a59fa318207 100644
--- a/drivers/media/dvb-frontends/stv6111.c
+++ b/drivers/media/dvb-frontends/stv6111.c
@@ -41,7 +41,7 @@ struct slookup {
 	u16 reg_value;
 };
 
-static struct slookup lnagain_nf_lookup[] = {
+static const struct slookup lnagain_nf_lookup[] = {
 	/* Gain *100dB // Reg */
 	{ 2572,	0 },
 	{ 2575, 1 },
@@ -77,7 +77,7 @@ static struct slookup lnagain_nf_lookup[] = {
 	{ 5102,	31 }
 };
 
-static struct slookup lnagain_iip3_lookup[] = {
+static const struct slookup lnagain_iip3_lookup[] = {
 	/* Gain *100dB // reg */
 	{ 1548,	0 },
 	{ 1552,	1 },
@@ -113,7 +113,7 @@ static struct slookup lnagain_iip3_lookup[] = {
 	{ 4535,	31 }
 };
 
-static struct slookup gain_rfagc_lookup[] = {
+static const struct slookup gain_rfagc_lookup[] = {
 	/* Gain *100dB // reg */
 	{ 4870,	0x3000 },
 	{ 4850,	0x3C00 },
@@ -173,7 +173,7 @@ static struct slookup gain_rfagc_lookup[] = {
  * This table is 6 dB too low comapred to the others (probably created with
  * a different BB_MAG setting)
  */
-static struct slookup gain_channel_agc_nf_lookup[] = {
+static const struct slookup gain_channel_agc_nf_lookup[] = {
 	/* Gain *100dB // reg */
 	{ 7082,	0x3000 },
 	{ 7052,	0x4000 },
@@ -232,7 +232,7 @@ static struct slookup gain_channel_agc_nf_lookup[] = {
 	{ 1927,	0xFF00 }
 };
 
-static struct slookup gain_channel_agc_iip3_lookup[] = {
+static const struct slookup gain_channel_agc_iip3_lookup[] = {
 	/* Gain *100dB // reg */
 	{ 7070,	0x3000 },
 	{ 7028,	0x4000 },
@@ -533,7 +533,8 @@ static int set_params(struct dvb_frontend *fe)
 	return 0;
 }
 
-static s32 table_lookup(struct slookup *table, int table_size, u16 reg_value)
+static s32 table_lookup(const struct slookup *table,
+			int table_size, u16 reg_value)
 {
 	s32 gain;
 	s32 reg_diff;
@@ -634,9 +635,9 @@ static int get_rf_strength(struct dvb_frontend *fe, u16 *st)
 	return 0;
 }
 
-static struct dvb_tuner_ops tuner_ops = {
+static const struct dvb_tuner_ops tuner_ops = {
 	.info = {
-		.name		= "STV6111",
+		.name		= "ST STV6111",
 		.frequency_min	= 950000,
 		.frequency_max	= 2150000,
 		.frequency_step	= 0
@@ -675,6 +676,6 @@ struct dvb_frontend *stv6111_attach(struct dvb_frontend *fe,
 }
 EXPORT_SYMBOL_GPL(stv6111_attach);
 
-MODULE_DESCRIPTION("STV6111 driver");
+MODULE_DESCRIPTION("ST STV6111 satellite tuner driver");
 MODULE_AUTHOR("Ralph Metzler, Manfred Voelkel");
 MODULE_LICENSE("GPL");
-- 
2.13.0
